import numpy as np

n = 1000000

a = np.random.uniform(-1,1, size=(n,))
b = np.random.uniform(-2,2, size=(n,))
c = np.random.uniform(-3,3, size=(n,))
d = np.random.uniform(-4,4, size=(n,))

distances = np.stack((abs(a-c),abs(b-c),abs(d-c)),axis=-1)
closest = np.argmin(distances,axis=-1)

unique, counts = np.unique(closest, return_counts=True)
results = dict(zip(unique, counts))

print(results)

a = np.random.normal(0,1, size=(n,))
b = np.random.normal(0,2, size=(n,))
c = np.random.normal(0,3, size=(n,))
d = np.random.normal(0,4, size=(n,))

distances = np.stack((abs(a-c),abs(b-c),abs(d-c)),axis=-1)
closest = np.argmin(distances,axis=-1)

unique, counts = np.unique(closest, return_counts=True)
results = dict(zip(unique, counts))

print(results)
