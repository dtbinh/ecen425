# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "myinth.c"
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
# 2 "myinth.c" 2
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
# 3 "myinth.c" 2
# 1 "DelayQueue.h" 1





void initializeDelayQueue(void);

void tickClock(void);

void insertDelayQueue(TCB* tcb);

void printDelayQueue(void);
# 4 "myinth.c" 2

extern int KeyBuffer;
extern unsigned int YKTickCounter;
extern YKSEM* NSemPtr;

void resetHandler() {
 exit(0);
}

void tickHandler() {

 int localCounter = 0;

 YKEnterMutex();
 localCounter = ++YKTickCounter;
 YKExitMutex();
 printString("\nTick ");
 printInt(localCounter);
 printNewLine();
 tickClock();
 return;

}

void keyboardHandler() {

 int i;

 if (KeyBuffer == 'd') {
  printString("\nDELAY KEY PRESSED\n");
  for (i = 0; i < 5000; i++);
  printString("\nDELAY COMPLETE\n");
 } else if (KeyBuffer == 'p') {
  YKSemPost(NSemPtr);
 } else {
  printString("\nKEYPRESS (");
  printChar((char) KeyBuffer);
  printString(") IGNORED\n");
 }

 return;
}
