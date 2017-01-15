# Rolf Niepraschk, 2017-01-15, Rolf.Niepraschk@gmx.de

.SUFFIXES : .dtx .ins .tex .ltx .dvi .ps .pdf .eps

MAIN = kalenderRN
YEAR = 2016
EXAMPLE = Kalender$(YEAR)
LATEX = pdflatex
TEX = tex

VERSION = $(shell awk '/ProvidesClass/ {print $$2}' $(MAIN).cls)

DIST_DIR = $(MAIN)
DIST_FILES = README.md $(MAIN).cls $(EXAMPLE).tex events$(YEAR).tex
ARCHNAME = $(MAIN)-$(VERSION).zip

all : EXAMPLE.pdf

$(EXAMPLE).pdf : $(EXAMPLE).tex $(MAIN).cls events$(YEAR).tex
	$(LATEX) $<

dist : $(DIST_FILES)
	mkdir -p $(DIST_DIR)
	cp -p $+ $(DIST_DIR)
	zip $(ARCHNAME) -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log

veryclean : clean
	$(RM) $(EXAMPLE).pdf $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
