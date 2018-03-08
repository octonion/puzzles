#!/usr/bin/env python

from ctypes import *
import os

# Nim int is 64-bit

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
lib.partitions.argtypes = [POINTER(c_long), c_long]
lib.partitions.restype = c_long

deck = ([4]*9)
deck.append(16)

d = 0

for i in xrange(10):

    # Dealer showing
    deck[i] -= 1
    p = 0
    for j in xrange(10):
        deck[j] -= 1
        nums_arr = (c_long*len(deck))(*deck)
        n = lib.partitions(nums_arr, c_long(j+1))
        deck[j] += 1
        p += n
    print('Dealer showing ', i,' partitions =',p)
    d += p
    deck[i] += 1

print('Total partitions =',d)
