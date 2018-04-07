```bash
g++ -O3 -fPIC -shared -o libpartitions.so partitions.cpp
python outcomes2.py
python3 outcomes3.py
```

```bash
g++ -Ofast -fPIC -shared -o libpartitions.so partitions.cpp
python outcomes2.py
python3 outcomes3.py
```
