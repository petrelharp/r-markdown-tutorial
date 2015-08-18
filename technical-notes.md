---
author: Peter Ralph
date: June 2, 2015
title: Technical notes
---

pandoc invocation
=================

General
-------

-   `-o (output file name)` : where to put output
-   `--standalone` : produces a standalone document, not a code fragment
    (using one of [these](https://github.com/jgm/pandoc-templates)
    [templates](http://pandoc.org/README.html#templates))
-   `--from=(format name)[+/-(extension name)]` : what to write out to
    (defaults to html) and optional turning on/off of various behavior,
    [listed here](http://pandoc.org/README.html#pandocs-markdown)
-   `--include-in-header=(file name)` : at the end of the header, e.g.
    css, javascript, `\newcommand`, etc. (but see `--css`)
-   `--include-before-body=(file name)` : at the beginning of the
    body, e.g. navigation bars, `\maketitle`, etc.
-   `--self-contained` : everything in one file (but see `--mathjax`)
-   `--mathjax[=URL]` : points to the `MathJax.js` script,
    *incompatible* with `--selfcontained`

Slides
======

For presentations
-----------------

See [the
documentation](http://pandoc.org/README.html#producing-slide-shows-with-pandoc)

-   `--variable=KEY[:VAL]` : assign template variable KEY to VAL, for
    instance:

    -   `theme` : for beamer or reveal.js presentations
    -   but note these can be also [set in
        metadata](http://tex.stackexchange.com/questions/139139/adding-headers-and-footers-using-pandoc/139205#139205)
-   `--incremental` : step through lists
-   `--slide-level` : headers above this level create sections; below
    this create slides.
-   `--css=(URL)` : include the css linked to

Other notes on making slides
----------------------------

A paragraph with three dots:

    . . .

makes a pause.

Other styles of presentation
-----------------------------

There are various [styles of presentation](http://pandoc.org/README.html#producing-slide-shows-with-pandoc) available.

I ended up using `reveal.js`, so it's included as a submodule,
but `slidy` looked pretty good, too.
Here's notes on getting the prerequisites.
There are rules in the Makefile to build the rest of these.

1.  reveal.js : pandoc 1.12 works only with reveal.js <= 2.6.2.

    So, if your pandoc is old, do this:

    ```{.sh}
    cd reveal.js
    git checkout 2.6.2
    cd ..
    ```

2.  **S5** :

    ```{.sh}
    mkdir s5 && cd s5
    wget http://meyerweb.com/eric/tools/s5/v/1.1/s5-11.zip
    unzip s5-11.zip 
    ln -s ui/default default
    ```

2.  **dzslides** : No setup, but seems to be broken.

4.  **slidy** : No setup, downloads from [w3c.org]

5.  **slideous** : Doesn't seem to produce a slideshow?

    ```{.sh}    
    mkdir slideous
    cd slideous/
    wget http://goessner.net/download/prj/slideous/slideous.zip
    unzip slideous.zip 
    ```




knitr and such
==============

Options for rendering using R
-----------------------------

There are methods in the Makefile for rendering with each of these methods.

-   `markdown::markdownToHTML( )` : lightweight but does some styling

    -   used by `knitr::knit2html()`
    -   automatically includes mathjax

-   `knitr::knit2html( )` : calls `markdown::markdownToHTML( )`, almost identical

-   `pander::Pandoc.convert( )` : looks quite nice, brings in jquery and others

    -   `pander` is an entire schema to translate `R` objects *to markdown*
    -   imports a bunch of javascript and css
    -   gave many people strange errors in Rstudio

-   `rmarkdown::render( )` : high-level, does everything, has a nice template.

    -   processes YAML header
    -   knits if necessary
    -   is what `Rstudio` relies on, which comes bundled with a binary for pandoc.


Codeblocks and `knitr`
----------------------

`knitr` just uses a *regular expression* to identify chunks of code to
parse:


``` {.sourceCode .R}
knitr::all_patterns$md$chunk.begin
## "^[\t >]*```+\\s*\\{[.]?([a-zA-Z]+.*)\\}\\s*$"

knitr::all_patterns$md$chunk.end
## [1] "^[\t >]*```+\\s*$"
```


Yihui's trick for getting around this is to use R to insert an "" into
the preamble, like so:

``` {.md}
 ``r ""```
```

Parsed that?

Here's an inline example:

    inline `R` code (`` ``r "r nrow(data)"`` ``)

**Alternatively,** you can make the patterns knitr uses to catch code
blocks more strict. Here's from the Makefile for this presentation:

``` {.make}
KNITR_PATTERNS = list( chunk.begin="^```+\\s*\\{[.]?(r[a-zA-Z]*.*)\\}\\s*$$", chunk.end="^```+\\s*$$", inline.code="`r +([^`]+)\\s*`")

%.md : %.Rmd
    cd $$(dirname $<); Rscript -e 'knitr::knit_patterns[["set"]]($(KNITR_PATTERNS)); knitr::knit(basename("$<"),output=basename("$@"))'
```

Knitr and working directories
-----------------------------

Yihui says that `setwd()` is *evil*, because it is not reproducible.
`knit()` works from the directory the `.Rmd` file is in. You *can*
change the directory `knitr` works in using


``` {.sourceCode .R}
opts_knit$set(root.dir=NEW.DIR)
```

Since this is interpreted relative to the *working directory* of the R session
that calls knitr,
it may be best to always set
```{.R}
opts_knit$set(root.dir=".")
```
in templates.
(But, beware of any dependencies!)


*Note:* some people try to call `setwd()` within their `.Rmd` file. But,
`knitr` resets this for each chunk (and, chastises you!).


knitr and for loops
-------------------

If `knitr` doesn't always make plots/output every time around the for
loop, the problem might be there's an error or something early on?

Tables
------

One option: use `xtable` + `results="asis"`.

````` {.Rmd}
 ```{r results="asis"}
 library(xtable)
 dtab <- xtable( table( sample( letters, 300, replace=TRUE ) ) )
 print(dtab,type='html')
 ```
`````

More on templates
=================

Currently (8/17/2015), rmarkdown's `render` function [**cannot** be used](https://github.com/rstudio/rmarkdown/issues/499) for templates
that might be compiled at the same time with different data.
There is no workaround.
This is too bad, because render parses the YAML header,
and makes the resulting html look nice.
Let's look under the hood to see how to replicate it.
Here's the call to `pandoc`:

`pandoc`:
* `+RTS -K512m -RTS` : this increases pandoc's stack space
* `test2.utf8.md` : the input file
* `--to html` : the output format
* `--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures` : the input format
    * `+autolink_bare_uris` : Makes all absolute URIs into links.
    * `+ascii_identifiers` : Causes the identifiers produced by auto_identifiers to be pure ASCII.
    * `+tex_math_single_backslash` : Causes `\(\)` and `\[\]` to be displayed as math.
    * `-implicit_figures` : An image occurring by itself in a paragraph will be rendered as a figure with a caption.
* `--output one/one.html` : output file
* `--smart` : curly quotes, em and en dashes, and ellipses.
* `--email-obfuscation none`
* `--self-contained --standalone`
* `--section-divs` : Wrap sections in `<div>` tags.
* `--template /usr/local/lib/R/site-library/rmarkdown/rmd/h/default.html` : rmarkdown's template
* `--variable 'theme:bootstrap'` : variable to the template
* `--include-in-header /tmp/RtmpLnM0EY/rmarkdown-str65b85d06d7aa.html` : this does various things:
    * `<script src="/usr/local/lib/R/site-library/rmarkdown/rmd/h/jquery-1.11.0/jquery.min.js"></script>`
    * `<meta name="viewport" content="width=device-width, initial-scale=1" />`
    * `<script src="/usr/local/lib/R/site-library/rmarkdown/rmd/h/bootstrap-3.3.1/js/bootstrap.min.js"></script>`
    * `<script src="/usr/local/lib/R/site-library/rmarkdown/rmd/h/bootstrap-3.3.1/shim/html5shiv.min.js"></script>`
    * `<script src="/usr/local/lib/R/site-library/rmarkdown/rmd/h/bootstrap-3.3.1/shim/respond.min.js"></script>`
    * and includes [normalize.css](https://necolas.github.io/normalize.css/3.0.2/normalize.css)
* `--mathjax --variable 'mathjax-url:https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML'` : The template inserts mathjax itself.
* `--no-highlight --variable highlightjs=/usr/local/lib/R/site-library/rmarkdown/rmd/h/highlight` : Turn off pandoc highlighting and tell the template to do the highlighting.

We can trim this down to 
```
MATHJAX=/usr/share/javascript/mathjax/MathJax.js  # for local mathjax
PANDOC_OPTS="--to html --from markdown-implicit_figures \\
    --standalone --self-contained --section-divs --template template.html \\
    --variable 'theme:bootstrap' --include-in-header resources/header-scripts.html \\
    --mathjax --variable mathjax-url:$MATHJAX?config=TeX-AMS-MML_HTMLorMML'"
```

So, now to turn `input.Rmd` into `output.html`, in a safe way,
we can run
```
R --vanilla -e 'knitr::knit("input.Rmd",output="output.md")'
pandoc output.md ${PANDOC_OPTS} --output output.html
```


Formatting and layout
=====================

Customization
-------------

Options:

-   modify a [rmarkdown format](http://rmarkdown.rstudio.com/developer_custom_formats.html)

-   or a [pandoc template](http://pandoc.org/README.html#templates)


About math rendering
--------------------

There are [many options](http://pandoc.org/README.html#math), but
probably `--mathjax` is the best?

Note that it is supposed to render as far as possible with unicode, but
this m$a$y depend on the proper fonts being installed?


Other types of text: line blocks
--------------------------------

These are just markdown except it pays attention to linebreaks.

    | Molecular & Computational Biology
    | University of Southern California
    | 1050 Child Way, RRI 201 (MCB)
    | Los Angeles, CA 90089-2910

**produces**

| Molecular & Computational Biology
| University of Southern California
| 1050 Child Way, RRI 201 (MCB)
| Los Angeles, CA 90089-2910

Other types of text: definition lists
-------------------------------------

To make a **definition list**

:   Each term must fit on one line, which may optionally be followed by
    a blank line, and must be followed by one or more definitions. A
    definition begins with a colon or tilde, which may be indented one
    or two spaces.

    A term may have multiple definitions, and each definition may
    consist of one or more block elements (paragraph, code block, list,
    etc.), each indented four spaces or one tab stop. The body of the
    definition (including the first line, aside from the colon or tilde)
    should be indented four spaces.

Self-contained documents
------------------------

HTML documents can stitch together lots of different pieces: images,
css, javascript, etcetera. These are *not* nice to email.

*But:* `pandoc` can produce *self-contained* documents, that are
email-ready. `rmarkdown` does this by default.

*Warning:* the best way of displaying math relies on
[mathjax](http://mathjax.org), which is a "large" javascript library,
and is *not* included. If you use LaTeX math, you need to host a local
copy of mathjax.

Other technicalities
--------------------

-   **indentation** : one tab (four spaces) indicates a code block
    *except* within lists

-   **header attributes** can be specified by appending
    `{#identifier .class .class key=value key=value}` afterwards

    -   e.g. `{# foo .unnumbered}` makes a section that can be linked to
        with `[link to foo](#foo)` and is unnumbered
    -   but sections without identifiers will be assigned ones
        automatically

