```bash
dmd -O -release -shared -oflibpartitions.so -fPIC partitions.d
ruby outcomes.rb
```

```bash
ldc2 -O3 -release -relocation-model=pic -shared partitions.d
ruby outcomes.rb
```
