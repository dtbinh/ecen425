lab6.bin:	lab6.s
			nasm lab6.s -o lab6.bin -l lab6.lst

lab6.s:		clib.s myinth.s yakc.s PriorityQueue.s DelayQueue.s Semaphore.s MessageQueue.s lab6app.s
			cat clib.s myisr.s myinth.s yaks.s yakc.s PriorityQueue.s DelayQueue.s Semaphore.s MessageQueue.s lab6app.s > lab6.s

myinth.s:		myinth.c
			cpp myinth.c myinth.i
			c86 -g myinth.i myinth.s

PriorityQueue.s:   PriorityQueue.c
				cpp PriorityQueue.c PriorityQueue.i
				c86 -g PriorityQueue.i PriorityQueue.s

DelayQueue.s:   DelayQueue.c
				cpp DelayQueue.c DelayQueue.i
				c86 -g DelayQueue.i DelayQueue.s

Semaphore.s:	Semaphore.c
			cpp Semaphore.c Semaphore.i
			c86 -g Semaphore.i Semaphore.s

MessageQueue.s:	MessageQueue.c
			cpp MessageQueue.c MessageQueue.i
			c86 -g MessageQueue.i MessageQueue.s

lab6app.s:	lab6app.c
			cpp lab6app.c lab6app.i
			c86 -g lab6app.i lab6app.s

yakc.s:		yakc.c
			cpp yakc.c yakc.i
			c86 -g yakc.i yakc.s

clean:		
			rm lab6.bin lab6.lst lab6.s myinth.s myinth.i DelayQueue.s DelayQueue.i yakc.s yakc.i PriorityQueue.i PriorityQueue.s Semaphore.i Semaphore.s MessageQueue.i MessageQueue.s lab6app.i lab6app.s
