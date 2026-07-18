---
layout: reference
title: "ASCII Table"
excerpt: "The full 7-bit ASCII table: control characters 0-31 and 127, plus every printable character 32-126."
tags: [lookup]
---

*C escape: the named `\x` escape sequence for that byte in C, where one exists. `\e` for `ESC` is a
GNU/Clang extension, not standard C — everything else listed is ISO C. Every byte can always be
written as `\xHH` or `\nnn` regardless; this column only lists the shorter named form where the
language defines one.*

| Dec | Hex | Character | C Escape | Dec | Hex | Character | C Escape |
|---|---|---|---|---|---|---|---|
| 0 | `0x00` | `NUL` — Null | `\0` | 64 | `0x40` | `@` | - |
| 1 | `0x01` | `SOH` — Start of Heading | - | 65 | `0x41` | `A` | - |
| 2 | `0x02` | `STX` — Start of Text | - | 66 | `0x42` | `B` | - |
| 3 | `0x03` | `ETX` — End of Text | - | 67 | `0x43` | `C` | - |
| 4 | `0x04` | `EOT` — End of Transmission | - | 68 | `0x44` | `D` | - |
| 5 | `0x05` | `ENQ` — Enquiry | - | 69 | `0x45` | `E` | - |
| 6 | `0x06` | `ACK` — Acknowledge | - | 70 | `0x46` | `F` | - |
| 7 | `0x07` | `BEL` — Bell | `\a` | 71 | `0x47` | `G` | - |
| 8 | `0x08` | `BS` — Backspace | `\b` | 72 | `0x48` | `H` | - |
| 9 | `0x09` | `HT` — Horizontal Tab | `\t` | 73 | `0x49` | `I` | - |
| 10 | `0x0a` | `LF` — Line Feed | `\n` | 74 | `0x4a` | `J` | - |
| 11 | `0x0b` | `VT` — Vertical Tab | `\v` | 75 | `0x4b` | `K` | - |
| 12 | `0x0c` | `FF` — Form Feed | `\f` | 76 | `0x4c` | `L` | - |
| 13 | `0x0d` | `CR` — Carriage Return | `\r` | 77 | `0x4d` | `M` | - |
| 14 | `0x0e` | `SO` — Shift Out | - | 78 | `0x4e` | `N` | - |
| 15 | `0x0f` | `SI` — Shift In | - | 79 | `0x4f` | `O` | - |
| 16 | `0x10` | `DLE` — Data Link Escape | - | 80 | `0x50` | `P` | - |
| 17 | `0x11` | `DC1` — Device Control 1 (XON) | - | 81 | `0x51` | `Q` | - |
| 18 | `0x12` | `DC2` — Device Control 2 | - | 82 | `0x52` | `R` | - |
| 19 | `0x13` | `DC3` — Device Control 3 (XOFF) | - | 83 | `0x53` | `S` | - |
| 20 | `0x14` | `DC4` — Device Control 4 | - | 84 | `0x54` | `T` | - |
| 21 | `0x15` | `NAK` — Negative Acknowledge | - | 85 | `0x55` | `U` | - |
| 22 | `0x16` | `SYN` — Synchronous Idle | - | 86 | `0x56` | `V` | - |
| 23 | `0x17` | `ETB` — End of Transmission Block | - | 87 | `0x57` | `W` | - |
| 24 | `0x18` | `CAN` — Cancel | - | 88 | `0x58` | `X` | - |
| 25 | `0x19` | `EM` — End of Medium | - | 89 | `0x59` | `Y` | - |
| 26 | `0x1a` | `SUB` — Substitute | - | 90 | `0x5a` | `Z` | - |
| 27 | `0x1b` | `ESC` — Escape | `\e` | 91 | `0x5b` | `[` | - |
| 28 | `0x1c` | `FS` — File Separator | - | 92 | `0x5c` | `\` | `\\` |
| 29 | `0x1d` | `GS` — Group Separator | - | 93 | `0x5d` | `]` | - |
| 30 | `0x1e` | `RS` — Record Separator | - | 94 | `0x5e` | `^` | - |
| 31 | `0x1f` | `US` — Unit Separator | - | 95 | `0x5f` | `_` | - |
| 32 | `0x20` | (space) | - | 96 | `0x60` | `` ` `` | - |
| 33 | `0x21` | `!` | - | 97 | `0x61` | `a` | - |
| 34 | `0x22` | `"` | `\"` | 98 | `0x62` | `b` | - |
| 35 | `0x23` | `#` | - | 99 | `0x63` | `c` | - |
| 36 | `0x24` | `$` | - | 100 | `0x64` | `d` | - |
| 37 | `0x25` | `%` | - | 101 | `0x65` | `e` | - |
| 38 | `0x26` | `&` | - | 102 | `0x66` | `f` | - |
| 39 | `0x27` | `'` | `\'` | 103 | `0x67` | `g` | - |
| 40 | `0x28` | `(` | - | 104 | `0x68` | `h` | - |
| 41 | `0x29` | `)` | - | 105 | `0x69` | `i` | - |
| 42 | `0x2a` | `*` | - | 106 | `0x6a` | `j` | - |
| 43 | `0x2b` | `+` | - | 107 | `0x6b` | `k` | - |
| 44 | `0x2c` | `,` | - | 108 | `0x6c` | `l` | - |
| 45 | `0x2d` | `-` | - | 109 | `0x6d` | `m` | - |
| 46 | `0x2e` | `.` | - | 110 | `0x6e` | `n` | - |
| 47 | `0x2f` | `/` | - | 111 | `0x6f` | `o` | - |
| 48 | `0x30` | `0` | - | 112 | `0x70` | `p` | - |
| 49 | `0x31` | `1` | - | 113 | `0x71` | `q` | - |
| 50 | `0x32` | `2` | - | 114 | `0x72` | `r` | - |
| 51 | `0x33` | `3` | - | 115 | `0x73` | `s` | - |
| 52 | `0x34` | `4` | - | 116 | `0x74` | `t` | - |
| 53 | `0x35` | `5` | - | 117 | `0x75` | `u` | - |
| 54 | `0x36` | `6` | - | 118 | `0x76` | `v` | - |
| 55 | `0x37` | `7` | - | 119 | `0x77` | `w` | - |
| 56 | `0x38` | `8` | - | 120 | `0x78` | `x` | - |
| 57 | `0x39` | `9` | - | 121 | `0x79` | `y` | - |
| 58 | `0x3a` | `:` | - | 122 | `0x7a` | `z` | - |
| 59 | `0x3b` | `;` | - | 123 | `0x7b` | `{` | - |
| 60 | `0x3c` | `<` | - | 124 | `0x7c` | \| | - |
| 61 | `0x3d` | `=` | - | 125 | `0x7d` | `}` | - |
| 62 | `0x3e` | `>` | - | 126 | `0x7e` | `~` | - |
| 63 | `0x3f` | `?` | `\?` | 127 | `0x7f` | `DEL` — Delete | - |
{: style="--table-col-1: 4%; --table-col-2: 7%; --table-col-3: 27%; --table-col-4: 8%; --table-col-5: 4%; --table-col-6: 7%; --table-col-7: 27%; --table-col-8: 8%;"}

---

### Sources

- [Wikipedia — ASCII](https://en.wikipedia.org/wiki/ASCII)
- [cppreference — Escape sequences](https://en.cppreference.com/w/c/language/escape.html)
