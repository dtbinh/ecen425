#include "clib.h"



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
