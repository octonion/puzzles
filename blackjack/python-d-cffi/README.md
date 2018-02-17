```bash
dmd -O -release -shared -oflibpartitions.so -fPIC partitions.d
python outcomes.py
```

```bash
ldc2 -O3 -release -relocation-model=pic -shared partitions.d
python outcomes.py
```
