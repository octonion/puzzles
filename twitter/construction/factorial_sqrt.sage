from collections import deque

bound = 20000

stack = deque()
found = {3}
stack.append(3)

while (len(stack) > 0):
    m = stack.pop()
    n = factorial(m).n()
    while (floor(n)>3):
        if (n<bound) and not(floor(n) in found):
            found.add(floor(n))
            stack.append(floor(n))
        n = sqrt(n)
print(sorted(found))
