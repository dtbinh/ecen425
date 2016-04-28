lab4.bin:	lab4.s
			nasm lab4.s -o lab4.bin -l lab4.lst

lab4.s:		clib.s myisr.s myinth.s yaks.s yakc.s ReadyQueue.s DelayQueue.s lab4b_app.s
			cat clib.s myisr.s myinth.s yaks.s yakc.s ReadyQueue.s DelayQueue.s lab4b_app.s > lab4.s

myinth.s:		myinth.c
			cpp myinth.c myinth.i
			c86 -g myinth.i myinth.s

ReadyQueue.s:   ReadyQueue.c
				cpp ReadyQueue.c ReadyQueue.i
				c86 -g ReadyQueue.i ReadyQueue.s

DelayQueue.s:   DelayQueue.c
				cpp DelayQueue.c DelayQueue.i
				c86 -g DelayQueue.i DelayQueue.s

lab4b_app.s:	lab4b_app.c
			cpp lab4b_app.c lab4b_app.i
			c86 -g lab4b_app.i lab4b_app.s

yakc.s:		yakc.c
			cpp yakc.c yakc.i
			c86 -g yakc.i yakc.s

clean:
			rm lab4.bin lab4.lst lab4.s myinth.s myinth.i DelayQueue.s DelayQueue.i yakc.s yakc.i ReadyQueue.i ReadyQueue.s lab4b_app.i lab4b_app.s Emu86OutputPipe*
