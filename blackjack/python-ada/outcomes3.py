#!/usr/bin/env python3

from ctypes import *
import os

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
lib.partitions.argtypes = [POINTER(c_int), c_int]
lib.partitions.restype = c_int

deck = ([4]*9)
deck.append(16)

d = 0

for i in range(0, 10):
    # Dealer showing
    deck[i] -= 1
    p = 0
    for j in range(0, 10):
        deck[j] -= 1
        nums_arr = (c_int*len(deck))(*deck)
        p += lib.partitions(nums_arr, c_int(j+1))
        deck[j] += 1
    print('Dealer showing ', i,' partitions =',p)
    d += p
    deck[i] += 1

print('Total partitions =',d)
