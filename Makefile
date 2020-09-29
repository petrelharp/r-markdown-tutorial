SHELL := /bin/bash
# use bash for <( ) syntax

.PHONY : 

all : using-rmarkdown.slides.html using-rmarkdown.html Readme.html technical-notes.html gotchas.html examples/linear-regression.html examples/sequences.html

# change this to the location of your local MathJax.js library
LOCAL_MATHJAX = /usr/share/javascript/mathjax/MathJax.js
ifeq ($(wildcard $(LOCAL_MATHJAX)),)
	MATHJAX = --mathjax
else
	MATHJAX = --mathjax=$(LOCAL_MATHJAX)
endif

# may want to add "--self-contained" to the following
PANDOC_OPTS = $(MATHJAX) --standalone
# optionally add in a latex file with macros
LATEX_MACROS = macros.tex
ifeq ($(wildcard $(LATEX_MACROS)),)
	# macros file isn't there
else
	PANDOC_OPTS += -H .pandoc.$(LATEX_MACROS)
endif

.pandoc.$(LATEX_MACROS) : $(LATEX_MACROS)
	(echo '<div style="display: none">'; echo '\['; cat $(LATEX_MACROS); echo '\]'; echo '</div>') > $@

# knitr by default tries to interpret ANY code chunk; I only want it to do the ones beginning with ```r.
KNITR_PATTERNS = list( chunk.begin="^```+\\s*\\{[.]?(r[a-zA-Z]*.*)\\}\\s*$$", chunk.end="^```+\\s*$$", inline.code="`r +([^`]+)\\s*`")
# or, uncomment for OSX:
# KNITR_PATTERNS = list( chunk.begin="^```+\\\\s*\\\\{[.]?(r[a-zA-Z]*.*)\\\\}\\\\s*$$", chunk.end="^```+\\\\s*$$", inline.code="`r +([^`]+)\\\\s*`")

%.html : %.Rmd
	Rscript -e 'knitr::knit_patterns[["set"]]($(KNITR_PATTERNS)); templater::render_template("$<", output="$@", change.rootdir=TRUE, clean=FALSE)'

%.html : %.md .pandoc.$(LATEX_MACROS)
	pandoc -o $@ $(PANDOC_OPTS) $(MATHJAX_OPTS) $<

%.local.html : %.md
	pandoc -o $@ $(PANDOC_OPTS) $(LOCAL_MATHJAX_OPTS) $<

%.md : %.Rmd .pandoc.$(LATEX_MACROS)
	Rscript -e 'knitr::knit_patterns[["set"]]($(KNITR_PATTERNS)); templater::render_template("$<", output="$@", change.rootdir=TRUE)'

%.pdf : %.md
	pandoc -o $@ -t latex $<

using-rmarkdown.html : using-rmarkdown.Rmd
	Rscript -e 'knitr::knit_patterns[["set"]]($(KNITR_PATTERNS)); templater::render_template("$<", output="$@", change.rootdir=TRUE)'


## VARIOUS SLIDE METHODS
REVEALJS_OPTS = -t revealjs -V theme=simple -V slideNumber=true -V transition=none -H resources/adjust-revealjs.style
SLIDY_OPTS = -t slidy
S5_OPTS = -t s5
SLIDES_OPTS = $(REVEALJS_OPTS)

%.slides.html : %.md
	pandoc -o $@ $(SLIDES_OPTS) $(PANDOC_OPTS) $<

%.revealjs.html : %.md
	pandoc -o $@ $(REVEALJS_OPTS) $(PANDOC_OPTS) $<

%.slidy.html : %.md
	pandoc -o $@ $(SLIDY_OPTS) $(PANDOC_OPTS) $<

%.s5.html : %.md
	pandoc -o $@ $(S5_OPTS) $(PANDOC_OPTS) $<


### VARIOUS METHODS USING R

%.rmarkdown.html : %.md
	### rmarkdown::render()
	cd $$(dirname $<); Rscript -e 'rmarkdown::render(basename("$<"),output_file=basename("$@"))'

%.markdown.html : %.md
	### markdown::markdownToHTML()
	cd $$(dirname $<); Rscript -e 'markdown::markdownToHTML(basename("$<"),output=basename("$@"))'

%.knitr.html : %.md
	### knitr::knit2html()
	cd $$(dirname $<); Rscript -e 'knitr::knit2html(basename("$<"),output=basename("$@"))'

%.pander.html : %.md
	### pander::Pandoc.convert()
	# note that pander silently modifies input markdown file
	# AND doesn't provide a way to set the output file
	# so this WON'T work with files with images in
	cd $$(dirname $<) && \
		TEMPFILE="$(addprefix _pander_,$(<F))" && \
		cp $(<F) $$TEMPFILE && \
	   	Rscript -e 'f.out <- pander::Pandoc.convert(f="'$${TEMPFILE}'",open=FALSE); file.copy(f.out,basename("$@")); unlink(f.out); cat("$@","\n")' && \
		rm $$TEMPFILE

