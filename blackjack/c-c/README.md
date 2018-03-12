```bash
gcc -O3 -fPIC -shared -o libpartitions.so partitions.c
gcc -O3 outcomes.c -ldl
```
