# README

20[ ] blog website, based on the [Reverie](https://jekyllthemes.io/theme/reverie) theme by Amit Merchant.

## Usage

Posts must be placed in the `_posts` folder. Post titles follow the convention `yyyy-mm-dd-title.md`. Post assets (such as images) go in the folder `assetsPost`, where you should create a folder with the same name of the post.

Each post should start with the following preamble:
```yaml
---
layout: post
title: the title of your post
author: your name. Autor defaults to '20[ ] team' if left blank
categories: keyword or a list of keywords [keyword1, keyword2, keyword3]
excerpt: A short summary of your post
usemathjax: true (omit this line if you don't need to typeset math)
thanks: A short acknowledged message. It will be shown immediately above the content of your post.
---
```

As for the content of the post, it should be typeset in markdown.
- Inline math is shown by using `$ ... $`. Notice that some expressions such as `a_b` typeset correctly, while expressions like `a_{b}` or `a_\command` sometimes do not. I guess this is because mathjax expects `_` to be followed by a literal.
- Display math is shown by using `$$ ... $$`. The problem above doesn't show up in this case, but you gotta be careful:
    ```markdown
    text
    $$ ... $$
    text
    ```
    does not typeset correctly, whereas:
    ```markdown
    text

    $$
    ...
    $$

    text
    ```
    does. You can also use environments, as in:
    ```
    $$
    \begin{align*}
     ...
    \end{align*}
    $$
    ```

## LaTeX-like theorem environments

We provide the following theorem environments: Definition, Proposition, Lemma, Theorem and Corollary. If you need others, just ask. The way these works is as follows:
```html
<div class="definition" markdown="1">
A *definition* is a blabla, such that: $...$. Furthermore, it is:

$$
...
$$

</div>
```

This gets rendered as a shaded box with your content inside, prepended with a bold **Definition.**. We don't have numbering yet, but we'll think about it should the need arise. Just swap `definition` inside the `class="..."` field above with `proposition`, `lemma`, `theorem` and `corollary` should you need those.

## Images

Whenever possible, we recommend the images to be `800` pixels in width, with **transparent** backround. Ideally, these should be easily readable on the light gray background of the blog website. You can strive from these guidelines if you have no alternative, but our definition and your definition of 'I had no alternative' may be different, and *we may complain*.