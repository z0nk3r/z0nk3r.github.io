---
layout: reference
title: "ELF Format"
excerpt: "Object file types, program/section header types, dynamic tags, and segment flags for the ELF binary format."
tags: [linux, c, lookup, pwn]
---

*Note: values sourced directly from the kernel's `linux/elf.h`, except `DT_BIND_NOW`/`DT_RUNPATH`/`DT_FLAGS` which aren't in that header (the kernel loader never needed them) — those three are sourced from glibc's `elf/elf.h` instead, noted where it matters.*

## Object File Types (`e_type`)

| Value | Constant | Meaning |
|---|---|---|
| 0 | `ET_NONE` | No file type |
| 1 | `ET_REL` | Relocatable file (a `.o`) |
| 2 | `ET_EXEC` | Executable file |
| 3 | `ET_DYN` | Shared object — also what PIE executables are (a PIE `ET_EXEC` doesn't exist; PIE binaries are `ET_DYN` with an entry point) |
| 4 | `ET_CORE` | Core dump file |
| 0xff00–0xffff | `ET_LOPROC`–`ET_HIPROC` | Processor-specific range |
{: style="--table-col-1: 14%; --table-col-2: 20%; --table-col-3: 66%;"}

## Program Header Types (`p_type`)

| Value | Constant | Meaning |
|---|---|---|
| 0 | `PT_NULL` | Unused entry |
| 1 | `PT_LOAD` | Loadable segment |
| 2 | `PT_DYNAMIC` | Dynamic linking information |
| 3 | `PT_INTERP` | Path to the requested program interpreter (dynamic linker) |
| 4 | `PT_NOTE` | Auxiliary information (notes) |
| 5 | `PT_SHLIB` | Reserved, unspecified semantics |
| 6 | `PT_PHDR` | Location of the program header table itself |
| 7 | `PT_TLS` | Thread-local storage template |
| 0x60000000–0x6fffffff | `PT_LOOS`–`PT_HIOS` | OS-specific range |
| 0x70000000–0x7fffffff | `PT_LOPROC`–`PT_HIPROC` | Processor-specific range |
| 0x6474e550 | `PT_GNU_EH_FRAME` | Exception-handling frame info (`.eh_frame_hdr`) |
| 0x6474e551 | `PT_GNU_STACK` | Stack executability — absence of this segment on an old binary means an executable stack |
| 0x6474e552 | `PT_GNU_RELRO` | Region to remap read-only after relocations are applied |
| 0x6474e553 | `PT_GNU_PROPERTY` | GNU property notes (e.g. CET/IBT markers) |
{: style="--table-col-1: 14%; --table-col-2: 20%; --table-col-3: 66%;"}

## Dynamic Section Tags (`d_tag`)

| Value | Constant | Meaning |
|---|---|---|
| 0 | `DT_NULL` | Marks the end of the `_DYNAMIC` array |
| 1 | `DT_NEEDED` | Name of a needed library |
| 2 | `DT_PLTRELSZ` | Total size of the relocations associated with the PLT |
| 3 | `DT_PLTGOT` | Address of the PLT and/or GOT |
| 4 | `DT_HASH` | Address of the symbol hash table |
| 5 | `DT_STRTAB` | Address of the string table |
| 6 | `DT_SYMTAB` | Address of the symbol table |
| 7 | `DT_RELA` | Address of the `Rela` relocation table |
| 8 | `DT_RELASZ` | Total size of the `Rela` table |
| 9 | `DT_RELAENT` | Size of one `Rela` entry |
| 10 | `DT_STRSZ` | Total size of the string table |
| 11 | `DT_SYMENT` | Size of one symbol table entry |
| 12 | `DT_INIT` | Address of the initialization function |
| 13 | `DT_FINI` | Address of the termination function |
| 14 | `DT_SONAME` | This object's own `SONAME` |
| 15 | `DT_RPATH` | Library search path (deprecated in favor of `DT_RUNPATH`) |
| 16 | `DT_SYMBOLIC` | Prefer resolving symbols within this shared object before the global scope |
| 17 | `DT_REL` | Address of the `Rel` relocation table |
| 18 | `DT_RELSZ` | Total size of the `Rel` table |
| 19 | `DT_RELENT` | Size of one `Rel` entry |
| 20 | `DT_PLTREL` | Type of relocation the PLT uses (`DT_REL` or `DT_RELA`) |
| 21 | `DT_DEBUG` | Used by debuggers at runtime (the classic `r_debug`/link-map hook GDB reads) |
| 22 | `DT_TEXTREL` | Segment permissions may be modified to apply a relocation |
| 23 | `DT_JMPREL` | Address of the PLT's relocation entries |
| 24 | `DT_BIND_NOW` | Process all relocations before execution — no lazy binding *(glibc-sourced)* |
| 29 | `DT_RUNPATH` | Library search path, evaluated after `DT_RPATH` and `LD_LIBRARY_PATH` *(glibc-sourced)* |
| 30 | `DT_FLAGS` | Flags for this object (e.g. `DF_BIND_NOW`, `DF_ORIGIN`) *(glibc-sourced)* |
| 0x6ffffef5 | `DT_GNU_HASH` | Address of the GNU-style symbol hash table |
| 0x6ffffff0 | `DT_VERSYM` | Address of the version symbol table |
| 0x6ffffffb | `DT_FLAGS_1` | State flags (`DF_1_*`) — this is where `DF_1_PIE` and `DF_1_NOW` (full RELRO's "now" half) actually live |
| 0x6ffffffc | `DT_VERDEF` | Address of version definitions |
| 0x6ffffffe | `DT_VERNEED` | Address of needed-version requirements |
{: style="--table-col-1: 14%; --table-col-2: 20%; --table-col-3: 66%;"}

## Section Header Types (`sh_type`)

| Value | Constant | Meaning |
|---|---|---|
| 0 | `SHT_NULL` | Unused section |
| 1 | `SHT_PROGBITS` | Program-defined data (e.g. `.text`, `.data`, `.rodata`) |
| 2 | `SHT_SYMTAB` | Symbol table |
| 3 | `SHT_STRTAB` | String table |
| 4 | `SHT_RELA` | Relocation entries with addends |
| 5 | `SHT_HASH` | Symbol hash table |
| 6 | `SHT_DYNAMIC` | Dynamic linking information |
| 7 | `SHT_NOTE` | Notes |
| 8 | `SHT_NOBITS` | Occupies no file space — this is `.bss` |
| 9 | `SHT_REL` | Relocation entries without addends |
| 10 | `SHT_SHLIB` | Reserved, unspecified semantics |
| 11 | `SHT_DYNSYM` | Minimal symbol table for dynamic linking |
{: style="--table-col-1: 14%; --table-col-2: 20%; --table-col-3: 66%;"}

## Segment Flags (`p_flags`)

| Value | Constant | Meaning |
|---|---|---|
| 0x1 | `PF_X` | Execute |
| 0x2 | `PF_W` | Write |
| 0x4 | `PF_R` | Read |
{: style="--table-col-1: 14%; --table-col-2: 20%; --table-col-3: 66%;"}

Combined, e.g. `PF_R\|PF_X` (5) is a typical `.text` `PT_LOAD` segment; `PF_R\|PF_W` (6) with no `PF_X` is what `PT_GNU_STACK` should have on a modern non-executable-stack binary.

## `e_ident` / Magic Bytes

| Byte offset | Constant | Meaning |
|---|---|---|
| 0–3 | `ELFMAG` | Magic bytes: `0x7f 'E' 'L' 'F'` |
| 4 | `EI_CLASS` | `ELFCLASS32` (1) or `ELFCLASS64` (2) |
| 5 | `EI_DATA` | `ELFDATA2LSB` (1, little-endian) or `ELFDATA2MSB` (2, big-endian) |
| 6 | `EI_VERSION` | ELF version (always 1 currently) |
| 7 | `EI_OSABI` | Target OS ABI — `ELFOSABI_LINUX` is 3 (though most Linux binaries actually still ship `ELFOSABI_NONE`/0 for portability) |
{: style="--table-col-1: 14%; --table-col-2: 20%; --table-col-3: 66%;"}

---

### Sources

- [torvalds/linux — linux/elf.h](https://github.com/torvalds/linux/blob/master/include/uapi/linux/elf.h)
- [glibc — elf/elf.h](https://github.com/bminor/glibc/blob/master/elf/elf.h)
- [man7.org — elf(5)](https://man7.org/linux/man-pages/man5/elf.5.html)
- [Wikipedia — Executable and Linkable Format](https://en.wikipedia.org/wiki/Executable_and_Linkable_Format)
