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


