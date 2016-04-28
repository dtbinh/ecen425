#include <stdio.h>

int main(){

int myvar = 10;
int myarray[5] = {0, 1, 2, 3, 4};


printf("original myvar is %d\n", myvar);

int i;
for(i=0;i < 6; i++){
  myarray[i] = myarray[i]*2;
  printf("%p\n", &myarray[i]);
}
printf("modified myvar is %p\n", &myvar);
printf("modified myvar is %d\n", myvar);
return 0;

}

