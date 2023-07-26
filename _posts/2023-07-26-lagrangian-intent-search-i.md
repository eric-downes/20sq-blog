---
layout: post
title: Lagrangian mechanics of intent search I
author: Fabrizio Genovese
categories: [intents, search, physics, lagrangian]
usemathjax: true
---

*I want to thank my fellow team members at 20[ ] and the guys at Anoma, Blockswap and Frontier Research for the useful discussions that helped me shaping what follows.*

If you have been around MEV-related circles at EthCC this summer, you may have heard many people coming to the conclusion that 'defining intents is easier, solving them is harder'. This is clearly wrong, as the two things are not independent: Defining what intents are defines how difficult solving them is. Indeed, it is a very well known fact since at least the dawn of computer science that the more expressive a formal language is, the more difficult it is to decide statements - that is, to establish if a statement can or cannot be proved - in the corresponding mechanism recognizing the language; this concept is known as [Chomsky hierarchy](https://en.wikipedia.org/wiki/Chomsky_hierarchy). Indeed, if your language is really simple - e.g. you say that the only acceptable intents are transactions in the 'traditional' sense - then solving them is even simpler, since there is nothing to solve. So, a truer statement would be that 'as the expressivity of the intent language grows, so do grow the intellectual and computational burdens for the searchers that have to solve them.

...But what are intents, and what does it mean to solve them? I think it would be useful to define a formal framework to state this problem. Hopefully, this framework will also turn into something practically useful at some point. Again, if you were around EthCC this summer, you may also have stumbled into me saying that 'intents can be formalized with a mix of algebraic topology and general relativity'. Unfortunately, I was wrong, and what seems to do the job instead is a mix of topology together with my least favourite part of maths after number theory: Lagrangian mechanics.

## What are intents?

### The recap for absolute dummies

*Since I'm talking to two different crowds, maths people that know nothing about crypto and crypto people that know very little mathematics, I'm going very slow. If you work in MEV-land just skip this part!*

In blockchain tech, you get things done via *transactions*. A transaction is, conceptually, nothing more than a way to change the blockchain state. For example, when you want to pay someone in crypto, you create a transaction that has the effect of decreasing your balance and increasing the balance of the payee accordingly.

Things become more complicated in blockchains like Ethereum, where you have *smart contracts* around. Here, transactions can call contract functions, so you can use transactions to, say, swap a number of tokens A for a suitable number of tokens B by calling some smart contract that does exactly this job.

...But *which* contract should you call? The problem is that there may be *many* ways to do so, e.g. there may be many different decentralized exchanges offering you different prices for the swap.
So, the problem for the user becomes: 'Say I have a goal, e.g. swapping some tokens. Which is the *best* way to do so? Which transaction should I come up with to get the best deal I can?'

### Intents, informally

Simply put, the idea of intents is that instead of specifying a transaction, you just specify a goal. You have a language to say 'I want to give away no more than $n$ tokens A and I want to receive no less than $m$ tokens B.' Then you, the *intent provider*, broadcast this statement to a network of *intent searchers*, which will compete to find the best transaction that does the job for you. So, intents are a way to offsource the problem of 'finding a way to satisfy a goal' to a bunch of other people, obviously for a fee.

### Intents, geometrically

To work towards a mathematical formalization of intent searching, we will adopt this slightly more involved point of view: When you, the intent provider, come up with an intent $\mathfrak{i}$, you specify (at least) a couple of points on some space, call them $s_0$ and $s_1$. An intent searcher $\mathfrak{s}$, in finding the transaction that satisfies $\mathfrak{i}$, does nothing but provide a transaction $s_0 \xrightarrow{t} s_1$. **So we reduced the problem of solving intents to a problem about finding paths in some space.** Clearly, there may be many different paths going from $s_0$ to $s_1$, so we'll also need a definition of 'best' path that the searcher can pick, or at least hope to approximate.

The entire goal of this blog post is to make this intuition formal.

## Formalizing intents


### The state space

First of all, we must formalize the concept of state space. Given some mechanism $G$, e.g. the Ethereum virtual machine, the *state space* has as *points* all the states in which the mechanism can be in. The *topology* on this points will be defined by the actions one can perform with the mechanism.

A simple, idealized representation of the state space is the one below, where the little squares are states, and two states are adjacent if you can go from one to the other via some atomic action. In Ethereum land, points would be the states of the EVM, and two points would be adjacent if there is some EVM trace bringing you from one state to the other:

![A simplification of the state space](tex/done/stateSpace.png)

In practice, since we're mainly working with discrete mechanisms such as the EVM, the state space will never be so regular, and the following representation would be more appropriate: Given a mechanism $G$, we can build its [state diagram](https://en.wikipedia.org/wiki/State_diagram) when we see $G$ as some sort of automaton:

![A state diagram](tex/done/stateDiagram.png)

As you can see, the state diagram is actually a graph, where nodes are states, and edges, in the literature called *transitions*, are inputs that we feed to the automaton (in our case in the form of calldata) to get to another state. Modulo some differences in the transition decorations, this assumption is without loss of generality as every Turing machine admits a representation in terms of state diagrams, so any 'computationally feasible' mechanism $G$ will admit such a representation.

In the picture above we see the state diagram of a simple automaton that has nothing to do with blockchain infrastructure: in practice, the state diagram of, say, the EVM, is a monstruous, infinite graph, which is impossible to draw. 

In any case, we can work with what we got:

>The *state space $S$ of a mechanism $G$* is the set of nodes of its state diagram.

Compared to the physical example above, we see that the state space $S$ for a mechanism $G$ has no real notion of continuity, differentiability or cohesion of any sort. It's just a set.

![A state space from a state diagram](tex/done/stateSpaceS.png)

### Discretising tangent bundles

*Disclaimer: If you know differential geometry, you will be upset. In this section I'm deliberately identifying points in a smooth manifold with their generalized coordinates. I'm doing so because the alternative would be to talk about charts and all the like, which would make this blog post tremendously long and out of scope.*

Our main endeavor is trying to export techniques from Lagrangian mechanics to intentland. Lagrangians are very useful and versatile objects that describe the dyamics of physical systems. The first concepts one needs in describing a physical system are *positions* and *velocities*, and we need to define those in our setting to be able to define Lagrangians.

Positions are easy to understand: You have some notion of space $M$ (which in classical mechanics is very well behaved and is called a *smooth manifold*) and a position is nothing more than a point in it, call it $\mathbf{q}$. This we can easy port to our discretised setting: 

>A *position* $\mathbf{q}$ is just an element of the state space $S$.

Velocities, on the other hand, are a bit harder. Given a representation of the physical space $M$, the velocity of a particle *at* a point represents a direction where the particle 'wants' to go while it stays in that point. Given $M$, at each point $\mathbf{q}$ we can build the *tangent space to $M$ at $\mathbf{q}$*, denoted with $T_\mathbf{q} M$. Velocities at point $\mathbf{q}$ are points in this space, and we denote them as $\mathbf{\dot{q}}$:

![Tangent space in the differential geometry sense](tex/done/tangentSpace.png)

One can prove that when $M$ is a smooth manifold of dimension $n$, $T_\mathbf{q} M$ has the same dimension $n$ for each $\mathbf{q}$. I won't dwelve into the mathematical details of what this means. The take home message is that:

- If $M$ has dimension $n$, then you can represent any position in $M$ as a tuple of n coordinates: $\mathbf{q} := (q_1, \dots, q_n)$;
- Velocities at any point $\mathbf{q}$ can also be represented as a tuple of n coordinates: $\mathbf{\dot{q}} := (\dot{q}_1, \dots, \dot{q}_n)$.

We can put all these things together and define an object called *tangent bundle*, denoted $TM$, as follows:

$$ 
TM := \bigsqcup_{\mathbf{q} \in M} T_\mathbf{q} M = \bigcup_{\mathbf{q} \in M} \{\mathbf{q}\} \times T_\mathbf{q} M = \{ (\mathbf{q},\mathbf{\dot{q}} ) \mid \mathbf{q} \in M, \mathbf{\dot{q}} \in T_\mathbf{q} M\}
$$

Now, if $M$ has dimension $n$, one can see that $TM$ has dimension $2n$. As spelled above, a point in $TM$ is a couple $(\mathbf{q}, \mathbf{\dot{q}})$, and can be described by a tuple of $2n$ coordinates: The first $n$ coordinates identify $\mathbf{q}$, the position; whereas the last $n$ coordinates identify the velocity $\mathbf{\dot{q}}$ at the position $\mathbf{q}$.

To apply Lagrangian techniques to our setting, we need to define an equivalent of velocities and tangent bundles for our sad, discrete state space $S$. This is no easy task, as the kind of objects we use in classical mechanics are incredibly well behaved with respect to the ones we have, but let's try.

As we said in the beginning, our state space $S$ is built out of a graph, the state diagram of our mechanism $G$. In particular, we used the nodes of this graph to build $S$. If intuitively velocities at a point represent 'where a particle wants to go', we can transfer this intuition right away to our case: Given a point $\mathbf{q}$ in our state space $S$, transitions starting at $\mathbf{q}$ represents 'where the state wants to go' when you apply them.

![Alt text](tex/done/TqS.png)

From this, we can define:

>*Velocities* at $\mathbf{q}$, denoted $\mathbf{\dot{q}}$, are atomic transitions that start in $\mathbf{q}$.


>\begin{align\*}
> T_\mathbf{q} S := \{\mathbf{\dot{q}} \mid \mathbf{q} \xrightarrow{\mathbf{\dot{q}}} \_\}\\\\
> TS := \bigsqcup_{\mathbf{q} \in S} T_\mathbf{q} S = \{ (\mathbf{q},\mathbf{\dot{q}} ) \mid \mathbf{q} \in S, \mathbf{\dot{q}} \in T_\mathbf{q} S\}.
>\end{align\*}

![TS](tex/done/TS.png)

This notion of tangent bundle, which we call *tangent bundle of the state space*, is much coarser and ugly than the one used in physics. As stressed before, $TM$ has a lot of nice properties, can be described nicely using coordinates, etc; whereas $TS$ is just a set of couples $(\mathbf{q},\mathbf{\dot{q}})$ where the second component depends somehow on the first.


### Constraints (re)-define state space topology

Ok, now that we have a decent notion of space, suppose that an agent $\mathfrak{p}$ (intent proposer) creates an intent. The intent is composed, at the very least, of two *regions* of $S$, that is, of two sets of states: The first is the region identifying the *premises* of the intent (in green in the picture below), whereas the second is the region identifying the *conclusions* of the intent (in blue):

![Alt text](tex/done/intentRegion.png)

Why do we need regions and not just points, you may ask? The reason is that a point in the state space is a very granular description of what's going on: Say that the intent provided by $\mathfrak{p}$ is 'I want to swap $100$ tokens A for no less than $50$ tokens B.' A given point in the state space will also contain a lot of information regarding things that $\mathfrak{p}$ does not care about, such as the the balance of other users $\mathfrak{p}' \neq \mathfrak{p}$ for which $\mathfrak{p}$ has no particular interest. As such, it is enough for us to consider *any* possible state where $\mathfrak{p}$ has $100$ tokens A as a viable starting point for a path 'solving' the intent. Indeed, in the example below the premises region is constituted by states where the balance of token A for the intent provider is always $100$. States in this region differ with respect to the balance (say, in Eth) of some other user $\mathfrak{p}'$. A similar reasoning holds for the conclusions region.

Now, depending on how expressive the language we use to define intents is, the intent provider $\mathfrak{p}$ may also express statements such as 'I don't want this particular smart contract to be used', or 'I want the token swap to be performed in this particular way'. This is where (algebraic) topology comes in: This is nothing more than identifying other regions of the state space in which either provider $\mathfrak{p}$ does not want the path to go, or in which it requires the path to pass. 
We won't focus on the latter type of constraints in this post, as it will be expressed naturally as we define how intents compose, which will be the content of a future post. As for the former type of constraints, the 'I don't want the path to go here' ones , they can be taken care of by 'punching holes' in the state space, which in formal terms means *by changing the simply connectedness of the state space* (if only we were working with a real topological space). In the picture below, we colored the 'holes' in red for clarity. In practice, it is sufficient to strip these elements from the state space $S$.

![Alt text](tex/done/intentRegionConstraints.png)

Further constraints clearly must be reflected on the structure of $TS$: If we 'disallow' some points in the state space $S$, then we also have to 'disallow' velocities that lead to one of those points. Elaborating on this further, we are quickly made aware of the fact that intents may also contain constraints that intervene purely on the $\mathbf{\dot{q}}$, that is, constraints that disallow using a given transition when in a given state. In general, we have to work with a restriction of the tangent bundle of the state space $TS$.

> \begin{equation}
> \text{An \textit{intent space} is a subset $T^i S \subseteq TS$ such that $(\mathbf{q},\mathbf{\dot{q}}) \in T^\mathfrak{i} S \wedge \mathbf{q} \xrightarrow{\mathbf{\dot{q}}} \mathbf{q'} \implies \mathbf{q'} \in \pi_1 (T^i S)$.}
> \end{equation}

Here, $\pi_1: TS \to S$ is the projection on the first coordinate.
In words: If $(\mathbf{q},\mathbf{\dot{q}})$ is in the intent space and $\mathbf{\dot{q}}$ leads to $\mathbf{q'}$, then $\mathbf{q'}$ must be included in the intent space as well somehow. Finally, 

> \begin{equation}
> \text{An \textit{intent} $\mathfrak{i}$ is a triple $(T^\mathfrak{i} S, S^\mathfrak{i}_i, S^\mathfrak{i}_f)$ with $S^\mathfrak{i}_i, S^\mathfrak{i}_f \subseteq S$.}
> \end{equation}
