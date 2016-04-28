#include <stdio.h>

int main(){
	
	int year = 2004;
	int leap = IsLeapYear(year);

	printf("leap ? %d\n", leap);	
	
	return 0;

}

int IsLeapYear(int year){
		
	if(((year%4)==0)&&((year%400)==0)){
		
		return 1;
		
	}
	else{
		if(((year%4)==0)&&((year%100)!=0)){
			return 1;			
		}	
	}
	return 0;
	
}
