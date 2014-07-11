# -*- makefile -*-

# Copyright (C) 2005  Nick Urbanik <nicku@nicku.org>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

#LATEX = latex --interaction=batchmode
#PDFLATEX = pdflatex --interaction=batchmode
LATEX = latex
PDFLATEX = pdflatex
DOCUMENT_BASE = slides
BIBTEX = bibtex

beamer_slide_files = $(wildcard *-slides.tex)
slides =             $(beamer_slide_files:%.tex=%-beamer.pdf)

gifs    = $(wildcard *.gif)
figures = $(wildcard *.fig)
epsfigs = $(figures:.fig=.eps) $(gifs:.gif=.eps)
pdffigs = $(figures:.fig=.pdf) $(gifs:.gif=.pdf)

all: \
	$(DOCUMENT_BASE)-beamer.pdf \

%.pdf: %.tex
	@echo
	@echo \*
	@echo \* Compiling $<
	@echo \*
	$(PDFLATEX) $<
#	$(BIBTEX) $(subst .tex,,$<)
	@while ( grep "Rerun to get cross-references"                   \
			$(subst .tex,.log,$<) >/dev/null ); do          \
		echo '** Re-running LaTeX **';                          \
		$(PDFLATEX) $<;                                            \
	done

%.pdf: %.eps
	@echo
	@echo \*
	@echo \* Producing PDF for $<
	@echo \*
	epstopdf $<

message:
	@echo "In order to build slides you must have beamer installed"
	@echo "Please run 'apt-get install tetex-beamer' in Debian or"
	@echo "'yum install tetex-beamer' in Fedora or Red Hat, or"
	@echo "As appropriate for your distribution."

list:
	@echo beamer_slide_files:
	@echo $(beamer_slide_files)
	@echo slides:
	@echo $(slides)

tidy:
	rm -f *.log *.ps *.toc *.aux *.eepic *.bak *.lg *.out *.idx *~ \
	*.nav *.snm *.out *.vrb  *.blg *.bbl

clean:  tidy
	rm -f *.dvi $(shell ls *.pdf 2>/dev/null|egrep -v gnu-head.pdf)

# Stop overzealous deletion of intermediate files
.PRECIOUS: %.eps $(pdffigs) %.slides-beamer.tex

.PHONY: all clean tidy list lpr print message

