# Paths of length 100 starting at 1

# This works

paths := (1/sqrt(5)+1/2)*(3+sqrt(5))^50+(-1/sqrt(5)+1/2)*(3-sqrt(5))^50:
simplify(paths);

# This also works

paths := round((1/sqrt(5)+1/2)*(3+sqrt(5))^50):
paths;
