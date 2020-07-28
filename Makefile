all: lib

sneslib: gl.yaml
	gitlayer get

lib.go: sneslib
	./build.sh

lib: lib.go
	go build lib.go

clean:
	- rm -rf sneslib lib.go lib
