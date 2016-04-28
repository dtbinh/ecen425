# Sample ECEn 425 Makefile

switch_final.bin:	switch_final.s
		nasm switch_final.s -o switch_final.bin -l switch_final.lst  # Step 4, Assemble

switch_final.s:	clib.s switch.s
		cat clib.s switch.s > switch_final.s        # Step 3, Concatenate

switch.s:	switch.c
		cpp switch.c switch.i      # Step 1, Preprocess
		c86 -g switch.i switch.s   # Step 2, Compile


clean:	
		rm switch_final.bin switch_final.lst switch_final.s
