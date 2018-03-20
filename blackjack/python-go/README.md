```bash
go build -o libpartitions.so -buildmode=c-shared partitions.go
python outcomes.py
```

```bash
go build -compiler gccgo -gccgoflags '-O3 -march=native' -o libpartitions.so -buildmode=c-shared partitions.go
python outcomes.py
```
