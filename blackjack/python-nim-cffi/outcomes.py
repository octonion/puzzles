from cffi import FFI

ffi = FFI()

lib = ffi.dlopen('./libpartitions.so')

ffi.cdef('''
  long long int partitions(long long int cards[10], long long int subtotal);
''')

deck = ([4]*9)
deck.append(16)

d = 0

for i in range(0, 10):

    # Dealer showing

    deck[i] = deck[i]-1

    p = 0
    for j in range(0, 10):
        deck[j] = deck[j]-1

        n = lib.partitions(deck, j+1)
        
        deck[j] = deck[j]+1
        p += n

    print('Dealer showing ', i,' partitions =',p)
    d += p

    deck[i] = deck[i]+1

print('Total partitions =',d)
