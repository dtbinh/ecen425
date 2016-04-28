#include "DelayQueue.h"
#include "ReadyQueue.h"
#include "yakk.h"

extern ReadyQueue readyQueue;
extern DelayQueue delayQueue;

void initializeDelayQueue() {
	delayQueue.size = 0;
	delayQueue.head = null;
}

void tickClock() {

	TCB* current;
    	TCB* temp;
	
	//Size == 0
	if (delayQueue.size == 0) return;
	
	//Size > 0
	current = delayQueue.head;
	while (current != null) {
    		current->delayCount--;
        	temp = current;
		current = current->next;
        	if (temp->delayCount == 0) {
			//Check if not at end
			if (temp->next != null) {
				temp->next->prev = null;
			}
			delayQueue.head = temp->next;
			temp->next = null;
			temp->prev = null;
			delayQueue.size--;
			insertReadyQueue(temp);
		}
	}

}

void insertDelayQueue(TCB* tcb) {
    
    TCB* current;
    unsigned int sumCount;
      
    if (tcb == null) return;
    
    //Size = 0
    if (delayQueue.size == 0) {
        delayQueue.head = tcb;
        tcb->next = null;
        tcb->prev = null;
        delayQueue.size++;
        return;
    }
    
    //Size > 0
    current = delayQueue.head;
    sumCount = 0;
    while (current != null) {
        sumCount += current->delayCount;
        if (tcb->delayCount < sumCount) {
            tcb->prev = current->prev;
            tcb->next = current;
            if (current == delayQueue.head) {
                delayQueue.head = tcb;
                current->prev->next = tcb;
            }
            current->prev = tcb;
            delayQueue.size++;
            tcb->delayCount = tcb->delayCount - sumCount;
            return;
        }
        if (current->next == null) {
            current->next = tcb;
            tcb->prev = current;
            tcb->next = null;
            delayQueue.size++;
            tcb->delayCount = tcb->delayCount - sumCount;
            return;
        }
        current = current->next;
    }
    
}

