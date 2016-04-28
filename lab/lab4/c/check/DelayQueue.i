# 1 "DelayQueue.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "DelayQueue.c"
# 1 "DelayQueue.h" 1



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
# 5 "DelayQueue.h" 2

typedef struct DelayQueue {
 TCB* head;
 unsigned int size;
} DelayQueue;

void initializeDelayQueue();

void tickClock();

void insertDelayQueue(TCB* tcb);

void removeDelayQueue();
# 2 "DelayQueue.c" 2
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
# 3 "DelayQueue.c" 2


extern ReadyQueue readyQueue;
extern DelayQueue delayQueue;

void initializeDelayQueue() {
 delayQueue.size = 0;
 delayQueue.head = 0;
}

void tickClock() {

 TCB* current;
     TCB* temp;


 if (delayQueue.size == 0) return;


 current = delayQueue.head;
 while (current != 0) {
      current->delayCount--;
         temp = current;
  current = current->next;
         if (temp->delayCount == 0) {

   if (temp->next != 0) {
    temp->next->prev = 0;
   }
   delayQueue.head = temp->next;
   temp->next = 0;
   temp->prev = 0;
   delayQueue.size--;
   insertReadyQueue(temp);
  }
 }

}

void insertDelayQueue(TCB* tcb) {

    TCB* current;
    unsigned int sumCount;

    if (tcb == 0) return;


    if (delayQueue.size == 0) {
        delayQueue.head = tcb;
        tcb->next = 0;
        tcb->prev = 0;
        delayQueue.size++;
        return;
    }


    current = delayQueue.head;
    sumCount = 0;
    while (current != 0) {
        sumCount += current->delayCount;
        if (tcb->delayCount < sumCount) {
            tcb->prev = current->prev;
            tcb->next = current;
            if (current == delayQueue.head) {
                delayQueue.head = tcb;
                current->prev->next = tcb;
            }
            current->prev = tcb;
            delayQueue.size++;
            tcb->delayCount = tcb->delayCount - sumCount;
            return;
        }
        if (current->next == 0) {
            current->next = tcb;
            tcb->prev = current;
            tcb->next = 0;
            delayQueue.size++;
            tcb->delayCount = tcb->delayCount - sumCount;
            return;
        }
        current = current->next;
    }

}
