from ctypes import *
import os

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
lib.partitions_.argtypes = [POINTER(c_int), POINTER(c_int)]
lib.partitions_.restype = c_int

deck = ([4]*9)
deck.append(16)

d = 0

for i in xrange(10):
    # Dealer showing
    deck[i] -= 1
    p = 0
    for j in xrange(10):
        deck[j] -= 1
        cards = (c_int*len(deck))(*deck)
        n = lib.partitions_(cards, byref(c_int(j+1)))
        deck[j] += 1
        p += n
    print('Dealer showing ', i,' partitions =',p)
    d += p
    deck[i] += 1
print('Total partitions =',d)
