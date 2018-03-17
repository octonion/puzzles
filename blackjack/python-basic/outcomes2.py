#!/usr/bin/env python

from ctypes import *
import os

#typedef struct _FBARRAYDIM {
#        size_t elements;
#        ssize_t lbound;
#        ssize_t ubound;
#} FBARRAYDIM;

#typedef struct _FBARRAY {
#        void           *data;        /* ptr + diff, must be at ofs 0! */
#        void           *ptr;
#        size_t          size;
#        size_t          element_len;
#        size_t          dimensions;
#        FBARRAYDIM      dimTB[1];    /* dimtb[dimensions] */
#} FBARRAY;

class FBArray(Structure):
    _fields_ = [("data", POINTER(c_size_t)),
                ("ptr", POINTER(c_size_t)),
                ("size", c_size_t),
                ("element_len", c_size_t),
                ("dimensions", c_size_t),
                ("elements", c_size_t),
                ("lbound", c_ssize_t),
                ("ubound", c_ssize_t)]

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
lib.partitions.argtypes = [POINTER(FBArray), c_size_t]
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
        pdeck = (c_size_t*len(deck))(*deck)
        cards = FBArray(pdeck,pdeck,80,8,1,10,0,9)
        p += lib.partitions(cards, c_size_t(j+1))
        deck[j] += 1
    print('Dealer showing ', i,' partitions =',p)
    d += p
    deck[i] += 1

print('Total partitions =',d)
