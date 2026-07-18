---
layout: reference
title: "CPU Registers"
excerpt: "General-purpose registers, ABI aliases, and calling-convention roles for every architecture covered on this site — one long page, one section per arch."
tags: [linux, c, lookup, pwn]
---

*Jump to: [x86](#x86-32-bit) · [x86_64](#x86_64) · [ARM](#arm-32-bit) · [ARM64](#arm64) · [MIPS](#mips-o32) · [MIPS64](#mips64-n64) · [PowerPC](#powerpc-32-bit) · [PowerPC64](#powerpc64) · [RISC-V32](#risc-v32) · [RISC-V64](#risc-v64)*

*Note: "Role" folds in caller-saved/callee-saved status (volatile = clobbered by a call, must be saved by the caller if needed after; callee-saved = a called function must preserve it). Values sourced from each architecture's real ABI spec — see Sources at the bottom — not a summarized cheat sheet. For the syscall-specific subset of these registers (which ones actually carry syscall arguments) see each architecture's own page under [Linux Syscalls](/references/syscalls/) instead — this page is about registers in general, including plain function calls.*

## x86 (32-bit)

| Register | Alias | Width | Role |
|---|---|---|---|
| `eax` | - | 32-bit | Accumulator; return value; caller-saved |
| `ebx` | - | 32-bit | General purpose; callee-saved |
| `ecx` | - | 32-bit | Counter (loop/shift ops); caller-saved |
| `edx` | - | 32-bit | Data; high half of a 64-bit return value (`edx:eax`); caller-saved |
| `esi` | - | 32-bit | Source index (string ops); callee-saved |
| `edi` | - | 32-bit | Destination index (string ops); callee-saved |
| `ebp` | - | 32-bit | Frame/base pointer; callee-saved by convention |
| `esp` | - | 32-bit | Stack pointer; preserved across calls |
| `eip` | - | 32-bit | Instruction pointer (not directly addressable) |
| `eflags` | - | 32-bit | Flags register (ZF, CF, SF, OF, DF, IF, ...) |
| `cs`/`ds`/`es`/`fs`/`gs`/`ss` | - | 16-bit | Segment selectors — `cs`=code, `ss`=stack, `ds`/`es`=data, `fs`/`gs`=extra (TLS use varies by OS) |
{: style="--table-col-1: 22%; --table-col-2: 12%; --table-col-3: 10%; --table-col-4: 56%;"}

`eax`, `ebx`, `ecx`, and `edx` each break down further into a 16-bit and a pair of 8-bit sub-registers — the 16-bit form (`ax`) is addressable as a whole, or as its high/low halves (`ah`/`al`) individually. `esi`, `edi`, `ebp`, and `esp` only go one level deeper than their 32-bit form (`si`, `di`, `bp`, `sp`) — 32-bit mode never gave them independent high/low byte names.

### x86 Register Diagram

```
31                                      15                  7                  0
+----------------------------------------+------------------+------------------+
|                                        |                 $ax                 |
|                  $eax                  +------------------+------------------+
|                                        |        $ah       |        $al       |
+----------------------------------------+------------------+------------------+
|                                        |                 $bx                 |
|                  $ebx                  +------------------+------------------+
|                                        |        $bh       |        $bl       |
+----------------------------------------+------------------+------------------+
|                                        |                 $cx                 |
|                  $ecx                  +------------------+------------------+
|                                        |        $ch       |        $cl       |
+----------------------------------------+------------------+------------------+
|                                        |                 $dx                 |
|                  $edx                  +------------------+------------------+
|                                        |        $dh       |        $dl       |
+----------------------------------------+------------------+------------------+
|                                        |                 $si                 |
|                  $esi                  +------------------+------------------+
|                                        |                  |       $sil       |
+----------------------------------------+------------------+------------------+
|                                        |                 $di                 |
|                  $edi                  +------------------+------------------+
|                                        |                  |       $dil       |
+----------------------------------------+------------------+------------------+
|                                        |                 $bp                 |
|                  $ebp                  +------------------+------------------+
|                                        |                  |       $bpl       |
+----------------------------------------+------------------+------------------+
|                                        |                 $sp                 |
|                  $esp                  +------------------+------------------+
|                                        |                  |       $spl       |
+----------------------------------------+------------------+------------------+
|                                                                              |
|                                     $eip                                     |
|                                                                              |
+------------------------------------------------------------------------------+
```

## x86_64

| Register | Alias | Width | Role |
|---|---|---|---|
| `rax` | `eax`/`ax`/`al` | 64-bit | Return value (1st half); caller-saved |
| `rbx` | `ebx`/`bx`/`bl` | 64-bit | General purpose; callee-saved |
| `rcx` | `ecx`/`cx`/`cl` | 64-bit | 4th integer arg; caller-saved |
| `rdx` | `edx`/`dx`/`dl` | 64-bit | 3rd integer arg; return value (2nd half); caller-saved |
| `rsi` | `esi`/`si`/`sil` | 64-bit | 2nd integer arg; caller-saved |
| `rdi` | `edi`/`di`/`dil` | 64-bit | 1st integer arg; caller-saved |
| `rbp` | `ebp`/`bp`/`bpl` | 64-bit | Frame pointer (optional); callee-saved |
| `rsp` | `esp`/`sp`/`spl` | 64-bit | Stack pointer; callee-saved (implicitly) |
| `r8` | `r8d`/`r8w`/`r8b` | 64-bit | 5th integer arg; caller-saved |
| `r9` | `r9d`/`r9w`/`r9b` | 64-bit | 6th integer arg; caller-saved |
| `r10` | `r10d`/`r10w`/`r10b` | 64-bit | Temp; `syscall`'s 4th arg (replaces `rcx`, which the instruction clobbers); caller-saved |
| `r11` | `r11d`/`r11w`/`r11b` | 64-bit | Temp; clobbered by the `syscall` instruction itself; caller-saved |
| `r12`–`r15` | `r12d`-`r15d` etc. | 64-bit | General purpose; callee-saved |
| `rip` | - | 64-bit | Instruction pointer (RIP-relative addressing) |
| `rflags` | - | 64-bit | Flags register |
| `cs`/`ss`/`ds`/`es` | - | 16-bit | Legacy segment selectors — base forced to 0 in long mode, unused for addressing |
| `fs`/`gs` | - | 16-bit + MSR | Base held in MSRs `FSBase`/`GSBase`; `fs` is glibc's TLS base on Linux |
{: style="--table-col-1: 14%; --table-col-2: 18%; --table-col-3: 14%; --table-col-4: 54%;"}

`rax` carries its 32/16/8-bit sub-registers down from the 32-bit era unchanged — `eax` is literally the low 32 bits of `rax` (writing `eax` zero-extends into the upper 32 bits of `rax`; writing `ax`/`al` does not), and `ax` still splits into `ah`/`al` the same way it did in 32-bit mode. Every other GPR added or extended for x86_64 — `rsi`/`rdi`/`rbp`/`rsp` (which gained a low-byte form, `sil`/`dil`/`bpl`/`spl`, only with a REX prefix) and `r8`-`r15` (`r8d`/`r8w`/`r8b`, etc.) — stops one level short of this: they get a 32-bit and 16-bit form and a single low-byte form, but **no separate high-byte (`*h`) register** — `ah`/`bh`/`ch`/`dh` are the only high-byte names that exist at all, a holdover from the four original 8086 registers.

### x86_64 Register Diagram

```
63                                                                         31                                       15                  7                  0
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $ax                 |
|                                    $rax                                   |                  $eax                  +------------------+------------------+
|                                                                           |                                        |        $ah       |        $al       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $bx                 |
|                                    $rbx                                   |                  $ebx                  +------------------+------------------+
|                                                                           |                                        |        $bh       |        $bl       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $cx                 |
|                                    $rcx                                   |                  $ecx                  +------------------+------------------+
|                                                                           |                                        |        $ch       |        $cl       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $dx                 |
|                                    $rdx                                   |                  $edx                  +------------------+------------------+
|                                                                           |                                        |        $dh       |        $dl       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $si                 |
|                                    $rsi                                   |                  $esi                  +------------------+------------------+
|                                                                           |                                        |                  |       $sil       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $di                 |
|                                    $rdi                                   |                  $edi                  +------------------+------------------+
|                                                                           |                                        |                  |       $dil       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $bp                 |
|                                    $rbp                                   |                  $ebp                  +------------------+------------------+
|                                                                           |                                        |                  |       $bpl       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                        |                 $sp                 |
|                                    $rsp                                   |                  $esp                  +------------------+------------------+
|                                                                           |                                        |                  |       $spl       |
+---------------------------------------------------------------------------+----------------------------------------+------------------+------------------+
|                                                                           |                                                                              |
|                                    $rip                                   |                                     $eip                                     |
|                                                                           |                                                                              |
+---------------------------------------------------------------------------+------------------------------------------------------------------------------+
```

## ARM (32-bit)

| Register | Alias | Width | Role |
|---|---|---|---|
| `r0`–`r3` | `a1`–`a4` | 32-bit | Argument/result registers; scratch; caller-saved |
| `r4`–`r8` | `v1`–`v5` | 32-bit | Callee-saved "variable" registers |
| `r9` | `v6` / `SB` / `TR` | 32-bit | Platform-specific: callee-saved variable reg, static base, or thread register depending on platform |
| `r10` | `v7` / `SL` | 32-bit | Callee-saved; sometimes used as a stack limit |
| `r11` | `v8` / `FP` | 32-bit | Callee-saved; frame pointer in many variants |
| `r12` | `IP` | 32-bit | Intra-procedure-call scratch register, used by linker veneers; caller-saved |
| `r13` | `SP` | 32-bit | Stack pointer; must be preserved across calls |
| `r14` | `LR` | 32-bit | Link register (return address); caller-saved if not needed after the call |
| `r15` | `PC` | 32-bit | Program counter |
| `cpsr` | - | 32-bit | Current Program Status Register — N/Z/C/V condition flags, mode bits, IRQ/FIQ masks |
{: style="--table-col-1: 14%; --table-col-2: 18%; --table-col-3: 14%; --table-col-4: 54%;"}

## ARM64

| Register | Alias | Width | Role |
|---|---|---|---|
| `x0`–`x7` | `w0`–`w7` | 64/32-bit | Argument/result registers (1st–8th); caller-saved |
| `x8` | `w8` | 64/32-bit | Indirect result location register (pointer to caller-allocated space for large struct returns); caller-saved |
| `x9`–`x15` | `w9`–`w15` | 64/32-bit | Temporary/scratch registers; caller-saved |
| `x16`–`x17` | `w16`–`w17` | 64/32-bit | `IP0`/`IP1` — intra-procedure-call temp registers, used by linker veneers/PLT stubs; caller-saved |
| `x18` | `w18` | 64/32-bit | Platform register — reserved for platform use (TLS/shadow-stack) on some OSes; otherwise a spare caller-saved register |
| `x19`–`x28` | `w19`–`w28` | 64/32-bit | Callee-saved |
| `x29` | `w29` / `FP` | 64/32-bit | Frame pointer; callee-saved |
| `x30` | `w30` / `LR` | 64/32-bit | Link register (return address); caller-saved |
| `sp` | `wsp` | 64/32-bit | Stack pointer — a separate register, not one of `x0`-`x30` |
| `pc` | - | 64-bit | Program counter (not directly accessible) |
| `xzr` | `wzr` | 64/32-bit | Zero register — reads as 0, writes discarded |
| `pstate` | `nzcv` | - | Process state — N/Z/C/V condition flags |
{: style="--table-col-1: 14%; --table-col-2: 18%; --table-col-3: 14%; --table-col-4: 54%;"}

## MIPS (o32)

| Register | Alias | Width | Role |
|---|---|---|---|
| `$zero` | `r0` | 32-bit | Hardwired zero |
| `$at` | `r1` | 32-bit | Assembler temporary — reserved for pseudo-instruction expansion |
| `$v0`–`$v1` | `r2`–`r3` | 32-bit | Return values; caller-saved |
| `$a0`–`$a3` | `r4`–`r7` | 32-bit | Arguments 1–4; caller-saved |
| `$t0`–`$t7` | `r8`–`r15` | 32-bit | Temporaries; caller-saved |
| `$s0`–`$s7` | `r16`–`r23` | 32-bit | Saved registers; callee-saved |
| `$t8`–`$t9` | `r24`–`r25` | 32-bit | Temporaries; caller-saved |
| `$k0`–`$k1` | `r26`–`r27` | 32-bit | Reserved for kernel/OS (interrupt/trap handling) |
| `$gp` | `r28` | 32-bit | Global pointer |
| `$sp` | `r29` | 32-bit | Stack pointer; callee-saved |
| `$fp` / `$s8` | `r30` | 32-bit | Frame pointer, doubling as a 9th saved register; callee-saved |
| `$ra` | `r31` | 32-bit | Return address; caller-saved unless explicitly preserved |
| `hi`, `lo` | - | 32-bit each | Hold the 64-bit result of an integer multiply/divide |
{: style="--table-col-1: 14%; --table-col-2: 12%; --table-col-3: 14%; --table-col-4: 60%;"}

## MIPS64 (n64)

Same base register file as o32, but n64 **renames registers 8–15**: what o32 calls `$t0`–`$t7` becomes `$a4`–`$a7` (5th–8th integer args) followed by a renumbered `$t0`–`$t3`. `$t8`/`$t9` keep their names and positions unchanged. Every other register keeps the same name, just 64 bits wide.

| Register | Alias | Width | Role |
|---|---|---|---|
| `$zero` | `r0` | 64-bit | Hardwired zero |
| `$at` | `r1` | 64-bit | Assembler temporary |
| `$v0`–`$v1` | `r2`–`r3` | 64-bit | Return values; caller-saved |
| `$a0`–`$a3` | `r4`–`r7` | 64-bit | Arguments 1–4; caller-saved |
| `$a4`–`$a7` | `r8`–`r11` | 64-bit | Arguments 5–8 — **this is o32's `$t0`-`$t3` slot, repurposed**; caller-saved |
| `$t0`–`$t3` | `r12`–`r15` | 64-bit | Temporaries — renumbered from o32's `$t4`-`$t7`; caller-saved |
| `$s0`–`$s7` | `r16`–`r23` | 64-bit | Saved registers; callee-saved |
| `$t8`–`$t9` | `r24`–`r25` | 64-bit | Temporaries — unchanged from o32; caller-saved |
| `$k0`–`$k1` | `r26`–`r27` | 64-bit | Reserved for kernel/OS |
| `$gp` | `r28` | 64-bit | Global pointer |
| `$sp` | `r29` | 64-bit | Stack pointer; callee-saved |
| `$fp` / `$s8` | `r30` | 64-bit | Frame pointer / 9th saved register; callee-saved |
| `$ra` | `r31` | 64-bit | Return address; caller-saved unless preserved |
| `hi`, `lo` | - | 64-bit each | Multiply/divide result |
{: style="--table-col-1: 14%; --table-col-2: 12%; --table-col-3: 14%; --table-col-4: 60%;"}

## PowerPC (32-bit)

| Register | Alias | Width | Role |
|---|---|---|---|
| `r0` | - | 32-bit | Volatile scratch, used in prologues; caller-saved |
| `r1` | `SP` | 32-bit | Stack pointer; callee-saved |
| `r2` | - | 32-bit | Reserved (TOC pointer on some ABI variants) |
| `r3`–`r10` | - | 32-bit | Argument-passing registers (up to 8 integer args); `r3`/`r4` double as the return value; caller-saved |
| `r11`–`r12` | - | 32-bit | Volatile; `r12` used by the linker for exception/global-linkage glue; caller-saved |
| `r13` | - | 32-bit | Small-data-area pointer (reserved, embedded/SVR4 EABI); non-volatile |
| `r14`–`r31` | - | 32-bit | General-purpose/local variables; callee-saved |
| `lr` | - | 32-bit | Link register (return address); volatile unless explicitly preserved |
| `ctr` | - | 32-bit | Count register — loop counter / indirect branch target (`bctr`); volatile |
| `cr` | - | 32-bit | Condition register, split into 8 four-bit fields `cr0`-`cr7`; volatile except by convention on some fields |
| `xer` | - | 32-bit | Fixed-point exception register (carry, overflow, string-op byte count); volatile |
| `pc` / `nip` | - | 32-bit | Program counter ("next instruction pointer") |
{: style="--table-col-1: 14%; --table-col-2: 10%; --table-col-3: 14%; --table-col-4: 62%;"}

## PowerPC64

Same register set, names, and numbering as 32-bit PowerPC above — only the width changes, to 64 bits. The volatile/non-volatile split is unchanged (`r0`, `r3`-`r12` volatile; `r1`, `r14`-`r31` non-volatile).

## RISC-V32

| Register | ABI Name | Width | Role |
|---|---|---|---|
| `x0` | `zero` | 32-bit | Hardwired zero |
| `x1` | `ra` | 32-bit | Return address; caller-saved |
| `x2` | `sp` | 32-bit | Stack pointer; callee-saved |
| `x3` | `gp` | 32-bit | Global pointer — fixed, not allocatable by the compiler |
| `x4` | `tp` | 32-bit | Thread pointer — fixed, not allocatable |
| `x5`–`x7` | `t0`–`t2` | 32-bit | Temporaries; caller-saved |
| `x8` | `s0`/`fp` | 32-bit | Saved register / frame pointer; callee-saved |
| `x9` | `s1` | 32-bit | Saved register; callee-saved |
| `x10`–`x17` | `a0`–`a7` | 32-bit | Arguments/return values (`a0`-`a1` double as the return value); caller-saved |
| `x18`–`x27` | `s2`–`s11` | 32-bit | Saved registers; callee-saved |
| `x28`–`x31` | `t3`–`t6` | 32-bit | Temporaries; caller-saved |
| — | `pc` | 32-bit | Program counter — not a GPR, a separate register |
{: style="--table-col-1: 12%; --table-col-2: 14%; --table-col-3: 14%; --table-col-4: 60%;"}

`gp` and `tp` must not be modified by ordinary code (signal handlers may depend on them being stable); if a frame pointer is used, it must be `x8`.

## RISC-V64

Identical ABI register names, numbers, and roles to RISC-V32 above — RISC-V does not rename registers based on word size (unlike MIPS's o32/n64 split). The only difference is that `x0`–`x31` are 64 bits wide instead of 32.

---

### Sources

- [System V AMD64 ABI](https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)
- [x86 calling conventions — Wikipedia](https://en.wikipedia.org/wiki/X86_calling_conventions)
- [ARM-software/abi-aa — AAPCS32](https://github.com/ARM-software/abi-aa/blob/main/aapcs32/aapcs32.rst)
- [ARM-software/abi-aa — AAPCS64](https://github.com/ARM-software/abi-aa/blob/main/aapcs64/aapcs64.rst)
- [System V ABI MIPS RISC Processor Supplement](https://refspecs.linuxfoundation.org/elf/mipsabi.pdf)
- [64-bit PowerPC ELF ABI Supplement](https://refspecs.linuxfoundation.org/ELF/ppc64/PPC-elf64abi.html)
- [RISC-V ELF psABI — Calling Convention](https://github.com/riscv-non-isa/riscv-elf-psabi-doc/blob/master/riscv-cc.adoc)
