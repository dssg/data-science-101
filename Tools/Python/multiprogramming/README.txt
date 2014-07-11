This directory has some demo files for different python multiprocessing functions. 
They can serve as useful templates and inspiration for your own code. Below, I've 
listed some good-to-know bits of info. It is written both for people who are new 
to multiprocessing and parallelism and for people who have experience with it in 
other languages, but need to learn the python library. 


Terms:
	-Parent: a process that creates (forks) other processes
	-Child: a process that was created (forked) by a parent
	-Process: a program executing on a computer. Processes are essentially 
	completely seerate from one another in scheduling, memory, and code. Many 
	processes may be running the same program (think two people logged into the
	same server using vi at the same time: each has their own vi process).
	-Thread: an independent execution stack within a process. Threads share memory
	with each other, which presents both opportunities and risks. In python, 
	threads are usually a bad choice for cpu-heavy parallel tasks, due to the
	way most operating systems schedule tasks to run on the physical hardware. No 
	threads are used in this code base.

max_processors:
	-This value is best set around 1.5x, where x is the number of cores on your 
	computer. You want slightly more processes than cores, to be sure all cpu 
	cycles are used, but not so many processes that they're constantly thrashing 
	or fighting for time. Longer tasks will do better with lower values like 1.2,
	while shorter tasks will do better with higher values like 1.8. The exact 
	value of this number ends up not being very critical. 
	-What is most important is that you don't allow the number of processes doing 
	cpu-heavy work to become dramatically larger than the number of physical 
	cores/processers available. This ends poorly on most operating systems, for a
	number of reasons. <http://en.wikipedia.org/wiki/Fork_bomb>

map vs apply:
	-Pool.map() splits input data into many chunks, then gives each process a chunk 
	to complete in parallel. This is good for tasks where you want to call the 
	same function on many pieces of data independently. (It is similar in use 
	cases to R's apply() function). This tends to be useful less often than the 
	other methods for data science / machine learning. 

	-Pool.apply() ties up your whole pool of processes with just one task. Basically, 
	you should never use this. 

	-Pool.apply_async() sends one job out to your pool, then returns immediately,
	while the main process continues to run. It can be called repeatedly in a loop,
	allowing you to queue up many tasks to execute in parallel. Because it is in a 
	pool, the library will manage the tasks so that only a managable number are 
	executing at any given point in time. apply_async() can take different data and 
	a different function each time, thereby giving you maximum control over what 
	executes and flexability to run different algorithms or specify different data 
	sets. This is often the best choice for data mining parallelization. 

Queues:
	When multiprocessing it is important to use the mp.Queue data type, as it is 
	safe for many threads or processes to access at once without data corruption. 
	Every function call on a queue will slow down your parallel processes by making
	them wait for the queue object to become free. Thus, you should try to call them 
	infrequently in the processes you spawn. They are, however, a good way to get 
	return values if you don't want to write output to files. 

callbacks:
	Callbacks are functions that execute in the parent process each time a child
	returns a result. They recieve the return value of the child as an argument. 
	Because they run in the parent process, they are not parallel. It is best to
	avoid using them if you can. If you must use them, try to write as little 
	code in them as possible so that they finish quickly and other processes don't
	wait as long for them to become free (since only one child can use the callback 
	at a time). 

Pool:
	A pool creates, holds, and manages a set of processes. Its parameters let you
	control how many processes are allowed to execute at once and many other things.
	Pools also abstract away start() and join() commands processes otherwise need.

Embarassingly Parallel:
	There are many kinds of parallelism. Most of them are hard and tricky to implement,
	and still only yeald margional gains in even the best theoretical cases. Most
	regular programming tasks are not worth parallelizing. Embarassingly parallel tasks
	are the execption. These tasks have many components, each of which is completely
	independent of all the others (no need for communication between the processes/tasks).
	Fortunately, data science is full of these situations. Generally, they fall in three
	categories: a) you want to run several algorithms on a data set, b) you want to 
	run one algorithm many times with a variety of parameters on a data set, and c) 
	you want to run an algorithm on a number of different data sets or data subsets 
	(e.g. leave-one-out cross-validation). 










