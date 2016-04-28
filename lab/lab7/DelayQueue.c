#include "DelayQueue.h"
#include "PriorityQueue.h"
#include "yakk.h"
#include "clib.h"

extern DelayQueue delayQueue;
extern PriorityQueue readyQueue;

void initializeDelayQueue() {
	delayQueue.size = 0;
	delayQueue.head = null;
}

void tickClock() {

	TCB* current;
   	TCB* temp;
	
	//Size == 0
	YKEnterMutex();
	if (delayQueue.size == 0) {
		YKExitMutex();		
		return;
	}
	
	current = delayQueue.head;
	if (delayQueue.size == 1) {
		current->delayCount--;
		if (current->delayCount == 0) {
			delayQueue.head = null;
			delayQueue.size = 0;
			current->next = null;
			current->prev = null;
			current->state = T_READY;
			YKExitMutex();
			insertPriorityQueue(&readyQueue, current);
			//printString("\nAfter insert\n");
			return;
		}
		YKExitMutex();
		return; 
	}

	current->delayCount--;
	while (current != null) {
		current = delayQueue.head;
		if (current->delayCount == 0) {
			delayQueue.head = current->next;
			if (current->next != null) {
				current->next->prev = null;
			}
			current->next = null;
			current->prev = null;
			current->state = T_READY;
			temp = current;
			delayQueue.size--;
			insertPriorityQueue(&readyQueue, temp);
			current = delayQueue.head;
		} else {
			YKExitMutex();
			return;
		}
	}

}

void insertDelayQueue(TCB* tcb) {
    
	TCB* current;
	unsigned int sumCount;
	unsigned int oldSumCount;    
  
	if (tcb == null) return;
    
	//Size = 0
	YKEnterMutex();
     if (delayQueue.size == 0) {
         delayQueue.head = tcb;
         tcb->next = null;
         tcb->prev = null;
         delayQueue.size++;
		YKExitMutex();
         return;
     }
    
     //Size > 0
     current = delayQueue.head;
     sumCount = 0;
	 oldSumCount = 0;
     while (current != null) {
         sumCount += current->delayCount;
		if (tcb->delayCount < sumCount) {
			tcb->next = current;
			tcb->prev = current->prev;
     		if (current == delayQueue.head) {
                    delayQueue.head = tcb;
            	} else {
				current->prev->next = tcb;
			}
            	current->prev = tcb;
            	delayQueue.size++;
			tcb->delayCount = tcb->delayCount - oldSumCount;
            	current->delayCount = current->delayCount - tcb->delayCount;
			YKExitMutex();
            	return;
        	}
        	if (current->next == null) {
        	    current->next = tcb;
        	    tcb->prev = current;
        	    tcb->next = null;
        	    delayQueue.size++;
        	    tcb->delayCount = tcb->delayCount - sumCount;
			YKExitMutex();
        	    return;
        	}
        	current = current->next;
			oldSumCount = sumCount;
    	}
 
}

void printDelayQueue(void) {

	TCB* current;
	int i;

	current = delayQueue.head;
	printString("Printing Delay Queue with size ");
	printInt(delayQueue.size);
	printNewLine();
	
	while (current != null) {
		printInt(current->priority);
		printString(" ");
		printInt(current->delayCount);
		printNewLine();
		current = current->next;
	}

}

