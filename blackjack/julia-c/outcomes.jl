deck = Cint[4,4,4,4,4,4,4,4,4,16]
global d = 0

for i = 1:10

    # Dealer showing
    deck[i] -= 1
    p = 0
    for j = 1:10
        deck[j] -= 1
        n = ccall((:partitions, "./libpartitions.so"), Cint,
                  (Ptr{Cint}, Cint), deck, j)
        deck[j] += 1
        p += n
    end
    println("Dealer showing ", i-1," partitions = ",p)
    d += p
    deck[i] += 1
end

println("Total partitions = ",d)
