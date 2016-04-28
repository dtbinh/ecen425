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
# 3 "myinth.c" 2

static char tick[5] = "TICK ";
static char keypress[10] = "KEYPRESS (";
static char ignored[9] = ") IGNORED";
static char delay[17] = "DELAY KEY PRESSED";
static char complete[14] = "DELAY COMPLETE";
extern int KeyBuffer;
extern unsigned int YKTickCounter;

void resetHandler() {

 exit(0);

}

void tickHandler() {

 YKEnterMutex();
 YKTickCounter++;
 YKExitMutex();
 printString("\nTick ");
 YKEnterMutex();
 printInt(YKTickCounter);
 YKExitMutex();
 printNewLine();
 YKTickHandler();
 return;

}

void keyboardHandler() {

 int i;

 if (KeyBuffer == 'd') {
  printNewLine();
  print(delay, 17);
  printNewLine();

  for (i = 0; i < 5000; i++);

  printNewLine();
  print(complete, 14);
  printNewLine();

 } else {
  printNewLine();
  print(keypress, 10);
  printChar((char) KeyBuffer);
  print(ignored, 9);
  printNewLine();
 }

 return;
}
