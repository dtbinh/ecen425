# Sample ECEn 425 Makefile

final_array.bin:	final_array.s
		nasm final_array.s -o final_array.bin -l final_array.lst  # Step 4, Assemble

final_array.s:	clib.s array.s
		cat clib.s array.s > final_array.s        # Step 3, Concatenate

array.s:	array.c
		cpp array.c array.i      # Step 1, Preprocess
		c86 -g array.i array.s   # Step 2, Compile


clean:	
		rm final_array.bin final_array.lst final_array.s
