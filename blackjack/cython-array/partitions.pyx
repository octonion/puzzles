#cython: language_level=3, boundscheck=False, wraparound=False

cpdef int partitions(int[:] cards, int subtotal):
    cdef:
        unsigned int i
        int m, total

    m = 0
    # Hit
    for i in range(0, 10):
        if (cards[i]>0):

            cards[i] = cards[i]-1
            total = subtotal+i+1

            if (total < 21):

                # Stand
                m += 1
                #print(cards, total)
                # Hit again
                m += partitions(cards, total)

            elif (total==21):

                # Stand; hit again is an automatic bust
                m += 1
                #print(cards, total)

            cards[i] = cards[i]+1

    return(m)
