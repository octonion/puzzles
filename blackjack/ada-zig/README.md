```bash
zig build-lib --release-fast partitions.zig --name libpartitions.so --library c
gnatmake outcomes.adb -largs -ldl
```
