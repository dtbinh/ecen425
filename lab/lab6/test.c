//#include "../include/yakk.h"
//#include "../include/yaku.h"
#include <stdio.h>

#define null 0
#define MAX_TASKS 10

typedef struct TCB TCB;

struct TCB {
	unsigned int tid;
	unsigned char priority;
	void* stackPointer;	
	unsigned int state;	
	unsigned int delayCount;
	TCB* next;
	TCB* prev;
};

typedef struct TaskBlock TaskBlock;

struct TaskBlock {
	TCB tasks[MAX_TASKS+1];
	unsigned int nextFreeTCB;	
};

typedef struct DelayQueue DelayQueue;

struct DelayQueue {
	TCB* head;
	unsigned int size;
};

typedef struct ReadyQueue ReadyQueue;

struct ReadyQueue {
	TCB* head;
	TCB* tail;
	unsigned int size;
};

static TaskBlock taskBlock;
static DelayQueue delayQueue;
static ReadyQueue readyQueue;

TCB* getNewTCB(void) {

	TCB* task;
	if (taskBlock.nextFreeTCB < MAX_TASKS + 1) {
                printf("nextFreeBlock = %d\n", taskBlock.nextFreeTCB);
                task = &taskBlock.tasks[taskBlock.nextFreeTCB];
		taskBlock.nextFreeTCB++;
		return task;
	} else {
		printf("TCBFullError\n");		
		return null;
	}

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

void initializeReadyQueue() {
	readyQueue.size = 0;
}

void insertReadyQueue(TCB* tcb) {

	if(tcb == null) return;

	//list is empty
	if (readyQueue.size == 0) {
		readyQueue.head = tcb;
		readyQueue.tail = tcb;
		tcb->next = null;
		tcb->prev = null;
		readyQueue.size = 1;
		return;
	}

	//size of the list = 1
	if (readyQueue.head == readyQueue.tail) {		
		if (readyQueue.head->priority < tcb->priority) {
			readyQueue.head->next = tcb;
			tcb->prev = readyQueue.head;
			tcb->next = null;
			readyQueue.tail = tcb;
			readyQueue.size++;
			return;
		} else {
			tcb->next = readyQueue.head;
			tcb->prev = null;
			readyQueue.tail->prev = tcb;
		}
	}

	//size of the readyQueue > 1
	TCB* temp = readyQueue.head;
	while (temp != null) {
		if (temp->priority > tcb->priority) {
			tcb->next = temp;
			tcb->prev = temp->prev;
			temp->prev = tcb;
			if (temp == readyQueue.head) readyQueue.head = tcb;
			readyQueue.size++;
			return;
		}
		temp = temp->next;
	}	

	//tcb has lowest priority
	readyQueue.tail->next = tcb;
	tcb->prev = readyQueue.tail;
	readyQueue.tail = tcb;
	tcb->next = null;
	readyQueue.size++;
	return;

}

TCB* removeReadyQueue() {

	TCB* retValue;
        
	//size of the list = 1
	if (readyQueue.head == readyQueue.tail) {
		retValue = readyQueue.head;
		readyQueue.size--;
		readyQueue.head = null;
		readyQueue.tail = null;
		return retValue;
	}

	//size of the list > 1
	retValue = readyQueue.head;
	readyQueue.head = readyQueue.head->next;
	readyQueue.size--;
	return retValue;	

}

int main(int argc, char** argv) {
     
    TCB* tasks[5];
    
    int i;    
    for (i = 0; i < 10; i += 2 ) {
        TCB* tcb1 = getNewTCB();        
        tasks[i / 2] = getNewTCB();        
        tcb1->tid = i / 2;        
        tasks[i / 2]->delayCount = i / 2;        
        tasks[i / 2]->tid = i / 2;        
        tcb1->priority = i / 2;        
        insertReadyQueue(tcb1);       
        insertDelayQueue(tasks[i / 2]);	
    }
                
    for (i = 0; i < 10; i += 2) {    
        TCB* tcb1 = removeReadyQueue();
        printf("Task %d was removed with priority %d\n", tcb1->tid, tcb1->priority);        
        printf("Task %d was removed with delta delay %d\n", tasks[i / 2]->tid, tasks[i / 2]->delayCount);        
    }
	
	return 0;

}
