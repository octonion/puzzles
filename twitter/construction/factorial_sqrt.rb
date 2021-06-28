#require 'set'
require 'sorted_set'

class Integer
  def fact
    (2..self).reduce(1,:*)
  end
end

bound = 20000

queue = Queue.new
queue << 3

found = SortedSet[3]
paths = {3 => 3}
sqrts = {3 => 0}

while (queue.size() > 0)
    m = queue.pop()
    n = m.fact()
    i = 0
    while (n>3)
        if (n<bound) and not(found.include?(n))
            found.add(n)
            queue << n
            paths[n] = m
            sqrts[n] = i
        end
        n = Integer.sqrt(n)
        i += 1
    end
end
print(found,"\n")

v = 72
while not(v==3)
    w = paths[v]
    print("#{v} <- #{w}! + #{sqrts[v]} sqrt\n")
    v = w
end
