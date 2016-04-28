# 1 "DelayQueue.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "DelayQueue.c"
# 1 "DelayQueue.h" 1



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
# 5 "DelayQueue.h" 2

void initializeDelayQueue(void);

void tickClock(void);

void insertDelayQueue(TCB* tcb);

void printDelayQueue(void);
# 2 "DelayQueue.c" 2
# 1 "PriorityQueue.h" 1





void initializePriorityQueue(PriorityQueue* queue);

void insertPriorityQueue(PriorityQueue* queue, TCB* tcb);

TCB* peekPriorityQueue(PriorityQueue* queue);

TCB* removePriorityQueue(PriorityQueue* queue);

void printPriorityQueue(PriorityQueue* queue);
# 3 "DelayQueue.c" 2

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
# 5 "DelayQueue.c" 2

extern DelayQueue delayQueue;
extern PriorityQueue readyQueue;

void initializeDelayQueue() {
 delayQueue.size = 0;
 delayQueue.head = 0;
}

void tickClock() {

 TCB* current;
    TCB* temp;


 YKEnterMutex();
 if (delayQueue.size == 0) {
  YKExitMutex();
  return;
 }

 current = delayQueue.head;
 if (delayQueue.size == 1) {
  current->delayCount--;
  if (current->delayCount == 0) {
   delayQueue.head = 0;
   delayQueue.size = 0;
   current->next = 0;
   current->prev = 0;
   current->state = T_READY;
   YKExitMutex();
   insertPriorityQueue(&readyQueue, current);

   return;
  }
  YKExitMutex();
  return;
 }

 current->delayCount--;
 while (current != 0) {
  current = delayQueue.head;
  if (current->delayCount == 0) {
   delayQueue.head = current->next;
   if (current->next != 0) {
    current->next->prev = 0;
   }
   current->next = 0;
   current->prev = 0;
   current->state = T_READY;
   temp = current;
   delayQueue.size--;
   insertPriorityQueue(&readyQueue, temp);
   current = delayQueue.head;
  } else {
   YKExitMutex();
   return;
  }
 }

}

void insertDelayQueue(TCB* tcb) {

 TCB* current;
 unsigned int sumCount;
 unsigned int oldSumCount;

 if (tcb == 0) return;


 YKEnterMutex();
     if (delayQueue.size == 0) {
         delayQueue.head = tcb;
         tcb->next = 0;
         tcb->prev = 0;
         delayQueue.size++;
  YKExitMutex();
         return;
     }


     current = delayQueue.head;
     sumCount = 0;
  oldSumCount = 0;
     while (current != 0) {
         sumCount += current->delayCount;
  if (tcb->delayCount < sumCount) {
   tcb->next = current;
   tcb->prev = current->prev;
       if (current == delayQueue.head) {
                    delayQueue.head = tcb;
             } else {
    current->prev->next = tcb;
   }
             current->prev = tcb;
             delayQueue.size++;
   tcb->delayCount = tcb->delayCount - oldSumCount;
             current->delayCount = current->delayCount - tcb->delayCount;
   YKExitMutex();
             return;
         }
         if (current->next == 0) {
             current->next = tcb;
             tcb->prev = current;
             tcb->next = 0;
             delayQueue.size++;
             tcb->delayCount = tcb->delayCount - sumCount;
   YKExitMutex();
             return;
         }
         current = current->next;
   oldSumCount = sumCount;
     }

}

void printDelayQueue(void) {

 TCB* current;
 int i;

 current = delayQueue.head;
 printString("Printing Delay Queue with size ");
 printInt(delayQueue.size);
 printNewLine();

 while (current != 0) {
  printInt(current->priority);
  printString(" ");
  printInt(current->delayCount);
  printNewLine();
  current = current->next;
 }

}
