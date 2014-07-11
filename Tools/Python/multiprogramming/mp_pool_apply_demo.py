#!/bin/python

# mp_pool_apply_demo.py
# A simple script demonstrating Pool, callback, and apply_async() of python's multiprocessing
# library for embarassingly parallel machine learning and data science tasks.
#
# @author: Jeff Lockhart, <jlockhart@fordham.edu>
# @date: 06/26/2014

import multiprocessing as mp
import time #used for sleep

# Sets an arbitrary time for the process to wait
t = 2

# The number of processes to spin up. Depending on the code, they may not all be used.
max_processes = 16

# a list of outputs from the processes
result_set = []

def slow_power(x):
    '''
    Spins the processor for a while, then returns x^2
    Intended to run in a child process
    '''
    time.sleep(t)
    return x*x

def gather_results(r):
    '''
    this is a callback function: when the functions in our processes return
    this function is called with their return value as an argument
    here we just add the results to a list, which is less efficent than using
    a shared return mp.Queue object, but offers more flexability if you
    want to do more than store the results for later (not shown here).
    '''
    result_set.append(r)

    return

def run_apply_pool():
    '''
    assigns a set of tasks (function calls with arguments) and farms them out to processes
    probably the simplest and most useful way to parallelize ML using this library
    '''
    pool = mp.Pool(processes=max_processes)

    for i in range(64):
        pool.apply_async(slow_power, args=(i, ), callback=gather_results)

    # no 4chan jokes please... 
    # we run these functions because they make us wait for all the tasks to finish
    # and they tidy up after the processes when theyre done
    pool.close()
    pool.join()

    # if we didn't close and join above, we couldn't be sure these results were ready yet
    for r in result_set:
        print r

    return

# safety precaution to prevent processes from spawning recursively 
# technically not necessary with careful calling and scoping
# valuable anyway: I'm not perfect
if __name__ == "__main__":
    print "Starting apply_pool demo..."
    run_apply_pool()
    print "apply_pool demo finished."

print "Done. Exiting.\n"
