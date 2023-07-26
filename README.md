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

- As a matter of style, we enclose math definitions, theorems and the like into blockquotes:
    ```markdown
    > An object $...$ is *a definition* if $...$ such that:
    >
    >$$
    >display math
    >$$


    ```