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
        if (temp->delayCount == 0) {
            removeDelayQueue(temp);
        }
        current = current->next;
	}

}

void insertDelayQueue(TCB* tcb) {
    TCB* current;
    unsigned int sumCount;
      
    //check if tcb is null
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

void removeDelayQueue(TCB* tcb) {
    TCB* current;
    TCB* temp;
    
    //check if tcb is null
    if (tcb == null) return;
    
    current = delayQueue.head;
    while (current != null) {
        if (current->priority = tcb->priority) {
            if (current == delayQueue.head) {
                temp = current;
                current = current->next;
                delayQueue.head = temp->next;
                temp->next->prev = null;
                delayQueue.size--;
                temp->next = null;
                temp->prev = null;
                insertReadyQueue(temp);
            } else if (current->next == null) {
                temp = current;
                current = current->next;
                temp->prev->next = null;
                delayQueue.size--;
                insertReadyQueue(temp);
            } else {
                temp = current;
                current = current->next;
                temp->prev->next = temp->next;
                temp->next->prev = temp->prev;
                temp->next = null;
                temp->prev = null;
                delayQueue.size--;
                insertReadyQueue(temp);
            }
        } 
    }
}

