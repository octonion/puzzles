#!/usr/bin/env python

from ctypes import *
import os

class RSArray(Structure):
    _fields_ = [("values", c_ulonglong*10)]

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
lib.partitions.argtypes = [POINTER(RSArray), c_ulonglong]
lib.partitions.restype = c_int

deck = ([4]*9)
deck.append(16)

d = 0

for i in xrange(10):
    # Dealer showing
    deck[i] -= 1
    p = 0
    for j in xrange(10):
        deck[j] -= 1
        cards = RSArray((c_ulonglong*len(deck))(*deck))
        p += lib.partitions(cards, c_ulonglong(j+1))
        deck[j] += 1
    print('Dealer showing ', i,' partitions =',p)
    d += p
    deck[i] += 1

print('Total partitions =',d)
