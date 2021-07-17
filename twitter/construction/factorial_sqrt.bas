#include once "gmp.bi"
#include once "string.bi"

#include once "MAP.bi"
#include once "QUEUE.bi"

dim as mpz_ptr n = allocate(sizeof(__mpz_struct))

dim bound as long
dim m as long
dim i as long
dim j as long
dim nn as long
dim v as long
dim w as long

mpz_init_set_si(n, 0)

bound = 20000

MQueueTemplate(long)
dim as TQUEUELONG queue

queue.push(3)

MMapTemplate(long, long)
dim found as TMAPLONGLONG
dim paths as TMAPLONGLONG
dim sqrts as TMAPLONGLONG

j = 1
found.insert(3,j)

' paths = {3 : 3}
' sqrts = {3 : 0}

while (queue.size() > 0)
    m = queue.pop()
    mpz_fac_ui(n,m)
    i = 0
    
    while (mpz_cmp_ui(n,bound)>0)
        mpz_sqrt(n,n)
        i += 1
    wend
    nn = mpz_get_ui(n)
    while (nn>3)
        if (found.find(nn) = 0) then
            j += 1
            found.insert(nn,j)
            queue.push(nn)
            paths.insert(nn,m)
            sqrts.insert(nn,i)
        end if
        mpz_sqrt(n,n)
        nn = mpz_get_ui(n)
        ' print *mpz_get_str(0, 10, n)
        'nn = floor(sqrt(nn))
        i += 1
    wend
wend
        
for i = 3 to 1000
    if (found.find(i)=0) then
        print format(i, "# ");
    end if
next
print
print

v = 9
while not(v=3)
    w = paths.find(v)
    print format(v,"# <-- ");
    print format(w, "#! + ");
    print format(sqrts.find(v),"# sqrt")
    v = w
wend
