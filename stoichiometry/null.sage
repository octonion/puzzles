# To balance:
# Combustion of butane
# C4H10 + O2 -> CO2 + H2O

A = matrix([[4, 0, 1, 0], [10, 0, 0, 2], [0, 2, 2, 1]])

# [  2  13  -8 -10]
print(kernel(A.transpose()))

# Balanced equation:
# 2C4H10 + 13O2 -> 8CO2 + 10H2O
