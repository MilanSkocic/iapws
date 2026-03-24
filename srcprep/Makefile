export PREP_DOCUMENT_DIR=../

f90prep=$(wildcard *.f90)
f90=$(patsubst %.f90, ../src/%.f90, $(f90prep))


all: example.txt fapi.txt capi.txt pyapi.txt $(f90)

../src/%.f90: %.f90
	prep $< -o $@

example.txt: ../example/example.f90 ../example/example.c ../example/example.py
	./concatex.sh

fapi.txt: iapws.f90
	./f2txt.sh $< $@

capi.txt: ../include/iapws.h
	./c2txt.sh $< $@

pyapi.txt: ../py/src/pyiapws/__init__.py
	./py2txt.sh $< $@

clean:
	rm -f $(f90)
	rm -f *api.txt example*.txt
