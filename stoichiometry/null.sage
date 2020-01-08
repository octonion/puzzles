# To balance:
# Combustion of butane
# C4H10 + O2 → CO2 + H2O

A = matrix([[4, 0, 1, 0], [10, 0, 0, 2], [0, 2, 2, 1]])

print(kernel(A.transpose()))
# Free module of degree 4 and rank 1 over Integer Ring
# Echelon basis matrix:
# [  2  13  -8 -10]

# Balanced equation:
# 2C4H10 + 13O2 -> 8CO2 + 10H2O

# To balance:
# HIO3 + FeI2 + HCl → FeCl3 + ICl + H2O

A = matrix([[1, 0, 1, 0, 0, 2], [1, 2, 0, 0, 1, 0], [3, 0, 0, 0, 0, 1], [0, 1, 0, 1, 0, 0], [0, 0, 1, 3, 1, 0]])

print(kernel(A.transpose()))
# Free module of degree 6 and rank 1 over Integer Ring
# Echelon basis matrix:
# [  5   4  25  -4 -13 -15]

# Balanced equation:
# 5HIO3 + 4FeI2 + 25HCl → 4FeCl3 + 13ICl + 15H2O

# To balance:
# S + HNO3 → H2SO4 + NO2 + H2O

A = matrix([[1, 0, 1, 0, 0], [0, 1, 2, 0, 2], [0, 1, 0, 1, 0], [0, 3, 4, 2, 1]])

print(kernel(A.transpose()))
# Free module of degree 5 and rank 1 over Integer Ring
# Echelon basis matrix:
# [ 1  6 -1 -6 -2]

# Balanced equation:
# S + 6HNO3 → H2SO4 + 6NO2 + 2H2O

# To balance:
# Cu + HNO3 → Cu(NO3)2 + NO + H2O

A = matrix([[1, 0, 1, 0, 0], [0, 1, 0, 0, 2], [0, 1, 2, 1, 0], [0, 3, 6, 1, 1]])

print(kernel(A.transpose()))
# Free module of degree 5 and rank 1 over Integer Ring
# Echelon basis matrix:
# [ 3  8 -3 -2 -4]

# Balanced equation:
# 3Cu + 8NO3 → 3Cu(NO3)2 + 2NO + 4H2O
