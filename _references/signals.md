---
layout: reference
title: "Linux Signals"
excerpt: "Every standard POSIX/Linux signal with its default action, plus the siginfo_t si_code sub-values fault signals carry."
tags: [linux, c, lookup]
---

## Standard Signals

*Note: numbering and default actions sourced from the kernel headers directly, not a cheat sheet. x86_64 doesn't override the generic numbering below — some other architectures (Alpha, SPARC, MIPS, PA-RISC) do assign different numbers to a few of these, which this table doesn't cover.*

| # | Name | Alt Name | Default | Description |
|---|---|---|---|---|
| 1 | `SIGHUP` | - | Term | Hangup detected on controlling terminal or death of controlling process |
| 2 | `SIGINT` | - | Term | Interrupt from keyboard |
| 3 | `SIGQUIT` | - | Core | Quit from keyboard |
| 4 | `SIGILL` | - | Core | Illegal instruction |
| 5 | `SIGTRAP` | - | Core | Trace/breakpoint trap |
| 6 | `SIGABRT` | `SIGIOT` | Core | Abort signal from `abort(3)` |
| 7 | `SIGBUS` | - | Core | Bus error (bad memory access) |
| 8 | `SIGFPE` | - | Core | Erroneous arithmetic operation |
| 9 | `SIGKILL` | - | Term | Kill signal (cannot be caught, blocked, or ignored) |
| 10 | `SIGUSR1` | - | Term | User-defined signal 1 |
| 11 | `SIGSEGV` | - | Core | Invalid memory reference |
| 12 | `SIGUSR2` | - | Term | User-defined signal 2 |
| 13 | `SIGPIPE` | - | Term | Broken pipe: write to pipe with no readers |
| 14 | `SIGALRM` | - | Term | Timer signal from `alarm(2)` |
| 15 | `SIGTERM` | - | Term | Termination signal |
| 16 | `SIGSTKFLT` | - | Term | Stack fault on coprocessor (Linux-only, unused on most modern kernels) |
| 17 | `SIGCHLD` | - | Ign | Child stopped, terminated, or continued |
| 18 | `SIGCONT` | - | Cont | Continue if stopped |
| 19 | `SIGSTOP` | - | Stop | Stop process (cannot be caught, blocked, or ignored) |
| 20 | `SIGTSTP` | - | Stop | Stop typed at terminal |
| 21 | `SIGTTIN` | - | Stop | Terminal input for background process |
| 22 | `SIGTTOU` | - | Stop | Terminal output for background process |
| 23 | `SIGURG` | - | Ign | Urgent condition on socket (4.2BSD) |
| 24 | `SIGXCPU` | - | Core | CPU time limit exceeded |
| 25 | `SIGXFSZ` | - | Core | File size limit exceeded |
| 26 | `SIGVTALRM` | - | Term | Virtual alarm clock (4.2BSD) |
| 27 | `SIGPROF` | - | Term | Profiling timer expired |
| 28 | `SIGWINCH` | - | Ign | Window resize signal (4.3BSD, Sun) |
| 29 | `SIGIO` | `SIGPOLL` | Term | I/O now possible (4.2BSD) |
| 30 | `SIGPWR` | - | Term | Power failure (System V) |
| 31 | `SIGSYS` | `SIGUNUSED` | Core | Bad system call (SVr4) |
{: style="--table-col-1: 5%; --table-col-2: 14%; --table-col-3: 12%; --table-col-4: 10%; --table-col-5: 59%;"}

**Default actions**: Term = terminate the process, Core = terminate and dump core, Ign = ignored by default, Stop = stop the process, Cont = continue a stopped process.

**Real-time signals**: `SIGRTMIN` (32) through `SIGRTMAX` (64) — 33 signals reserved for application use. Unlike the standard signals above, real-time signals queue (multiple pending instances of the same signal are all delivered, not coalesced into one) and are delivered in guaranteed FIFO order per signal number. glibc reserves the first two of these internally, so `SIGRTMIN` as seen by an application is usually the kernel's 32+2=34, not 32 directly.

## `si_code` Values

When a handler is registered with `SA_SIGINFO`, the `siginfo_t` passed to it carries an `si_code` field with more detail than the signal number alone gives. Generic `SI_*` codes can accompany any signal; the fault-generating signals below each define their own more specific set. Concretely, this is what makes a SIGSEGV's `siginfo_t` look like:

```c
siginfo_t {
    si_signo = 0xb,   /* signal 0xb/11 == SIGSEGV */
    si_errno = 0x0,
    si_code  = 0x2,   /* SEGV_ACCERR: invalid permissions for mapped object */
    ...
}
```

### Generic (any signal)

| Value | Name | Meaning |
|---|---|---|
| 0 | `SI_USER` | Sent by `kill()`, `sigsend()`, or `raise()` |
| 0x80 | `SI_KERNEL` | Sent by the kernel from somewhere |
| -1 | `SI_QUEUE` | Sent by `sigqueue()` |
| -2 | `SI_TIMER` | Sent by timer expiration |
| -3 | `SI_MESGQ` | Sent by real-time message queue state change |
| -4 | `SI_ASYNCIO` | Sent by AIO completion |
| -5 | `SI_SIGIO` | Sent by queued SIGIO |
| -6 | `SI_TKILL` | Sent by the `tkill()` syscall |
| -7 | `SI_DETHREAD` | Sent by `execve()` killing subsidiary threads |
| -60 | `SI_ASYNCNL` | Sent by glibc's async name lookup completion |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGILL`

| Value | Name | Meaning |
|---|---|---|
| 1 | `ILL_ILLOPC` | Illegal opcode |
| 2 | `ILL_ILLOPN` | Illegal operand |
| 3 | `ILL_ILLADR` | Illegal addressing mode |
| 4 | `ILL_ILLTRP` | Illegal trap |
| 5 | `ILL_PRVOPC` | Privileged opcode |
| 6 | `ILL_PRVREG` | Privileged register |
| 7 | `ILL_COPROC` | Coprocessor error |
| 8 | `ILL_BADSTK` | Internal stack error |
| 9 | `ILL_BADIADDR` | Unimplemented instruction address |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGFPE`

| Value | Name | Meaning |
|---|---|---|
| 1 | `FPE_INTDIV` | Integer divide by zero |
| 2 | `FPE_INTOVF` | Integer overflow |
| 3 | `FPE_FLTDIV` | Floating-point divide by zero |
| 4 | `FPE_FLTOVF` | Floating-point overflow |
| 5 | `FPE_FLTUND` | Floating-point underflow |
| 6 | `FPE_FLTRES` | Floating-point inexact result |
| 7 | `FPE_FLTINV` | Floating-point invalid operation |
| 8 | `FPE_FLTSUB` | Subscript out of range |
| 14 | `FPE_FLTUNK` | Undiagnosed floating-point exception |
| 15 | `FPE_CONDTRAP` | Trap on condition |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGSEGV`

| Value | Name | Meaning |
|---|---|---|
| 1 | `SEGV_MAPERR` | Address not mapped to object |
| 2 | `SEGV_ACCERR` | Invalid permissions for mapped object |
| 3 | `SEGV_BNDERR` | Failed address bound checks |
| 4 | `SEGV_PKUERR` | Failed protection key checks |
| 5 | `SEGV_ACCADI` | ADI (MCD tag) not enabled for mapped object |
| 6 | `SEGV_ADIDERR` | Disrupting MCD error |
| 7 | `SEGV_ADIPERR` | Precise MCD exception |
| 8 | `SEGV_MTEAERR` | Asynchronous ARM MTE error |
| 9 | `SEGV_MTESERR` | Synchronous ARM MTE exception |
| 10 | `SEGV_CPERR` | Control protection fault |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGBUS`

| Value | Name | Meaning |
|---|---|---|
| 1 | `BUS_ADRALN` | Invalid address alignment |
| 2 | `BUS_ADRERR` | Non-existent physical address |
| 3 | `BUS_OBJERR` | Object-specific hardware error |
| 4 | `BUS_MCEERR_AR` | Hardware memory error consumed on a machine check (action required) |
| 5 | `BUS_MCEERR_AO` | Hardware memory error detected but not consumed (action optional) |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGTRAP`

| Value | Name | Meaning |
|---|---|---|
| 1 | `TRAP_BRKPT` | Process breakpoint |
| 2 | `TRAP_TRACE` | Process trace trap |
| 3 | `TRAP_BRANCH` | Process taken-branch trap |
| 4 | `TRAP_HWBKPT` | Hardware breakpoint/watchpoint |
| 5 | `TRAP_UNK` | Undiagnosed trap |
| 6 | `TRAP_PERF` | perf event with `sigtrap=1` |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

There's a second, unrelated set of `SIGTRAP` `si_code`s used by `ptrace(2)` event notifications, of the form `(PTRACE_EVENT_XXX << 8) | SIGTRAP)` — see the [ptrace(2) Requests](/references/ptrace-requests/) page for the `PTRACE_EVENT_*` values.

### `SIGCHLD`

| Value | Name | Meaning |
|---|---|---|
| 1 | `CLD_EXITED` | Child has exited |
| 2 | `CLD_KILLED` | Child was killed |
| 3 | `CLD_DUMPED` | Child terminated abnormally |
| 4 | `CLD_TRAPPED` | Traced child has trapped |
| 5 | `CLD_STOPPED` | Child has stopped |
| 6 | `CLD_CONTINUED` | Stopped child has continued |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGPOLL`

| Value | Name | Meaning |
|---|---|---|
| 1 | `POLL_IN` | Data input available |
| 2 | `POLL_OUT` | Output buffers available |
| 3 | `POLL_MSG` | Input message available |
| 4 | `POLL_ERR` | I/O error |
| 5 | `POLL_PRI` | High-priority input available |
| 6 | `POLL_HUP` | Device disconnected |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

### `SIGSYS`

| Value | Name | Meaning |
|---|---|---|
| 1 | `SYS_SECCOMP` | Triggered by a seccomp filter |
| 2 | `SYS_USER_DISPATCH` | Triggered by syscall user dispatch |
{: style="--table-col-1: 12%; --table-col-2: 25%; --table-col-3: 63%;"}

---

### Sources

- [torvalds/linux — asm-generic/signal.h](https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/signal.h)
- [torvalds/linux — asm-generic/siginfo.h](https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/siginfo.h)
- [man7.org — signal(7)](https://man7.org/linux/man-pages/man7/signal.7.html)
- [Wikipedia — Signal (IPC)](https://en.wikipedia.org/wiki/Signal_(IPC))
