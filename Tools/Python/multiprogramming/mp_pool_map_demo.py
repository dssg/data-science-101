#!/bin/python

# mp_pool_map_demo.py
# A simple script demonstrating Pool and map() of python's multiprocessing
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

def slow_power(x):
    '''
    Spins the processor for a while, then returns x^2
    Intended to run in a child process
    '''
    time.sleep(t)
    return x*x

def run_map_pool():
    '''
    Maps subsets of the input data to a pool of worker processes, all executing the same function
    Probably the least useful for machine learning, where we want to control and vary the functions and data
    '''
    data = []
    for i in range(64):
        data.append(i)
    
    # make the process pool
    # from the doc: "If processes is None then the number returned by os.cpu_count() is used."
    pool = mp.Pool(processes=max_processes)
    # tell the pool to divide the data among the workers and call slow_powerin each
    # the default chunk size for data is 1; this is simple to code but not always the most efficent
    # note that the result of map() can come back as an assignment
    result = pool.map(slow_power, data)

    for r in result:
        print r

    return

# safety precaution to prevent processes from spawning recursively 
# technically not necessary with careful calling and scoping
# valuable anyway: I'm not perfect
if __name__ == "__main__":
    print "Starting map_pool demo..."
    run_map_pool()
    print "map_pool demo finished."

print "Done. Exiting.\n"
