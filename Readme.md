A quick introduction to R/markdown
==================================

These are notes and materials for a short (2-hour) course on using R/markdown to generate reports
and dynamic documents.

Here's a link to [the slides](http://petrelharp.github.io/r-markdown-tutorial/using-rmarkdown.slides.html).
Also, here are some [technical notes](http://petrelharp.github.io/r-markdown-tutorial/technical-notes.html)
on getting pandoc, R+markdown, and this presentation to work.


Outline
-------

1.  Markdown

    * philosophy: just write
    * structure: headers, breaks
    * formatting: **bold**, *emphasis*
    * [links](Outline)
    * math
    * code blocks
    * images
    * [metadata](https://github.com/jgm/pandoc/issues/851)
    * the [wider](http://en.wikipedia.org/wiki/Markdown) [world](http://blog.codinghorror.com/standard-flavored-markdown/) of [markdown(s)](http://commonmark.org/)

2.  Rendering markdown with [pandoc](http://pandoc.org)

    * bare-bones
    * adding style
    * metadata/YAML headers
    * self-contained documents (+local mathjax)
    * gotchas
    * the [documentation](http://pandoc.org/README.html) and [where to look for help](http://stackoverflow.com/questions/tagged/pandoc?sort=frequent&pageSize=15)

3.  Adding [R](http://r-project.org/)

    * what [knitr](http://yihui.name/knitr/) does
    * code chunks
    * figures
    * tables
    * chunk options
    * inline `R`
    * rmarkdown and rstudio

4.  One report, many documents: a working example

    * one subdirectory per dataset
    * json configuration + simulated data
    * external variables with knitr
    * using `Rscript` instead



Compiling the presentation yourself
-----------------------------------


The presentation uses [reveal.js](http://lab.hakim.se/reveal-js/).
You can get this repository along with reveal.js like so:

````{.sh}
git clone https://github.com/petrelharp/r-markdown-tutorial.git
cd r-markdown-turoial
git submodule init && git submodule update
````

With an up-to-date version of pandoc, R, and knitr,
you should be able to compile the presentation like so:

````{.sh}
make using-rmarkdown.slides.html
````

Since I give presentations sometimes not on the internet,
this by default relies on a local installation of MathJax,
so unless you've installed this on Debian/Ubuntu (`aptitude install libjs-mathjax`),
to view the maths properly you need to change the location in the Makefile.

The presentation will not render in Rstudio because:
by default, `knitr` tries to process all code blocks;
so to have example code in the document you have to munge your own code.
To keep my document processable by just pandoc, and prettier
(except the inline code)
I am rendering the presentation after modifying the regular expression knitr uses
to identify code chunks to require exactly three backticks,
at the start of the line, and the identifier `r`
(by default it is much more lax).
See the Makefile for how this is done.


