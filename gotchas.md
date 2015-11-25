---
author: Peter Ralph
date: 26 October 2015
title: "R+markdown gotchas"
---


These things were confusing to me for a while.
They might be to others also.

How to format $\LaTeX$ for pandoc
=================================

There are a lot of different ways to enter math in LaTeX already,
and there's more when using pandoc.
This is kinda nice for the newcomer to LaTeX, since it's more forgiving,
but if you want to produce *both* html and pdf output, you have to do it just right.
For html output, it seems safe to just wrap everything in \$\$s;
but this breaks when passed to pdflatex.
The solution, at least for now, is to use `\aligned` instead of `\align`:

- If you are producing pdf, pandoc will pass your LaTeX directly to pdflatex;
    so your code needs to be valid there.
- If you are producing html, pandoc [includes raw LaTeX blocks if --mathjax is specified](https://github.com/jgm/pandoc/commit/4f0c5c30809f09bd700cd47035f86a3db1c64669),
    so you can go ahead and use \\align environments and everything.
- Definitions (\\newcommand, etc) go at the top of the file, after the YAML header.

For instance, this file:

~~~~~~~~~~~
\newcommand{\R}{\mathbb{R}}

This is for $\R$eal.
$$\begin{aligned}
    e^{i\pi} = -1
\end{aligned}$$
~~~~~~~~~~~

compiles just fine both with

~~~~~~~~~~
pandoc test.md -o test.pdf
pandoc test.md --standalone --mathjax -o test.html
~~~~~~~~~~



`rmarkdown` does not work with templated reports
================================================

It's nice and convenient to turn your `.Rmd` files into html using `rmarkdown`'s function `render()`.
And, R+markdown is a great way to produce templated reports:
write one .Rmd file; apply it to many datasets of the same structure.
**But**, as I discovered the hard way,
if you call, say, 
`render("template.Rmd",output_file="a.html")` 
and
`render("template.Rmd",output_file="b.html")` 
at the same time in different R sessions,
with different variables,
you won't get different reports,
you'll get the same one twice, silently.
As far as I can tell, there's [no workaround](https://github.com/rstudio/rmarkdown/issues/499)
with rmarkdown;
the way to do it is to call `knitr` and `pandoc` yourself
(which is what rmarkdown does under the hood anyhow).


Name every chunk a different name, *even in different files*
==========================================================

`knitr` caches figures in a subdirectory, by default called `figure/`.
The same goes for the results of any *cached* chunk.
You can, and should, change this, 
by specifying a file-specific prefix for the figures, 
for instance as follows:

~~~~~~~~~~~~~~
```{r setup_knitr}
knitr::opts_chunk$set(fig.path=file.path("figure",gsub("\.Rmd","",knitr::current_input()),""),
    cache.path=file.path("cache",gsub("\.Rmd","",knitr::current_input()),""))
```
~~~~~~~~~~~~~~
or, defining Makefile rules:

~~~~~~~~~~~~~~
%.md : %.Rmd
	Rscript -e 'knitr::opts_chunk$$set(fig.path=file.path("figure","$*",""),cache.path=file.path("cache","$*",""));knitr::knit(basename("$<"),output=basename("$@"))'

%.html : %.md
	cd $(dir $<) && pandoc $(notdir $<) $(PANDOC_OPTS) --output $(notdir $@)
~~~~~~~~~~~~~~

Mathjax CDNs
============

For some versions of pandoc,
the second command above wouldn't have worked.
That's because pandoc would have inserted the URL *without* the `https://` in front,
as discussed [here](https://github.com/jgm/pandoc/issues/2200).
This works if the file is being served from a webserver, 
but not if you're looking at it on your local computer (using the `file://` protocol).
The solution is to pass in the mathjax URL explicitly:

~~~~~~~~~~
pandoc test.md --standalone --mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML -o test.html
~~~~~~~~~~

... or to update your pandoc.
