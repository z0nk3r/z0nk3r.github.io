---
layout: reference
title: "ptrace(2) Requests"
excerpt: "Every PTRACE_* request constant — generic and x86-specific — with its numeric value and what it does."
tags: [linux, c, lookup, pwn]
---

*Note: the kernel header spells the USER-area requests `PTRACE_PEEKUSR`/`PTRACE_POKEUSR` (no "E" before "R"); glibc's `<sys/ptrace.h>` wrapper exposes them as `PTRACE_PEEKUSER`/`PTRACE_POKEUSER` instead — same requests, different name depending on which header you're looking at.*

## Generic Requests

| Constant | Value | Description |
|---|---|---|
| `PTRACE_TRACEME` | 0 | Indicate that this process is to be traced by its parent |
| `PTRACE_PEEKTEXT` | 1 | Read a word at an address in the tracee's memory |
| `PTRACE_PEEKDATA` | 2 | Read a word at an address in the tracee's memory (same as PEEKTEXT on Linux) |
| `PTRACE_PEEKUSR` | 3 | Read a word at an offset in the tracee's USER area (registers/process info) |
| `PTRACE_POKETEXT` | 4 | Write a word to an address in the tracee's memory |
| `PTRACE_POKEDATA` | 5 | Write a word to an address in the tracee's memory (same as POKETEXT on Linux) |
| `PTRACE_POKEUSR` | 6 | Write a word to an offset in the tracee's USER area |
| `PTRACE_CONT` | 7 | Restart the stopped tracee, optionally delivering a signal |
| `PTRACE_KILL` | 8 | Send the tracee a SIGKILL. **Deprecated** — use `kill(2)`/`tgkill(2)` instead |
| `PTRACE_SINGLESTEP` | 9 | Restart the tracee and stop it again after one instruction |
| `PTRACE_ATTACH` | 16 | Attach to a process, making it a tracee, and send it SIGSTOP |
| `PTRACE_DETACH` | 17 | Restart the tracee and detach from it |
| `PTRACE_SYSCALL` | 24 | Restart the tracee and stop it at the next syscall entry or exit |
| `PTRACE_SETOPTIONS` | 0x4200 | Set tracing options (bitmask of `PTRACE_O_*` flags, see below) |
| `PTRACE_GETEVENTMSG` | 0x4201 | Retrieve a message about the ptrace event that just occurred |
| `PTRACE_GETSIGINFO` | 0x4202 | Retrieve `siginfo_t` for the signal that caused the stop |
| `PTRACE_SETSIGINFO` | 0x4203 | Set the tracee's `siginfo_t` |
| `PTRACE_GETREGSET` | 0x4204 | Read tracee registers of a given `NT_*` type via an iovec |
| `PTRACE_SETREGSET` | 0x4205 | Write tracee registers of a given `NT_*` type via an iovec |
| `PTRACE_SEIZE` | 0x4206 | Attach without stopping the tracee; enables SEIZE/INTERRUPT/LISTEN semantics |
| `PTRACE_INTERRUPT` | 0x4207 | Stop a seized tracee that's running or sleeping in the kernel |
| `PTRACE_LISTEN` | 0x4208 | Restart a stopped, seized tracee but keep it in a listening state |
| `PTRACE_PEEKSIGINFO` | 0x4209 | Retrieve queued `siginfo_t`s without removing them from the queue |
| `PTRACE_GETSIGMASK` | 0x420a | Retrieve the tracee's blocked-signal mask |
| `PTRACE_SETSIGMASK` | 0x420b | Set the tracee's blocked-signal mask |
| `PTRACE_SECCOMP_GET_FILTER` | 0x420c | Dump the tracee's classic BPF seccomp filter |
| `PTRACE_SECCOMP_GET_METADATA` | 0x420d | Retrieve seccomp filter metadata |
| `PTRACE_GET_SYSCALL_INFO` | 0x420e | Retrieve detailed info about the syscall that caused the stop |
| `PTRACE_GET_RSEQ_CONFIGURATION` | 0x420f | Retrieve restartable-sequence (rseq) ABI configuration |
| `PTRACE_SET_SYSCALL_USER_DISPATCH_CONFIG` | 0x4210 | Configure Syscall User Dispatch for the tracee |
| `PTRACE_GET_SYSCALL_USER_DISPATCH_CONFIG` | 0x4211 | Read Syscall User Dispatch config |
| `PTRACE_SET_SYSCALL_INFO` | 0x4212 | Set syscall info (counterpart to GET_SYSCALL_INFO) |
{: style="--table-col-1: 28%; --table-col-2: 12%; --table-col-3: 60%;"}

## x86 / x86_64-specific Requests

Not in the generic header above — defined per-architecture. These are the x86 values (`arch/x86/include/uapi/asm/ptrace-abi.h`).

| Constant | Value | Description |
|---|---|---|
| `PTRACE_GETREGS` | 12 | Read the tracee's general-purpose registers |
| `PTRACE_SETREGS` | 13 | Write the tracee's general-purpose registers |
| `PTRACE_GETFPREGS` | 14 | Read the tracee's floating-point registers |
| `PTRACE_SETFPREGS` | 15 | Write the tracee's floating-point registers |
| `PTRACE_GETFPXREGS` | 18 | Read extended FP registers (FXSAVE format) |
| `PTRACE_SETFPXREGS` | 19 | Write extended FP registers (FXSAVE format) |
| `PTRACE_OLDSETOPTIONS` | 21 | Legacy predecessor of `PTRACE_SETOPTIONS` |
| `PTRACE_GET_THREAD_AREA` | 25 | Read a GDT entry (32-bit TLS) |
| `PTRACE_SET_THREAD_AREA` | 26 | Write a GDT entry (32-bit TLS) |
| `PTRACE_ARCH_PRCTL` | 30 | x86_64-only: `arch_prctl()` on behalf of the tracee (e.g. FS/GS base) |
| `PTRACE_SYSEMU` | 31 | Like SYSCALL, but don't actually execute the syscall (used by user-mode emulators) |
| `PTRACE_SYSEMU_SINGLESTEP` | 32 | SYSEMU combined with single-stepping |
| `PTRACE_SINGLEBLOCK` | 33 | Resume execution until the next branch |
{: style="--table-col-1: 28%; --table-col-2: 12%; --table-col-3: 60%;"}

## Event Codes (`PTRACE_EVENT_*`)

Returned via `PTRACE_GETEVENTMSG` after a `PTRACE_O_TRACE*`-enabled stop, and encoded into SIGTRAP's status as `(event << 8) | SIGTRAP`.

| Constant | Value |
|---|---|
| `PTRACE_EVENT_FORK` | 1 |
| `PTRACE_EVENT_VFORK` | 2 |
| `PTRACE_EVENT_CLONE` | 3 |
| `PTRACE_EVENT_EXEC` | 4 |
| `PTRACE_EVENT_VFORK_DONE` | 5 |
| `PTRACE_EVENT_EXIT` | 6 |
| `PTRACE_EVENT_SECCOMP` | 7 |
| `PTRACE_EVENT_STOP` | 128 |
{: style="--table-col-1: 60%; --table-col-2: 40%;"}

## Options (`PTRACE_O_*`)

Bitmask flags passed to `PTRACE_SETOPTIONS`.

| Constant | Value |
|---|---|
| `PTRACE_O_TRACESYSGOOD` | 1 |
| `PTRACE_O_TRACEFORK` | 2 |
| `PTRACE_O_TRACEVFORK` | 4 |
| `PTRACE_O_TRACECLONE` | 8 |
| `PTRACE_O_TRACEEXEC` | 16 |
| `PTRACE_O_TRACEVFORKDONE` | 32 |
| `PTRACE_O_TRACEEXIT` | 64 |
| `PTRACE_O_TRACESECCOMP` | 128 |
| `PTRACE_O_EXITKILL` | 0x100000 |
| `PTRACE_O_SUSPEND_SECCOMP` | 0x200000 |
{: style="--table-col-1: 60%; --table-col-2: 40%;"}

---

### Sources

- [torvalds/linux — linux/ptrace.h](https://github.com/torvalds/linux/blob/master/include/uapi/linux/ptrace.h)
- [torvalds/linux — x86/ptrace-abi.h](https://github.com/torvalds/linux/blob/master/arch/x86/include/uapi/asm/ptrace-abi.h)
- [man7.org — ptrace(2)](https://man7.org/linux/man-pages/man2/ptrace.2.html)
- [Wikipedia — ptrace](https://en.wikipedia.org/wiki/Ptrace)
