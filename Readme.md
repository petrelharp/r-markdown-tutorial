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
    * gotchas
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



Notes on setting up to build the *presentation*
---------------------------------------------

There are various [styles of presentation](http://pandoc.org/README.html#producing-slide-shows-with-pandoc) available.

My favorite: perhaps slidy or reveal.js.

1.  **S5** :

    ```{.sh}
    mkdir s5 && cd s5
    wget http://meyerweb.com/eric/tools/s5/v/1.1/s5-11.zip
    unzip s5-11.zip 
    ln -s ui/default default
    ```

2.  **dzslides** : No setup, but seems to be broken.

3.  slidy : No setup, downloads from [w3c.org]

4.  slideous : Doesn't seem to produce a slideshow?

    ```{.sh}    
    mkdir slideous
    cd slideous/
    wget http://goessner.net/download/prj/slideous/slideous.zip
    unzip slideous.zip 
    ```

5.  reveal.js : pandoc 1.12 works with reveal.js <= 2.6.2

    ```{.sh}
    git clone https://github.com/hakimel/reveal.js.git
    cd reveal.js
    git checkout 2.6.2
    cd ..
    ```

    An up-to-date pandoc shouldn't need the checkout.

    Note: can change theme with e.g. `-V theme=moon`

