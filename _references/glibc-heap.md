---
layout: reference
title: "glibc Heap (malloc) Internals"
excerpt: "The real malloc_chunk struct, size-field flag bits, bin sizing, and tcache layout — plus what changed if you're used to fastbins."
tags: [linux, c, lookup, pwn]
---

*Note: the chunk struct, bin sizing, and tcache details below are sourced from current glibc master. Fastbins — which most CTF heap-exploitation material (this-generation write-ups, `pwndbg`/`GEF` heap commands, etc.) still assumes exist — were actually removed from glibc's malloc entirely at some point after 2.39-ish master; see the callout near the bottom. If you're working against a real binary, check `ldd --version` or the ELF's `.comment`/`GNU_ABI_TAG` before assuming which of these applies.*

## Chunk Layout

```c
struct malloc_chunk {
  INTERNAL_SIZE_T      mchunk_prev_size;  /* Size of previous chunk (if free). */
  INTERNAL_SIZE_T      mchunk_size;       /* Size in bytes, including overhead. */

  struct malloc_chunk* fd;                /* double links -- used only if free. */
  struct malloc_chunk* bk;

  /* Only used for large blocks: pointer to next larger size. */
  struct malloc_chunk* fd_nextsize;
  struct malloc_chunk* bk_nextsize;
};
```

Allocated chunk, in memory:

```
    chunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Size of previous chunk, if unallocated (P clear)  |
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Size of chunk, in bytes                     |A|M|P|
      mem-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             User data starts here...                          .
            .             (malloc_usable_size() bytes)                      .
            .                                                               |
nextchunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Size of next chunk, in bytes                |A|0|1|
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

Free chunk — the user-data area is overlaid with `fd`/`bk` list pointers:

```
    chunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Size of previous chunk, if unallocated (P clear)  |
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    `head:' |             Size of chunk, in bytes                     |A|0|P|
      mem-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Forward pointer to next chunk in list             |
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Back pointer to previous chunk in list            |
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Unused space (may be 0 bytes long)                .
            .                                                               |
nextchunk-> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    `foot:' |             Size of chunk, in bytes                           |
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
            |             Size of next chunk, in bytes                |A|0|0|
            +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

`mem` (the pointer `malloc()` actually returns) starts 2 words (`CHUNK_HDR_SZ`) after `chunk` — `chunk2mem(p)`/`mem2chunk(mem)` convert between the two. `MIN_CHUNK_SIZE` is the offset of `fd_nextsize` in the struct (a free chunk needs at least that much space for its list pointers).

## Size Field Flag Bits (the "A|M|P" bits above)

The low 3 bits of `mchunk_size` are stolen as flags — real chunk sizes are always a multiple of `2*SIZE_SZ`, so these bits are otherwise unused.

| Bit | Name | Meaning |
|---|---|---|
| `0x1` | `PREV_INUSE` | Set if the *previous* adjacent chunk is in use. If clear, the word before this chunk's header holds the previous chunk's size, letting you walk backward — if `PREV_INUSE` is set you *cannot* determine the previous chunk's size at all. The very first chunk ever allocated always has this set, so you can never walk off the front of the heap. |
| `0x2` | `IS_MMAPPED` | Set if this chunk was obtained directly via `mmap()` rather than from the normal heap/arena (large allocations bypass the arena entirely). |
| `0x4` | `NON_MAIN_ARENA` | Set if this chunk belongs to a thread arena other than `main_arena`. Multi-threaded programs get a separate arena per thread (up to a configurable limit, then arenas are shared), and only non-main-arena chunks carry this bit. |
{: style="--table-col-1: 10%; --table-col-2: 18%; --table-col-3: 72%;"}

## Bin Sizing

`NBINS` = 128 total bins, split into `NSMALLBINS` = 64 small bins (sizes `< 512` bytes on 64-bit, spaced 8 bytes apart — one exact size per bin) and large bins (approximately logarithmically spaced beyond that): 32 bins of size-range-width 64, 16 bins of width 512, 8 bins of width 4096, 4 bins of width 32768, 2 bins of width 262144, and 1 catch-all bin for anything larger. Bins top out around 1MB, since larger requests go straight to `mmap()` (see `IS_MMAPPED` above) instead.

## tcache

Every thread gets its own small per-thread cache, checked *before* falling through to the normal bin machinery on both `malloc()` and `free()` — this is why tcache is almost always the first thing worth attacking in a modern heap challenge.

```c
/* Overlaid on the user-data portion of a chunk when it's cached. */
typedef struct tcache_entry {
    struct tcache_entry *next;
    uintptr_t key;   /* exists to detect double frees */
} tcache_entry;

/* One per thread. */
typedef struct tcache_perthread_struct {
    uint16_t num_slots[TCACHE_MAX_BINS];
    tcache_entry *entries[TCACHE_MAX_BINS];
} tcache_perthread_struct;
```

`TCACHE_MAX_BINS` = 76 (64 small-size bins + 12 large-size bins, up to ~4MB chunks). Each bin holds up to `TCACHE_FILL_COUNT` = 16 chunks by default before overflowing back to the normal bins.

**Safe-Linking**: current glibc masks the `next` pointer in each `tcache_entry` using ASLR randomness (derived from the heap's own address), rather than storing it raw. This is specifically a mitigation against tcache poisoning — a corrupted/attacker-controlled `next` pointer no longer decodes to a valid address without also knowing the heap base, and a bad decode gets caught by an alignment check.

## Legacy: Fastbins (glibc ≲ 2.39)

Older glibc — which is still what the overwhelming majority of real-world CTF binaries and deployed systems actually run — additionally had **fastbins**: a set of `NFASTBINS` (10) singly-linked LIFO lists for the smallest chunk sizes (up to `MAX_FAST_SIZE`, around 128 bytes on 64-bit by default, tunable via the now-inert `M_MXFAST`/`mallopt`). Fastbin chunks were **not consolidated with their neighbors on `free()`** — this is precisely what made fastbin-based attacks (fastbin dup, House of Spirit, etc.) possible: freeing the same chunk twice, or a forged chunk, could get accepted onto a fastbin list with a single `PREV_INUSE`/size check and no double-free detection at all (tcache's `key` field, above, is the direct answer to this weakness). Current glibc master has eliminated fastbins as a distinct mechanism entirely — chunks that would previously have landed in a fastbin now go through the same unified small-bin/tcache path as everything else.

---

### Sources

- [glibc — malloc/malloc.c](https://github.com/bminor/glibc/blob/master/malloc/malloc.c)
- [sourceware.org glibc wiki — Malloc Internals](https://sourceware.org/glibc/wiki/MallocInternals)
- [Wikipedia — C dynamic memory allocation](https://en.wikipedia.org/wiki/C_dynamic_memory_allocation)
