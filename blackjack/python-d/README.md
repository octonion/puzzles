```bash
dmd -shared -oflibpartitions.so -fPIC partitions.d
python outcomes.py
```
[10, 0, -1221592608, 32767, -1221592688, 32767, -20940678, 32633, 1597697216, 21942]
1597694288
...
```bash
ldc2 -O3 -release -relocation-model=pic -shared partitions.d
python outcomes.py
```
Segmentation fault (core dumped)
