---
layout: reference
title: "Linux Capabilities"
excerpt: "Every Linux capability bit, from CAP_CHOWN to CAP_CHECKPOINT_RESTORE, with what it actually grants."
tags: [linux, c, lookup, appsec, pwn]
---

*Note: descriptions are condensed from the kernel header's own comments — quoted directly where short, summarized where the source comment is a long multi-clause paragraph (CAP_SYS_ADMIN and CAP_BPF in particular are historically a dumping ground for "everything else").*

| Value | Constant | Grants |
|---|---|---|
| 0 | `CAP_CHOWN` | Bypass the restriction on changing file ownership/group ownership |
| 1 | `CAP_DAC_OVERRIDE` | Bypass file read/write/execute permission checks |
| 2 | `CAP_DAC_READ_SEARCH` | Bypass file read and directory read/execute permission checks |
| 3 | `CAP_FOWNER` | Bypass permission checks that normally require matching file owner UID |
| 4 | `CAP_FSETID` | Don't clear set-user/group-ID bits when a file is modified; set S_ISGID even if not in the file's group |
| 5 | `CAP_KILL` | Bypass permission checks for sending signals (UID match normally required) |
| 6 | `CAP_SETGID` | Manipulate process GIDs (`setgid()`, `setgroups()`) and forge GID on socket credentials |
| 7 | `CAP_SETUID` | Manipulate process UIDs (`setuid()` family, including fsuid) and forge PID on socket credentials |
| 8 | `CAP_SETPCAP` | Add/remove capabilities from the calling thread's bounding and inheritable sets |
| 9 | `CAP_LINUX_IMMUTABLE` | Modify the `S_IMMUTABLE` and `S_APPEND` file attributes |
| 10 | `CAP_NET_BIND_SERVICE` | Bind to TCP/UDP ports below 1024 |
| 11 | `CAP_NET_BROADCAST` | Make socket broadcasts, listen to multicast |
| 12 | `CAP_NET_ADMIN` | Network administration: interface config, firewall/routing tables, promiscuous mode, and more |
| 13 | `CAP_NET_RAW` | Use RAW and PACKET sockets; bind to any address for transparent proxying |
| 14 | `CAP_IPC_LOCK` | Lock shared memory segments; `mlock()`/`mlockall()` |
| 15 | `CAP_IPC_OWNER` | Bypass permission checks for System V IPC ownership |
| 16 | `CAP_SYS_MODULE` | Load and unload kernel modules |
| 17 | `CAP_SYS_RAWIO` | Perform I/O port operations (`ioperm()`/`iopl()`); access `/dev/bus/usb` devices directly |
| 18 | `CAP_SYS_CHROOT` | Use `chroot()` |
| 19 | `CAP_SYS_PTRACE` | `ptrace()` any process, regardless of UID |
| 20 | `CAP_SYS_PACCT` | Configure process accounting (`acct()`) |
| 21 | `CAP_SYS_ADMIN` | Broad "everything else" bucket: mount/umount, quotas, hostname/domainname, swapon/swapoff, most other admin-only syscalls not covered by a more specific capability |
| 22 | `CAP_SYS_BOOT` | `reboot()` and kexec load |
| 23 | `CAP_SYS_NICE` | Raise process priority/niceness of other UIDs; set real-time scheduling; set CPU affinity of other processes |
| 24 | `CAP_SYS_RESOURCE` | Override resource limits, quotas, and reserved filesystem space |
| 25 | `CAP_SYS_TIME` | Set the system clock and real-time clock |
| 26 | `CAP_SYS_TTY_CONFIG` | Configure tty devices; `vhangup()` |
| 27 | `CAP_MKNOD` | Create special files via `mknod()` (device nodes, FIFOs) |
| 28 | `CAP_LEASE` | Take leases on files (`fcntl(F_SETLEASE)`) |
| 29 | `CAP_AUDIT_WRITE` | Write records to the kernel audit log |
| 30 | `CAP_AUDIT_CONTROL` | Configure kernel audit logging |
| 31 | `CAP_SETFCAP` | Set file capabilities; map UID 0 into a child user namespace |
| 32 | `CAP_MAC_OVERRIDE` | Override a Mandatory Access Control (MAC) policy, if one is enforced by an LSM |
| 33 | `CAP_MAC_ADMIN` | Change MAC configuration/state, if an LSM enforces one |
| 34 | `CAP_SYSLOG` | Configure kernel `printk`/syslog behavior |
| 35 | `CAP_WAKE_ALARM` | Trigger something that wakes the system from suspend |
| 36 | `CAP_BLOCK_SUSPEND` | Prevent system suspend |
| 37 | `CAP_AUDIT_READ` | Read the kernel audit log via multicast netlink |
| 38 | `CAP_PERFMON` | Privileged `perf_events`/`i915_perf` observability operations |
| 39 | `CAP_BPF` | Load/inspect BPF programs and maps (advanced verifier features, BTF, JITed code) |
| 40 | `CAP_CHECKPOINT_RESTORE` | Checkpoint/restore operations; choose PID on `clone3()`; write `ns_last_pid` |
{: style="--table-col-1: 6%; --table-col-2: 22%; --table-col-3: 72%;"}

`CAP_LAST_CAP` is currently 40 (41 capabilities total, 0–40).

---

### Sources

- [torvalds/linux — linux/capability.h](https://github.com/torvalds/linux/blob/master/include/uapi/linux/capability.h)
- [man7.org — capabilities(7)](https://man7.org/linux/man-pages/man7/capabilities.7.html)
- [Wikipedia — Capability-based security](https://en.wikipedia.org/wiki/Capability-based_security)
