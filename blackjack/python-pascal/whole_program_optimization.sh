#/bin/sh

# -CD and -fPIC do not seem to be necessary

fpc -O4 -FWpartitions-1.wpo -OWall -CX -XX -Xs- -al -olibpartitions.so partitions.pas
fpc -O4 -FWpartitions-2.wpo -OWall -Fwpartitions-1.wpo -Owall -CX -XX -Xs- -al -olibpartitions.so partitions.pas
fpc -O4 -Fwpartitions-2.wpo -Owall -CX -XX -Xs- -al -olibpartitions.so partitions.pas
