#ifndef DELAY_QUEUE_H
#define DELAY_QUEUE_H

#include "yakk.h"

void initializeDelayQueue(void);

void tickClock(void);

void insertDelayQueue(TCB* tcb);

void printDelayQueue(void);

#endif
