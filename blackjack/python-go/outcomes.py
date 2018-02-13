from ctypes import *
import os

class GoSlice(Structure):
    _fields_ = [("data", POINTER(c_void_p)), 
                ("len", c_longlong), ("cap", c_longlong)]

lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
#lib.partitions.argtypes = [POINTER(c_int), c_int]
#lib.partitions.restype = c_int

deck = ([4]*9)
deck.append(16)

d = 0

for i in range(0, 10):

    # Dealer showing

    deck[i] = deck[i]-1

    p = 0
    for j in range(0, 10):
        deck[j] = deck[j]-1

        cards = GoSlice((c_void_p * 10)(*deck),10,10)
        
        n = lib.partitions(cards, c_int(j+1))
        deck[j] = deck[j]+1
        p += n

    print('Dealer showing ', i,' partitions =',p)
    d += p

    deck[i] = deck[i]+1

print('Total partitions =',d)
