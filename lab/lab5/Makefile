lab5.bin:	lab5.s
			nasm lab5.s -o lab5.bin -l lab5.lst

lab5.s:		clib.s myinth.s yakc.s PriorityQueue.s DelayQueue.s Semaphore.s lab5app.s
			cat clib.s myisr.s myinth.s yaks.s yakc.s PriorityQueue.s DelayQueue.s Semaphore.s lab5app.s > lab5.s

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

lab5app.s:	lab5app.c
			cpp lab5app.c lab5app.i
			c86 -g lab5app.i lab5app.s

yakc.s:		yakc.c
			cpp yakc.c yakc.i
			c86 -g yakc.i yakc.s

clean:		
			rm lab5.bin lab5.lst lab5.s myinth.s myinth.i DelayQueue.s DelayQueue.i yakc.s yakc.i PriorityQueue.i PriorityQueue.s Semaphore.i Semaphore.s lab5app.i lab5app.s
