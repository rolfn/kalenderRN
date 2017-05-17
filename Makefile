# Rolf Niepraschk, 2017-01-22, Rolf.Niepraschk@gmx.de

.SUFFIXES : .dtx .ins .tex .ltx .dvi .ps .pdf .eps

MAIN = tikz-kalender
LATEX = pdflatex
TEX = tex

VERSION = $(shell awk '/ProvidesClass/ {print $$2}' $(MAIN).cls)

DIST_DIR = $(MAIN)
ARCHNAME = $(MAIN)-$(VERSION).zip
EVENTS = Feiertage-2016.events Schulferien-2016.events Urlaub.events \
  Geburtstage.events Sonstiges.events 
ADD = tikz-kalender-translation.clo
MAIN_FILES = $(MAIN).cls $(ADD) README.md
DOC_FILES = tikz-kalender-example1.pdf tikz-kalender-example2.pdf \
	tikz-kalender-example1.tex tikz-kalender-example2.tex $(EVENTS)

all : tikz-kalender-example1.pdf tikz-kalender-example2.pdf

%.pdf : %.tex $(MAIN).cls $(ADD) $(EVENTS)
	$(LATEX) $<

dist : $(ARCHNAME)

$(ARCHNAME) : $(DOC_FILES)
	$(RM) $@
	mkdir -p $(DIST_DIR)/doc
	cp -p $(MAIN_FILES) $(DIST_DIR)/
	cp -p $(DOC_FILES) $(DIST_DIR)/doc/
	zip $@ -r $(DIST_DIR)
	rm -rf $(DIST_DIR)

clean :
	$(RM) *.aux *.log

veryclean : clean
	$(RM) $(EXAMPLE).pdf $(ARCHNAME)

debug :
	@echo $(ARCHNAME)
