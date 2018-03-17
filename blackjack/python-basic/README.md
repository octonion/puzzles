```bash
fbc -O 3 -dylib -pic partitions.bas
python outcomes2.py
python3 outcomes3.py
```

```bash
fbc -O 3 -c -pic partitions.bas
gcc -O3 -fpic -shared partitions.o -o libpartitions.so
python outcomes2.py
python3 outcomes3.py
```
