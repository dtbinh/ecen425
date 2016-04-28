#ifndef YAKK_H
#define YAKK_H

#define null 0
#define MAX_TASKS 3

//Kernel Data Structures
enum TaskState {T_BLOCKED, T_READY, T_RUNNING};
enum KernelState {K_BLOCKED, K_RUNNING};

typedef struct TCB {
	unsigned int tid;
	unsigned char priority;
	void* stackPointer;	
	enum TaskState state;	
	unsigned int delayCount;
	struct TCB* next;
	struct TCB* prev;
} TCB;

typedef struct TaskBlock {
	TCB TCBPool[MAX_TASKS+1];
	unsigned int nextFreeTCB;	
} TaskBlock;


void YKInitialize(void);
void YKEnterMutex(void);
void YKExitMutex(void);
void YKIdleTask(void);
void YKNewTask(void (*task)(void), void *taskStack, unsigned char priority);
void YKRun(void);
void YKScheduler(void);
void YKDispatcher(void);

TCB* getNewTCB(void);
unsigned int getYKCtxSwCount();

#endif
