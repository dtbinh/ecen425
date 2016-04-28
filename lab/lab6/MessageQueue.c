#include "yakk.h"
#include "clib.h"
#include "PriorityQueue.h"

extern PriorityQueue readyQueue;

YKQ* YKQCreate(void** start, unsigned size) {

	YKQ* newMessageQueue;

	newMessageQueue = getNewQueue();
	if (newMessageQueue == null) exit(NEW_QUEUE_FAILED);

	initializePriorityQueue(&(newMessageQueue->queue));
	newMessageQueue->messages = start;
	newMessageQueue->maxSize = size;
	newMessageQueue->currentSize = 0;

	return newMessageQueue;

}

void* YKQPend(YKQ* queue) {

	void* message;
	int i;
	TCB* runningTask;

	if (queue == null) return null;
	
	YKEnterMutex();
	if (*queue->messages == null) {
		runningTask = removePriorityQueue(&readyQueue);
		runningTask->state = T_BLOCKED;
		insertPriorityQueue((&(queue->queue)), runningTask);
		YKExitMutex();
		asm("int 0x20");
	}

	message = queue->messages[0];
	for (i = 0; i < queue->currentSize-1; i++) {
		queue->messages[i] = queue->messages[i+1];
	}
	queue->currentSize--;
	queue->messages[queue->currentSize] = null;

	YKExitMutex();
	return message;
	
}

int YKQPost(YKQ* queue, void* msg) {

	TCB* readyTask;
	int retVal;

	YKEnterMutex();
	if (queue->currentSize < queue->maxSize) {
		queue->messages[queue->currentSize] = msg;
		queue->currentSize++;
		retVal = 1;

	} else {
		retVal = 1;
	}
		
	readyTask = removePriorityQueue(&(queue->queue));
	if (readyTask == null) {
		YKExitMutex();
		return retVal;
	} else {
		readyTask->state = T_READY;
		insertPriorityQueue(&readyQueue, readyTask);
		YKExitMutex();
		if (YKGetISRCallDepth() == 0) {
			asm("int 0x20");
		}
	}
	return retVal;

}




