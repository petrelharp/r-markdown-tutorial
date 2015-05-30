-----
title: "Narrowing the brain-publication barrier with R+markdown"
author: "Peter Ralph"
date: June 2, 2015
output: 
    ioslides_presentation : 
        selfcontained : true
        mathjax : local
        smaller : true
        transition : faster
-----


Markdown
========


Philosophy: just write
----------------------

**Goal:** 
don't even *think* about the layout,
just the content.

**Solutions:** 

    - unformatted text 
    - [markdown](http://commonmark.org/)
    - [LaTeX](http://latex-project.org/intro.html)

Markdown aims to be readable as-is, but *also* have methods to produce beautiful output. 
Obligatory quote:

> A Markdown-formatted document should be publishable as-is, as plain text, without looking like it’s been marked up with tags or formatting instructions. -- [John Gruber](http://daringfireball.net/projects/markdown/syntax#philosophy)


In other words, it's plaintext wysiwig.


No, really, don't think about the layout
----------------------------------------

Don't even *think* about the layout,
just the content.

> it is better to leave document design to document designers, and to let authors get on with writing documents -- [LaTeX](http://latex-project.org/intro.html)

Of course, you can tweak.

Today's goal:

1. Learn a few simple rules
2. and get going producing content.


Structuring text: what matters
------------------------------

**Principles:**

1.  Separate things with newlines.
2.  Pay attention to the number of spaces at the start of lines
3.  Don't worry about linebreaks.

If you're writing on a typewriter,
hitting carriage return
always starts a new line.

But, it's nice to have different (semantic) levels of spaces.

```
**Principles:**

1.  Separate things with newlines.
2.  Pay attention to the number of spaces at the start of lines
3.  Don't worry about linebreaks.

If you're writing on a typewriter,
hitting carriage return
always starts a new line.

But, it's nice to have different (semantic) levels of spaces.
```


Markdown syntax in one slide
----------------------------

```
Level-one header
================

Level-two header
----------------

Text formatting:

- **bold**
- *italics*
- ~~strikeout~~
- super^scripts^ and sub~scripts~
- `inline code`

Another level-two header
------------------------

This list is ordered

1.  and note that by indenting 
    
    subsequent content can be part of list items

2.  *indenting* means one tab, or four spaces

**Recommendation:** after using markdown for a little bit, 
follow [this link to the documentation](http://pandoc.org/README.html)
and spend half an hour reading it.

```


Markdown syntax in one slide, rendered
--------------------------------------

### Level-one header

#### Level-two header

Text formatting:

- **bold**
- *italics*
- ~~strikeout~~
- super^scripts^ and sub~scripts~
- `inline code`

#### Another level-two header

This list is ordered

1.  and note that by indenting 
    
    subsequent content can be part of list items

2.  *indenting* means one tab, or four spaces

    i)   and lists can be nested
    ii)  and have different numbering formats

**Recommendation:** after using markdown for a little bit, 
follow [this link to the documentation](http://pandoc.org/README.html)
and spend half an hour reading it.



Including math
--------------

As in 
[increasingly](http://meta.math.stackexchange.com/questions/2/tex-math-markup-is-sorely-needed) 
[many places](http://en.wikipedia.org/wiki/Help:Displaying_a_formula) 
these days,
you can just write math, in TeX,
surrounded by dollar signs.


```
For instance, $\frac{\pi}{4} = \sum_{n=0}^\infty \frac{(-1)^n}{2k+1}$.
```
For instance, $\frac{\pi}{4} = \sum_{n=0}^\infty \frac{(-1)^n}{2k+1}$.




Other types of text: code blocks
--------------------------------

    ```{.r}
    code(blocks)
    ```

**produces**

```{.r}
code(blocks)
```

Other types of text: blockquotes
--------------------------------

    > I also dream about a modern replacement for LaTeX 
    > designed from the ground up to target multiple output formats 
    > (at least PDF, HTML, EPUB). -- [John MacFarlane](http://john.macfarlane.usesthis.com/)

**produces**

> I also dream about a modern replacement for LaTeX 
> designed from the ground up to target multiple output formats 
> (at least PDF, HTML, EPUB). -- [John MacFarlane](http://john.macfarlane.usesthis.com/)


Gotchas
-------



For more info see [the documentation](http://pandoc.org/README.html#the-four-space-rule).



Technical notes: [Pandoc options](http://pandoc.org/README.html)
===============================


General
-------

    *  `-o (output file name)` : where to put output
    *  `--standalone` : produces a standalone document, not a code fragment (using one of [these](https://github.com/jgm/pandoc-templates) [templates](http://pandoc.org/README.html#templates))
    *  `--from=(format name)[+/-(extension name)]` : what to write out to (defaults to html) and optional turning on/off of various behavior, [listed here](http://pandoc.org/README.html#pandocs-markdown)
    *  `--include-in-header=(file name)` : at the end of the header, e.g. css, javascript, `\newcommand`, etc. (but see `--css`)
    *  `--include-before-body=(file name)` : at the beginning of the body, e.g. navigation bars, `\maketitle`, etc.


For presentations
-----------------

    *  `--selfcontained` : only for html output (but see `--mathjax`)
    *  `--mathjax[=URL]` : points to the `MathJax.js` script, *incompatible* with `--selfcontained`
    *  `--variable=KEY[:VAL]` : assign template variable KEY to VAL, for instance:

        *  `theme` : for beamer or reveal.js presentations
        *  but note these can be also [set in metadata](http://tex.stackexchange.com/questions/139139/adding-headers-and-footers-using-pandoc/139205#139205)

    *  `--incremental` : step through lists
    *  `--slide-level` : headers above this level create sections; below this create slides.
    *  `--css=(URL)` : include the css linked to

###  Other technicalities

    * **indentation** : one tab (four spaces) indicates a code block *except* within lists

    * **header attributes** can be specified by appending `{#identifier .class .class key=value key=value}` afterwards

        * e.g. `{# foo .unnumbered}` makes a section that can be linked to with `[link to foo](#foo)` and is unnumbered
        * but sections without identifiers will be assigned ones automatically 


About math rendering
--------------------

There are [many options](http://pandoc.org/README.html#math),
but probably `--mathjax` is the best?

Note that it is supposed to render as far as possible with unicode,
but this m$\alpha$y depend on the proper fonts being installed?



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

:  Each term must fit on one line, which may optionally be followed by a blank line, 
    and must be followed by one or more definitions. 
    A definition begins with a colon or tilde, which may be indented one or two spaces.

    A term may have multiple definitions, and each definition may consist of one or more block elements (paragraph, code block, list, etc.), each indented four spaces or one tab stop. The body of the definition (including the first line, aside from the colon or tilde) should be indented four spaces.

