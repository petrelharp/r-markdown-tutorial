PANDOC_OPTS = --mathjax --standalone

%.html : %.md
	pandoc -o $@ $(PANDOC_OPTS) $<

## VARIOUS SLIDE METHODS
REVEALJS_OPTS = -t revealjs -V theme=moon
SLIDY_OPTS = -t slidy
S5_OPTS = -t s5
SLIDES_OPTS = $(REVEALJS_OPTS)

%.slides.html : %.md
	pandoc -o $@ $(SLIDES_OPTS) $(PANDOC_OPTS) $<

%.slides.revealjs.html : %.md
	pandoc -o $@ $(REVEALJS_OPTS) $(PANDOC_OPTS) $<

%.slides.slidy.html : %.md
	pandoc -o $@ $(SLIDY_OPTS) $(PANDOC_OPTS) $<

%.slides.s5.html : %.md
	pandoc -o $@ $(S5_OPTS) $(PANDOC_OPTS) $<


### VARIOUS METHODS USING R

%.rmarkdown.html : %.md
	### rmarkdown::render()
	Rscript -e 'setwd(dirname("$<"));rmarkdown::render(basename("$<"),output_file=basename("$@"))'

%.markdown.html : %.md
	### markdown::markdownToHTML()
	Rscript -e 'setwd(dirname("$<"));markdown::markdownToHTML(basename("$<"),output=basename("$@"))'

%.knitr.html : %.md
	### knitr::knit2html()
	Rscript -e 'setwd(dirname("$<"));knitr::knit2html(basename("$<"),output=basename("$@"))'

%.pander.html : %.md
	### pander::Pandoc.convert()
	# note that pander silently modifies input markdown file
	# AND doesn't provide a way to set the output file
	Rscript -e 'setwd(dirname("$<")); f.out <- pander::Pandoc.convert(text=paste(scan(basename("$<"),what="char",sep="\n"),collapse="\n"),open=FALSE); file.copy(f.out,basename("$@")); "$@"'

