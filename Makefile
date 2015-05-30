PANDOC_OPTS = --mathjax --standalone

%.html : %.md
	pandoc -o $@ $(PANDOC_OPTS) $<
