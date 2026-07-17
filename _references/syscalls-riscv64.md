---
layout: reference
title: "riscv64 Syscalls"
crumb_title: "riscv64"
excerpt: "Full 64-bit RISC-V Linux syscall table: NR, name, man page and kernel source links, and which register holds each argument."
tags: [linux, c, lookup]
permalink: /references/syscalls/riscv64/
syscalls_arch: riscv64
hidden_from_index: true
---

*AKA: `RISC-V`, `RV64`.*

*CPU ISAs: `riscv64`.*

## Calling Convention

| Syscall NR | Return | arg0 | arg1 | arg2 | arg3 | arg4 | arg5 |
|---|---|---|---|---|---|---|---|
| `a7` | `a0` | `a0` | `a1` | `a2` | `a3` | `a4` | `a5` |
{: style="--table-col-1: 12.5%; --table-col-2: 12.5%; --table-col-3: 12.5%; --table-col-4: 12.5%; --table-col-5: 12.5%; --table-col-6: 12.5%; --table-col-7: 12.5%; --table-col-8: 12.5%;"}

Invoked via `ecall`. Like x86_64 and arm64, RISC-V has no separate error-flag register — a negative return value in `a0` (in the `-4095..-1` range) signals `-errno`.

## Syscalls

*Note: argument types are sourced from each syscall's man page, not copied from a cheat sheet. RISC-V uses a single generic syscall list shared with riscv32 — most numbers and names are identical between the two, but riscv64 exposes modern names (`mmap`, `fcntl`, `statfs`, `fstatfs`, `truncate`, `ftruncate`, `lseek`, `sendfile`, `fadvise64`, plus `newfstatat`/`fstat`) at the same NRs where riscv32 instead exposes legacy 32-bit-only equivalents (`mmap2`, `fcntl64`, etc.) — a genuinely different public name at the same slot, not just a wider version of it. `riscv_hwprobe` and `riscv_flush_icache` are RISC-V-specific syscalls. A few rows are undocumented (no published man page yet) — marked as such.*

| NR | Name | References | `%a7` | arg0 (`%a0`) | arg1 (`%a1`) | arg2 (`%a2`) | arg3 (`%a3`) | arg4 (`%a4`) | arg5 (`%a5`) |
|---|---|---|---|---|---|---|---|---|---|
| 0 | `io_setup` | [man](https://man7.org/linux/man-pages/man2/io_setup.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_setup&type=code) | `0x00` | `unsigned int nr_events` | `aio_context_t *ctx_idp` | - | - | - | - |
| 1 | `io_destroy` | [man](https://man7.org/linux/man-pages/man2/io_destroy.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_destroy&type=code) | `0x01` | `aio_context_t ctx_id` | - | - | - | - | - |
| 2 | `io_submit` | [man](https://man7.org/linux/man-pages/man2/io_submit.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_submit&type=code) | `0x02` | `aio_context_t ctx_id` | `long nr` | `struct iocb **iocbpp` | - | - | - |
| 3 | `io_cancel` | [man](https://man7.org/linux/man-pages/man2/io_cancel.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_cancel&type=code) | `0x03` | `aio_context_t ctx_id` | `struct iocb *iocb` | `struct io_event *result` | - | - | - |
| 4 | `io_getevents` | [man](https://man7.org/linux/man-pages/man2/io_getevents.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_getevents&type=code) | `0x04` | `aio_context_t ctx_id` | `long min_nr` | `long nr` | `struct io_event *events` | `struct timespec *timeout` | - |
| 5 | `setxattr` | [man](https://man7.org/linux/man-pages/man2/setxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setxattr&type=code) | `0x05` | `const char\ *path` | `const char\ *name` | `const void\ *value` | `size_t size` | `int flags` | - |
| 6 | `lsetxattr` | [man](https://man7.org/linux/man-pages/man2/lsetxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lsetxattr&type=code) | `0x06` | `const char\ *path` | `const char\ *name` | `const void\ *value` | `size_t size` | `int flags` | - |
| 7 | `fsetxattr` | [man](https://man7.org/linux/man-pages/man2/fsetxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fsetxattr&type=code) | `0x07` | `int fd` | `const char\ *name` | `const void\ *value` | `size_t size` | `int flags` | - |
| 8 | `getxattr` | [man](https://man7.org/linux/man-pages/man2/getxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getxattr&type=code) | `0x08` | `const char *path` | `const char *name` | `void *value` | `size_t size` | - | - |
| 9 | `lgetxattr` | [man](https://man7.org/linux/man-pages/man2/lgetxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lgetxattr&type=code) | `0x09` | `const char *path` | `const char *name` | `void *value` | `size_t size` | - | - |
| 10 | `fgetxattr` | [man](https://man7.org/linux/man-pages/man2/fgetxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fgetxattr&type=code) | `0x0a` | `int fd` | `const char *name` | `void *value` | `size_t size` | - | - |
| 11 | `listxattr` | [man](https://man7.org/linux/man-pages/man2/listxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+listxattr&type=code) | `0x0b` | `const char *path` | `char *list` | `size_t size` | - | - | - |
| 12 | `llistxattr` | [man](https://man7.org/linux/man-pages/man2/llistxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+llistxattr&type=code) | `0x0c` | `const char *path` | `char *list` | `size_t size` | - | - | - |
| 13 | `flistxattr` | [man](https://man7.org/linux/man-pages/man2/flistxattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+flistxattr&type=code) | `0x0d` | `int fd` | `char *list` | `size_t size` | - | - | - |
| 14 | `removexattr` | [man](https://man7.org/linux/man-pages/man2/removexattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+removexattr&type=code) | `0x0e` | `const char\ *path` | `const char\ *name` | - | - | - | - |
| 15 | `lremovexattr` | [man](https://man7.org/linux/man-pages/man2/lremovexattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lremovexattr&type=code) | `0x0f` | `const char\ *path` | `const char\ *name` | - | - | - | - |
| 16 | `fremovexattr` | [man](https://man7.org/linux/man-pages/man2/fremovexattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fremovexattr&type=code) | `0x10` | `int fd` | `const char\ *name` | - | - | - | - |
| 17 | `getcwd` | [man](https://man7.org/linux/man-pages/man2/getcwd.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getcwd&type=code) | `0x11` | `char *buf` | `size_t size` | - | - | - | - |
| 18 | `lookup_dcookie` | [man](https://man7.org/linux/man-pages/man2/lookup_dcookie.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lookup_dcookie&type=code) | `0x12` | `uint64_t cookie` | `char *buffer` | `size_t len` | - | - | - |
| 19 | `eventfd2` | [man](https://man7.org/linux/man-pages/man2/eventfd2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+eventfd2&type=code) | `0x13` | `unsigned int initval` | `int flags` | - | - | - | - |
| 20 | `epoll_create1` | [man](https://man7.org/linux/man-pages/man2/epoll_create1.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+epoll_create1&type=code) | `0x14` | `int flags` | - | - | - | - | - |
| 21 | `epoll_ctl` | [man](https://man7.org/linux/man-pages/man2/epoll_ctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+epoll_ctl&type=code) | `0x15` | `int epfd` | `int op` | `int fd` | `struct epoll_event *event` | - | - |
| 22 | `epoll_pwait` | [man](https://man7.org/linux/man-pages/man2/epoll_pwait.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+epoll_pwait&type=code) | `0x16` | `int epfd` | `struct epoll_event *events` | `int maxevents` | `int timeout` | `const sigset_t *sigmask` | - |
| 23 | `dup` | [man](https://man7.org/linux/man-pages/man2/dup.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+dup&type=code) | `0x17` | `int oldfd` | - | - | - | - | - |
| 24 | `dup3` | [man](https://man7.org/linux/man-pages/man2/dup3.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+dup3&type=code) | `0x18` | `int oldfd` | `int newfd` | `int flags` | - | - | - |
| 25 | `fcntl` | [man](https://man7.org/linux/man-pages/man2/fcntl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fcntl&type=code) | `0x19` | `int fd` | `int cmd` | `...` | - | - | - |
| 26 | `inotify_init1` | [man](https://man7.org/linux/man-pages/man2/inotify_init1.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+inotify_init1&type=code) | `0x1a` | `int flags` | - | - | - | - | - |
| 27 | `inotify_add_watch` | [man](https://man7.org/linux/man-pages/man2/inotify_add_watch.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+inotify_add_watch&type=code) | `0x1b` | `int fd` | `const char *pathname` | `uint32_t mask` | - | - | - |
| 28 | `inotify_rm_watch` | [man](https://man7.org/linux/man-pages/man2/inotify_rm_watch.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+inotify_rm_watch&type=code) | `0x1c` | `int fd` | `int wd` | - | - | - | - |
| 29 | `ioctl` | [man](https://man7.org/linux/man-pages/man2/ioctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+ioctl&type=code) | `0x1d` | `int fd` | `unsigned long request` | `...` | - | - | - |
| 30 | `ioprio_set` | [man](https://man7.org/linux/man-pages/man2/ioprio_set.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+ioprio_set&type=code) | `0x1e` | `int which` | `int who` | `int ioprio` | - | - | - |
| 31 | `ioprio_get` | [man](https://man7.org/linux/man-pages/man2/ioprio_get.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+ioprio_get&type=code) | `0x1f` | `int which` | `int who` | - | - | - | - |
| 32 | `flock` | [man](https://man7.org/linux/man-pages/man2/flock.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+flock&type=code) | `0x20` | `int fd` | `int operation` | - | - | - | - |
| 33 | `mknodat` | [man](https://man7.org/linux/man-pages/man2/mknodat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mknodat&type=code) | `0x21` | `int dirfd` | `const char *pathname` | `mode_t mode` | `dev_t dev` | - | - |
| 34 | `mkdirat` | [man](https://man7.org/linux/man-pages/man2/mkdirat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mkdirat&type=code) | `0x22` | `int dirfd` | `const char *pathname` | `mode_t mode` | - | - | - |
| 35 | `unlinkat` | [man](https://man7.org/linux/man-pages/man2/unlinkat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+unlinkat&type=code) | `0x23` | `int dirfd` | `const char *pathname` | `int flags` | - | - | - |
| 36 | `symlinkat` | [man](https://man7.org/linux/man-pages/man2/symlinkat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+symlinkat&type=code) | `0x24` | `const char *target` | `int newdirfd` | `const char *linkpath` | - | - | - |
| 37 | `linkat` | [man](https://man7.org/linux/man-pages/man2/linkat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+linkat&type=code) | `0x25` | `int olddirfd` | `const char *oldpath` | `int newdirfd` | `const char *newpath` | `int flags` | - |
| 38 | *Not Implemented* | - | `0x26` | *reserved* | - | - | - | - | - |
| 39 | `umount2` | [man](https://man7.org/linux/man-pages/man2/umount2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+umount2&type=code) | `0x27` | `const char *target` | `int flags` | - | - | - | - |
| 40 | `mount` | [man](https://man7.org/linux/man-pages/man2/mount.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mount&type=code) | `0x28` | `const char *source` | `const char *target` | `const char *filesystemtype` | `unsigned long mountflags` | `const void *data` | - |
| 41 | `pivot_root` | [man](https://man7.org/linux/man-pages/man2/pivot_root.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pivot_root&type=code) | `0x29` | `const char *new_root` | `const char *put_old` | - | - | - | - |
| 42 | `nfsservctl` | [man](https://man7.org/linux/man-pages/man2/nfsservctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+nfsservctl&type=code) | `0x2a` | `int cmd` | `struct nfsctl_arg *argp` | `union nfsctl_res *resp` | - | - | - |
| 43 | `statfs` | [man](https://man7.org/linux/man-pages/man2/statfs.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+statfs&type=code) | `0x2b` | `const char *path` | `struct statfs *buf` | - | - | - | - |
| 44 | `fstatfs` | [man](https://man7.org/linux/man-pages/man2/fstatfs.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fstatfs&type=code) | `0x2c` | `int fd` | `struct statfs *buf` | - | - | - | - |
| 45 | `truncate` | [man](https://man7.org/linux/man-pages/man2/truncate.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+truncate&type=code) | `0x2d` | `const char *path` | `off_t length` | - | - | - | - |
| 46 | `ftruncate` | [man](https://man7.org/linux/man-pages/man2/ftruncate.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+ftruncate&type=code) | `0x2e` | `int fd` | `off_t length` | - | - | - | - |
| 47 | `fallocate` | [man](https://man7.org/linux/man-pages/man2/fallocate.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fallocate&type=code) | `0x2f` | `int fd` | `int mode` | `off_t offset` | `off_t len` | - | - |
| 48 | `faccessat` | [man](https://man7.org/linux/man-pages/man2/faccessat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+faccessat&type=code) | `0x30` | `int dirfd` | `const char *pathname` | `int mode` | `int flags` | - | - |
| 49 | `chdir` | [man](https://man7.org/linux/man-pages/man2/chdir.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+chdir&type=code) | `0x31` | `const char *path` | - | - | - | - | - |
| 50 | `fchdir` | [man](https://man7.org/linux/man-pages/man2/fchdir.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fchdir&type=code) | `0x32` | `int fd` | - | - | - | - | - |
| 51 | `chroot` | [man](https://man7.org/linux/man-pages/man2/chroot.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+chroot&type=code) | `0x33` | `const char *path` | - | - | - | - | - |
| 52 | `fchmod` | [man](https://man7.org/linux/man-pages/man2/fchmod.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fchmod&type=code) | `0x34` | `int fd` | `mode_t mode` | - | - | - | - |
| 53 | `fchmodat` | [man](https://man7.org/linux/man-pages/man2/fchmodat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fchmodat&type=code) | `0x35` | `int dirfd` | `const char *pathname` | `mode_t mode` | `int flags` | - | - |
| 54 | `fchownat` | [man](https://man7.org/linux/man-pages/man2/fchownat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fchownat&type=code) | `0x36` | `int dirfd` | `const char *pathname` | `uid_t owner` | `gid_t group` | `int flags` | - |
| 55 | `fchown` | [man](https://man7.org/linux/man-pages/man2/fchown.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fchown&type=code) | `0x37` | `int fd` | `uid_t owner` | `gid_t group` | - | - | - |
| 56 | `openat` | [man](https://man7.org/linux/man-pages/man2/openat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+openat&type=code) | `0x38` | `int dirfd` | `const char *pathname` | `int flags` | - | - | - |
| 57 | `close` | [man](https://man7.org/linux/man-pages/man2/close.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+close&type=code) | `0x39` | `int fd` | - | - | - | - | - |
| 58 | `vhangup` | [man](https://man7.org/linux/man-pages/man2/vhangup.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+vhangup&type=code) | `0x3a` | - | - | - | - | - | - |
| 59 | `pipe2` | [man](https://man7.org/linux/man-pages/man2/pipe2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pipe2&type=code) | `0x3b` | `int pipefd[2]` | `int flags` | - | - | - | - |
| 60 | `quotactl` | [man](https://man7.org/linux/man-pages/man2/quotactl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+quotactl&type=code) | `0x3c` | `int cmd` | `const char *special` | `int id` | `caddr_t addr` | - | - |
| 61 | `getdents64` | [man](https://man7.org/linux/man-pages/man2/getdents64.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getdents64&type=code) | `0x3d` | `int fd` | `void *dirp` | `size_t count` | - | - | - |
| 62 | `lseek` | [man](https://man7.org/linux/man-pages/man2/lseek.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lseek&type=code) | `0x3e` | `int fd` | `off_t offset` | `int whence` | - | - | - |
| 63 | `read` | [man](https://man7.org/linux/man-pages/man2/read.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+read&type=code) | `0x3f` | `int fd` | `void *buf` | `size_t count` | - | - | - |
| 64 | `write` | [man](https://man7.org/linux/man-pages/man2/write.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+write&type=code) | `0x40` | `int fd` | `const void *buf` | `size_t count` | - | - | - |
| 65 | `readv` | [man](https://man7.org/linux/man-pages/man2/readv.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+readv&type=code) | `0x41` | `int fd` | `const struct iovec *iov` | `int iovcnt` | - | - | - |
| 66 | `writev` | [man](https://man7.org/linux/man-pages/man2/writev.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+writev&type=code) | `0x42` | `int fd` | `const struct iovec *iov` | `int iovcnt` | - | - | - |
| 67 | `pread64` | [man](https://man7.org/linux/man-pages/man2/pread64.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pread64&type=code) | `0x43` | `int fd` | `void *buf` | `size_t count` | `off_t offset` | - | - |
| 68 | `pwrite64` | [man](https://man7.org/linux/man-pages/man2/pwrite64.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pwrite64&type=code) | `0x44` | `int fd` | `const void *buf` | `size_t count` | `off_t offset` | - | - |
| 69 | `preadv` | [man](https://man7.org/linux/man-pages/man2/preadv.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+preadv&type=code) | `0x45` | `int fd` | `const struct iovec *iov` | `int iovcnt` | `off_t offset` | - | - |
| 70 | `pwritev` | [man](https://man7.org/linux/man-pages/man2/pwritev.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pwritev&type=code) | `0x46` | `int fd` | `const struct iovec *iov` | `int iovcnt` | `off_t offset` | - | - |
| 71 | `sendfile` | [man](https://man7.org/linux/man-pages/man2/sendfile.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sendfile&type=code) | `0x47` | `int out_fd` | `int in_fd` | `off_t *offset` | `size_t count` | - | - |
| 72 | `pselect6` | [man](https://man7.org/linux/man-pages/man2/pselect6.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pselect6&type=code) | `0x48` | `int nfds` | `fd_set *restrict readfds` | `fd_set *restrict writefds` | `fd_set *restrict exceptfds` | `const struct timespec *restrict timeout` | `const sigset_t *restrict sigmask` |
| 73 | `ppoll` | [man](https://man7.org/linux/man-pages/man2/ppoll.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+ppoll&type=code) | `0x49` | `struct pollfd *fds` | `nfds_t nfds` | `const struct timespec *tmo_p` | `const sigset_t *sigmask` | - | - |
| 74 | `signalfd4` | [man](https://man7.org/linux/man-pages/man2/signalfd4.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+signalfd4&type=code) | `0x4a` | `int fd` | `const sigset_t *mask` | `int flags` | - | - | - |
| 75 | `vmsplice` | [man](https://man7.org/linux/man-pages/man2/vmsplice.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+vmsplice&type=code) | `0x4b` | `int fd` | `const struct iovec *iov` | `size_t nr_segs` | `unsigned int flags` | - | - |
| 76 | `splice` | [man](https://man7.org/linux/man-pages/man2/splice.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+splice&type=code) | `0x4c` | `int fd_in` | `off64_t *off_in` | `int fd_out` | `off64_t *off_out` | `size_t len` | `unsigned int flags` |
| 77 | `tee` | [man](https://man7.org/linux/man-pages/man2/tee.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+tee&type=code) | `0x4d` | `int fd_in` | `int fd_out` | `size_t len` | `unsigned int flags` | - | - |
| 78 | `readlinkat` | [man](https://man7.org/linux/man-pages/man2/readlinkat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+readlinkat&type=code) | `0x4e` | `int dirfd` | `const char *restrict pathname` | `char *restrict buf` | `size_t bufsiz` | - | - |
| 79 | `newfstatat` | [man](https://man7.org/linux/man-pages/man2/newfstatat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+newfstatat&type=code) | `0x4f` | `int dirfd` | `const char *restrict pathname` | `struct stat *restrict statbuf` | `int flags` | - | - |
| 80 | `fstat` | [man](https://man7.org/linux/man-pages/man2/fstat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fstat&type=code) | `0x50` | `int fd` | `struct stat *statbuf` | - | - | - | - |
| 81 | `sync` | [man](https://man7.org/linux/man-pages/man2/sync.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sync&type=code) | `0x51` | - | - | - | - | - | - |
| 82 | `fsync` | [man](https://man7.org/linux/man-pages/man2/fsync.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fsync&type=code) | `0x52` | `int fd` | - | - | - | - | - |
| 83 | `fdatasync` | [man](https://man7.org/linux/man-pages/man2/fdatasync.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fdatasync&type=code) | `0x53` | `int fd` | - | - | - | - | - |
| 84 | `sync_file_range` | [man](https://man7.org/linux/man-pages/man2/sync_file_range.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sync_file_range&type=code) | `0x54` | `int fd` | `off64_t offset` | `off64_t nbytes` | `unsigned int flags` | - | - |
| 85 | `timerfd_create` | [man](https://man7.org/linux/man-pages/man2/timerfd_create.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timerfd_create&type=code) | `0x55` | `int clockid` | `int flags` | - | - | - | - |
| 86 | `timerfd_settime` | [man](https://man7.org/linux/man-pages/man2/timerfd_settime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timerfd_settime&type=code) | `0x56` | `int fd` | `int flags` | `const struct itimerspec *new_value` | `struct itimerspec *old_value` | - | - |
| 87 | `timerfd_gettime` | [man](https://man7.org/linux/man-pages/man2/timerfd_gettime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timerfd_gettime&type=code) | `0x57` | `int fd` | `struct itimerspec *curr_value` | - | - | - | - |
| 88 | `utimensat` | [man](https://man7.org/linux/man-pages/man2/utimensat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+utimensat&type=code) | `0x58` | `int dirfd` | `const char *pathname` | `const struct timespec times[2]` | `int flags` | - | - |
| 89 | `acct` | [man](https://man7.org/linux/man-pages/man2/acct.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+acct&type=code) | `0x59` | `const char *filename` | - | - | - | - | - |
| 90 | `capget` | [man](https://man7.org/linux/man-pages/man2/capget.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+capget&type=code) | `0x5a` | `cap_user_header_t hdrp` | `cap_user_data_t datap` | - | - | - | - |
| 91 | `capset` | [man](https://man7.org/linux/man-pages/man2/capset.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+capset&type=code) | `0x5b` | `cap_user_header_t hdrp` | `const cap_user_data_t datap` | - | - | - | - |
| 92 | `personality` | [man](https://man7.org/linux/man-pages/man2/personality.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+personality&type=code) | `0x5c` | `unsigned long persona` | - | - | - | - | - |
| 93 | `exit` | [man](https://man7.org/linux/man-pages/man2/exit.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+exit&type=code) | `0x5d` | `int status` | - | - | - | - | - |
| 94 | `exit_group` | [man](https://man7.org/linux/man-pages/man2/exit_group.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+exit_group&type=code) | `0x5e` | `int status` | - | - | - | - | - |
| 95 | `waitid` | [man](https://man7.org/linux/man-pages/man2/waitid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+waitid&type=code) | `0x5f` | `idtype_t idtype` | `id_t id` | `siginfo_t *infop` | `int options` | - | - |
| 96 | `set_tid_address` | [man](https://man7.org/linux/man-pages/man2/set_tid_address.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+set_tid_address&type=code) | `0x60` | `int *tidptr` | - | - | - | - | - |
| 97 | `unshare` | [man](https://man7.org/linux/man-pages/man2/unshare.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+unshare&type=code) | `0x61` | `int flags` | - | - | - | - | - |
| 98 | `futex` | [man](https://man7.org/linux/man-pages/man2/futex.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+futex&type=code) | `0x62` | `uint32_t *uaddr` | `int futex_op` | `uint32_t val` | `const struct timespec *timeout` | `uint32_t *uaddr2` | `uint32_t val3` |
| 99 | `set_robust_list` | [man](https://man7.org/linux/man-pages/man2/set_robust_list.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+set_robust_list&type=code) | `0x63` | `struct robust_list_head *head` | `size_t len` | - | - | - | - |
| 100 | `get_robust_list` | [man](https://man7.org/linux/man-pages/man2/get_robust_list.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+get_robust_list&type=code) | `0x64` | `int pid` | `struct robust_list_head **head_ptr` | `size_t *len_ptr` | - | - | - |
| 101 | `nanosleep` | [man](https://man7.org/linux/man-pages/man2/nanosleep.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+nanosleep&type=code) | `0x65` | `const struct timespec *req` | `struct timespec *rem` | - | - | - | - |
| 102 | `getitimer` | [man](https://man7.org/linux/man-pages/man2/getitimer.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getitimer&type=code) | `0x66` | `int which` | `struct itimerval *curr_value` | - | - | - | - |
| 103 | `setitimer` | [man](https://man7.org/linux/man-pages/man2/setitimer.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setitimer&type=code) | `0x67` | `int which` | `const struct itimerval *restrict new_value` | `struct itimerval *restrict old_value` | - | - | - |
| 104 | `kexec_load` | [man](https://man7.org/linux/man-pages/man2/kexec_load.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+kexec_load&type=code) | `0x68` | `unsigned long entry` | `unsigned long nr_segments` | `struct kexec_segment *segments` | `unsigned long flags` | - | - |
| 105 | `init_module` | [man](https://man7.org/linux/man-pages/man2/init_module.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+init_module&type=code) | `0x69` | `void *module_image` | `unsigned long len` | `const char *param_values` | - | - | - |
| 106 | `delete_module` | [man](https://man7.org/linux/man-pages/man2/delete_module.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+delete_module&type=code) | `0x6a` | `const char *name` | `unsigned int flags` | - | - | - | - |
| 107 | `timer_create` | [man](https://man7.org/linux/man-pages/man2/timer_create.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timer_create&type=code) | `0x6b` | `clockid_t clockid` | `struct sigevent *restrict sevp` | `timer_t *restrict timerid` | - | - | - |
| 108 | `timer_gettime` | [man](https://man7.org/linux/man-pages/man2/timer_gettime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timer_gettime&type=code) | `0x6c` | `timer_t timerid` | `struct itimerspec *curr_value` | - | - | - | - |
| 109 | `timer_getoverrun` | [man](https://man7.org/linux/man-pages/man2/timer_getoverrun.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timer_getoverrun&type=code) | `0x6d` | `timer_t timerid` | - | - | - | - | - |
| 110 | `timer_settime` | [man](https://man7.org/linux/man-pages/man2/timer_settime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timer_settime&type=code) | `0x6e` | `timer_t timerid` | `int flags` | `const struct itimerspec *restrict new_value` | `struct itimerspec *restrict old_value` | - | - |
| 111 | `timer_delete` | [man](https://man7.org/linux/man-pages/man2/timer_delete.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+timer_delete&type=code) | `0x6f` | `timer_t timerid` | - | - | - | - | - |
| 112 | `clock_settime` | [man](https://man7.org/linux/man-pages/man2/clock_settime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clock_settime&type=code) | `0x70` | `clockid_t clockid` | `const struct timespec *tp` | - | - | - | - |
| 113 | `clock_gettime` | [man](https://man7.org/linux/man-pages/man2/clock_gettime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clock_gettime&type=code) | `0x71` | `clockid_t clockid` | `struct timespec *tp` | - | - | - | - |
| 114 | `clock_getres` | [man](https://man7.org/linux/man-pages/man2/clock_getres.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clock_getres&type=code) | `0x72` | `clockid_t clockid` | `struct timespec *res` | - | - | - | - |
| 115 | `clock_nanosleep` | [man](https://man7.org/linux/man-pages/man2/clock_nanosleep.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clock_nanosleep&type=code) | `0x73` | `clockid_t clockid` | `int flags` | `const struct timespec *request` | `struct timespec *remain` | - | - |
| 116 | `syslog` | [man](https://man7.org/linux/man-pages/man2/syslog.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+syslog&type=code) | `0x74` | `int type` | `char *bufp` | `int len` | - | - | - |
| 117 | `ptrace` | [man](https://man7.org/linux/man-pages/man2/ptrace.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+ptrace&type=code) | `0x75` | `enum __ptrace_request request` | `pid_t pid` | `void *addr` | `void *data` | - | - |
| 118 | `sched_setparam` | [man](https://man7.org/linux/man-pages/man2/sched_setparam.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_setparam&type=code) | `0x76` | `pid_t pid` | `const struct sched_param *param` | - | - | - | - |
| 119 | `sched_setscheduler` | [man](https://man7.org/linux/man-pages/man2/sched_setscheduler.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_setscheduler&type=code) | `0x77` | `pid_t pid` | `int policy` | `const struct sched_param *param` | - | - | - |
| 120 | `sched_getscheduler` | [man](https://man7.org/linux/man-pages/man2/sched_getscheduler.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_getscheduler&type=code) | `0x78` | `pid_t pid` | - | - | - | - | - |
| 121 | `sched_getparam` | [man](https://man7.org/linux/man-pages/man2/sched_getparam.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_getparam&type=code) | `0x79` | `pid_t pid` | `struct sched_param *param` | - | - | - | - |
| 122 | `sched_setaffinity` | [man](https://man7.org/linux/man-pages/man2/sched_setaffinity.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_setaffinity&type=code) | `0x7a` | `pid_t pid` | `size_t cpusetsize` | `const cpu_set_t *mask` | - | - | - |
| 123 | `sched_getaffinity` | [man](https://man7.org/linux/man-pages/man2/sched_getaffinity.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_getaffinity&type=code) | `0x7b` | `pid_t pid` | `size_t cpusetsize` | `cpu_set_t *mask` | - | - | - |
| 124 | `sched_yield` | [man](https://man7.org/linux/man-pages/man2/sched_yield.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_yield&type=code) | `0x7c` | - | - | - | - | - | - |
| 125 | `sched_get_priority_max` | [man](https://man7.org/linux/man-pages/man2/sched_get_priority_max.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_get_priority_max&type=code) | `0x7d` | `int policy` | - | - | - | - | - |
| 126 | `sched_get_priority_min` | [man](https://man7.org/linux/man-pages/man2/sched_get_priority_min.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_get_priority_min&type=code) | `0x7e` | `int policy` | - | - | - | - | - |
| 127 | `sched_rr_get_interval` | [man](https://man7.org/linux/man-pages/man2/sched_rr_get_interval.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_rr_get_interval&type=code) | `0x7f` | `pid_t pid` | `struct timespec *tp` | - | - | - | - |
| 128 | `restart_syscall` | [man](https://man7.org/linux/man-pages/man2/restart_syscall.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+restart_syscall&type=code) | `0x80` | - | - | - | - | - | - |
| 129 | `kill` | [man](https://man7.org/linux/man-pages/man2/kill.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+kill&type=code) | `0x81` | `pid_t pid` | `int sig` | - | - | - | - |
| 130 | `tkill` | [man](https://man7.org/linux/man-pages/man2/tkill.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+tkill&type=code) | `0x82` | `pid_t tid` | `int sig` | - | - | - | - |
| 131 | `tgkill` | [man](https://man7.org/linux/man-pages/man2/tgkill.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+tgkill&type=code) | `0x83` | `pid_t tgid` | `pid_t tid` | `int sig` | - | - | - |
| 132 | `sigaltstack` | [man](https://man7.org/linux/man-pages/man2/sigaltstack.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sigaltstack&type=code) | `0x84` | `const stack_t *restrict ss` | `stack_t *restrict old_ss` | - | - | - | - |
| 133 | `rt_sigsuspend` | [man](https://man7.org/linux/man-pages/man2/rt_sigsuspend.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigsuspend&type=code) | `0x85` | `const sigset_t *mask` | - | - | - | - | - |
| 134 | `rt_sigaction` | [man](https://man7.org/linux/man-pages/man2/rt_sigaction.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigaction&type=code) | `0x86` | `int signum` | `const struct sigaction *restrict act` | `struct sigaction *restrict oldact` | - | - | - |
| 135 | `rt_sigprocmask` | [man](https://man7.org/linux/man-pages/man2/rt_sigprocmask.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigprocmask&type=code) | `0x87` | `int how` | `const kernel_sigset_t *set` | `kernel_sigset_t *oldset` | `size_t sigsetsize` | - | - |
| 136 | `rt_sigpending` | [man](https://man7.org/linux/man-pages/man2/rt_sigpending.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigpending&type=code) | `0x88` | `sigset_t *set` | - | - | - | - | - |
| 137 | `rt_sigtimedwait` | [man](https://man7.org/linux/man-pages/man2/rt_sigtimedwait.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigtimedwait&type=code) | `0x89` | `const sigset_t *restrict set` | `siginfo_t *restrict info` | `const struct timespec *restrict timeout` | - | - | - |
| 138 | `rt_sigqueueinfo` | [man](https://man7.org/linux/man-pages/man2/rt_sigqueueinfo.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigqueueinfo&type=code) | `0x8a` | `pid_t tgid` | `int sig` | `siginfo_t *info` | - | - | - |
| 139 | `rt_sigreturn` | [man](https://man7.org/linux/man-pages/man2/rt_sigreturn.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_sigreturn&type=code) | `0x8b` | `...` | - | - | - | - | - |
| 140 | `setpriority` | [man](https://man7.org/linux/man-pages/man2/setpriority.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setpriority&type=code) | `0x8c` | `int which` | `id_t who` | `int prio` | - | - | - |
| 141 | `getpriority` | [man](https://man7.org/linux/man-pages/man2/getpriority.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getpriority&type=code) | `0x8d` | `int which` | `id_t who` | - | - | - | - |
| 142 | `reboot` | [man](https://man7.org/linux/man-pages/man2/reboot.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+reboot&type=code) | `0x8e` | `int cmd` | - | - | - | - | - |
| 143 | `setregid` | [man](https://man7.org/linux/man-pages/man2/setregid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setregid&type=code) | `0x8f` | `gid_t rgid` | `gid_t egid` | - | - | - | - |
| 144 | `setgid` | [man](https://man7.org/linux/man-pages/man2/setgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setgid&type=code) | `0x90` | `gid_t gid` | - | - | - | - | - |
| 145 | `setreuid` | [man](https://man7.org/linux/man-pages/man2/setreuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setreuid&type=code) | `0x91` | `uid_t ruid` | `uid_t euid` | - | - | - | - |
| 146 | `setuid` | [man](https://man7.org/linux/man-pages/man2/setuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setuid&type=code) | `0x92` | `uid_t uid` | - | - | - | - | - |
| 147 | `setresuid` | [man](https://man7.org/linux/man-pages/man2/setresuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setresuid&type=code) | `0x93` | `uid_t ruid` | `uid_t euid` | `uid_t suid` | - | - | - |
| 148 | `getresuid` | [man](https://man7.org/linux/man-pages/man2/getresuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getresuid&type=code) | `0x94` | `uid_t *ruid` | `uid_t *euid` | `uid_t *suid` | - | - | - |
| 149 | `setresgid` | [man](https://man7.org/linux/man-pages/man2/setresgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setresgid&type=code) | `0x95` | `gid_t rgid` | `gid_t egid` | `gid_t sgid` | - | - | - |
| 150 | `getresgid` | [man](https://man7.org/linux/man-pages/man2/getresgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getresgid&type=code) | `0x96` | `gid_t *rgid` | `gid_t *egid` | `gid_t *sgid` | - | - | - |
| 151 | `setfsuid` | [man](https://man7.org/linux/man-pages/man2/setfsuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setfsuid&type=code) | `0x97` | `uid_t fsuid` | - | - | - | - | - |
| 152 | `setfsgid` | [man](https://man7.org/linux/man-pages/man2/setfsgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setfsgid&type=code) | `0x98` | `gid_t fsgid` | - | - | - | - | - |
| 153 | `times` | [man](https://man7.org/linux/man-pages/man2/times.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+times&type=code) | `0x99` | `struct tms *buf` | - | - | - | - | - |
| 154 | `setpgid` | [man](https://man7.org/linux/man-pages/man2/setpgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setpgid&type=code) | `0x9a` | `pid_t pid` | `pid_t pgid` | - | - | - | - |
| 155 | `getpgid` | [man](https://man7.org/linux/man-pages/man2/getpgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getpgid&type=code) | `0x9b` | `pid_t pid` | - | - | - | - | - |
| 156 | `getsid` | [man](https://man7.org/linux/man-pages/man2/getsid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getsid&type=code) | `0x9c` | `pid_t pid` | - | - | - | - | - |
| 157 | `setsid` | [man](https://man7.org/linux/man-pages/man2/setsid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setsid&type=code) | `0x9d` | - | - | - | - | - | - |
| 158 | `getgroups` | [man](https://man7.org/linux/man-pages/man2/getgroups.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getgroups&type=code) | `0x9e` | `int size` | `gid_t list[]` | - | - | - | - |
| 159 | `setgroups` | [man](https://man7.org/linux/man-pages/man2/setgroups.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setgroups&type=code) | `0x9f` | `size_t size` | `const gid_t *list` | - | - | - | - |
| 160 | `uname` | [man](https://man7.org/linux/man-pages/man2/uname.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+uname&type=code) | `0xa0` | `struct utsname *buf` | - | - | - | - | - |
| 161 | `sethostname` | [man](https://man7.org/linux/man-pages/man2/sethostname.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sethostname&type=code) | `0xa1` | `const char *name` | `size_t len` | - | - | - | - |
| 162 | `setdomainname` | [man](https://man7.org/linux/man-pages/man2/setdomainname.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setdomainname&type=code) | `0xa2` | `const char *name` | `size_t len` | - | - | - | - |
| 163 | `getrlimit` | [man](https://man7.org/linux/man-pages/man2/getrlimit.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getrlimit&type=code) | `0xa3` | `int resource` | `struct rlimit *rlim` | - | - | - | - |
| 164 | `setrlimit` | [man](https://man7.org/linux/man-pages/man2/setrlimit.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setrlimit&type=code) | `0xa4` | `int resource` | `const struct rlimit *rlim` | - | - | - | - |
| 165 | `getrusage` | [man](https://man7.org/linux/man-pages/man2/getrusage.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getrusage&type=code) | `0xa5` | `int who` | `struct rusage *usage` | - | - | - | - |
| 166 | `umask` | [man](https://man7.org/linux/man-pages/man2/umask.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+umask&type=code) | `0xa6` | `mode_t mask` | - | - | - | - | - |
| 167 | `prctl` | [man](https://man7.org/linux/man-pages/man2/prctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+prctl&type=code) | `0xa7` | `int option` | `unsigned long arg2` | `unsigned long arg3` | `unsigned long arg4` | `unsigned long arg5` | - |
| 168 | `getcpu` | [man](https://man7.org/linux/man-pages/man2/getcpu.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getcpu&type=code) | `0xa8` | `unsigned int *cpu` | `unsigned int *node` | - | - | - | - |
| 169 | `gettimeofday` | [man](https://man7.org/linux/man-pages/man2/gettimeofday.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+gettimeofday&type=code) | `0xa9` | `struct timeval *restrict tv` | `struct timezone *restrict tz` | - | - | - | - |
| 170 | `settimeofday` | [man](https://man7.org/linux/man-pages/man2/settimeofday.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+settimeofday&type=code) | `0xaa` | `const struct timeval *tv` | `const struct timezone *tz` | - | - | - | - |
| 171 | `adjtimex` | [man](https://man7.org/linux/man-pages/man2/adjtimex.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+adjtimex&type=code) | `0xab` | `struct timex *buf` | - | - | - | - | - |
| 172 | `getpid` | [man](https://man7.org/linux/man-pages/man2/getpid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getpid&type=code) | `0xac` | - | - | - | - | - | - |
| 173 | `getppid` | [man](https://man7.org/linux/man-pages/man2/getppid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getppid&type=code) | `0xad` | - | - | - | - | - | - |
| 174 | `getuid` | [man](https://man7.org/linux/man-pages/man2/getuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getuid&type=code) | `0xae` | - | - | - | - | - | - |
| 175 | `geteuid` | [man](https://man7.org/linux/man-pages/man2/geteuid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+geteuid&type=code) | `0xaf` | - | - | - | - | - | - |
| 176 | `getgid` | [man](https://man7.org/linux/man-pages/man2/getgid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getgid&type=code) | `0xb0` | - | - | - | - | - | - |
| 177 | `getegid` | [man](https://man7.org/linux/man-pages/man2/getegid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getegid&type=code) | `0xb1` | - | - | - | - | - | - |
| 178 | `gettid` | [man](https://man7.org/linux/man-pages/man2/gettid.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+gettid&type=code) | `0xb2` | - | - | - | - | - | - |
| 179 | `sysinfo` | [man](https://man7.org/linux/man-pages/man2/sysinfo.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sysinfo&type=code) | `0xb3` | `struct sysinfo *info` | - | - | - | - | - |
| 180 | `mq_open` | [man](https://man7.org/linux/man-pages/man2/mq_open.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mq_open&type=code) | `0xb4` | `const char *name` | `int oflag` | - | - | - | - |
| 181 | `mq_unlink` | [man](https://man7.org/linux/man-pages/man2/mq_unlink.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mq_unlink&type=code) | `0xb5` | `const char *name` | - | - | - | - | - |
| 182 | `mq_timedsend` | [man](https://man7.org/linux/man-pages/man2/mq_timedsend.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mq_timedsend&type=code) | `0xb6` | `mqd_t mqdes` | `const char *msg_ptr` | `size_t msg_len` | `unsigned int msg_prio` | `const struct timespec *abs_timeout` | - |
| 183 | `mq_timedreceive` | [man](https://man7.org/linux/man-pages/man2/mq_timedreceive.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mq_timedreceive&type=code) | `0xb7` | `mqd_t mqdes` | `char *restrict msg_ptr` | `size_t msg_len` | `unsigned int *restrict msg_prio` | `const struct timespec *restrict abs_timeout` | - |
| 184 | `mq_notify` | [man](https://man7.org/linux/man-pages/man2/mq_notify.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mq_notify&type=code) | `0xb8` | `mqd_t mqdes` | `const struct sigevent *sevp` | - | - | - | - |
| 185 | `mq_getsetattr` | [man](https://man7.org/linux/man-pages/man2/mq_getsetattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mq_getsetattr&type=code) | `0xb9` | `mqd_t mqdes` | `const struct mq_attr *newattr` | `struct mq_attr *oldattr` | - | - | - |
| 186 | `msgget` | [man](https://man7.org/linux/man-pages/man2/msgget.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+msgget&type=code) | `0xba` | `key_t key` | `int msgflg` | - | - | - | - |
| 187 | `msgctl` | [man](https://man7.org/linux/man-pages/man2/msgctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+msgctl&type=code) | `0xbb` | `int msqid` | `int cmd` | `struct msqid_ds *buf` | - | - | - |
| 188 | `msgrcv` | [man](https://man7.org/linux/man-pages/man2/msgrcv.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+msgrcv&type=code) | `0xbc` | `int msqid` | `void *msgp` | `size_t msgsz` | `long msgtyp` | `int msgflg` | - |
| 189 | `msgsnd` | [man](https://man7.org/linux/man-pages/man2/msgsnd.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+msgsnd&type=code) | `0xbd` | `int msqid` | `const void *msgp` | `size_t msgsz` | `int msgflg` | - | - |
| 190 | `semget` | [man](https://man7.org/linux/man-pages/man2/semget.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+semget&type=code) | `0xbe` | `key_t key` | `int nsems` | `int semflg` | - | - | - |
| 191 | `semctl` | [man](https://man7.org/linux/man-pages/man2/semctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+semctl&type=code) | `0xbf` | `int semid` | `int semnum` | `int cmd` | `...` | - | - |
| 192 | `semtimedop` | [man](https://man7.org/linux/man-pages/man2/semtimedop.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+semtimedop&type=code) | `0xc0` | `int semid` | `struct sembuf *sops` | `size_t nsops` | `const struct timespec *timeout` | - | - |
| 193 | `semop` | [man](https://man7.org/linux/man-pages/man2/semop.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+semop&type=code) | `0xc1` | `int semid` | `struct sembuf *sops` | `size_t nsops` | - | - | - |
| 194 | `shmget` | [man](https://man7.org/linux/man-pages/man2/shmget.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+shmget&type=code) | `0xc2` | `key_t key` | `size_t size` | `int shmflg` | - | - | - |
| 195 | `shmctl` | [man](https://man7.org/linux/man-pages/man2/shmctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+shmctl&type=code) | `0xc3` | `int shmid` | `int cmd` | `struct shmid_ds *buf` | - | - | - |
| 196 | `shmat` | [man](https://man7.org/linux/man-pages/man2/shmat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+shmat&type=code) | `0xc4` | `int shmid` | `const void *shmaddr` | `int shmflg` | - | - | - |
| 197 | `shmdt` | [man](https://man7.org/linux/man-pages/man2/shmdt.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+shmdt&type=code) | `0xc5` | `const void *shmaddr` | - | - | - | - | - |
| 198 | `socket` | [man](https://man7.org/linux/man-pages/man2/socket.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+socket&type=code) | `0xc6` | `int domain` | `int type` | `int protocol` | - | - | - |
| 199 | `socketpair` | [man](https://man7.org/linux/man-pages/man2/socketpair.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+socketpair&type=code) | `0xc7` | `int domain` | `int type` | `int protocol` | `int sv[2]` | - | - |
| 200 | `bind` | [man](https://man7.org/linux/man-pages/man2/bind.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+bind&type=code) | `0xc8` | `int sockfd` | `const struct sockaddr *addr` | `socklen_t addrlen` | - | - | - |
| 201 | `listen` | [man](https://man7.org/linux/man-pages/man2/listen.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+listen&type=code) | `0xc9` | `int sockfd` | `int backlog` | - | - | - | - |
| 202 | `accept` | [man](https://man7.org/linux/man-pages/man2/accept.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+accept&type=code) | `0xca` | `int sockfd` | `struct sockaddr *restrict addr` | `socklen_t *restrict addrlen` | - | - | - |
| 203 | `connect` | [man](https://man7.org/linux/man-pages/man2/connect.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+connect&type=code) | `0xcb` | `int sockfd` | `const struct sockaddr *addr` | `socklen_t addrlen` | - | - | - |
| 204 | `getsockname` | [man](https://man7.org/linux/man-pages/man2/getsockname.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getsockname&type=code) | `0xcc` | `int sockfd` | `struct sockaddr *restrict addr` | `socklen_t *restrict addrlen` | - | - | - |
| 205 | `getpeername` | [man](https://man7.org/linux/man-pages/man2/getpeername.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getpeername&type=code) | `0xcd` | `int sockfd` | `struct sockaddr *restrict addr` | `socklen_t *restrict addrlen` | - | - | - |
| 206 | `sendto` | [man](https://man7.org/linux/man-pages/man2/sendto.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sendto&type=code) | `0xce` | `int sockfd` | `const void *buf` | `size_t len` | `int flags` | `const struct sockaddr *dest_addr` | `socklen_t addrlen` |
| 207 | `recvfrom` | [man](https://man7.org/linux/man-pages/man2/recvfrom.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+recvfrom&type=code) | `0xcf` | `int sockfd` | `void *restrict buf` | `size_t len` | `int flags` | `struct sockaddr *restrict src_addr` | `socklen_t *restrict addrlen` |
| 208 | `setsockopt` | [man](https://man7.org/linux/man-pages/man2/setsockopt.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setsockopt&type=code) | `0xd0` | `int sockfd` | `int level` | `int optname` | `const void *optval` | `socklen_t optlen` | - |
| 209 | `getsockopt` | [man](https://man7.org/linux/man-pages/man2/getsockopt.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getsockopt&type=code) | `0xd1` | `int sockfd` | `int level` | `int optname` | `void *restrict optval` | `socklen_t *restrict optlen` | - |
| 210 | `shutdown` | [man](https://man7.org/linux/man-pages/man2/shutdown.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+shutdown&type=code) | `0xd2` | `int sockfd` | `int how` | - | - | - | - |
| 211 | `sendmsg` | [man](https://man7.org/linux/man-pages/man2/sendmsg.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sendmsg&type=code) | `0xd3` | `int sockfd` | `const struct msghdr *msg` | `int flags` | - | - | - |
| 212 | `recvmsg` | [man](https://man7.org/linux/man-pages/man2/recvmsg.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+recvmsg&type=code) | `0xd4` | `int sockfd` | `struct msghdr *msg` | `int flags` | - | - | - |
| 213 | `readahead` | [man](https://man7.org/linux/man-pages/man2/readahead.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+readahead&type=code) | `0xd5` | `int fd` | `off64_t offset` | `size_t count` | - | - | - |
| 214 | `brk` | [man](https://man7.org/linux/man-pages/man2/brk.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+brk&type=code) | `0xd6` | `void *addr` | - | - | - | - | - |
| 215 | `munmap` | [man](https://man7.org/linux/man-pages/man2/munmap.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+munmap&type=code) | `0xd7` | `void *addr` | `size_t length` | - | - | - | - |
| 216 | `mremap` | [man](https://man7.org/linux/man-pages/man2/mremap.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mremap&type=code) | `0xd8` | `void *old_address` | `size_t old_size` | `size_t new_size` | `int flags` | `...` | - |
| 217 | `add_key` | [man](https://man7.org/linux/man-pages/man2/add_key.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+add_key&type=code) | `0xd9` | `const char *type` | `const char *description` | `const void *payload` | `size_t plen` | `key_serial_t keyring` | - |
| 218 | `request_key` | [man](https://man7.org/linux/man-pages/man2/request_key.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+request_key&type=code) | `0xda` | `const char *type` | `const char *description` | `const char *callout_info` | `key_serial_t dest_keyring` | - | - |
| 219 | `keyctl` | [man](https://man7.org/linux/man-pages/man2/keyctl.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+keyctl&type=code) | `0xdb` | `int operation` | `unsigned long arg2` | `unsigned long arg3` | `unsigned long arg4` | `unsigned long arg5` | - |
| 220 | `clone` | [man](https://man7.org/linux/man-pages/man2/clone.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clone&type=code) | `0xdc` | `int (*fn)(void *)` | `void *stack` | `int flags` | `void *arg` | `...` | - |
| 221 | `execve` | [man](https://man7.org/linux/man-pages/man2/execve.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+execve&type=code) | `0xdd` | `const char *pathname` | `char *const argv[]` | `char *const envp[]` | - | - | - |
| 222 | `mmap` | [man](https://man7.org/linux/man-pages/man2/mmap.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mmap&type=code) | `0xde` | `void *addr` | `size_t length` | `int prot` | `int flags` | `int fd` | `off_t offset` |
| 223 | `fadvise64` | [man](https://man7.org/linux/man-pages/man2/fadvise64.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fadvise64&type=code) | `0xdf` | `int fd` | `off_t offset` | `off_t len` | `int advice` | - | - |
| 224 | `swapon` | [man](https://man7.org/linux/man-pages/man2/swapon.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+swapon&type=code) | `0xe0` | `const char *path` | `int swapflags` | - | - | - | - |
| 225 | `swapoff` | [man](https://man7.org/linux/man-pages/man2/swapoff.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+swapoff&type=code) | `0xe1` | `const char *path` | - | - | - | - | - |
| 226 | `mprotect` | [man](https://man7.org/linux/man-pages/man2/mprotect.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mprotect&type=code) | `0xe2` | `void *addr` | `size_t len` | `int prot` | - | - | - |
| 227 | `msync` | [man](https://man7.org/linux/man-pages/man2/msync.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+msync&type=code) | `0xe3` | `void *addr` | `size_t length` | `int flags` | - | - | - |
| 228 | `mlock` | [man](https://man7.org/linux/man-pages/man2/mlock.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mlock&type=code) | `0xe4` | `const void *addr` | `size_t len` | - | - | - | - |
| 229 | `munlock` | [man](https://man7.org/linux/man-pages/man2/munlock.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+munlock&type=code) | `0xe5` | `const void *addr` | `size_t len` | - | - | - | - |
| 230 | `mlockall` | [man](https://man7.org/linux/man-pages/man2/mlockall.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mlockall&type=code) | `0xe6` | `int flags` | - | - | - | - | - |
| 231 | `munlockall` | [man](https://man7.org/linux/man-pages/man2/munlockall.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+munlockall&type=code) | `0xe7` | - | - | - | - | - | - |
| 232 | `mincore` | [man](https://man7.org/linux/man-pages/man2/mincore.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mincore&type=code) | `0xe8` | `void *addr` | `size_t length` | `unsigned char *vec` | - | - | - |
| 233 | `madvise` | [man](https://man7.org/linux/man-pages/man2/madvise.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+madvise&type=code) | `0xe9` | `void *addr` | `size_t length` | `int advice` | - | - | - |
| 234 | `remap_file_pages` | [man](https://man7.org/linux/man-pages/man2/remap_file_pages.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+remap_file_pages&type=code) | `0xea` | `void *addr` | `size_t size` | `int prot` | `size_t pgoff` | `int flags` | - |
| 235 | `mbind` | [man](https://man7.org/linux/man-pages/man2/mbind.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mbind&type=code) | `0xeb` | `void *addr` | `unsigned long len` | `int mode` | `const unsigned long *nodemask` | `unsigned long maxnode` | `unsigned int flags` |
| 236 | `get_mempolicy` | [man](https://man7.org/linux/man-pages/man2/get_mempolicy.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+get_mempolicy&type=code) | `0xec` | `int *mode` | `unsigned long *nodemask` | `unsigned long maxnode` | `void *addr` | `unsigned long flags` | - |
| 237 | `set_mempolicy` | [man](https://man7.org/linux/man-pages/man2/set_mempolicy.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+set_mempolicy&type=code) | `0xed` | `int mode` | `const unsigned long *nodemask` | `unsigned long maxnode` | - | - | - |
| 238 | `migrate_pages` | [man](https://man7.org/linux/man-pages/man2/migrate_pages.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+migrate_pages&type=code) | `0xee` | `int pid` | `unsigned long maxnode` | `const unsigned long *old_nodes` | `const unsigned long *new_nodes` | - | - |
| 239 | `move_pages` | [man](https://man7.org/linux/man-pages/man2/move_pages.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+move_pages&type=code) | `0xef` | `int pid` | `unsigned long count` | `void **pages` | `const int *nodes` | `int *status` | `int flags` |
| 240 | `rt_tgsigqueueinfo` | [man](https://man7.org/linux/man-pages/man2/rt_tgsigqueueinfo.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rt_tgsigqueueinfo&type=code) | `0xf0` | `pid_t tgid` | `pid_t tid` | `int sig` | `siginfo_t *info` | - | - |
| 241 | `perf_event_open` | [man](https://man7.org/linux/man-pages/man2/perf_event_open.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+perf_event_open&type=code) | `0xf1` | `struct perf_event_attr *attr` | `pid_t pid` | `int cpu` | `int group_fd` | `unsigned long flags` | - |
| 242 | `accept4` | [man](https://man7.org/linux/man-pages/man2/accept4.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+accept4&type=code) | `0xf2` | `int sockfd` | `struct sockaddr *restrict addr` | `socklen_t *restrict addrlen` | `int flags` | - | - |
| 243 | `recvmmsg` | [man](https://man7.org/linux/man-pages/man2/recvmmsg.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+recvmmsg&type=code) | `0xf3` | `int sockfd` | `struct mmsghdr *msgvec` | `unsigned int vlen` | `int flags` | `struct timespec *timeout` | - |
| 244 | *Not Implemented* | - | `0xf4` | *reserved* | - | - | - | - | - |
| 245 | *Not Implemented* | - | `0xf5` | *reserved* | - | - | - | - | - |
| 246 | *Not Implemented* | - | `0xf6` | *reserved* | - | - | - | - | - |
| 247 | *Not Implemented* | - | `0xf7` | *reserved* | - | - | - | - | - |
| 248 | *Not Implemented* | - | `0xf8` | *reserved* | - | - | - | - | - |
| 249 | *Not Implemented* | - | `0xf9` | *reserved* | - | - | - | - | - |
| 250 | *Not Implemented* | - | `0xfa` | *reserved* | - | - | - | - | - |
| 251 | *Not Implemented* | - | `0xfb` | *reserved* | - | - | - | - | - |
| 252 | *Not Implemented* | - | `0xfc` | *reserved* | - | - | - | - | - |
| 253 | *Not Implemented* | - | `0xfd` | *reserved* | - | - | - | - | - |
| 254 | *Not Implemented* | - | `0xfe` | *reserved* | - | - | - | - | - |
| 255 | *Not Implemented* | - | `0xff` | *reserved* | - | - | - | - | - |
| 256 | *Not Implemented* | - | `0x100` | *reserved* | - | - | - | - | - |
| 257 | *Not Implemented* | - | `0x101` | *reserved* | - | - | - | - | - |
| 258 | `riscv_hwprobe` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+riscv_hwprobe&type=code) | `0x102` | *RISC-V CPU-feature probing syscall (added Linux 6.4), no published man page yet* | - | - | - | - | - |
| 259 | `riscv_flush_icache` | [man](https://man7.org/linux/man-pages/man2/riscv_flush_icache.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+riscv_flush_icache&type=code) | `0x103` | `void *start` | `void *end` | `unsigned long flags` | - | - | - |
| 260 | `wait4` | [man](https://man7.org/linux/man-pages/man2/wait4.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+wait4&type=code) | `0x104` | `pid_t pid` | `int *wstatus` | `int options` | `struct rusage *rusage` | - | - |
| 261 | `prlimit64` | [man](https://man7.org/linux/man-pages/man2/prlimit64.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+prlimit64&type=code) | `0x105` | `pid_t pid` | `int resource` | `const struct rlimit *new_limit` | `struct rlimit *old_limit` | - | - |
| 262 | `fanotify_init` | [man](https://man7.org/linux/man-pages/man2/fanotify_init.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fanotify_init&type=code) | `0x106` | `unsigned int flags` | `unsigned int event_f_flags` | - | - | - | - |
| 263 | `fanotify_mark` | [man](https://man7.org/linux/man-pages/man2/fanotify_mark.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fanotify_mark&type=code) | `0x107` | `int fanotify_fd` | `unsigned int flags` | `uint64_t mask` | `int dirfd` | `const char *pathname` | - |
| 264 | `name_to_handle_at` | [man](https://man7.org/linux/man-pages/man2/name_to_handle_at.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+name_to_handle_at&type=code) | `0x108` | `int dirfd` | `const char *pathname` | `struct file_handle *handle` | `int *mount_id` | `int flags` | - |
| 265 | `open_by_handle_at` | [man](https://man7.org/linux/man-pages/man2/open_by_handle_at.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+open_by_handle_at&type=code) | `0x109` | `int mount_fd` | `struct file_handle *handle` | `int flags` | - | - | - |
| 266 | `clock_adjtime` | [man](https://man7.org/linux/man-pages/man2/clock_adjtime.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clock_adjtime&type=code) | `0x10a` | `clockid_t clk_id` | `struct timex *buf` | - | - | - | - |
| 267 | `syncfs` | [man](https://man7.org/linux/man-pages/man2/syncfs.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+syncfs&type=code) | `0x10b` | `int fd` | - | - | - | - | - |
| 268 | `setns` | [man](https://man7.org/linux/man-pages/man2/setns.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setns&type=code) | `0x10c` | `int fd` | `int nstype` | - | - | - | - |
| 269 | `sendmmsg` | [man](https://man7.org/linux/man-pages/man2/sendmmsg.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sendmmsg&type=code) | `0x10d` | `int sockfd` | `struct mmsghdr *msgvec` | `unsigned int vlen` | `int flags` | - | - |
| 270 | `process_vm_readv` | [man](https://man7.org/linux/man-pages/man2/process_vm_readv.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+process_vm_readv&type=code) | `0x10e` | `pid_t pid` | `const struct iovec *local_iov` | `unsigned long liovcnt` | `const struct iovec *remote_iov` | `unsigned long riovcnt` | `unsigned long flags` |
| 271 | `process_vm_writev` | [man](https://man7.org/linux/man-pages/man2/process_vm_writev.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+process_vm_writev&type=code) | `0x10f` | `pid_t pid` | `const struct iovec *local_iov` | `unsigned long liovcnt` | `const struct iovec *remote_iov` | `unsigned long riovcnt` | `unsigned long flags` |
| 272 | `kcmp` | [man](https://man7.org/linux/man-pages/man2/kcmp.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+kcmp&type=code) | `0x110` | `pid_t pid1` | `pid_t pid2` | `int type` | `unsigned long idx1` | `unsigned long idx2` | - |
| 273 | `finit_module` | [man](https://man7.org/linux/man-pages/man2/finit_module.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+finit_module&type=code) | `0x111` | `int fd` | `const char *param_values` | `int flags` | - | - | - |
| 274 | `sched_setattr` | [man](https://man7.org/linux/man-pages/man2/sched_setattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_setattr&type=code) | `0x112` | `pid_t pid` | `struct sched_attr *attr` | `unsigned int flags` | - | - | - |
| 275 | `sched_getattr` | [man](https://man7.org/linux/man-pages/man2/sched_getattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+sched_getattr&type=code) | `0x113` | `pid_t pid` | `struct sched_attr *attr` | `unsigned int size` | `unsigned int flags` | - | - |
| 276 | `renameat2` | [man](https://man7.org/linux/man-pages/man2/renameat2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+renameat2&type=code) | `0x114` | `int olddirfd` | `const char *oldpath` | `int newdirfd` | `const char *newpath` | `unsigned int flags` | - |
| 277 | `seccomp` | [man](https://man7.org/linux/man-pages/man2/seccomp.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+seccomp&type=code) | `0x115` | `unsigned int operation` | `unsigned int flags` | `void *args` | - | - | - |
| 278 | `getrandom` | [man](https://man7.org/linux/man-pages/man2/getrandom.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getrandom&type=code) | `0x116` | `void *buf` | `size_t buflen` | `unsigned int flags` | - | - | - |
| 279 | `memfd_create` | [man](https://man7.org/linux/man-pages/man2/memfd_create.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+memfd_create&type=code) | `0x117` | `const char *name` | `unsigned int flags` | - | - | - | - |
| 280 | `bpf` | [man](https://man7.org/linux/man-pages/man2/bpf.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+bpf&type=code) | `0x118` | `int cmd` | `union bpf_attr *attr` | `unsigned int size` | - | - | - |
| 281 | `execveat` | [man](https://man7.org/linux/man-pages/man2/execveat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+execveat&type=code) | `0x119` | `int dirfd` | `const char *pathname` | `const char *const argv[]` | `const char *const envp[]` | `int flags` | - |
| 282 | `userfaultfd` | [man](https://man7.org/linux/man-pages/man2/userfaultfd.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+userfaultfd&type=code) | `0x11a` | `int flags` | - | - | - | - | - |
| 283 | `membarrier` | [man](https://man7.org/linux/man-pages/man2/membarrier.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+membarrier&type=code) | `0x11b` | `int cmd` | `unsigned int flags` | `int cpu_id` | - | - | - |
| 284 | `mlock2` | [man](https://man7.org/linux/man-pages/man2/mlock2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mlock2&type=code) | `0x11c` | `const void *addr` | `size_t len` | `unsigned int flags` | - | - | - |
| 285 | `copy_file_range` | [man](https://man7.org/linux/man-pages/man2/copy_file_range.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+copy_file_range&type=code) | `0x11d` | `int fd_in` | `off64_t *off_in` | `int fd_out` | `off64_t *off_out` | `size_t len` | `unsigned int flags` |
| 286 | `preadv2` | [man](https://man7.org/linux/man-pages/man2/preadv2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+preadv2&type=code) | `0x11e` | `int fd` | `const struct iovec *iov` | `int iovcnt` | `off_t offset` | `int flags` | - |
| 287 | `pwritev2` | [man](https://man7.org/linux/man-pages/man2/pwritev2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pwritev2&type=code) | `0x11f` | `int fd` | `const struct iovec *iov` | `int iovcnt` | `off_t offset` | `int flags` | - |
| 288 | `pkey_mprotect` | [man](https://man7.org/linux/man-pages/man2/pkey_mprotect.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pkey_mprotect&type=code) | `0x120` | `void *addr` | `size_t len` | `int prot` | `int pkey` | - | - |
| 289 | `pkey_alloc` | [man](https://man7.org/linux/man-pages/man2/pkey_alloc.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pkey_alloc&type=code) | `0x121` | `unsigned int flags` | `unsigned int access_rights` | - | - | - | - |
| 290 | `pkey_free` | [man](https://man7.org/linux/man-pages/man2/pkey_free.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pkey_free&type=code) | `0x122` | `int pkey` | - | - | - | - | - |
| 291 | `statx` | [man](https://man7.org/linux/man-pages/man2/statx.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+statx&type=code) | `0x123` | `int dirfd` | `const char *restrict pathname` | `int flags` | `unsigned int mask` | `struct statx *restrict statxbuf` | - |
| 292 | `io_pgetevents` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_pgetevents&type=code) | `0x124` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 293 | `rseq` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rseq&type=code) | `0x125` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 294 | `kexec_file_load` | [man](https://man7.org/linux/man-pages/man2/kexec_file_load.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+kexec_file_load&type=code) | `0x126` | `int kernel_fd` | `int initrd_fd` | `unsigned long cmdline_len` | `const char *cmdline` | `unsigned long flags` | - |
| 295 | *Not Implemented* | - | `0x127` | *reserved* | - | - | - | - | - |
| 296 | *Not Implemented* | - | `0x128` | *reserved* | - | - | - | - | - |
| 297 | *Not Implemented* | - | `0x129` | *reserved* | - | - | - | - | - |
| 298 | *Not Implemented* | - | `0x12a` | *reserved* | - | - | - | - | - |
| 299 | *Not Implemented* | - | `0x12b` | *reserved* | - | - | - | - | - |
| 300 | *Not Implemented* | - | `0x12c` | *reserved* | - | - | - | - | - |
| 301 | *Not Implemented* | - | `0x12d` | *reserved* | - | - | - | - | - |
| 302 | *Not Implemented* | - | `0x12e` | *reserved* | - | - | - | - | - |
| 303 | *Not Implemented* | - | `0x12f` | *reserved* | - | - | - | - | - |
| 304 | *Not Implemented* | - | `0x130` | *reserved* | - | - | - | - | - |
| 305 | *Not Implemented* | - | `0x131` | *reserved* | - | - | - | - | - |
| 306 | *Not Implemented* | - | `0x132` | *reserved* | - | - | - | - | - |
| 307 | *Not Implemented* | - | `0x133` | *reserved* | - | - | - | - | - |
| 308 | *Not Implemented* | - | `0x134` | *reserved* | - | - | - | - | - |
| 309 | *Not Implemented* | - | `0x135` | *reserved* | - | - | - | - | - |
| 310 | *Not Implemented* | - | `0x136` | *reserved* | - | - | - | - | - |
| 311 | *Not Implemented* | - | `0x137` | *reserved* | - | - | - | - | - |
| 312 | *Not Implemented* | - | `0x138` | *reserved* | - | - | - | - | - |
| 313 | *Not Implemented* | - | `0x139` | *reserved* | - | - | - | - | - |
| 314 | *Not Implemented* | - | `0x13a` | *reserved* | - | - | - | - | - |
| 315 | *Not Implemented* | - | `0x13b` | *reserved* | - | - | - | - | - |
| 316 | *Not Implemented* | - | `0x13c` | *reserved* | - | - | - | - | - |
| 317 | *Not Implemented* | - | `0x13d` | *reserved* | - | - | - | - | - |
| 318 | *Not Implemented* | - | `0x13e` | *reserved* | - | - | - | - | - |
| 319 | *Not Implemented* | - | `0x13f` | *reserved* | - | - | - | - | - |
| 320 | *Not Implemented* | - | `0x140` | *reserved* | - | - | - | - | - |
| 321 | *Not Implemented* | - | `0x141` | *reserved* | - | - | - | - | - |
| 322 | *Not Implemented* | - | `0x142` | *reserved* | - | - | - | - | - |
| 323 | *Not Implemented* | - | `0x143` | *reserved* | - | - | - | - | - |
| 324 | *Not Implemented* | - | `0x144` | *reserved* | - | - | - | - | - |
| 325 | *Not Implemented* | - | `0x145` | *reserved* | - | - | - | - | - |
| 326 | *Not Implemented* | - | `0x146` | *reserved* | - | - | - | - | - |
| 327 | *Not Implemented* | - | `0x147` | *reserved* | - | - | - | - | - |
| 328 | *Not Implemented* | - | `0x148` | *reserved* | - | - | - | - | - |
| 329 | *Not Implemented* | - | `0x149` | *reserved* | - | - | - | - | - |
| 330 | *Not Implemented* | - | `0x14a` | *reserved* | - | - | - | - | - |
| 331 | *Not Implemented* | - | `0x14b` | *reserved* | - | - | - | - | - |
| 332 | *Not Implemented* | - | `0x14c` | *reserved* | - | - | - | - | - |
| 333 | *Not Implemented* | - | `0x14d` | *reserved* | - | - | - | - | - |
| 334 | *Not Implemented* | - | `0x14e` | *reserved* | - | - | - | - | - |
| 335 | *Not Implemented* | - | `0x14f` | *reserved* | - | - | - | - | - |
| 336 | *Not Implemented* | - | `0x150` | *reserved* | - | - | - | - | - |
| 337 | *Not Implemented* | - | `0x151` | *reserved* | - | - | - | - | - |
| 338 | *Not Implemented* | - | `0x152` | *reserved* | - | - | - | - | - |
| 339 | *Not Implemented* | - | `0x153` | *reserved* | - | - | - | - | - |
| 340 | *Not Implemented* | - | `0x154` | *reserved* | - | - | - | - | - |
| 341 | *Not Implemented* | - | `0x155` | *reserved* | - | - | - | - | - |
| 342 | *Not Implemented* | - | `0x156` | *reserved* | - | - | - | - | - |
| 343 | *Not Implemented* | - | `0x157` | *reserved* | - | - | - | - | - |
| 344 | *Not Implemented* | - | `0x158` | *reserved* | - | - | - | - | - |
| 345 | *Not Implemented* | - | `0x159` | *reserved* | - | - | - | - | - |
| 346 | *Not Implemented* | - | `0x15a` | *reserved* | - | - | - | - | - |
| 347 | *Not Implemented* | - | `0x15b` | *reserved* | - | - | - | - | - |
| 348 | *Not Implemented* | - | `0x15c` | *reserved* | - | - | - | - | - |
| 349 | *Not Implemented* | - | `0x15d` | *reserved* | - | - | - | - | - |
| 350 | *Not Implemented* | - | `0x15e` | *reserved* | - | - | - | - | - |
| 351 | *Not Implemented* | - | `0x15f` | *reserved* | - | - | - | - | - |
| 352 | *Not Implemented* | - | `0x160` | *reserved* | - | - | - | - | - |
| 353 | *Not Implemented* | - | `0x161` | *reserved* | - | - | - | - | - |
| 354 | *Not Implemented* | - | `0x162` | *reserved* | - | - | - | - | - |
| 355 | *Not Implemented* | - | `0x163` | *reserved* | - | - | - | - | - |
| 356 | *Not Implemented* | - | `0x164` | *reserved* | - | - | - | - | - |
| 357 | *Not Implemented* | - | `0x165` | *reserved* | - | - | - | - | - |
| 358 | *Not Implemented* | - | `0x166` | *reserved* | - | - | - | - | - |
| 359 | *Not Implemented* | - | `0x167` | *reserved* | - | - | - | - | - |
| 360 | *Not Implemented* | - | `0x168` | *reserved* | - | - | - | - | - |
| 361 | *Not Implemented* | - | `0x169` | *reserved* | - | - | - | - | - |
| 362 | *Not Implemented* | - | `0x16a` | *reserved* | - | - | - | - | - |
| 363 | *Not Implemented* | - | `0x16b` | *reserved* | - | - | - | - | - |
| 364 | *Not Implemented* | - | `0x16c` | *reserved* | - | - | - | - | - |
| 365 | *Not Implemented* | - | `0x16d` | *reserved* | - | - | - | - | - |
| 366 | *Not Implemented* | - | `0x16e` | *reserved* | - | - | - | - | - |
| 367 | *Not Implemented* | - | `0x16f` | *reserved* | - | - | - | - | - |
| 368 | *Not Implemented* | - | `0x170` | *reserved* | - | - | - | - | - |
| 369 | *Not Implemented* | - | `0x171` | *reserved* | - | - | - | - | - |
| 370 | *Not Implemented* | - | `0x172` | *reserved* | - | - | - | - | - |
| 371 | *Not Implemented* | - | `0x173` | *reserved* | - | - | - | - | - |
| 372 | *Not Implemented* | - | `0x174` | *reserved* | - | - | - | - | - |
| 373 | *Not Implemented* | - | `0x175` | *reserved* | - | - | - | - | - |
| 374 | *Not Implemented* | - | `0x176` | *reserved* | - | - | - | - | - |
| 375 | *Not Implemented* | - | `0x177` | *reserved* | - | - | - | - | - |
| 376 | *Not Implemented* | - | `0x178` | *reserved* | - | - | - | - | - |
| 377 | *Not Implemented* | - | `0x179` | *reserved* | - | - | - | - | - |
| 378 | *Not Implemented* | - | `0x17a` | *reserved* | - | - | - | - | - |
| 379 | *Not Implemented* | - | `0x17b` | *reserved* | - | - | - | - | - |
| 380 | *Not Implemented* | - | `0x17c` | *reserved* | - | - | - | - | - |
| 381 | *Not Implemented* | - | `0x17d` | *reserved* | - | - | - | - | - |
| 382 | *Not Implemented* | - | `0x17e` | *reserved* | - | - | - | - | - |
| 383 | *Not Implemented* | - | `0x17f` | *reserved* | - | - | - | - | - |
| 384 | *Not Implemented* | - | `0x180` | *reserved* | - | - | - | - | - |
| 385 | *Not Implemented* | - | `0x181` | *reserved* | - | - | - | - | - |
| 386 | *Not Implemented* | - | `0x182` | *reserved* | - | - | - | - | - |
| 387 | *Not Implemented* | - | `0x183` | *reserved* | - | - | - | - | - |
| 388 | *Not Implemented* | - | `0x184` | *reserved* | - | - | - | - | - |
| 389 | *Not Implemented* | - | `0x185` | *reserved* | - | - | - | - | - |
| 390 | *Not Implemented* | - | `0x186` | *reserved* | - | - | - | - | - |
| 391 | *Not Implemented* | - | `0x187` | *reserved* | - | - | - | - | - |
| 392 | *Not Implemented* | - | `0x188` | *reserved* | - | - | - | - | - |
| 393 | *Not Implemented* | - | `0x189` | *reserved* | - | - | - | - | - |
| 394 | *Not Implemented* | - | `0x18a` | *reserved* | - | - | - | - | - |
| 395 | *Not Implemented* | - | `0x18b` | *reserved* | - | - | - | - | - |
| 396 | *Not Implemented* | - | `0x18c` | *reserved* | - | - | - | - | - |
| 397 | *Not Implemented* | - | `0x18d` | *reserved* | - | - | - | - | - |
| 398 | *Not Implemented* | - | `0x18e` | *reserved* | - | - | - | - | - |
| 399 | *Not Implemented* | - | `0x18f` | *reserved* | - | - | - | - | - |
| 400 | *Not Implemented* | - | `0x190` | *reserved* | - | - | - | - | - |
| 401 | *Not Implemented* | - | `0x191` | *reserved* | - | - | - | - | - |
| 402 | *Not Implemented* | - | `0x192` | *reserved* | - | - | - | - | - |
| 403 | *Not Implemented* | - | `0x193` | *reserved* | - | - | - | - | - |
| 404 | *Not Implemented* | - | `0x194` | *reserved* | - | - | - | - | - |
| 405 | *Not Implemented* | - | `0x195` | *reserved* | - | - | - | - | - |
| 406 | *Not Implemented* | - | `0x196` | *reserved* | - | - | - | - | - |
| 407 | *Not Implemented* | - | `0x197` | *reserved* | - | - | - | - | - |
| 408 | *Not Implemented* | - | `0x198` | *reserved* | - | - | - | - | - |
| 409 | *Not Implemented* | - | `0x199` | *reserved* | - | - | - | - | - |
| 410 | *Not Implemented* | - | `0x19a` | *reserved* | - | - | - | - | - |
| 411 | *Not Implemented* | - | `0x19b` | *reserved* | - | - | - | - | - |
| 412 | *Not Implemented* | - | `0x19c` | *reserved* | - | - | - | - | - |
| 413 | *Not Implemented* | - | `0x19d` | *reserved* | - | - | - | - | - |
| 414 | *Not Implemented* | - | `0x19e` | *reserved* | - | - | - | - | - |
| 415 | *Not Implemented* | - | `0x19f` | *reserved* | - | - | - | - | - |
| 416 | *Not Implemented* | - | `0x1a0` | *reserved* | - | - | - | - | - |
| 417 | *Not Implemented* | - | `0x1a1` | *reserved* | - | - | - | - | - |
| 418 | *Not Implemented* | - | `0x1a2` | *reserved* | - | - | - | - | - |
| 419 | *Not Implemented* | - | `0x1a3` | *reserved* | - | - | - | - | - |
| 420 | *Not Implemented* | - | `0x1a4` | *reserved* | - | - | - | - | - |
| 421 | *Not Implemented* | - | `0x1a5` | *reserved* | - | - | - | - | - |
| 422 | *Not Implemented* | - | `0x1a6` | *reserved* | - | - | - | - | - |
| 423 | *Not Implemented* | - | `0x1a7` | *reserved* | - | - | - | - | - |
| 424 | `pidfd_send_signal` | [man](https://man7.org/linux/man-pages/man2/pidfd_send_signal.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pidfd_send_signal&type=code) | `0x1a8` | `int pidfd` | `int sig` | `siginfo_t *_Nullable info` | `unsigned int flags` | - | - |
| 425 | `io_uring_setup` | [man](https://man7.org/linux/man-pages/man2/io_uring_setup.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_uring_setup&type=code) | `0x1a9` | `u32 entries` | `struct io_uring_params *params` | - | - | - | - |
| 426 | `io_uring_enter` | [man](https://man7.org/linux/man-pages/man2/io_uring_enter.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_uring_enter&type=code) | `0x1aa` | `unsigned int fd` | `unsigned int to_submit` | `unsigned int min_complete` | `unsigned int flags` | `sigset_t *sig` | - |
| 427 | `io_uring_register` | [man](https://man7.org/linux/man-pages/man2/io_uring_register.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+io_uring_register&type=code) | `0x1ab` | `unsigned int fd` | `unsigned int opcode` | `void *arg` | `unsigned int nr_args` | - | - |
| 428 | `open_tree` | [man](https://man7.org/linux/man-pages/man2/open_tree.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+open_tree&type=code) | `0x1ac` | `int dirfd` | `const char *path` | `unsigned int flags` | - | - | - |
| 429 | `move_mount` | [man](https://man7.org/linux/man-pages/man2/move_mount.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+move_mount&type=code) | `0x1ad` | `int from_dirfd` | `const char *from_path` | `int to_dirfd` | `const char *to_path` | `unsigned int flags` | - |
| 430 | `fsopen` | [man](https://man7.org/linux/man-pages/man2/fsopen.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fsopen&type=code) | `0x1ae` | `const char *fsname` | `unsigned int flags` | - | - | - | - |
| 431 | `fsconfig` | [man](https://man7.org/linux/man-pages/man2/fsconfig.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fsconfig&type=code) | `0x1af` | `int fd` | `unsigned int cmd` | `const char *_Nullable key` | `const void *_Nullable value` | `int aux` | - |
| 432 | `fsmount` | [man](https://man7.org/linux/man-pages/man2/fsmount.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fsmount&type=code) | `0x1b0` | `int fsfd` | `unsigned int flags` | `unsigned int attr_flags` | - | - | - |
| 433 | `fspick` | [man](https://man7.org/linux/man-pages/man2/fspick.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fspick&type=code) | `0x1b1` | `int dirfd` | `const char *path` | `unsigned int flags` | - | - | - |
| 434 | `pidfd_open` | [man](https://man7.org/linux/man-pages/man2/pidfd_open.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pidfd_open&type=code) | `0x1b2` | `pid_t pid` | `unsigned int flags` | - | - | - | - |
| 435 | `clone3` | [man](https://man7.org/linux/man-pages/man2/clone3.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+clone3&type=code) | `0x1b3` | `struct clone_args *cl_args` | `size_t size` | - | - | - | - |
| 436 | `close_range` | [man](https://man7.org/linux/man-pages/man2/close_range.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+close_range&type=code) | `0x1b4` | `unsigned int first` | `unsigned int last` | `int flags` | - | - | - |
| 437 | `openat2` | [man](https://man7.org/linux/man-pages/man2/openat2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+openat2&type=code) | `0x1b5` | `int dirfd` | `const char *path` | `struct open_how *how` | `size_t size` | - | - |
| 438 | `pidfd_getfd` | [man](https://man7.org/linux/man-pages/man2/pidfd_getfd.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+pidfd_getfd&type=code) | `0x1b6` | `int pidfd` | `int targetfd` | `unsigned int flags` | - | - | - |
| 439 | `faccessat2` | [man](https://man7.org/linux/man-pages/man2/faccessat2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+faccessat2&type=code) | `0x1b7` | `int dirfd` | `const char *path` | `int mode` | `int flags` | - | - |
| 440 | `process_madvise` | [man](https://man7.org/linux/man-pages/man2/process_madvise.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+process_madvise&type=code) | `0x1b8` | `int pidfd` | `const struct iovec *iovec` | `size_t n` | `int advice` | `unsigned int flags` | - |
| 441 | `epoll_pwait2` | [man](https://man7.org/linux/man-pages/man2/epoll_pwait2.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+epoll_pwait2&type=code) | `0x1b9` | `int epfd` | `struct epoll_event *events` | `int n` | `const struct timespec *_Nullable timeout` | `const sigset_t *_Nullable sigmask` | - |
| 442 | `mount_setattr` | [man](https://man7.org/linux/man-pages/man2/mount_setattr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mount_setattr&type=code) | `0x1ba` | `int dirfd` | `const char *path` | `unsigned int flags` | `struct mount_attr *attr` | `size_t size` | - |
| 443 | `quotactl_fd` | [man](https://man7.org/linux/man-pages/man2/quotactl_fd.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+quotactl_fd&type=code) | `0x1bb` | `int fd` | `int op` | `int id` | `caddr_t addr` | - | - |
| 444 | `landlock_create_ruleset` | [man](https://man7.org/linux/man-pages/man2/landlock_create_ruleset.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+landlock_create_ruleset&type=code) | `0x1bc` | `const struct landlock_ruleset_attr *attr` | `size_t size` | `uint32_t flags` | - | - | - |
| 445 | `landlock_add_rule` | [man](https://man7.org/linux/man-pages/man2/landlock_add_rule.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+landlock_add_rule&type=code) | `0x1bd` | `int ruleset_fd` | `enum landlock_rule_type rule_type` | `const void *rule_attr` | `uint32_t flags` | - | - |
| 446 | `landlock_restrict_self` | [man](https://man7.org/linux/man-pages/man2/landlock_restrict_self.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+landlock_restrict_self&type=code) | `0x1be` | `int ruleset_fd` | `uint32_t flags` | - | - | - | - |
| 447 | `memfd_secret` | [man](https://man7.org/linux/man-pages/man2/memfd_secret.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+memfd_secret&type=code) | `0x1bf` | `unsigned int flags` | - | - | - | - | - |
| 448 | `process_mrelease` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+process_mrelease&type=code) | `0x1c0` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 449 | `futex_waitv` | [man](https://man7.org/linux/man-pages/man2/futex_waitv.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+futex_waitv&type=code) | `0x1c1` | `struct futex_waitv *waiters` | `unsigned int n` | `unsigned int flags` | `const struct timespec *_Nullable timeout` | `clockid_t clockid` | - |
| 450 | `set_mempolicy_home_node` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+set_mempolicy_home_node&type=code) | `0x1c2` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 451 | `cachestat` | [man](https://man7.org/linux/man-pages/man2/cachestat.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+cachestat&type=code) | `0x1c3` | `unsigned int fd` | `struct cachestat_range *cstat_range` | `struct cachestat *cstat` | `unsigned int flags` | - | - |
| 452 | `fchmodat2` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+fchmodat2&type=code) | `0x1c4` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 453 | `map_shadow_stack` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+map_shadow_stack&type=code) | `0x1c5` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 454 | `futex_wake` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+futex_wake&type=code) | `0x1c6` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 455 | `futex_wait` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+futex_wait&type=code) | `0x1c7` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 456 | `futex_requeue` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+futex_requeue&type=code) | `0x1c8` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 457 | `statmount` | [man](https://man7.org/linux/man-pages/man2/statmount.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+statmount&type=code) | `0x1c9` | `struct mnt_id_req *req` | `struct statmount *smbuf` | `size_t bufsize` | `unsigned long flags` | - | - |
| 458 | `listmount` | [man](https://man7.org/linux/man-pages/man2/listmount.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+listmount&type=code) | `0x1ca` | `struct mnt_id_req *req` | `uint64_t *mnt_ids` | `size_t n` | `unsigned long flags` | - | - |
| 459 | `lsm_get_self_attr` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lsm_get_self_attr&type=code) | `0x1cb` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 460 | `lsm_set_self_attr` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lsm_set_self_attr&type=code) | `0x1cc` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 461 | `lsm_list_modules` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+lsm_list_modules&type=code) | `0x1cd` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 462 | `mseal` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+mseal&type=code) | `0x1ce` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 463 | `setxattrat` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+setxattrat&type=code) | `0x1cf` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 464 | `getxattrat` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+getxattrat&type=code) | `0x1d0` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 465 | `listxattrat` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+listxattrat&type=code) | `0x1d1` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 466 | `removexattrat` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+removexattrat&type=code) | `0x1d2` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 467 | `open_tree_attr` | [man](https://man7.org/linux/man-pages/man2/open_tree_attr.2.html) [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+open_tree_attr&type=code) | `0x1d3` | `int dirfd` | `const char *path` | `unsigned int flags` | `struct mount_attr *_Nullable attr` | `size_t size` | - |
| 468 | `file_getattr` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+file_getattr&type=code) | `0x1d4` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 469 | `file_setattr` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+file_setattr&type=code) | `0x1d5` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 470 | `listns` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+listns&type=code) | `0x1d6` | *undocumented (no published man page yet)* | - | - | - | - | - |
| 471 | `rseq_slice_yield` | [src](https://github.com/search?q=repo%3Atorvalds%2Flinux+SYSCALL_DEFINE+rseq_slice_yield&type=code) | `0x1d7` | *undocumented (no published man page yet)* | - | - | - | - | - |
{: style="--table-col-1: 5%; --table-col-2: 14%; --table-col-3: 9%; --table-col-4: 7%; --table-col-5: 12%; --table-col-6: 12%; --table-col-7: 12%; --table-col-8: 11%; --table-col-9: 9%; --table-col-10: 9%;"}
