using CSV
using DataFrames
using Distances
using Combinatorics

using Random

const best_lock = ReentrantLock()

function dat(solution)

    score = 0.0
    for c in combinations(solution,2)
        score += 100*cosine_dist(words[c[1]],words[c[2]])
    end
    return score/binomial(length(solution),2)
    
end

df = CSV.read("glove.840B.300d.txt", DataFrame; delim=" ", quotechar=' ', header=false)

#common_df = CSV.read("common.csv", DataFrame; delim=",", header=false)
#common = common_df[:,1]

#kaggle_df = CSV.read("kaggle.csv", DataFrame; delim=",", header=false)
#kaggle = kaggle_df[:,1]

valid_df = CSV.read("words-common.txt", DataFrame; delim=",", header=false)
valid = valid_df[:,1]

#hunspell_df = CSV.read("hunspell.csv", DataFrame; delim=",", header=false)
#hunspell = hunspell_df[:,1]

s = size(df)
println(s)

rows = s[1]
columns = s[2]

k = String(df[1,1])
v = Vector(df[1,2:end])
words = Dict(k => v)

ks = df[:,1]
vs = Matrix(df[:,2:end])

min_length = 2

clean = filter(word -> all(isletter, word), ks)
clean = filter(word -> all(isascii, word), ks)
clean = filter(word -> length(word)>=min_length, clean)

#common = filter(word -> all(isletter, word), common)
#common = filter(word -> all(isascii, word), common)
#common = filter(word -> length(word)>=min_length, common)

#kaggle = filter(word -> all(isletter, word), kaggle)
#kaggle = filter(word -> all(isascii, word), kaggle)
#kaggle = filter(word -> length(word)>=min_length, kaggle)

valid = filter(word -> all(isletter, word), valid)
valid = filter(word -> all(isascii, word), valid)
valid = filter(word -> length(word)>=min_length, valid)

#hunspell = filter(word -> all(isletter, word), hunspell)
#hunspell = filter(word -> all(isascii, word), hunspell)
#hunspell = filter(word -> length(word)>=min_length, hunspell)

#common = intersect(common, clean)
#kaggle = intersect(kaggle, clean)
valid = intersect(valid, clean)
#hunspell = intersect(hunspell, clean)

for i = 2:rows
    words[ks[i]] = vs[i,:]
end

#test = ["chairman", "version", "thatcher", "chest", "species", "traffic", "exhibition"]

#println(test)
#println(dat(test))

n_words = length(valid)
println(n_words)

#shuffle!(valid)

best = 108.0

factor = 1.0

Threads.@threads for i1 = 1:n_words

    if mod(i1,100)==0
        println(Threads.threadid(),": ", valid[i1])
    end

    for i2 = i1+1:n_words

        b1 = dat([valid[i1],valid[i2]])

        if b1 < 130.0
            continue
        end

        if b1 < best + factor*5
            continue
        end

        #println(Threads.threadid(),": ",b1, " ", valid[i1], " ", valid[i2])
        
        for i3 = 1:n_words

            b2 = dat([valid[i1],valid[i2],valid[i3]])

            if b2 < 115.0
                continue
            end

            if b2 < best + factor*4
                continue
            end

#            check1 = dat([valid[i1],valid[i3]])
#            if check1 > b1
#                continue
#            end

            for i4 = 1:n_words

                b3 = dat([valid[i1],valid[i2],valid[i3],valid[i4]])
                if b3 < best + factor*3
                    continue
                end

#                check1 = dat([valid[i1],valid[i4]])
#                if check1 > b1
#                    continue
#                end

#                check2 = dat([valid[i1],valid[i2],valid[i4]])
#                if check2 > b2
#                    continue
#                end

                for i5 = 1:n_words

                    b4 = dat([valid[i1],valid[i2],valid[i3],valid[i4],valid[i5]])
                    if b4 < best + factor*2
                        continue
                    end

#                    check1 = dat([valid[i1],valid[i5]])
#                    if check1 > b1
#                        continue
#                    end
                    
#                    check2 = dat([valid[i1],valid[i2],valid[i5]])
#                    if check2 > b2
#                        continue
#                    end

#                    check3 = dat([valid[i1],valid[i2],valid[i3],valid[i5]])
#                    if check3 > b3
#                        continue
#                    end

                    for i6 = 1:n_words

                        b5 = dat([valid[i1],valid[i2],valid[i3],valid[i4],valid[i5],valid[i6]])
                        if b5 < best + factor*1
                            continue
                        end

#                        check1 = dat([valid[i1],valid[i6]])
#                        if check1 > b1
#                            continue
#                        end
                    
#                        check2 = dat([valid[i1],valid[i2],valid[i6]])
#                        if check2 > b2
#                            continue
#                        end

#                        check3 = dat([valid[i1],valid[i2],valid[i3],valid[i6]])
#                        if check3 > b3
#                            continue
#                        end

#                        check4 = dat([valid[i1],valid[i2],valid[i3],valid[i4],valid[i6]])
#                        if check4 > b4
#                            continue
#                        end
                        
                        for i7 = 1:n_words

                            solution = [valid[i1],valid[i2],valid[i3],valid[i4],valid[i5],valid[i6],valid[i7]]
                            d = dat(solution)
            
                            if d>=best
                                println(Threads.threadid(),": ",d," ",solution)
                                lock(best_lock)
                                try
                                    global best = d
                                finally
                                    unlock(best_lock)
                                end
                            end
                        end
            
                    end
        
                end
            end
        end
    end
end
