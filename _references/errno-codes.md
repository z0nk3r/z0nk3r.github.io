---
layout: reference
title: "Linux errno Codes"
excerpt: "Every errno code in the Linux kernel, with the #define name, description, and the raw 64-bit $rax value a failed syscall leaves behind."
tags: [linux, c, lookup]
---

## Base errors (1–34)

| Code | Name | `syscall $rax` | Description |
|---|---|---|---|
| 1 | `EPERM` | `0xffffffffffffffff` | Operation not permitted |
| 2 | `ENOENT` | `0xfffffffffffffffe` | No such file or directory |
| 3 | `ESRCH` | `0xfffffffffffffffd` | No such process |
| 4 | `EINTR` | `0xfffffffffffffffc` | Interrupted system call |
| 5 | `EIO` | `0xfffffffffffffffb` | I/O error |
| 6 | `ENXIO` | `0xfffffffffffffffa` | No such device or address |
| 7 | `E2BIG` | `0xfffffffffffffff9` | Argument list too long |
| 8 | `ENOEXEC` | `0xfffffffffffffff8` | Exec format error |
| 9 | `EBADF` | `0xfffffffffffffff7` | Bad file number |
| 10 | `ECHILD` | `0xfffffffffffffff6` | No child processes |
| 11 | `EAGAIN` | `0xfffffffffffffff5` | Try again |
| 11 | `EWOULDBLOCK` | `0xfffffffffffffff5` | Operation would block (alias for EAGAIN) |
| 12 | `ENOMEM` | `0xfffffffffffffff4` | Out of memory |
| 13 | `EACCES` | `0xfffffffffffffff3` | Permission denied |
| 14 | `EFAULT` | `0xfffffffffffffff2` | Bad address |
| 15 | `ENOTBLK` | `0xfffffffffffffff1` | Block device required |
| 16 | `EBUSY` | `0xfffffffffffffff0` | Device or resource busy |
| 17 | `EEXIST` | `0xffffffffffffffef` | File exists |
| 18 | `EXDEV` | `0xffffffffffffffee` | Cross-device link |
| 19 | `ENODEV` | `0xffffffffffffffed` | No such device |
| 20 | `ENOTDIR` | `0xffffffffffffffec` | Not a directory |
| 21 | `EISDIR` | `0xffffffffffffffeb` | Is a directory |
| 22 | `EINVAL` | `0xffffffffffffffea` | Invalid argument |
| 23 | `ENFILE` | `0xffffffffffffffe9` | File table overflow |
| 24 | `EMFILE` | `0xffffffffffffffe8` | Too many open files |
| 25 | `ENOTTY` | `0xffffffffffffffe7` | Not a typewriter |
| 26 | `ETXTBSY` | `0xffffffffffffffe6` | Text file busy |
| 27 | `EFBIG` | `0xffffffffffffffe5` | File too large |
| 28 | `ENOSPC` | `0xffffffffffffffe4` | No space left on device |
| 29 | `ESPIPE` | `0xffffffffffffffe3` | Illegal seek |
| 30 | `EROFS` | `0xffffffffffffffe2` | Read-only file system |
| 31 | `EMLINK` | `0xffffffffffffffe1` | Too many links |
| 32 | `EPIPE` | `0xffffffffffffffe0` | Broken pipe |
| 33 | `EDOM` | `0xffffffffffffffdf` | Math argument out of domain of func |
| 34 | `ERANGE` | `0xffffffffffffffde` | Math result not representable |
{: style="--table-col-1: 6%; --table-col-2: 17%; --table-col-3: 17%; --table-col-4: 60%;"}

## Extended errors (35–134)

| Code | Name | `syscall $rax` | Description |
|---|---|---|---|
| 35 | `EDEADLK` | `0xffffffffffffffdd` | Resource deadlock would occur |
| 35 | `EDEADLOCK` | `0xffffffffffffffdd` | Alias for EDEADLK |
| 36 | `ENAMETOOLONG` | `0xffffffffffffffdc` | File name too long |
| 37 | `ENOLCK` | `0xffffffffffffffdb` | No record locks available |
| 38 | `ENOSYS` | `0xffffffffffffffda` | Invalid system call number |
| 39 | `ENOTEMPTY` | `0xffffffffffffffd9` | Directory not empty |
| 40 | `ELOOP` | `0xffffffffffffffd8` | Too many symbolic links encountered |
| 42 | `ENOMSG` | `0xffffffffffffffd6` | No message of desired type |
| 43 | `EIDRM` | `0xffffffffffffffd5` | Identifier removed |
| 44 | `ECHRNG` | `0xffffffffffffffd4` | Channel number out of range |
| 45 | `EL2NSYNC` | `0xffffffffffffffd3` | Level 2 not synchronized |
| 46 | `EL3HLT` | `0xffffffffffffffd2` | Level 3 halted |
| 47 | `EL3RST` | `0xffffffffffffffd1` | Level 3 reset |
| 48 | `ELNRNG` | `0xffffffffffffffd0` | Link number out of range |
| 49 | `EUNATCH` | `0xffffffffffffffcf` | Protocol driver not attached |
| 50 | `ENOCSI` | `0xffffffffffffffce` | No CSI structure available |
| 51 | `EL2HLT` | `0xffffffffffffffcd` | Level 2 halted |
| 52 | `EBADE` | `0xffffffffffffffcc` | Invalid exchange |
| 53 | `EBADR` | `0xffffffffffffffcb` | Invalid request descriptor |
| 54 | `EXFULL` | `0xffffffffffffffca` | Exchange full |
| 55 | `ENOANO` | `0xffffffffffffffc9` | No anode |
| 56 | `EBADRQC` | `0xffffffffffffffc8` | Invalid request code |
| 57 | `EBADSLT` | `0xffffffffffffffc7` | Invalid slot |
| 59 | `EBFONT` | `0xffffffffffffffc5` | Bad font file format |
| 60 | `ENOSTR` | `0xffffffffffffffc4` | Device not a stream |
| 61 | `ENODATA` | `0xffffffffffffffc3` | No data available |
| 62 | `ETIME` | `0xffffffffffffffc2` | Timer expired |
| 63 | `ENOSR` | `0xffffffffffffffc1` | Out of streams resources |
| 64 | `ENONET` | `0xffffffffffffffc0` | Machine is not on the network |
| 65 | `ENOPKG` | `0xffffffffffffffbf` | Package not installed |
| 66 | `EREMOTE` | `0xffffffffffffffbe` | Object is remote |
| 67 | `ENOLINK` | `0xffffffffffffffbd` | Link has been severed |
| 68 | `EADV` | `0xffffffffffffffbc` | Advertise error |
| 69 | `ESRMNT` | `0xffffffffffffffbb` | Srmount error |
| 70 | `ECOMM` | `0xffffffffffffffba` | Communication error on send |
| 71 | `EPROTO` | `0xffffffffffffffb9` | Protocol error |
| 72 | `EMULTIHOP` | `0xffffffffffffffb8` | Multihop attempted |
| 73 | `EDOTDOT` | `0xffffffffffffffb7` | RFS specific error |
| 74 | `EBADMSG` | `0xffffffffffffffb6` | Not a data message |
| 74 | `EFSBADCRC` | `0xffffffffffffffb6` | Bad CRC detected (alias for EBADMSG) |
| 75 | `EOVERFLOW` | `0xffffffffffffffb5` | Value too large for defined data type |
| 76 | `ENOTUNIQ` | `0xffffffffffffffb4` | Name not unique on network |
| 77 | `EBADFD` | `0xffffffffffffffb3` | File descriptor in bad state |
| 78 | `EREMCHG` | `0xffffffffffffffb2` | Remote address changed |
| 79 | `ELIBACC` | `0xffffffffffffffb1` | Can not access a needed shared library |
| 80 | `ELIBBAD` | `0xffffffffffffffb0` | Accessing a corrupted shared library |
| 81 | `ELIBSCN` | `0xffffffffffffffaf` | .lib section in a.out corrupted |
| 82 | `ELIBMAX` | `0xffffffffffffffae` | Attempting to link in too many shared libraries |
| 83 | `ELIBEXEC` | `0xffffffffffffffad` | Cannot exec a shared library directly |
| 84 | `EILSEQ` | `0xffffffffffffffac` | Illegal byte sequence |
| 85 | `ERESTART` | `0xffffffffffffffab` | Interrupted system call should be restarted |
| 86 | `ESTRPIPE` | `0xffffffffffffffaa` | Streams pipe error |
| 87 | `EUSERS` | `0xffffffffffffffa9` | Too many users |
| 88 | `ENOTSOCK` | `0xffffffffffffffa8` | Socket operation on non-socket |
| 89 | `EDESTADDRREQ` | `0xffffffffffffffa7` | Destination address required |
| 90 | `EMSGSIZE` | `0xffffffffffffffa6` | Message too long |
| 91 | `EPROTOTYPE` | `0xffffffffffffffa5` | Protocol wrong type for socket |
| 92 | `ENOPROTOOPT` | `0xffffffffffffffa4` | Protocol not available |
| 93 | `EPROTONOSUPPORT` | `0xffffffffffffffa3` | Protocol not supported |
| 94 | `ESOCKTNOSUPPORT` | `0xffffffffffffffa2` | Socket type not supported |
| 95 | `EOPNOTSUPP` | `0xffffffffffffffa1` | Operation not supported on transport endpoint |
| 96 | `EPFNOSUPPORT` | `0xffffffffffffffa0` | Protocol family not supported |
| 97 | `EAFNOSUPPORT` | `0xffffffffffffff9f` | Address family not supported by protocol |
| 98 | `EADDRINUSE` | `0xffffffffffffff9e` | Address already in use |
| 99 | `EADDRNOTAVAIL` | `0xffffffffffffff9d` | Cannot assign requested address |
| 100 | `ENETDOWN` | `0xffffffffffffff9c` | Network is down |
| 101 | `ENETUNREACH` | `0xffffffffffffff9b` | Network is unreachable |
| 102 | `ENETRESET` | `0xffffffffffffff9a` | Network dropped connection because of reset |
| 103 | `ECONNABORTED` | `0xffffffffffffff99` | Software caused connection abort |
| 104 | `ECONNRESET` | `0xffffffffffffff98` | Connection reset by peer |
| 105 | `ENOBUFS` | `0xffffffffffffff97` | No buffer space available |
| 106 | `EISCONN` | `0xffffffffffffff96` | Transport endpoint is already connected |
| 107 | `ENOTCONN` | `0xffffffffffffff95` | Transport endpoint is not connected |
| 108 | `ESHUTDOWN` | `0xffffffffffffff94` | Cannot send after transport endpoint shutdown |
| 109 | `ETOOMANYREFS` | `0xffffffffffffff93` | Too many references: cannot splice |
| 110 | `ETIMEDOUT` | `0xffffffffffffff92` | Connection timed out |
| 111 | `ECONNREFUSED` | `0xffffffffffffff91` | Connection refused |
| 112 | `EHOSTDOWN` | `0xffffffffffffff90` | Host is down |
| 113 | `EHOSTUNREACH` | `0xffffffffffffff8f` | No route to host |
| 114 | `EALREADY` | `0xffffffffffffff8e` | Operation already in progress |
| 115 | `EINPROGRESS` | `0xffffffffffffff8d` | Operation now in progress |
| 116 | `ESTALE` | `0xffffffffffffff8c` | Stale file handle |
| 117 | `EUCLEAN` | `0xffffffffffffff8b` | Structure needs cleaning |
| 117 | `EFSCORRUPTED` | `0xffffffffffffff8b` | Filesystem is corrupted (alias for EUCLEAN) |
| 118 | `ENOTNAM` | `0xffffffffffffff8a` | Not a XENIX named type file |
| 119 | `ENAVAIL` | `0xffffffffffffff89` | No XENIX semaphores available |
| 120 | `EISNAM` | `0xffffffffffffff88` | Is a named type file |
| 121 | `EREMOTEIO` | `0xffffffffffffff87` | Remote I/O error |
| 122 | `EDQUOT` | `0xffffffffffffff86` | Quota exceeded |
| 123 | `ENOMEDIUM` | `0xffffffffffffff85` | No medium found |
| 124 | `EMEDIUMTYPE` | `0xffffffffffffff84` | Wrong medium type |
| 125 | `ECANCELED` | `0xffffffffffffff83` | Operation Canceled |
| 126 | `ENOKEY` | `0xffffffffffffff82` | Required key not available |
| 127 | `EKEYEXPIRED` | `0xffffffffffffff81` | Key has expired |
| 128 | `EKEYREVOKED` | `0xffffffffffffff80` | Key has been revoked |
| 129 | `EKEYREJECTED` | `0xffffffffffffff7f` | Key was rejected by service |
| 130 | `EOWNERDEAD` | `0xffffffffffffff7e` | Owner died |
| 131 | `ENOTRECOVERABLE` | `0xffffffffffffff7d` | State not recoverable |
| 132 | `ERFKILL` | `0xffffffffffffff7c` | Operation not possible due to RF-kill |
| 133 | `EHWPOISON` | `0xffffffffffffff7b` | Memory page has hardware error |
| 134 | `EFTYPE` | `0xffffffffffffff7a` | Wrong file type for the intended operation |
{: style="--table-col-1: 6%; --table-col-2: 17%; --table-col-3: 17%; --table-col-4: 60%;"}

---

### Sources

- [torvalds/linux — errno-base.h](https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/errno-base.h)
- [torvalds/linux — errno.h](https://github.com/torvalds/linux/blob/master/include/uapi/asm-generic/errno.h)
- [Wikipedia — errno.h](https://en.wikipedia.org/wiki/Errno.h)
