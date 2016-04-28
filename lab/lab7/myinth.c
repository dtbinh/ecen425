#include "clib.h"
#include "yakk.h"
#include "DelayQueue.h"
#include "lab7defs.h"

extern unsigned int YKTickCounter;
extern char KeyBuffer;
extern YKEVENT* charEvent;
extern YKEVENT* numEvent;

void resetHandler() {
	exit(0);
}

void tickHandler() {

	unsigned int localCounter;

	tickClock();
	YKEnterMutex();
	localCounter = ++YKTickCounter;
	YKExitMutex();

	printString("\nTick: ");
	printInt(localCounter);
	printNewLine();

}

void keyboardHandler() {

	char c;
	YKEnterMutex();
	c = KeyBuffer;
	YKExitMutex();

	switch (c) {

		case 'a' : 	YKEventSet(charEvent, EVENT_A_KEY);
				 	break;
		case 'b' : 	YKEventSet(charEvent, EVENT_B_KEY);
				 	break;
		case 'c' : 	YKEventSet(charEvent, EVENT_C_KEY);
				 	break;
		case 'd' : 	YKEventSet(charEvent, EVENT_A_KEY |
										  EVENT_B_KEY |
										  EVENT_C_KEY);
				 	break;
		case '1' : 	YKEventSet(numEvent, EVENT_1_KEY);
				 	break;
		case '2' : 	YKEventSet(numEvent, EVENT_2_KEY);
				 	break;
		case '3' : 	YKEventSet(numEvent, EVENT_3_KEY);
				 	break;
		default  :	printString("\nKEYPRESS (");
					printChar(c);
					printString(") IGNORED\n");
	}

}
