#!/bin/sh

/usr/bin/plic -C -dELF -lsiaxgo -ew "-cn(^) -i/usr/lib/include" outcomes.pli -o outcomes.o
ld -z muldefs -Bstatic -M -o outcomes --oformat=elf32-i386 -melf_i386 -e main outcomes.o --start-group /usr/lib/libprf.a --end-group >outcomes.map
