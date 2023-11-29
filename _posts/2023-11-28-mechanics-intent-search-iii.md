---
layout: post
title: Mechanics of intent solving III - Obstructions to Compositionality
author: Fabrizio Genovese
categories: [intents, search, physics, lagrangian]
excerpt: Where we try to apply grad topology to the world of intent solving.
image: assetsPosts/2023-07-26-lagrangian-intent-search-i/greedyAction.png
usemathjax: true
thanks: I want to thank Caterina Puca, Amar Hadzihasanovic and Bob Coecke, without which this piece of formal theory would not have been developed.
---

Part of the 20[ ] team has been busy in the last week with a research retreat around *obstructions of compositionality*. In this post, I'll explain how this has a direct role in better understanding intent search.

## Recap and Introduction

If you recall, a few months ago we gave a [Lagrangian account](/lagrangian-intent-search-i) of what intent solving was. To recap:

- We have a graph where:
  -  vertexes are (EVM) states;
  -  edges represent actions that lead from a state to another (e.g. calling a function with a given payload);
- An intent specifies a couple of regions in this graph:
  - One region indentifies the *premises* of the intent, that is, the states in which intent search can be triggered;
  - The other region identifies the *conclusions* of the intent, that is, the states that the intent proposer considers as acceptable solutions;
- Solving the intent means finding a path connecting these regions;
- The intent solver wants to find the path that best maximizes its revenue, or any other utility function (e.g. welfare).

This is a hard problem, and we'd really like it to be compositional. *Compositionality* is a pervasive problem in engineering in general and in crypto in particular. In a very handwavy way, we can say that:

{% def %}
*Compositionality* is the study of why and how proprieties of a given system can be inferred from the proprieties of its parts. Dually, it is the study of how to lift proprieties of smaller systems to the propriety of the system obtained by composing them in some way.
{% enddef %}

To break this down even further, we usually build complex systems by first building some pieces in isolation and then by gluing them together (this is very well known to developers that first implement modules and libraries and then tie everything together into a final product). This is known as 'modularity', and I have written about how this is different from compositionality [before](
https://medium.com/statebox/modularity-vs-compositionality-a-history-of-misunderstandings-be0150033568).
Indeed, compositionality means modularity in that we want some proprieties of the components (e.g. being 'safe' according to some spec) to lift to the composed system ('a system made by composing safe components should be safe').

Simple examples of non-safe modular systems are:
  - Plugs and sockets: You can stick a needle into a socket and get electrocuted. So the system is modular (the needle fits the socket) but non-compositional with respect to safety.
  - Gas tanks: Again, you can pour any fluid into a car's gas tank using a funnel, which makes the system modular. Still, the composite system (fluid-into-funnel-into-car) is not necessarily compositional wrt the car ever starting again.


## Why should I care?

The reason why compositionality is relevant for us, is that solving intents compositionally is a powerful thing:

> Suppose you have an intent, expressed as the problem of finding the 'best' path to go from region $A$ to region $B$ of some graph, according to some definition of 'best'. Ideally, we would like to:
- Finding some intermediate regions $I_0, \dots, I_n$;
- Finding the best paths from $A$ to $I_0$, from $I_0$ to $I_1$ and so on, all the way up to $I_n$, $B$;
- Having a way to glue these paths together, such that the resulting path is the best path from $A$ to $B$.

In the context of [Lagrangian intents](/lagrangian-intent-search-i), this means that given an intent from the perspective of a solver $\mathfrak{s}$, that is, a triple $(T^\mathfrak{i,s} S, S^\mathfrak{i,s}_i, S^\mathfrak{i,s}_f)$, and given some Lagrangian $\mathcal{L}$ defining our concept of 'best', we would like to be able to split the search problem into subproblems, in such a way that finding paths that minimize the Lagrangian action $\mathcal{A}^\mathfrak{s}$ for the subproblems results in a path that minimizes $\mathcal{A}^\mathfrak{s}$ for the overall intent.

As you can see, having a compositional account of intent solving is a powerful concept, because:
- It gives us a hell of a computational advantage, since we know we can break a complicated intents into computationally simpler pieces and solve them separately;
- It gives an easy way to bundle intents, as we can solve single intents separately and then bundle the solutions together, while being reassured that no single intent gets solved suboptimally.


### ...But is this possible?

Compositionality is a very powerful property to have, and it is rarely satisfied in practice. That is, the class of problems that are truly compositional is rather small. I have been studying compositionality in abstract terms for the last 8 years, and recently, together with some colleagues, we've been increasingly focusing on characterizing 'obstructions' to compositionality: That is, we want to understand why compositionality fails for a given problem. Hopefully, this sort of information is useful to pinpoint subclasses of problems that exhibit less pathological behavior.

In the context of intent solving, this could mean that solving and bundling general intents is a computationally very hard problem, but focusing on particular subclasses of intents - such as atomic swaps - removes many computational difficulties, making the restricted problem approachable.

That is, the formal study of obstructions to compositionality can be a useful tool to inform an intent solver about where are the low hanging fruits one can focus on.


## Setting the stage

In this post, I'll explain the approach to obstructions of compositionality that I have worked out with several coauthors in [this paper](https://arxiv.org/abs/2307.14461). I redirect you there for a more formal treatment of this topic.


### Open Graphs

To illustrate how our technique works, let's consider the following example. 

{% ex %}
An *open graph* is a graph as below:

{% tikz %}
    \rotatebox{0}{
        \scalebox{1}{
            \begin{tikzpicture}
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$1$}] (al1) at (-2,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$1$}] (ar1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$2$}] (ar2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$3$}] (ar3) at (0,-2) {};
                        \draw[thick] (al1) to (ar1);
                        \draw[thick, out=180, in=180, looseness=2] (ar2) to (ar3);
            \end{tikzpicture}
        }
    }
{% endtikz %}

Intuitively, it is a graph with 'open interfaces', in this case the sets $\\{1\\}$ and $\\{1,2,3\\}$.
{% endex %}

{% ex {"id":"exOpenGraphs"} %}
If we have two open graphs, and if their interfaces match:

{% tikz %}
    \rotatebox{0}{
        \scalebox{1}{
            \begin{tikzpicture}
                \begin{scope}[xshift=-2cm]
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$1$}] (al1) at (-2,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$1$}] (ar1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$2$}] (ar2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$3$}] (ar3) at (0,-2) {};
                        \draw[thick] (al1) to (ar1);
                        \draw[thick, out=180, in=180, looseness=2] (ar2) to (ar3);
                \end{scope}
                \begin{scope}[xshift=2cm]
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$1$}] (br3) at (2,-2) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$1$}] (bl1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$2$}] (bl2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$3$}] (bl3) at (0,-2) {};
                        \draw[thick, out=0, in=0, looseness=2] (bl1) to (bl2);
                        \draw[thick] (bl3) to (br3);
                \end{scope}
            \end{tikzpicture}
        }
    }
{% endtikz %}

Then they can be composed:

{% tikz %}
    \rotatebox{0}{
        \scalebox{1}{
            \begin{tikzpicture}
            \begin{scope}[xshift=0cm]
                \begin{scope}[xshift=-0cm]
                    \node[circle, fill, minimum size=5pt, inner sep=0pt,label=left:{$1$}] (al1) at (-2,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt] (ar1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt] (ar2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt] (ar3) at (0,-2) {};
                        \draw[thick] (al1) to (ar1);
                        \draw[thick, out=180, in=180, looseness=2] (ar2) to (ar3);
                \end{scope}
                \begin{scope}[xshift=0cm]
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$1$}] (br3) at (2,-2) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt] (bl1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt] (bl2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt] (bl3) at (0,-2) {};
                        \draw[thick, out=0, in=0, looseness=2] (bl1) to (bl2);
                        \draw[thick] (bl3) to (br3);
                \end{scope}
            \end{scope}
            \end{tikzpicture}
        }
    }
{% endtikz %}

{% endex %}

Now, suppose that we want to map each graph to the *reachability* relation between its interfaces. This means that, for instance, we want to map the open graph:

{% tikz %}
    \rotatebox{0}{
        \scalebox{1}{
            \begin{tikzpicture}
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=left:{$1$}] (al1) at (-2,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$1$}] (ar1) at (0,0) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$2$}] (ar2) at (0,-1) {};
                    \node[circle, fill, minimum size=5pt, inner sep=0pt, label=right:{$3$}] (ar3) at (0,-2) {};
                        \draw[thick] (al1) to (ar1);
                        \draw[thick, out=180, in=180, looseness=2] (ar2) to (ar3);
            \end{tikzpicture}
        }
    }
{% endtikz %}

to a relation between the sets $\\{1\\}$ and $\\{1,2,3\\}$. This relation works as follows: an element in $\\{1\\}$ (yes,there's only one) is related to an element in $\\{1,2,3\\}$ if only if the corresponding open graph connects them. We see that, in this case, this relation is empty, since there is no way to reach any point in the right interface if you start from the left interface.

As we can compose open graphs if their interfaces match, so we can compose relations:

{% def {"id":"defRelComp"} %}
Suppose that you have a relation $R$ between sets $A$ and $B$, and a relation $S$ between sets $B$ and $C$. Then we can obtain a composed relation $R;S$ between sets $A$ and $C$ by setting:

**$a \in A$ is related to $c \in C$ through $R;S$ if and only if there exists $b \in B$ such that $a \in A$ is related to $b \in B$ through $R$ and $b \in B$ is related to $c \in C$ through $S$:**

$$
(a,c) \in R;S \iff \exists b \in B. ((a,b) \in R \wedge (b,c) \in S).
$$
{% enddef %}

So we see that, when we have two composable open graphs, we can either evaluate the reachability relations on the components, and then compose the relations, or compose the graphs first and then evaluate the reachability on the composition. Ideally, we would like these two operations to be the same, since if calculating the reachability relation scales badly with respect to the size of the graph, we see could get a big computational advantage in calculating the relation on the components and then gluing them together instead of having to compute it for the big graph itself.

Alas, this is not the case. To see why, let's look again at the picture in [Example 2](#exOpenGraphs):
Call the graph on the to left $G$ and the graph on the top right $H$. The graph at the bottom is their composition, $G;H$. If we map each graph to the reachability relation on it, then $G$ goes to the relation $\\{1\\} \xrightarrow{\mathfrak{R}G} \\{1,2,3\\}$, which as we already remarked is emtpy. Similarly, $H$ goes to the empty relation $\\{1,2,3\\} \xrightarrow{\mathfrak{R}H} \\{1\\}$. These two can be composed into a relation $\\{1\\} \xrightarrow{\mathfrak{R}G;\mathfrak{R}H} \\{1\\}$, and applying [Definition 2](#defRelComp) above, you can see how this relation is itself empty. ...On the other hand, if we evaluate the relation on the composite $\\{1\\} \xrightarrow{G;H} \\{1\\}$, this amounts to compute the reachability relation between the interfaces connected by the graph $G;H$ of the picture above. This relation is not empty at all, since we can clearly go from the $1$ on the left to the $1$ on the right!

So, we have $\mathfrak{R}G;\mathfrak{R}G \subseteq \mathfrak{R}(G;H)$, and the intuitive reason for this is that in composing $G;H$ we created a 'zig-zag path' that wasn't there before. 

With this, we established that the reachability problem is non-compositional: evaluating reachability on the components misses out some solutions (in this case *all of them*) on the composite. Moreover, in the example above, we also established that there is a function $\mathfrak{R}G;\mathfrak{R}G \subseteq \mathfrak{R}(G;H)$ - in this case even more than a function, an inclusion - and that compositionality fails precisely because this function is not invertible - that is, it is not a bijection.

This example is not an outlier: Indeed, almost all compositional problems can be rephrased in a similar way. Formally, the recipe is as follows:

- We organize our problem and solution domains (in the case above open graphs and relations) into mathematical structures called *categories*;
- We encode our problem into a mapping between these categories (as we mapped open graphs to their reachability relations above);
- This mapping will be almost invariably a *lax* or an *oplax functor*;
- Our problem is compositional precisely when this (op-)lax functor is *strong*;
- Characterizing obstructions to compositionality means characterizing obstructions for this functor to be strong.

There are a lot of definitions in the list above (*category*,*functor*) that would require a lot of time to unpack, but this is not important at the moment: What is important is to understand that a lax functor is strong precisely when a particular 'function' (more precisely a *morphism* in some *category of functors and natural transfomations between them*) is invertible.

So, precisely as we can characterize obstructions to compositionality in the open graph problem by studying obstructions to some function being invertible, so we can study obstructions to compositionality for *any* problem by studying if some *morphism* (that is, a fancier definition of function) is invertible. All this is to say that, what we are doing here in this toy example directly generalizes to much more complicated classes of problems.


## From invertibility to terminality

> In the following, I will use the word *morphism* quite a lot. *morphisms* are just a generalization of the concept of function. Functions are defined between sets, e.g. $A \xrightarrow{f} B$ is a function from set $A$ to set $B$. More generally, morphisms are defined between *objects* in some environment called a *category*. If this confuses you, in the reminder of this post, you can think 'function' every time you read 'morphism'.

Ok, so our new problem at hand is: Given a morphism $f: A \to B$, when is it invertible? First of all, a formal definition:

{% def %}
A morphism $f: A \to B$ in a category $\mathcal{C}$ is called *invertible*, or equivalently an *isomorphism*, if there is another morphism $f^{-1}: B \to A$ such that:

$$
\begin{align*}
A \xrightarrow{f} B \xrightarrow{f^{-1}} A &= A \xrightarrow{id_A} A\\
B \xrightarrow{f^{-1}} A \xrightarrow{f} B &= B \xrightarrow{id_B} B
\end{align*}
$$
{% enddef %}

> We see that this definition of invertibility, in the case of functions, coincides precisely with what we expect: A function is invertible precisely when it is bijective (here $id_A$ is just the function that sends any element of $A$ to itself).

Now, notice this: If $f:A \to B$ is invertible, then for any other morphism $g:X \to B$ there is a morphism $h: X \to A$ for which we have $g = h;f$, or, as we category theorists like to say, for which this diagram *commutes*:

{% quiver {"id":"commutingTriangle"} %}
<!-- https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoIiwxXV0= -->
<iframe class="quiver-embed" src="https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoIiwxXV0=&embed" width="432" height="432" style="border-radius: 8px; border: none;"></iframe>
{% endquiver %}

Indeed, it is enough to define $h = g;f^{-1}$, and to notice that:
{% quiver %}
<!-- https://q.uiver.app/#q=WzAsNCxbMCwwLCJYIl0sWzQsMCwiQSJdLFsyLDIsIkIiXSxbMiwwLCJCIl0sWzEsMiwiZiIsMV0sWzAsMiwiZyIsMV0sWzAsMywiZyIsMV0sWzMsMSwiZl57LTF9IiwxXSxbMywyLCJpZF9CIiwxLHsic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFswLDEsImgiLDEseyJjdXJ2ZSI6LTR9XV0= -->
<iframe class="quiver-embed" src="https://q.uiver.app/#q=WzAsNCxbMCwwLCJYIl0sWzQsMCwiQSJdLFsyLDIsIkIiXSxbMiwwLCJCIl0sWzEsMiwiZiIsMV0sWzAsMiwiZyIsMV0sWzAsMywiZyIsMV0sWzMsMSwiZl57LTF9IiwxXSxbMywyLCJpZF9CIiwxLHsic3R5bGUiOnsiaGVhZCI6eyJuYW1lIjoibm9uZSJ9fX1dLFswLDEsImgiLDEseyJjdXJ2ZSI6LTR9XV0=&embed" width="800" height="500" style="border-radius: 8px; border: none;"></iframe>
{% endquiver %}

> Again, in the case of functions, $X \xrightarrow{h} A \xrightarrow{f} B$ just denotes function composition (apply $h$, then apply $f$). With this intuition in mind, interpreting these diagrams should be easy.

In jargon, we say that *$f$ is invertible if every $g$ factors through $f$ uniquely*. So, we have:

{% prop %}
A morphism $f:A \to B$ is invertible if and only if any other morphism $g:X \to B$ factors through it.
{% endprop %}

This proposition is an if and only if, meaning that if $f$ is not invertible, then there will always be some $g: X \to B$ for which this is not true. On the other hand, such a $g$ can be seen as an *onstruction* to $f$'s invertibility.

There are two ways in which such a $g$ can fail to factor uniquely through $f$:
- g doesn't factor through $f$ at all, that is, there is no $h$ that makes the triangle in [Figure 1](#commutingTriangle) commute:
    {% quiver %}
    <!-- https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCI/Pz8iLDEseyJjb2xvdXIiOlswLDYwLDYwXX0sWzAsNjAsNjAsMV1dXQ== -->
    <iframe class="quiver-embed" src="https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCI/Pz8iLDEseyJjb2xvdXIiOlswLDYwLDYwXX0sWzAsNjAsNjAsMV1dXQ==&embed" width="432" height="432" style="border-radius: 8px; border: none;"></iframe>
    {% endquiver %}
- g factors through $f$ in multiple ways, that is, there are at least two $h_0 \neq h_1$ for which the triangle in [Figure 1](#commutingTriangle) commutes:
    {% quiver %}
    <!-- https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoXzAiLDEseyJjdXJ2ZSI6LTJ9XSxbMCwyLCJoXzEiLDEseyJjdXJ2ZSI6Mn1dXQ== -->
    <iframe class="quiver-embed" src="https://q.uiver.app/#q=WzAsMyxbMCwwLCJYIl0sWzEsMiwiQiJdLFsyLDAsIkEiXSxbMCwxLCJnIiwxXSxbMiwxLCJmIiwxXSxbMCwyLCJoXzAiLDEseyJjdXJ2ZSI6LTJ9XSxbMCwyLCJoXzEiLDEseyJjdXJ2ZSI6Mn1dXQ==&embed" width="432" height="432" style="border-radius: 8px; border: none;"></iframe>  
    {% endquiver %}

Now, the conceptually hard part. If you squint your eyes enough, you'll notice that the morphism $h$ in [Figure 1](#commutingTriangle) is somehow a 'morphism between morphisms': What I mean is that, through $h$, we can map $g$ into $f$. So yes, $h$ goes from $X$ to $A$, but changing perspective, we could also write:

$$
h: g \to f.
$$

Embracing these perspective, we can depict morphisms to a fixed object $B$ (such as $f$ and $g$) as points of some space (or object of a category, for the mathematically aware), and morphisms that make the triangles as the one in [Figure 1](#commutingTriangle) commute as paths (morphimsms) in this space.

Having taken this conceptual leap, saying that $f:A \to B$ is invertible amounts to say that for any other point of this space, there is *exactly one path to $f$*. For the mathematically versed, this is made formal by saying that:

{% prop {"id":"isoInSliceCat"} %}
A morphism $f:A \to B$ in a category $\mathcal{C}$ is invertible if and only if it is a terminal object in the slice category $\mathcal{C}/B$.
{% endprop %}

So, there you have it: We transformed our problem once more: Instead of studying obstructions to invertibility directly, we need to study obstructions to terminality, that is:

> A point in some space (e.g. a topological space, or a graph) is terminal precisely when, for any other point, there is exactly one way to reach it.
>
> Can we qualitatively describe obstructions for a point to have this propriety?