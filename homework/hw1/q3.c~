#include <stdio.h>


int main(){

	int t1 = 0x1234abcd;
	int t2;
	
	t2 = ((t1<<8)&(0xff00ff00)) | (((~(t1>>8))&(0x00ff0000))|((t1>>8)&(0x000000ff)));
	
	printf("t1 = %x\n", t1);	
	printf("t2 = %x\n", t2);

	return 0;
}



