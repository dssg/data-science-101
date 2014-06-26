#!/bin/python

# mp_queues_demo.py
# A simple script demonstrating pool.Queue and start() of python's multiprocessing
# library for embarassingly parallel machine learning and data science tasks.
#
# @author: Jeff Lockhart, <jlockhart@fordham.edu>
# @date: 06/26/2014

import multiprocessing as mp
from Queue import Empty
import time #used for sleep

# Sets an arbitrary time for the process to wait
t = 2

# Sets an arbitrary number of additions to spin the processor
iterations = 10000

# The number of processes to spin up. Depending on the code, they may not all be used.
max_processes = 16

# queues for threads to take jobs from and store outputs to.
# much like python's vanilla Queue.Queue, except process and thread safe.
# the result queue is optional: you could very well dump files (pictures, csv's, etc.)
# instead of sending information back to the parent as a memory object.
work_q = mp.Queue()
result_q = mp.Queue()

def slow_power(x):
    '''
    Spins the processor for a while, then returns x^2
    Intended to run in a child process
    '''
    time.sleep(t)
    return x*x

def worker(in_q, out_q):
    '''
    An arbitrary worker that will spin a processor for a while, take a value from the input queue,
    Then make the square of it a tuple and add it to the output queue
    '''
    # a dictionary mapping inputs to outputs for just this process
    out_dict = {}
    
    # oh the horror!
    while True:
        try:
            # get the next element in the work queue
            x = in_q.get_nowait()
            # compute its power, store the result to this process' result dict
            out_dict[x] = slow_power(x)

        except Empty:
            # when there are no more jobs, send our whole result buffer to the shared result queue
            # because of the async processes, we don't know if the queue is empty until we "get" from it
            out_q.put(out_dict)
            # this is our loop termination condition: critical not to forget!!
            return

def run_q_sharing_proc():
    '''
    starts a set of processes that share input/output queues. 
    '''
    # a list of processes we've started
    p_list = []
    master_result_dict = {}

    # queue up some work to be done, before the processes start
    for i in range(64):
        work_q.put(i)

    # spin up some threads to do the work
    for j in range(max_processes):
        # create a new process
        # the queues must be passed as arguments, since each process has its own scope
        p = mp.Process(target=worker, args=(work_q, result_q))
        #remember the process ID for later
        p_list.append(p)
        #launch the process and let it run
        p.start()

    # get n results from n processes, waiting for the results if necessary
    # this should be called before join
    for i in range(max_processes):
        master_result_dict.update(result_q.get())

    # join (shut down) all child processes with the parent
    for p in p_list:
        p.join()

    for k,v in master_result_dict.items():
        print k, v

    return

# safety precaution to prevent processes from spawning recursively 
# technically not necessary with careful calling and scoping
# valuable anyway: I'm not perfect
if __name__ == "__main__":
    print "Starting q_sharing demo..."
    run_q_sharing_proc()
    print "q_sharing demo finished."


print "Done. Exiting.\n"
    


