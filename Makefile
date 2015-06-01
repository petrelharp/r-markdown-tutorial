PANDOC_OPTS = --mathjax=/usr/share/javascript/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML --standalone

%.html : %.md
	pandoc -o $@ $(PANDOC_OPTS) $<

%.md : %.Rmd
	cd $$(dirname $<); Rscript -e 'knitr::knit(basename("$<"),output=basename("$@"))'

## VARIOUS SLIDE METHODS
REVEALJS_OPTS = -t revealjs -V theme=moon
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

