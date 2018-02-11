from ctypes import *
import os

test_lib = cdll.LoadLibrary(os.path.abspath("libpartitions.so"))
test_lib.partitions.argtypes = [POINTER(c_long), c_long]
test_lib.partitions.restype = c_long

deck = ([4]*9)
deck.append(16)

d = 0

for i in range(0, 10):

    # Dealer showing

    deck[i] = deck[i]-1

    p = 0
    for j in range(0, 10):
        deck[j] = deck[j]-1

        nums_arr = (c_long*len(deck))(*deck)
            
        n = test_lib.partitions(nums_arr, c_long(j+1))
        #print('Starting with ', j, n)
        deck[j] = deck[j]+1
        p += n

    print('Dealer showing ', i,' partitions =',p)
    d += p

    deck[i] = deck[i]+1

print('Total partitions =',d)
