#!/usr/bin/env python

from ctypes import *
import os

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
lib._T010partitionsAASiSpySiG5cards_Si8subtotaltF.argtypes = [POINTER(c_long),c_int]
lib._T010partitionsAASiSpySiG5cards_Si8subtotaltF.restype = c_int

deck = ([4]*9)
deck.append(16)
d = 0

for i in xrange(10):
    # Dealer showing
    deck[i] -= 1
    p = 0
    for j in xrange(10):
        deck[j] -= 1
        cards = (c_long*10)(*deck)
        p += lib._T010partitionsAASiSpySiG5cards_Si8subtotaltF(cards,c_int(j+1))
        deck[j] += 1
    print('Dealer showing ', i,' partitions =',p)
    d += p
    deck[i] += 1

print('Total partitions =',d)
