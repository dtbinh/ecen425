#include <stdio.h>

int main(){
  
	int i;
	printf("Enter any # ");
	scanf("%d", i);  /* The '&' was "accidentally" left out before the i */

	printf("Entered # is %d\n", i);	
	
  return 0;
}


