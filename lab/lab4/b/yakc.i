# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "yakc.c"
# 1 "ReadyQueue.h" 1



# 1 "yakk.h" 1







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
 TCB TCBPool[3 +1];
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
# 5 "ReadyQueue.h" 2

typedef struct ReadyQueue {
 TCB* head;
 TCB* tail;
 unsigned int size;
} ReadyQueue;

void initializeReadyQueue();
void insertReadyQueue(TCB* tcb);
TCB* peekReadyQueue();
TCB* removeReadyQueue();
# 2 "yakc.c" 2
# 1 "DelayQueue.h" 1





typedef struct DelayQueue {
 TCB* head;
 unsigned int size;
} DelayQueue;

void initializeDelayQueue();
void tickClock();
void insertDelayQueue(TCB* tcb);
void removeDelayQueue();
# 3 "yakc.c" 2



ReadyQueue readyQueue;
DelayQueue delayQueue;
static TaskBlock taskBlock;
static int idleStack[3];
static enum KernelState kernelState;
static int TASK_ID = 0;
static TCB* currentTask;
static int YKCtxSwCount = 0;
static int YKIdleCount = 0;

unsigned int getYKCtxSwCount() {
    return YKCtxSwCount;
}

void YKInitialize(void){
 YKEnterMutex();


 initializeReadyQueue();
 initializeDelayQueue();
 taskBlock.nextFreeTCB = 0;

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
 if(newTCB == 0) {
  exit(-1);
 }


 TASK_ID++;
 newTCB->tid = TASK_ID;
 newTCB->priority = priority;
 newTCB->stackPointer = ((void*)((int*) taskStack - 12));
 newTCB->state = T_READY;
 newTCB->delayCount = 0;
 newTCB->next = 0;
 newTCB->prev = 0;


 asm("push bx");
 asm("push cx");
 asm("mov bx, [bp+6]");
 asm("mov cx, [bp+4]");
 asm("mov [bx-2], word 0x0200");
 asm("mov [bx-4], word 0x0");
 asm("mov [bx-6], cx");
 asm("pop cx");
 asm("pop bx");


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
 if(newTask == 0) {
  exit(-2);
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
# 134 "yakc.c"
TCB* getNewTCB(void) {
 TCB* task;
 if (taskBlock.nextFreeTCB < 3 + 1) {
          task = &taskBlock.TCBPool[taskBlock.nextFreeTCB];
  taskBlock.nextFreeTCB++;
  return task;
 } else {
  return 0;
 }
}
