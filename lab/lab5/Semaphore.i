# 1 "Semaphore.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "Semaphore.c"
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
# 2 "Semaphore.c" 2
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
# 3 "Semaphore.c" 2
# 1 "PriorityQueue.h" 1





void initializePriorityQueue(PriorityQueue* queue);

void insertPriorityQueue(PriorityQueue* queue, TCB* tcb);

TCB* peekPriorityQueue(PriorityQueue* queue);

TCB* removePriorityQueue(PriorityQueue* queue);

void printPriorityQueue(PriorityQueue* queue);
# 4 "Semaphore.c" 2

extern PriorityQueue readyQueue;

YKSEM* YKSemCreate(int initialValue) {
 YKSEM* newSemaphore;

 newSemaphore = getNewSem();
 if (newSemaphore == 0) exit(3);

 initializePriorityQueue(&(newSemaphore->queue));
 newSemaphore->value = initialValue;

 return newSemaphore;

}

void YKSemPend(YKSEM* semaphore) {

 TCB* runningTask;

 YKEnterMutex();
 if (semaphore->value < 1) {
  semaphore->value--;
  runningTask = removePriorityQueue(&readyQueue);
  runningTask->state = T_BLOCKED;
  insertPriorityQueue((&(semaphore->queue)), runningTask);
  YKExitMutex();
  asm("int 0x20");
  return;

 } else {
  semaphore->value--;
  YKExitMutex();
  return;
 }

}

void YKSemPost(YKSEM* semaphore) {

 TCB* readyTask;

 YKEnterMutex();
 semaphore->value++;
 readyTask = removePriorityQueue(&(semaphore->queue));
 if (readyTask == 0) {
  YKExitMutex();
  return;
 }
 readyTask->state = T_READY;
 insertPriorityQueue(&readyQueue, readyTask);
 YKExitMutex();
 if (YKGetISRCallDepth() == 0) {
  asm("int 0x20");
 }
 return;

}
