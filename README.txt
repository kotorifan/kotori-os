kotori-os
=========
Hopefully this is the last one and the one I will work on 
long in the future, but you never know, so I won't make
any promises; not that anybody would care anyway.

Depedencies
-----------
- GNU GCC cross-compiler + Binutils (+ GDB for debugging)
- Netwide Assembler
- mtools, dosfstools, parted
- (git)
- qemu for x86_64 to run it
- Lua (for running the additional scripts in ./scripts/)

Usage
-----
$ make build_limine
$ make build
$ make run # for normal usage
$ make debug # for debugging (you need to connect with gdb)

Mirrors
-------
I don't like relying on some specific git hosting service, since
they all suck, but if I get offered free backups of my code, I'll
use it. As such, I mirrored the code of Kotori-OS on the following
git hosting services:

- https://github.com/kotorifan/kotori-os
- https://codeberg.org/kotorifan/kotori-os
- https://git.disroot.org/kotorifan/kotori-os
- https://git.nadeko.net/kotorifan/kotori-os
- https://gitgud.io/kotorifan/kotori-os-new

They are ought to be all equally up to date as they are all in my git
push remotes or whatever you call them.

Copying
-------
GPLv3 (see COPYING.txt)
