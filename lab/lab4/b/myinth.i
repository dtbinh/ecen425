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

extern int KeyBuffer;

int counter = 0;

void reset_handler(){
 exit(0);
}

void tick_handler(){
 counter++;
 printNewLine();
 printNewLine();
 printString("TICK ");
 printInt(counter);
 printNewLine();
 printNewLine();
}

void keyboard_handler(){
 int i;
 char kb = KeyBuffer;

 if(kb == 'd'){
  printNewLine();
  printNewLine();
  printString("DELAY KEY PRESSED");
  printNewLine();
  printNewLine();


  for(i = 0; i < 5000; i++){

  }

  printNewLine();
  printNewLine();
  printString("DELAY COMPLETE");
  printNewLine();
  printNewLine();

 }
 else{
  printNewLine();
  printNewLine();
  printString("KEYPRESS ");
  printChar('(');
  printChar(kb);
  printChar(')');
  printString(" IGNORED");
  printNewLine();
  printNewLine();
 }

}
