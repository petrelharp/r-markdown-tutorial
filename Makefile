%.html : %.md
	pandoc -o $@ $<
