#include "../include/clib.h"
#include "../include/yakk.h"

static char tick[5] = "TICK ";
static char keypress[10] = "KEYPRESS (";
static char ignored[9] = ") IGNORED";
static char delay[17] = "DELAY KEY PRESSED";
static char complete[14] = "DELAY COMPLETE";
extern int KeyBuffer;
extern unsigned int YKTickCounter;

void resetHandler() {

	exit(0);

}

void tickHandler() {

	YKEnterMutex();
	YKTickCounter++;
	YKExitMutex();
	printString("\nTick ");
	YKEnterMutex();
	printInt(YKTickCounter);
	YKExitMutex();
	printNewLine();
	YKTickHandler();
	return;

}

void keyboardHandler() {

	int i;	

	if (KeyBuffer == 'd') {
		printNewLine();
		print(delay, 17);
		printNewLine();

		for (i = 0; i < 5000; i++);
	
		printNewLine();
		print(complete, 14);		
		printNewLine();

	} else {
		printNewLine();
		print(keypress, 10);
		printChar((char) KeyBuffer);
		print(ignored, 9);
		printNewLine();
	}

	return;
}
