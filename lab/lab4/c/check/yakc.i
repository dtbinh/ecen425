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
# 3 "yakc.c" 2

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
# 5 "yakc.c" 2
# 1 "DelayQueue.h" 1





typedef struct DelayQueue {
 TCB* head;
 unsigned int size;
} DelayQueue;

void initializeDelayQueue();

void tickClock();

void insertDelayQueue(TCB* tcb);

void removeDelayQueue();
# 6 "yakc.c" 2


unsigned int YKCtxSwCount = 0;
unsigned int YKIdleCount = 0;
unsigned int YKTickCounter = 0;


static unsigned int ISRCallDepth = 0;
TCB* currentTask;
ReadyQueue readyQueue;
DelayQueue delayQueue;
static TaskBlock taskBlock;
static int idleTaskStack[10];
static enum KernelState kernelState = K_BLOCKED;





void YKEnterMutex(void) {


 asm("cli");

}

void YKExitMutex(void) {


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


 initializeReadyQueue();
 initializeDelayQueue();


 taskBlock.nextFreeTCB == 0;



 YKNewTask(YKIdleTask, &idleTaskStack[10], 100);


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

 YKEnterMutex();
 if (kernelState == K_BLOCKED) return;
 readyTask = peekReadyQueue();
 if (readyTask == 0) exit(2);
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



 insertReadyQueue(newTask);

 asm("int 0x20");
 return;

}

TCB* getNewTCB(void) {

 TCB* task;
 if (taskBlock.nextFreeTCB < 4 + 1) {
          task = &taskBlock.TCBPool[taskBlock.nextFreeTCB];
  taskBlock.nextFreeTCB++;
  return task;
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
