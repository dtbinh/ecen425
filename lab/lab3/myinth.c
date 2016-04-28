#include "clib.h"

extern int KeyBuffer;

int counter = 0;

void reset_handler(){
	exit(0);
}

void tick_handler(){
	counter++;
	printNewLine();
	printNewLine();
	printString("TICK ");
	printInt(counter);
	printNewLine();
	printNewLine();
}

void keyboard_handler(){
	int i;
	char kb = KeyBuffer;
	
	if(kb == 'd'){
		printNewLine();
		printNewLine();		
		printString("DELAY KEY PRESSED");
		printNewLine();
		printNewLine();
		
		
		for(i = 0; i < 5000; i++){
			
		}
		
		printNewLine();
		printNewLine();		
		printString("DELAY COMPLETE");
		printNewLine();
		printNewLine();					
				
	}
	else{
		printNewLine();
		printNewLine();		
		printString("KEYPRESS ");
		printChar('(');
		printChar(kb);
		printChar(')');
		printString(" IGNORED");
		printNewLine();
		printNewLine();							
	}

}
