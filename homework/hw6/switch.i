# 1 "switch.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "switch.c"
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
# 2 "switch.c" 2



int main(){

 int x = 5;
 int y = 7;

 int i = 1;
 switch(i){

  case 77: x = x+y; break;
  case 321: x = x-y; break;
  case 583: x = x*y; break;
  case 850: x = x/y; break;
  case 1: x = x%y; break;
  case 5: x = x^y; break;
  case 62: printInt(x); break;
  case 425: printInt(y); break;
  default: printInt(x+y); break;


 }


 return 0;
}
