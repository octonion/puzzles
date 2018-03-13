```bash
gcc -O3 -fPIC -shared partitions.c -o partitions.so
gcc -O3 outcomes.c -ldl
```

```bash
icc -O3 -fPIC -shared partitions.c -o partitions.so
icc -O3 outcomes.c
```
