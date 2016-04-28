#ifndef YAKK_H
#define YAKK_H

#include "yaku.h"

#define null 0
#define IDLETASKSTACKSIZE 512

//Error Codes
#define NEW_TASK_FAILED 1
#define READY_QUEUE_EMPTY 2
#define NEW_SEM_FAILED 3

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

typedef struct PriorityQueue {
	TCB* head;
	TCB* tail;
	unsigned int size;
} PriorityQueue;

typedef struct DelayQueue {
	TCB* head;
	unsigned int size;
} DelayQueue;

typedef struct Semaphore {
	int value;
	PriorityQueue queue;
} YKSEM;

typedef struct SemBlock {
	YKSEM SemPool[MAX_SEMS];
	unsigned int nextFreeSem;
} SemBlock;

//Kernel API
void YKInitialize(void);
void YKEnterMutex(void);
void YKExitMutex(void);
void YKIdleTask(void);
void YKNewTask(void (* task) (void), void *taskStack, unsigned char priority);
void YKDelayTask(unsigned count);
void YKEnterISR(void);
void YKExitISR(void);
unsigned int YKGetISRCallDepth(void);
void YKScheduler(void);
void YKDispatcher(TCB* readyTask);
void YKTickHandler(void);
YKSEM* YKSemCreate(int initialValue);
void YKSemPend(YKSEM* semaphore);
void YKSemPost(YKSEM* semaphore);
//YKQ* YKQCreate(void** start, unsigned size);
//void YKQPend(YKQ* queue);
//int YKQPost(YKQ* queue, void* msg);
//YKEVENT* YKEventCreate(unsigned initialValue);
//void YKEventSet(YKEVENT* event, unsigned eventMask);
//void YKEVentReset(YKEVENT* event, unsigned eventMask);
TCB* getNewTCB(void);
YKSEM* getNewSem(void);
void YKRun(void);
unsigned int getYKCtxSwCount();
unsigned int getYKIdelCount(); 
void setYKIdelCount(int value);
void setYKCtxSwCount(int value);

#endif
