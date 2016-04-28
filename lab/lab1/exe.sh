#!/bin/bash

cpp lab1.c lab1.i
c86 -g lab1.i lab1.s
cat clib.s lab1asm.s lab1.s > lab1final.s
nasm lab1final.s -o lab1.bin -l lab1.lst

