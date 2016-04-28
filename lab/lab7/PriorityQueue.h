#ifndef PRIORITY_QUEUE_H
#define PRIORITY_QUEUE_H

#include "yakk.h"

void initializePriorityQueue(PriorityQueue* queue);

void insertPriorityQueue(PriorityQueue* queue, TCB* tcb);

TCB* peekPriorityQueue(PriorityQueue* queue);

TCB* removePriorityQueue(PriorityQueue* queue);

void printPriorityQueue(PriorityQueue* queue);

#endif
