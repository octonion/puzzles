```bash
zig build-lib --release-fast partitions.zig --name libpartitions.so --library c
gnatmake shared_library_call.adb -largs -ldl
```
