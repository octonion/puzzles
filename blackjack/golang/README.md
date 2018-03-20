```bash
go build outcomes.go
./outcomes
```

```bash
gccgo -O3 outcomes.go -o outcomes
./outcomes
```

```bash
go build -compiler gccgo -gccgoflags '-O3 -march=native' outcomes.go
```
