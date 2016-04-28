# 1 "PriorityQueue.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "PriorityQueue.c"
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
# 2 "PriorityQueue.c" 2
# 1 "PriorityQueue.h" 1





void initializePriorityQueue(PriorityQueue* queue);

void insertPriorityQueue(PriorityQueue* queue, TCB* tcb);

TCB* peekPriorityQueue(PriorityQueue* queue);

TCB* removePriorityQueue(PriorityQueue* queue);

void printPriorityQueue(PriorityQueue* queue);
# 3 "PriorityQueue.c" 2
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
# 4 "PriorityQueue.c" 2

void initializePriorityQueue(PriorityQueue* queue) {
 queue->size = 0;
 queue->head = 0;
 queue->tail = 0;
}

void insertPriorityQueue(PriorityQueue* queue, TCB* tcb) {

 TCB* temp;

 if(tcb == 0) return;


 YKEnterMutex();
 if (queue->size == 0) {
  queue->head = tcb;
  queue->tail = tcb;
  tcb->next = 0;
  tcb->prev = 0;
  queue->size = 1;
  YKExitMutex();
  return;
 }


 if (queue->size == 1) {
  if (queue->head->priority < tcb->priority) {
   queue->head->next = tcb;
   tcb->prev = queue->head;
   tcb->next = 0;
   queue->tail = tcb;
   queue->size++;
   YKExitMutex();
   return;
  } else {
   tcb->next = queue->head;
   tcb->prev = 0;
   queue->tail->prev = tcb;
   queue->head = tcb;
   queue->size++;
   YKExitMutex();
   return;
  }
 }


 temp = queue->head;
 while (temp != 0) {
  if (temp->priority > tcb->priority) {
   tcb->next = temp;
   tcb->prev = temp->prev;
   if (temp == queue->head) {
    queue->head = tcb;
   } else {
    temp->prev->next = tcb;
   }
   temp->prev = tcb;
   queue->size++;
   YKExitMutex();
   return;
  }
  temp = temp->next;
 }


 queue->tail->next = tcb;
 tcb->prev = queue->tail;
 queue->tail = tcb;
 tcb->next = 0;
 queue->size++;
 YKExitMutex();
 return;

}

TCB* peekPriorityQueue(PriorityQueue* queue) {

 return queue->head;

}

TCB* removePriorityQueue(PriorityQueue* queue) {

 TCB* retValue;


 YKEnterMutex();
 if (queue->size == 0) {
  YKExitMutex();
  return 0;
 }


 if (queue->size == 1) {
  retValue = queue->head;
  retValue->next = 0;
  retValue->prev = 0;
  queue->size--;
  queue->head = 0;
  queue->tail = 0;
  YKExitMutex();
  return retValue;
 }


 retValue = queue->head;
 queue->head = queue->head->next;
 queue->head->prev = 0;
 queue->size--;
 retValue->next = 0;
 retValue->prev = 0;
 YKExitMutex();
 return retValue;

}

void printPriorityQueue(PriorityQueue* queue) {
 TCB* current;

 while (current != 0) {
  printInt(current->priority);
  printNewLine();
  current = current->next;
 }
}
