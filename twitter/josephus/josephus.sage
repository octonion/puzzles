
"""
Random Josephus problem.

Initially n people are arranged in a circle and labelled 1..n
in order. When person j goes, they uniformly at random kill
one of the other n-1 survivors, then play passes to the next
survivor in the circular order. Note the first person to is
in person 1, then person 2 (if still alive) goes. Play
continues until we're left with a single survivor.

p[i,j] is the probability that starting with i people,
the person j is the final survivor.

The recursive relation is:

p[i,j] = (j-2)/(i-1)*p[i-1,j-2] + (i-j)/(i-1)*p[i-1,j-1]

For person j to be the final survivor after person 1 goes,
either someone before them in the order was killed (positions
2..(j-1)), which occurs with probability (j-2)/(i-1), or someone
after them in the order was killed (positions (j+1)..i), which
occurs with probability (i-j)/(i-1).

If someone among positions 2..(j-1) was killed, the next person
to go puts the person originally in position j effectively
in position j-2.

If someone among positions (j+1)..i was killed, the next person
to go puts the person originally in position j effectively in
position j-1.
"""

n = 50

p = matrix(QQ, matrix.zero(n))
p[1,1] = 1

for i in range(2,n):
    p[i,1] = p[i-1,i-1]
    for j in range(2,i+1):
        p[i,j] = (j-2)/(i-1)*p[i-1,j-2] + (i-j)/(i-1)*p[i-1,j-1]

# print out all p[i,j] values.

print()

for i in range(1,n):
    for j in range(1,i+1):
        print(i,j,p[i,j].n())

# print out (i,j) pairs with maximum survival probability.

print()

for i in range(1,n):
    m = 1
    mv = p[i,1]
    for j in range(1,i+1):
        if p[i,j] > mv:
            mv = p[i,j]
            m = j
    print(i,m,mv.n())
