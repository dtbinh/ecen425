#ifndef DELAY_QUEUE_H
#define DELAY_QUEUE_H

#include "yakk.h"

typedef struct DelayQueue {
	TCB* head;
	unsigned int size;
} DelayQueue;

void initializeDelayQueue();

void tickClock();

void insertDelayQueue(TCB* tcb);

void removeDelayQueue();

#endif
