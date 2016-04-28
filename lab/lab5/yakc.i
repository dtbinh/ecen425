# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "yakc.c"
# 1 "clib.h" 1






void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 2 "yakc.c" 2
# 1 "yakk.h" 1



# 1 "yaku.h" 1
# 5 "yakk.h" 2
# 16 "yakk.h"
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
 TCB TCBPool[10 +1];
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
 YKSEM SemPool[10];
 unsigned int nextFreeSem;
} SemBlock;


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






TCB* getNewTCB(void);
YKSEM* getNewSem(void);
void YKRun(void);
unsigned int getYKCtxSwCount();
unsigned int getYKIdelCount();
void setYKIdelCount(int value);
void setYKCtxSwCount(int value);
# 3 "yakc.c" 2

# 1 "PriorityQueue.h" 1





void initializePriorityQueue(PriorityQueue* queue);

void insertPriorityQueue(PriorityQueue* queue, TCB* tcb);

TCB* peekPriorityQueue(PriorityQueue* queue);

TCB* removePriorityQueue(PriorityQueue* queue);

void printPriorityQueue(PriorityQueue* queue);
# 5 "yakc.c" 2
# 1 "DelayQueue.h" 1





void initializeDelayQueue(void);

void tickClock(void);

void insertDelayQueue(TCB* tcb);

void printDelayQueue(void);
# 6 "yakc.c" 2


unsigned int YKCtxSwCount = 0;
unsigned int YKIdleCount = 0;
unsigned int YKTickCounter = 0;


static unsigned int ISRCallDepth = 0;
TCB* currentTask = 0;
PriorityQueue readyQueue;
DelayQueue delayQueue;
TaskBlock taskBlock;
static SemBlock semBlock;
static int idleTaskStack[512];
static enum KernelState kernelState = K_BLOCKED;

unsigned int getYKCtxSwCount() {
    return YKCtxSwCount;
}

unsigned int getYKIdleCount() {
    return YKIdleCount;
}

void setYKIdleCount(int value) {
    YKIdleCount = value;
}

void setYKCtxSwCount(int value) {
    YKCtxSwCount = value;
}


void YKEnterISR(void) {
 YKEnterMutex();
 ISRCallDepth++;
 YKExitMutex();
}

void YKExitISR(void) {
 YKEnterMutex();
 ISRCallDepth--;
 if (ISRCallDepth == 0) {
  YKExitMutex();
  YKScheduler();
 }
}

unsigned int YKGetISRCallDepth(void) {

 return ISRCallDepth;
}

void YKInitialize(void) {

 YKEnterMutex();


 initializePriorityQueue(&readyQueue);
 initializeDelayQueue();


 taskBlock.nextFreeTCB == 0;



 YKNewTask(YKIdleTask, &idleTaskStack[512], 100);


 YKExitMutex();
 return;

}

void YKScheduler(void) {

 TCB* readyTask;
 YKEnterMutex();
 if (kernelState == K_BLOCKED) return;
 readyTask = peekPriorityQueue(&readyQueue);
 if (readyTask == 0) exit(2);
 if (readyTask != currentTask) {
  currentTask = readyTask;
  currentTask->state = T_READY;
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


 newTask = getNewTCB();
 if (newTask == 0) exit(1);


 newTask->tid = 0;
 newTask->priority = priority;
 newTask->stackPointer = ((void*)((int*) taskStack - 12));
 newTask->state = T_READY;
 newTask->delayCount = 0;
 newTask->next = 0;
 newTask->prev = 0;


 asm("push bx");
 asm("push cx");
 asm("mov bx, [bp+6]");
 asm("mov cx, [bp+4]");
 asm("mov [bx-2], word 0x0200");
 asm("mov [bx-4], word 0x0");
 asm("mov [bx-6], cx");
 asm("pop cx");
 asm("pop bx");

 insertPriorityQueue(&readyQueue, newTask);
 asm("int 0x20");
 return;

}

TCB* getNewTCB(void) {

 TCB* task;
 if (taskBlock.nextFreeTCB < 10 + 1) {
          task = &taskBlock.TCBPool[taskBlock.nextFreeTCB];
  taskBlock.nextFreeTCB++;
  return task;
 } else {
  return 0;
 }

}

YKSEM* getNewSem(void) {

 YKSEM* semaphore;
 if (semBlock.nextFreeSem < 10) {
          semaphore = &semBlock.SemPool[semBlock.nextFreeSem];
  semBlock.nextFreeSem++;
  return semaphore;
 } else {
  return 0;
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

 delayedTask = removePriorityQueue(&readyQueue);
 delayedTask->state = T_BLOCKED;
 delayedTask->delayCount = count;
 insertDelayQueue(delayedTask);
 asm("int 0x20");
 return;

}

void YKTickHandler(void) {

 tickClock();

}
