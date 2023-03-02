

all: install.md license.md requirements.md
	doxygen doxyfile
	rm -rf ../docs/*
	cp -r build/html/* ../docs/

install.md: ../INSTALL.txt
	cp $< getting_started/$@

license.md: ../LICENSE.txt
	cp $< getting_started/$@

requirements.md: ../REQUIREMENTS.txt
	cp $< getting_started/$@