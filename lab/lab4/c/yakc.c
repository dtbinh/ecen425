#include "ReadyQueue.h"
#include "DelayQueue.h"
#include "yakk.h"
#include "clib.h"


ReadyQueue readyQueue;
DelayQueue delayQueue;
static TaskBlock taskBlock;
static int idleStack[3];
static enum KernelState kernelState;
static int TASK_ID = 0;
static TCB* currentTask;
int YKCtxSwCount = 0;
int YKIdleCount = 0;
int YKTickNum = 0;

unsigned int getYKCtxSwCount() {
    return YKCtxSwCount;
}

void YKInitialize(void){
	YKEnterMutex();
	
	//init our data structures
	initializeReadyQueue();
	initializeDelayQueue();
	taskBlock.nextFreeTCB = 0;
	//starts idle task
	YKNewTask(YKIdleTask, &idleStack[3], 100);
	
	YKExitMutex();
}

void YKEnterMutex(void){
	asm("cli");
}

void YKExitMutex(void){
	asm("sti");
}

void YKIdleTask(void){
	int dummy;

	while(1){
		dummy++;
		dummy--;
		YKIdleCount++;
	}
}

void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority){
	TCB* newTCB;
	
	newTCB = getNewTCB();
	if(newTCB == null) {
		exit(-1);  //-1 exit code means more tasks were created than allowed
	}
	
	//init the TCB
	TASK_ID++;
	newTCB->tid = TASK_ID;
	newTCB->priority = priority;
	newTCB->stackPointer = ((void*)((int*) taskStack - 12));
	newTCB->state = T_READY;
	newTCB->delayCount = 0;
	newTCB->next = null;
	newTCB->prev = null;
	
	//creating the stack
	asm("push bx");
	asm("push cx");
	asm("mov bx, [bp+6]"); //Get value that is the address of stack
	asm("mov cx, [bp+4]"); //Get value that is the address of function pointer
	asm("mov [bx-2], word 0x0200"); //Move flag register onto the stack
	asm("mov [bx-4], word 0x0");
	asm("mov [bx-6], cx");
	asm("pop cx");
	asm("pop bx");
	
	//insert into the ReadyQueue	
	insertReadyQueue(newTCB);
	YKScheduler();
	return;
}

void YKRun(void){
	YKEnterMutex();
	kernelState = K_RUNNING;
	YKScheduler();
	YKExitMutex();
}

void YKScheduler(void){
	TCB* newTask;


	YKEnterMutex();
	
	if(kernelState == K_BLOCKED) {
		return;
	}
	newTask = peekReadyQueue();
	if(newTask == null) {
		exit(-2);  //exit code -2 means there are no ready tasks in the queue
	}
	if(newTask != currentTask) {
		currentTask->state = T_READY;
		currentTask = newTask;
		currentTask->state = T_RUNNING;
		YKCtxSwCount++;
		YKDispatcher();
	}
	YKExitMutex();
	return;
}

//void YKDispatcher(void){
//	asm("cli");
//	asm("push bp");
//	asm("mov bp, sp");
//	asm("mov bx, [bp+4]");	//Obtain stack pointer from TCB
//	asm("mov sp, [bx+4]");	//Load stack pointer into SP
////	asm("pop bp"); 
////	asm("pop es");
////	asm("pop ds");
////	asm("pop si");
////	asm("pop di");
////	asm("pop dx");
////	asm("pop cx");
////	asm("pop bx");
////	asm("pop ax");
//	asm("sti");
//	asm("iret");
//}

TCB* getNewTCB(void) {
	TCB* task;
	if (taskBlock.nextFreeTCB < MAX_TASKS + 1) {			// taskBlock only can't contain tasks more than MAX_TASKS
          task = &taskBlock.TCBPool[taskBlock.nextFreeTCB];
		taskBlock.nextFreeTCB++;
		return task;
	} else {
		return null;
	}
}

void YKDelayTask(unsigned count){

	
	currentTask->delayCount = count;
	currentTask->state = T_BLOCKED;
	
	insertDelayQueue(currentTask);	
	
	YKScheduler();
	
}
void EnterISR(void){
	
}
void ExitISR(void){
	
}
void YKTickHandler(void){
	tickClock();

}


