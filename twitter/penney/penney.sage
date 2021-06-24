
def seq_p(seq):
    p = 1
    for s in seq:
        p *= symbol_p[s]
    return(p)

var('p q')
symbol_p = {}
symbol_p['H'] = p
symbol_p['T'] = q

#seq = ['THH','HTH','HHT']
seq = sys.argv[1].split(',')

n = len(seq)

A = zero_matrix(SR,n)

for i in range(0,n):
    for j in range(0,n):
        l = min(len(seq[i]),len(seq[j]))
        for k in range(1,l+1):
            #print(k,seq[j][0:k],seq[i][-k:])
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

#print(P)
print()
fair_P = P.subs({p:1/2, q:1/2})

for i in range(0,len(seq)):
    print("Pr({}) = {}".format(seq[i],fair_P[i]))
