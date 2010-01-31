GOBIN=$(HOME)/bin
SPECIFY=specify

all: test

clean:
	cd src; make clean

format:
	cd src; gofmt -w *.go
	cd spec; gofmt -w *.go

test:
	cd src; make testpackage
	cd spec; $(SPECIFY) *.go

package:
	cd src; make package

