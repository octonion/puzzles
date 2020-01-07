# To balance:
# Combustion of butane
# C4H10 + O2 → CO2 + H2O

A = matrix([[4, 0, 1, 0], [10, 0, 0, 2], [0, 2, 2, 1]])

# [  2  13  -8 -10]
print(kernel(A.transpose()))

# Balanced equation:
# 2C4H10 + 13O2 -> 8CO2 + 10H2O

# To balance:
# HIO3 + FeI2 + HCl → FeCl3 + ICl + H2O

A = matrix([[1, 0, 1, 0, 0, 2], [1, 2, 0, 0, 1, 0], [3, 0, 0, 0, 0, 1], [0, 1, 0, 1, 0, 0], [0, 0, 1, 3, 1, 0]])

# [  5   4  25  -4 -13 -15]
print(kernel(A.transpose()))

# Balanced equation:
# 5HIO3 + 4FeI2 + 25HCl → 4FeCl3 + 13ICl + 15H2O
