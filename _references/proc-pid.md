---
layout: reference
title: "/proc/[pid]/ Reference"
excerpt: "The most useful entries under /proc/[pid]/ for debugging, reverse engineering, and process introspection."
tags: [linux, c, lookup, pwn]
---

*Note: descriptions are drawn from the real `proc_pid_*(5)` man pages, not paraphrased from memory. Most of these require the caller to hold `PTRACE_MODE_READ_FSCREDS` or `PTRACE_MODE_ATTACH_FSCREDS` on the target (roughly: same UID, or `CAP_SYS_PTRACE`) — see [ptrace(2) Requests](/references/ptrace-requests/) for what those access modes gate.*

| Entry | Description |
|---|---|
| `maps` | Currently mapped memory regions and their permissions: `address perms offset dev inode pathname`. The single most-used file for RE/exploitation — this is where you find the base addresses of the binary, libc, the stack, and the heap. |
| `mem` | The process's memory itself, accessible via `open()`/`read()`/`lseek()` at the offsets shown in `maps`. Lets you read (and, if writable, patch) live process memory without `ptrace()`. |
| `status` | Human-readable summary of `stat`/`statm` plus more: name, state, `Tgid`/`Pid`/`PPid`, UID/GID, `VmPeak`/`VmSize`/`VmRSS`, thread count, signal masks, capability sets. |
| `stat` | Machine-parsable status info used by `ps(1)` — pid, comm, state (`R`/`S`/`D`/`Z`/`T`/`t`/`X`...), and many more fields in a fixed `scanf()`-friendly order. Defined in `fs/proc/array.c`. |
| `statm` | Memory usage in pages: `size resident shared text lib data dt`. |
| `cmdline` | The process's complete command line, null-byte separated, as it appears in process memory — a process can freely overwrite its own copy (this is how tools like `setproctitle()` fake a different process name in `ps`). Empty for a zombie. |
| `environ` | The process's *initial* environment (as set at `execve()` time), null-byte separated. Later `putenv()`/`setenv()` calls are **not** reflected here. |
| `exe` | Symlink to the actual executable being run. A deleted-but-still-running binary shows `(deleted)` appended — a classic sign something fileless/self-deleting is in play. |
| `cwd` | Symlink to the process's current working directory. |
| `root` | Symlink to the process's root directory (as set by `chroot()`) — reflects mount namespaces too, so this is the *process's own view* of `/`, not necessarily the host's. |
| `fd/` | One entry per open file descriptor, named by number, symlinked to the actual file. `0`/`1`/`2` are stdin/stdout/stderr; pipes and sockets show as `type:[inode]`; anonymous fds (eventfd, epoll, etc.) show as `anon_inode:file-type`. |
| `fdinfo/` | Per-fd metadata (`pos`, `flags`, `mnt_id`) plus type-specific fields — e.g. `eventfd-count`, or an epoll fd's watched `tfd`/`events`/`data`. Owner-readable only. |
| `task/` | One subdirectory per thread, named by TID, each mirroring the full `/proc/pid/` file set for that individual thread. |
| `mounts` | Every filesystem currently mounted in the process's mount namespace, in `fstab(5)` format. Pollable — you get `POLLPRI` when it changes. |
| `net/` | Networking-layer state (namespace-aware): `arp`, `dev`, `tcp`, `udp`, and more, in plain ASCII. |
| `stack` | A symbolic trace of the process's *kernel*-side call stack (requires `CONFIG_STACKTRACE`) — useful for seeing what syscall/kernel path a hung process is stuck in. |
| `syscall` | The syscall number and raw argument registers of the syscall currently executing, plus the stack pointer and program counter — or `-1`/`"running"` if not currently blocked in one. Requires `CONFIG_HAVE_ARCH_TRACEHOOK`. |
| `wchan` | The symbolic kernel location where a sleeping process is blocked. |
| `personality` | The process's execution domain as set by `personality(2)`, in hex — this is where you'd see `ADDR_NO_RANDOMIZE` (0x0040000) if ASLR has been disabled for that process. |
{: style="--table-col-1: 12%; --table-col-2: 88%;"}

---

### Sources

- [man7.org — proc_pid(5)](https://man7.org/linux/man-pages/man5/proc_pid.5.html)
- [Wikipedia — procfs](https://en.wikipedia.org/wiki/Procfs)
