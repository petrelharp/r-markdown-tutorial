---
title: Looking for markdown gotchas
author: Peter Ralph
date: June 2, 2015
---


# Unintended consequences

Can I link to [other sections](#another-sub-section)?

This text
 incrementally
  increases
   the number
    of leading
     spaces.

How do lists work?
1.  this one
2.  does not 
3.  start with a blank line
    * nor this sublist

1. this list does
2. and might get confused with the previous
    * and has a sublist
    * with bullets

1. and so does this one
2. but only one leading line 
3. so might also be confused


1. this one, however
2. starts with **two** leading lines
3. is it separate?

Here's another list.

1. this one begins
2. with a blank line
    and contains entries with multiple lines

    and multiple paragraphs
        and even indented code blocks

        ... right?

 

1.  Can a single space start a new list? *(no)*
2.  What if
    my text block within a list

    has unindented lines? *(no biggie)*


How do you even put a code block directly after a list, then?  [Oh, I see.](http://pandoc.org/README.html#ending-a-list)

## A sub-section: math

Math?

Greek variables, like $\pi$, just work?

Wrap standalone fomulas with *two* dollar signs,
for instance:
$$
\begin{align}
\frac{\pi}{4} = \sum_{n=0}^\infty \frac{(-1)^n}{2k+1} .
\end{align}
$$

What's the difference between double ($$\sum_{k=1}^n k$$) and single ($\sum_{k=1}^n k$)dollar signs?


```
For instance, $\frac{\pi}{4} = \sum_{n=0}^\infty \frac{(-1)^n}{2k+1}$.
```
For instance, $\frac{\pi}{4} = \sum_{n=0}^\infty \frac{(-1)^n}{2k+1}$.



## Another sub-section


![thanks, internet](cat-pandoc.jpg)

![smaller?](cat-pandoc.jpg cat){width=1in}
