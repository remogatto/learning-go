PACKAGE=fib
TESTPROG=test_$(PACKAGE)

include $(GOROOT)/src/Make.$(GOARCH)
export GC
export LD
export O

SRC=$(wildcard *.go)

all: test

clean:
	rm -rf *.[a68] $(TESTPROG) _test *~

test: testpackage

package: $(PACKAGE).a

$(PACKAGE).a: $(PACKAGE).$O
	gopack grc $@ $(PACKAGE).$O

$(PACKAGE).$O: $(SRC)
	$(GC) -o $@ $(SRC)

testpackage: test$(PACKAGE).a

test$(PACKAGE).a: test$(PACKAGE).$O
	gopack grc $@ test$(PACKAGE).$O

test$(PACKAGE).$O: _test $(SRC)
	for i in $(SRC); do sed -e 's/package $(PACKAGE)/package test$(PACKAGE)/' < $$i > _test/$$i; done
	$(GC) -o $@ _test/*.go

_test:
	mkdir _test
