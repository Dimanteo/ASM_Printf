#!/bin/bash
nasm -f elf64 -l conv.lst conv.s
ld -s -o conv.elf conv.o