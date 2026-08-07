include ../../make.in

MANSRC=iapws.1.man \
	   iapws_lib.3.man \
	   iapws_version.3.man \
	   iapws_kh.3.man \
	   iapws_kd.3.man \
	   iapws_kw.3.man
MAN=$(patsubst %.man, %, $(MANSRC))
MANPDF=$(patsubst %, %.pdf, $(MAN))
MANTXT=$(patsubst %, %.txt, $(MAN))
MANGZ=$(patsubst %, %.gz, $(MAN))
MANHTML=$(patsubst %, %.html, $(MAN))

all: examples $(MAN) $(BOOKMAN) $(MANGZ) $(MANPDF) $(MANTXT) $(MANHTML)

examples: 
	./concatex

iapws.1: iapws.1.man
	cat $< seealso.man > tmp
	sed -E "s/@VERSION@/$(FPM_VERSION)/g;s/@DATE@/$(shell date +'%d %B %Y')/g" tmp > $@
	rm -rfv tmp

iapws_lib.3: iapws_lib.3.man
	cat $< examples.man seealso.man > tmp
	sed -E "s/@VERSION@/$(FPM_VERSION)/g;s/@DATE@/$(shell date +'%d %B %Y')/g" tmp > $@
	rm -rfv tmp

iapws_%.3: iapws_%.3.man
	cat $< seealso.man > tmp
	sed -E "s/@VERSION@/$(FPM_VERSION)/g;s/@DATE@/$(shell date +'%d %B %Y')/g" tmp > $@
	rm -rfv tmp

%.pdf: %
	man -l -Tpdf $< > $@

%.html: %
	man -l -Thtml $< > $@

%.gz: %
	gzip -fk $^ > $@

%.txt: %
	man -l $< > $@

.PHONY: clean
clean:
	rm -fv $(MAN) $(BOOKMAN) $(MANGZ) $(MANPDF) $(MANTXT) $(MANHTML)

