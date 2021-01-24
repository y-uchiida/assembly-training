#!/bin/bash

echo compiling $1.s to $1.exe...
as -o $1.o $1.s --32
ld -o $1.exe -e entry_point $1.o -m elf_i386

echo start $1.exe on gdb...
gdb $1.exe