

all: install.md license.md requirements.md
	doxygen doxyfile
	make -C build/latex
	cp build/latex/refman.pdf build/html
	rm -rf ../docs/*
	cp -r build/html/* ../docs/

install.md: ../INSTALL.txt
	cp $< getting_started/$@

license.md: ../LICENSE.txt
	cp $< getting_started/$@

requirements.md: ../REQUIREMENTS.txt
	cp $< getting_started/$@

pdf: 
	make -C build/latex
	cp build/latex/refman.pdf build/html