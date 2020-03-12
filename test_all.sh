#!/bin/bash
function testModule {
    home=$(pwd)
    cd $1
    echo "Unit tests for $1"
    nasm -f elf64 -l tests.lst tests.s
    ld -s -o tests.elf tests.o
    ./tests.elf
    echo "Tests passed $1"
    echo
    cd $home
}
while [ -n "$1" ]
do
case "$1" in
    -a ) testModule "Converter/"
         testModule "Str/"
         testModule "Main/";;
    -f ) testModule $2
         shift;;
esac
shift
done
