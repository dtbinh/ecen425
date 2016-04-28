# 1 "ReadyQueue.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "ReadyQueue.c"
# 1 "yakk.h" 1



# 1 "yaku.h" 1
# 5 "yakk.h" 2






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
 TCB TCBPool[4 +1];
 unsigned int nextFreeTCB;
} TaskBlock;


void YKInitialize(void);

void YKEnterMutex(void);

void YKExitMutex(void);

void YKIdleTask(void);

void YKNewTask(void (* task) (void), void *taskStack, unsigned char priority);

void YKDelayTask(unsigned count);

void YKEnterISR(void);

void YKExitISR(void);

void YKScheduler(void);

void YKDispatcher(TCB* readyTask);

void YKTickHandler(void);
# 70 "yakk.h"
TCB* getNewTCB(void);

void YKRun(void);
# 2 "ReadyQueue.c" 2
# 1 "ReadyQueue.h" 1





typedef struct ReadyQueue {
 TCB* head;
 TCB* tail;
 unsigned int size;
} ReadyQueue;

void initializeReadyQueue();

void insertReadyQueue(TCB* tcb);

TCB* peekReadyQueue();

TCB* removeReadyQueue();
# 3 "ReadyQueue.c" 2
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
# 4 "ReadyQueue.c" 2

extern ReadyQueue readyQueue;

void initializeReadyQueue() {
 readyQueue.size = 0;
 readyQueue.head = 0;
 readyQueue.tail = 0;
}

void insertReadyQueue(TCB* tcb) {

 TCB* temp;

 if(tcb == 0) return;


 if (readyQueue.size == 0) {
  readyQueue.head = tcb;
  readyQueue.tail = tcb;
  tcb->next = 0;
  tcb->prev = 0;
  readyQueue.size = 1;



  return;
 }


 if (readyQueue.size == 1) {
  if (readyQueue.head->priority < tcb->priority) {
   readyQueue.head->next = tcb;
   tcb->prev = readyQueue.head;
   tcb->next = 0;
   readyQueue.tail = tcb;
   readyQueue.size++;
   return;
  } else {
   tcb->next = readyQueue.head;
   tcb->prev = 0;
   readyQueue.tail->prev = tcb;
   readyQueue.head = tcb;
   readyQueue.size++;



   return;
  }
 }



 temp = readyQueue.head;
 while (temp != 0) {
  if (temp->priority > tcb->priority) {
   tcb->next = temp;
   tcb->prev = temp->prev;
   temp->prev = tcb;
   if (temp == readyQueue.head) readyQueue.head = tcb;
   readyQueue.size++;
   return;
  }
  temp = temp->next;
 }


 readyQueue.tail->next = tcb;
 tcb->prev = readyQueue.tail;
 readyQueue.tail = tcb;
 tcb->next = 0;
 readyQueue.size++;
 return;

}

TCB* peekReadyQueue() {

 if (readyQueue.size == 0) {
  return 0;
 } else {
  return readyQueue.head;
 }

}

TCB* removeReadyQueue() {

 TCB* retValue;


 if (readyQueue.size == 0) {
  return 0;
 }


 if (readyQueue.size == 1) {


  retValue = readyQueue.head;
  readyQueue.size--;
  readyQueue.head = 0;
  readyQueue.tail = 0;
  return retValue;
 }




 retValue = readyQueue.head;
 readyQueue.head = readyQueue.head->next;
 readyQueue.size--;
 retValue->next = 0;
 retValue->prev = 0;
 return retValue;

}
