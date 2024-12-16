±s±---
layout: post
title: Basics of applying dynamics to Ethereum Issuance
author: Eric Downes
categories: [ethereum, issuance]
excerpt: This is a pedagogical blog post on differential equtions for ethereum in a series summarizing our research funded by EF GRANT INFO.
usemathjax: true
thanks: I am grateful for useful discussions with Eric Siu, Andrew Sudbury, and the the 20 Squares team; especially Danieli Palombi and Philipp Zahn.
---

## The Problem

The share of Ether staked by exchanges such as Coinbase and Liquid
Staking Providers (LSTs) such as Lido ("centralized" staking services)
continues to grow.  This has provoked
[concerns](https://issuance.wtf/), first raised by Ethereum
researchers, and which we share, that the future of Ethereum might
involve (1) all of its native asset being staked, such that (2) the de
facto liquid Ether is controlled by a confederation of centralized
un-transparent govrnance. In this blog post we setup some basics for
readers who can read python but are unfamiliar with differential
equations.

We use "stock and flow" differential equation models to study Ethereum
macroeconomics, specifically how changing issuance impacts these
questions.  We will publish several blog posts on this topic:

0. (This post) Basics of applying Dynamics to Ethereum
1. [Danger in reducing issuance to avoid Runaway Staking](./2024-12-05-issuance-fundamentals.md)
2. Will reducing issuance avoid Governance Centralization?
3. Other Levers besides Issuance, and a means of evaluating levers.
4. Some tools to help the community study and resolve policy debates.

We wrapped the `scipy.odesim` tool and provided some examples
[here](https://github.com/20squares/issuance-fundamentals) for
researchers wishing to simulate their own models.  We will return to
this tool in greater depth later, and demonstrate some basic usage
below.

# TLDR for the impatient

* Under the present yield curve, assuming weak Ethereum supply should eventually
  stabilize: nearly all Ether is staked with zero inflation; issuance
  matches the burn.

-- include styuff from notion.so 


# Why Diff Eq

On the face of it, differential equations, such as the reader may have
suffered through in highschool or college does not seem up to the task
of saying anything useful about Ethereum.
-- Everything in Ethereum is discrete, not continuous
-- Diferential Equations are cookbook recipes solving very limited solutions.

As often, everything is a matter of perspective.  Let's illustrate by
modeling the burn rate from [EIP
1559](https://ethereum.github.io/abm1559/notebooks/eip1559.html).
This EIP split Ethereum transaction fees into base and priority fees,
where the base fee is destroyed forever, and determined dynamically by
the amount of block congestion, using gas price as proxy.  The idea is
that traders can still compete for priority in blocks but they must
pay a deflationary penalty when "excessive" competition for
blockspace occurs.

$$\displaystyle
\beta_{t+\tau} = \left(1+\frac{1}{8}
\left(\frac{g_{t}}{g^\star}-1\right)\right)\beta_t
$$

Where:
- $\tau$ is the blocktime between successive blocks $$\approx12$$s/block
- $\beta_t$$ is the burn rate in ETH/block at time $t$
- $g_t$$ is the gas price in Ether at time $$t$$
- $g^\star$ is the target gas price $$15\times10^6$$ETH/block.

The above equation is a "difference equation", solved by 



But, if we are
studying policy questions like issuance, we are looking at much longer
times, such as quarters.  


# A Toy Model

Let’s start with two assumptions about Ethereum

1. All Ether ever issued can be split into “Staked Ether” $S$ “Unstaked Ether” $U$
    
    $(1)~~~~~E = S + U$
    
    $E$ — Total Ether in existence
    
    $S$ — Ether staked as per the Shanghai hard-fork
    
    $U$ — Everything else; burned Ether, liquid Ether, Ether locked in smart contracts, etc.
    
    $U=C+B$ circulating and burned
    

1. Ethereum is Proof-of-Stake with a protocol-level yield curve.
    
    The existing yield curve, post-Shanghai hardfork, $y_0(S)$ determines issuance of new Ether, and EIP-1559 determines Ether burned “lost” $\ell$ from the system.  We count burned Ether as part of total Ether $E$ so:
    
    $(2)~~~~~\dot{E}:=\frac{dE}{dt}=y(S)S$
    
    These staking rewards occur directly to $U$ and may be reinvested into $S$ at a reinvestment rate $r$.  
