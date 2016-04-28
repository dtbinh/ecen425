#include "yakk.h"
#include "ReadyQueue.h"
#include "clib.h"

extern ReadyQueue readyQueue;

void initializeReadyQueue() {
	readyQueue.size = 0;
	readyQueue.head = null;
	readyQueue.tail = null;
}

void insertReadyQueue(TCB* tcb) {

	TCB* temp;

	if(tcb == null) return;

	//list is empty
	if (readyQueue.size == 0) {
		readyQueue.head = tcb;
		readyQueue.tail = tcb;
		tcb->next = null;
		tcb->prev = null;
		readyQueue.size = 1;
		//printString("readyQueue size is ");
		//printInt(readyQueue.size);
		//printNewLine();
		return;
	}

	//size of the list = 1
	if (readyQueue.size == 1) {		
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
			readyQueue.head = tcb;
			readyQueue.size++;
			//printString("readyQueue size is ");
			//printInt(readyQueue.size);
			//printNewLine();
			return;
		}
	}

	//size of the readyQueue > 1
	 
	temp = readyQueue.head;
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

TCB* peekReadyQueue() {

	if (readyQueue.size == 0) {
		return null;
	} else {
		return readyQueue.head;
	}
		
}

TCB* removeReadyQueue() {

	TCB* retValue;

	//Size of the list = 0
	if (readyQueue.size == 0) {
		return null;
	}
        
	//size of the list = 1
	if (readyQueue.size == 1) {
		//printInt(0);
		//printNewLine();
		retValue = readyQueue.head;
		readyQueue.size--;
		readyQueue.head = null;
		readyQueue.tail = null;
		return retValue;
	}

	//size of the list > 1
	//printString("Removing from readyQueue\n");
	//printNewLine();
	retValue = readyQueue.head;
	readyQueue.head = readyQueue.head->next;
	readyQueue.size--;
	retValue->next = null;
	retValue->prev = null;
	return retValue;	

}
