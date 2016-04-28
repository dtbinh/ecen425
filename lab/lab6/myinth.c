#include "clib.h"
#include "yakk.h"
#include "lab6defs.h"
#include "DelayQueue.h"

extern unsigned int YKTickCounter;
extern int GlobalFlag;
extern struct msg MsgArray[];
extern YKQ* MsgQPtr;

void resetHandler() {
	exit(0);
}

void tickHandler() {

	static int next = 0;
	static int data = 0;

	tickClock();
	YKEnterMutex();
	YKTickCounter++;
	YKExitMutex();

	MsgArray[next].tick = YKTickCounter;
	data = (data + 89) % 100;
	MsgArray[next].data = data;
	if (YKQPost(MsgQPtr, (void*) &(MsgArray[next])) == 0)
		printString("  TickISR: queue overflow! \n");
	else if (++next >= MSGARRAYSIZE)
		next = 0;

}

void keyboardHandler() {

	YKEnterMutex();
	GlobalFlag = 1;
	YKExitMutex();
}
