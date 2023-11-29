---
layout: post
title: Mechanics of intent solving II - Obstructions to Compositionality
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

<div class="definition" markdown="1">
*Compositionality* is the study of why and how proprieties of a given system can be inferred from the proprieties of its parts. Dually, it is the study of how to lift proprieties of smaller systems to the propriety of the system obtained by composing them in some way.
</div>

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

In a nutshell, we will formalize the problem of compositionality as asking if a given *(op-)lax functor* representing our problem is *strong*.  Most importantly, we'll develop a formal toolkit to provide qualitative information about what goes wrong when this requirement fails. But to make sense of all this, I first need to tell you what all these mysterious terms are.

### Categories

Functors are mappings between categories. So, let's start by defining what a category is:

<div class="definition" markdown="1">
A *Category* is a mathematical structure composed of:
- A bunch of *objects*, denoted $A, B, \dots$. You can see objects as systems or entities you care about (e.g. graphs or sets);
- A bunch of morphisms connecting objects, denoted $f: A \to B$. You can see morphisms as way to turn an object into another (e.g. a graph homomorphism or a function between sets);
- For each object $A$, an identity morphism $id: A \to A$, which can be thought of as 'the transformation that doesn't change anything';
- A composition operation that takes two morphisms $A \xrightarrow{f} B$ and $B \xrightarrow{g} C$ and returns a morphism $A \xrightarrow{f;g} C$.

Moreover, the following laws need to be satisfied:
- Composing with the identity does nothing: 
$$
\begin{align*}
    A \xrightarrow{id_A} A \xrightarrow{f} B &= A \xrightarrow{f} B \\
    A \xrightarrow{f} B \xrightarrow{id_B} B &= A \xrightarrow{f} B
\end{align*}
$$
- Composition is associative: $(f;g);h = f;(g;h)$
</div>

Basically, a category is a bunch of 'things' and 'structure-preserving maps between them', which can be composed. We require that 'leaving a thing as is' always preserves its structure. A lot of things in mathematics form categories, but what we really care about is ways to map categories to other categories.

The reason is because many problems we care about can be expressed as some sort of mapping between categories:

$$
F: \text{syntax} \to \text{semantics}
$$

Here,*syntax* is a category telling us how some stuff we care about composes, whereas *semantics* is a category of meanings of some sort. $F$ expresses the fact that we can map any syntactic entity on the left to a meaning on the right, in a way that is compatible with how objects on the left and on the right compose.

#### Spelled out example: Open graphs

To have a better grasp of what's going on, consider the following problem. An *open graph* is a graph as below:

![Example of open graph]()

Intuitively, it is a graph with 'open interfaces', in this case the sets $\\{1\\}$ and $\\{1,2,3\\}$. Indeed, these graphs can be seen as *transformations* between the interfaces, and if the interfaces match, they can be composed:

![Open graph composition]()

For each interface, there is an identity open graph that just connects each vertex with itself:

![Identity open graph]()

<div class="proposition" markdown="1">
Interfaces and open graphs between them form a category, denoted **OpenGrph**.
- Objects are interfaces;
- Morphisms are open graphs between them;
- Identities are identity open graphs as depicted above;
- Composition works as depicted above.
</div>

Now, suppose that we want to map each graph on the *reachability* relation on it. This means that, for instance, we want to map the open graph:

![Example of open graph]()

to a relation between the sets $\\{1\\}$ and $\\{1,2,3\\}$ such that an element in $\\{1\\}$ is related to an element in $\\{1,2,3\\}$ only if the corresponding open graph connects them. We see that, in this case, this relation is empty, since there is no way to reach any point in the right interface if you start from the left interface.

The recipe we're concocting is the following:
- Each interface gets mapped to itself;
- An open graph $A \xrightarrow{G} B$ gets mapped to a relation $RG$ between $A$ and $B$ (that is, formally, a set $R \subseteq A \times B$) such that $a \in A$ and $b \in B$ are related if and only if one can go from $a$ to $b$ via $G$.

As sets and relations between them also form a category, called **Rel**, relations can be composed. So we see that, when an open graph arises as the composition of two other open graphs, we can either evaluate the reachability relation on the components, and then compose the relations, or evaluate the reachability on the graph composition. Ideally, we would like these two operations to be the same, but they are not. To see why, let's look again at the picture above:

![Open graph composition]()

Call the graph on the left $G$ and the graph in the center $H$. The graph on the right is their composition, $G;H$. If we map each graph on the reachability relation on it, then $G$ goes to the relation $\\{1\\} \xrightarrow{RG} \\{1,2,3\\}$, which as we already remarked is emtpy. Similarly, $H$ goes to the empty relation $\\{1,2,3\\} \xrightarrow{RH} \\{1\\}$. These two can be composed into a relation $\\{1\\} \xrightarrow{RG;RH} \\{1\\}$ which, being the composition of two empty relations, is itself empty. ...On the other hand, if we evaluate the relation $\\{1\\} \xrightarrow{R(G;H)} \\{1\\}$, this amounts to compute the reachability relation between the interfaces connected by the graph $G;H$ of the picture above. This relation is not empty at all, since we can clearly go from the $1$ on the left to the $1$ on the right!

So, we have $RG;RG \subseteq R(G;H)$, and the intuitive reason for this is that in composing $G;H$ we created a 'zig-zag path' that wasn't there before. 

### Compositionality as a lax functor

With this, we established that the reachability problem is non-compositional: evaluating reachability on the components misses out some solutions (in this case *all of them* on the composite. Moreover, in the example above,  we also established that not only $RG;RG \neq R(G;H)$, but also $RG;RG \subseteq R(G;H)$, so 'evaluating on the components and then composing' is related in some way with 'evaluating on the composition'.

Formally, we say that we have a *lax functor* $\mathbf{OpenGrph} \to \mathbf{Rel}$. In more formal terms, this amounts more or less to the following (modulo natural transformations, bicategories and similar things that are too complicated to define in this post):

<div class="definition" markdown="1">
Given categories $\mathcal{C}, \mathcal{D}$, a *lax functor* $F: \mathcal{C} \to \mathcal{D}$ is given by:
- A mapping from the objects of $\mathcal{C}$ to the objects of $\mathcal{D}$;
- A mapping from the morphisms of $\mathcal{C}$ to the morphisms of $\mathcal{D}$, such that:
    - If $F$ maps $A \mapsto FA$ and $B \mapsto FB$, then $f: A \to B$ gets mapped to $Ff: FA \to FB$. That is, mapping respects 'source' and 'target' of a morphism;
    - Identities in $\mathcal{D}$ are connected to the mappings of the identities in $\mathcal{C}$: There is some morphism  $id_{FA} \to Fid_A$;
    - Composing in $\mathcal{C}$ and then mapping is connected with composing the mappings in $\mathcal{D}$: There is some morphism $Ff;Fg \to F(f;g)$.

Alternatively, we say that $F$ is *oplax* if the arrows in the above definition go in the opposite direction, that is, if for every $A,f,g$ it is $Fid_A \to id_{FA}$ and $F(f;g) \to Ff;Fg$.
</div>

This seems a bit convoluted. Indeed, in the definition above, what we'd like to simply have $id_{FA} = Fid_A$ and $Ff;Fg = F(f;g)$ - that is, identities get carried to identities and the evaluation on the composition is the composition of the evaluations. When this happens, we say that $F$ is a *strict functor*, or just a *functor*. The next best thing, which is morally equivalent to having a strict functor, is to require $F$ to be *strong*. This means that for each $A,f,g$ the morphisms $id_{FA} \to Fid_A$ and $F(f;g) \to Ff ; Fg$ are *invertible*, or, as we say in jargon,*isomorphisms*. In practice, requiring these morphisms to be invertible means that we can freely go back and forth from $id_{FA}$ to $Fid_A$ without losing information, and similarly for $F(f;g)$ and $Ff ; Fg$. Examples of familiar invertible morphisms are bijections between sets or, for the mathematically versed, isomorphisms of groups, or homeomorphisms of topological spaces.

The reason why I am bothering you with all these definitions is that:

> We can formalize many useful problems, such as composing paths - and thus (de)composing intents, for that matter - as (op-)lax functors:
>
>$$F: \mathcal{C} \to \mathcal{D}$$
>
> These problems are *compositional* - that is, they can be solved for the components and then the solution spaces can be glued together - precisely when $F$ is strong or strict.


Ok, so the problem of why a problem fails to be compositional can be reduced to the problem of why some particular functor $F$ fails to be strong. This, in turn, can be reduced to the problem of understanding why the morphisms $id_{FA} \to Fid_A$, $Ff;Fg \to F(f;g)$ fail to be invertible.

...But generalizing even further, this means that if we manage to develop a general theory characterizing why a given morphism $f:A \to B$ in an *arbitrary* category fails to be invertible, then we can piggyback to our original problem (as the arrows involved in the definition of a lax functor also live in some category!)

### Reducing invertibility to terminality

Ok, so our new problem at hand is: Given a morphism $f: A \to B$, when is it invertible? First of all, a formal definition:

<div class="definition" markdown="1">
A morphism $f: A \to B$ in a category $\mathcal{C}$ is called *invertible*, or an *isomorphism* if there is another morphism $f^{-1}: B \to A$ such that:

$$
\begin{align*}
A \xrightarrow{f} B \xrightarrow{f^{-1}} A &= A \xrightarrow{id_A} A\\
B \xrightarrow{f^{-1}} A \xrightarrow{f} B &= B \xrightarrow{id_B} B
\end{align*}
$$
</div>

Now, notice this: If $f:A \to B$ is invertible, then for any other morphism $g:X \to B$ there is a morphism $h: X \to A$ for which we have $g = h;f$, or, as we category theorists like to say, for which this diagram *commutes*:

Indeed, it is enough to define $h = g;f^{-1}$, and to notice that:

In jargon, we say that *$f$ is invertible if every $g$ factors through $f$ uniquely*. This theorem is an if and only if, meaning that if $f$ is not invertible, then there will always be some $g: X \to B$ for which this is not true. There are two ways in which this can fail:
- g doesn't factor through $f$ at all, that is, there is no $h$ that makes the triangle above commute;
- g factors through $f$ in multiple ways, that is, there are at least two $h_1 \neq h_2$ for which the triangle above commutes.