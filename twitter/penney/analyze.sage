
import itertools

def seq_p(seq):
    p = 1
    for s in seq:
        p *= symbol_p[s]
    return(p)

def winning_p(seq):
    n = len(seq)
    A = zero_matrix(SR,n)

    for i in range(0,n):
        for j in range(0,n):
            l = min(len(seq[i]),len(seq[j]))
            for k in range(1,l+1):
                if (seq[i][0:k]==seq[j][-k:]):
                    A[i,j] += 1/seq_p(seq[i][0:k])

    D = zero_vector(SR, n)
    for i in range(0,n):
        B = copy(A)
        B[:,i] = ones_matrix(n,1)
        D[i] = det(B)

    s = sum(D)

    P = zero_vector(SR, n)
    for i in range(0,n):
        P[i] = D[i]/s

    #x = P.sub({p:1/2, q:1/2})
    return(P)

var('p q')
symbol_p = {}
symbol_p['H'] = p
symbol_p['T'] = q

n = 3

#seq = ['THH','HTH','HHT']

seq = [''.join(x) for x in itertools.product('HT', repeat=n)]

for i in range(0,len(seq)):
    for j in range(i+1,len(seq)):
        max_p = 0
        best = 0
        for k in range(0,len(seq)):
            if (k==i) or (k==j):
                continue
            P = winning_p([seq[i],seq[j],seq[k]]).subs({p:1/2, q:1/2})[2]
            #print(P)
            if (P>max_p):
                max_p = P
                best = k
            #print(seq[i],seq[j],P)
        print(seq[i],seq[j],seq[best],max_p.n())

#print(P)

#print(P.subs({p:1/2, q:1/2}))
