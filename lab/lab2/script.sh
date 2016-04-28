#!/bin/sh

cpp lab2.c lab2.i
c86 -g lab2.i lab2.s
cat clib.s lab2.s > lab2final.s
nasm lab2final.s -o lab2.bin -l lab2.lst
