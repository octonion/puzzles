```bash
gcc -O3 -fPIC -shared -o libpartitions.so partitions.c
julia -O --check-bounds=no --math-mode=fast outcomes.jl
```
