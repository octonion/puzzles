require 'set'

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
    while (n.floor()>3)
        if (n<bound) and not(found.include?(n.floor()))
            found.add(n.floor())
            queue << n.floor()
            paths[n.floor()] = m
            sqrts[n.floor()] = i
        end
        n = Integer.sqrt(n)
        i += 1
    end
end
print(found,"\n")

v = 9
while not(v==3)
    w = paths[v]
    print("#{v} <- #{w}! + #{sqrts[v]} sqrt\n")
    v = w
end
