#!/bin/bash
nasm -f elf64 -l tests.lst tests.s
ld -s -o tests.elf tests.o
./tests.elf