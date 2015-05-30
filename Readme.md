A quick introduction to R/markdown
==================================

These are notes and materials for a short (2-hour) course on using R/markdown to generate reports
and dynamic documents.


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
    * self-contained documents (+local mathjax)
    * the [documentation](http://pandoc.org/README.html) and [where to look for help](http://stackoverflow.com/questions/tagged/pandoc?sort=frequent&pageSize=15)
    * some other things pandoc does

3.  Adding [R](http://r-project.org/)

    * what [knitr](http://yihui.name/knitr/) does
    * code chunks
    * tables
    * figures
    * chunk options
    * inline `R`
    * rmarkdown and rstudio

4.  One report, many documents: a working example

    * one subdirectory per dataset
    * json configuration + simulated ata
    * external variables with knitr
    * using `Rscript` instead
