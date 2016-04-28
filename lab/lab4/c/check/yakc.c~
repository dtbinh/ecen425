#include "../include/clib.h"
#include "../include/yakk.h"
#include "../include/yaku.h"
#include "../include/ReadyQueue.h"
#include "../include/DelayQueue.h"

//User Accessible Variables
unsigned int YKCtxSwCount = 0;
unsigned int YKIdleCount = 0;
unsigned int YKTickCounter = 0;

//Kernel Accessible Variables
static unsigned int ISRCallDepth = 0;
TCB* currentTask;
ReadyQueue readyQueue;
DelayQueue delayQueue;
static TaskBlock taskBlock;
static int idleTaskStack[IDLETASKSTACKSIZE];
static enum KernelState kernelState = K_BLOCKED;

//Error Codes
#define NEW_TASK_FAILED 1
#define READY_QUEUE_EMPTY 2

void YKEnterMutex(void) {

	//disable interrupts
	asm("cli");

}

void YKExitMutex(void) {

	//Conditionally enable interrupts
	asm("sti");

}

void YKEnterISR(void) {

	ISRCallDepth++;

}

void YKExitISR(void) {

	ISRCallDepth--;
	if (ISRCallDepth == 0) YKScheduler();

}

void YKInitialize(void) {

	YKEnterMutex();

	//Set up queues
	initializeReadyQueue();
	initializeDelayQueue();

	//Set up Task Block
	taskBlock.nextFreeTCB == 0;
	//
		
	//Set up Idle Task
	YKNewTask(YKIdleTask, &idleTaskStack[IDLETASKSTACKSIZE], 100);
	//

	YKExitMutex();
	return;

}

void YKIdleTask(void) {

	printString("IdleTask ran\n");

	while (1) {
		YKEnterMutex();
		YKIdleCount++;
		YKExitMutex();
	}

}

void YKScheduler(void) {

	TCB* readyTask; 
	//printString("We are in scheduler\n");
	YKEnterMutex();
	if (kernelState == K_BLOCKED) return;
	readyTask = peekReadyQueue();
	if (readyTask == null) exit(READY_QUEUE_EMPTY);
	if (readyTask != currentTask) {
		currentTask->state = T_READY;
		currentTask = readyTask;
		YKCtxSwCount++;
		readyTask->state = T_RUNNING;
		YKDispatcher(readyTask);
		YKExitMutex();
		return;
	}
	YKExitMutex();
	return;
}

void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority) {

	TCB* newTask;
	//printInt(priority);
	//printNewLine();	
	
	//Obtain a TCB
	//printString("Obtain a TCB\n");
	newTask = getNewTCB();
	if (newTask == null) exit(NEW_TASK_FAILED);

	//Fill TCB
	//printString("Fill TCB\n");
	newTask->tid = 0;
	newTask->priority = priority;
	newTask->stackPointer = ((void*)((int*) taskStack - 12));
	newTask->state = T_READY;
	newTask->delayCount = 0;
	newTask->next = null;
	newTask->prev = null;

	//Set up Stack
	//printString("Set up Stack\n");
	asm("push bx");
	asm("push cx");
	asm("mov bx, [bp+6]"); //Get address of stack
	asm("mov cx, [bp+4]"); //Get address of function pointer
	asm("mov [bx-2], word 0x0200"); //Move flag register onto the stack
	asm("mov [bx-4], word 0x0");	
	asm("mov [bx-6], cx");
	asm("pop cx");
	asm("pop bx");

	//Insert into ready queue
	//printString("Insert into ready queue\n");
	insertReadyQueue(newTask);
	//printString("Call scheduler\n");
	asm("int 0x20");
	return; 

}

TCB* getNewTCB(void) {
	
	TCB* task;
	if (taskBlock.nextFreeTCB < MAX_TASKS + 1) {
          task = &taskBlock.TCBPool[taskBlock.nextFreeTCB];
		taskBlock.nextFreeTCB++;
		return task;
	} else {
		return null;
	}

}

void YKRun(void) {

	YKEnterMutex();
	kernelState = K_RUNNING;
	YKScheduler();
	YKExitMutex();
	return;

}

void YKDelayTask(unsigned int count) {

	TCB* delayedTask;

	if (count == 0) return;

	currentTask->state = T_BLOCKED;
	currentTask->delayCount = count;
	delayedTask = removeReadyQueue();
	insertDelayQueue(delayedTask);
	asm("int 0x20");
	return;

}

void YKTickHandler(void) {

	tickClock();

}


