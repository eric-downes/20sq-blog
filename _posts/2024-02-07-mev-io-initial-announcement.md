---
layout: post
title: "Splitting the block"
excerpt: "In the last months, we have been tasked with defining the mechanisms underlying MEV Protocol Protocol, a novel market design that can be realized now without changes to the Ethereum core protocol. As MEV Protocol Protocol is getting very close to launch, we deem it timely to offer a brief description of how it works."
author: Philipp Zahn
categories: [MEV Protocol Protocol, ethereum, L2s, MEV Protocol, PBS, market design]
date: 2024-02-07
usemathjax: true
---

In the last months, we have been tasked with defining the mechanisms underlying [MEV Protocol Protocol](https://mev.io), a novel market design that can be realized now without changes to the Ethereum core protocol. We think of MEV Protocol as a radical but also pragmatic proposal to change the way block space is allocated in Ethereum - thereby (hopefully) introducing new dynamism in the whole value chain. As the basic MEV Protocol design is in place, and given recent discussion popping up around [Blockspace futures](https://ethresear.ch/t/execution-tickets/17944), we deem it timely to offer a brief description of how it works.

## The current state of affairs in PBS

The transition to proof-of-stake is an amazing feat of engineering and market design - after all how many software based system of the size of Ethereum have been radically transformed in production and have been working ever since.

By now, however, the initial enthusiasm has paved way to a sobering assessment of the current state of affairs. New forces of centralization have emerged.

First, Proposer-Builder-Separation has turned out to be a two-sided sword. On one hand, the design has worked as intended: Simplify the proposer task to avoid the need for specialization of at the proposer level and introduce competition and specialization at the lower levels of the value chain. On the other hand, we see high concentration along the critical infrastructure such as mev-boost and the block-building pipeline - including vertical integration. We discussed some of these aspects already [here](https://blog.20squares.xyz/mev-cui-bono/).

Second, through staking services such as Lido, the initial argument of the PBS design - namely that being a validator is a dumb task and open to anyone - is put into question. While things are not settled, it is questionable whether the core staking in Ethereum will be in effect accessible by everyone in the future or mediated through a few organizations.

Third, with the rise of intents, and new services being introduced at the bottom of the value chain, another possible centralization force is slowly (quickly?) building up.

These forces are not operating in isolation but are intertwined leading to a potpourri of possible trajectories.

We are obviously not the first to point out these developments. The space has been discussing various remedies, changes to the protocol as well as new off-chain infrastructure in the last months.

Significant changes to the protocol itself, such as [PEPC](https://ethresear.ch/t/unbundling-pbs-towards-protocol-enforced-proposer-commitments-pepc/138791) or [MEV-BURN](https://ethresear.ch/t/mev-burn-a-simple-design/15590/1), are not going to be implemented any time soon. We also see no new infrastructure being proposed that could significantly impact current developments NOW. There are ambitious projects such as Anoma and SUAVE by flashbots. But these projects will unfold only in months.

On the other hand, MEV Protocol is a much simpler but nevertheless radical proposal, built with pragmatism in mind and already live on testnet. As a note of caution, we do not believe the design we propose is the endpoint. Rather we see it as an experiment to explore the wider space of possibility and designs.

## The core: splitting the block

The design we propose departs from the current PBS architecture in several ways. But as its nucleus, from which any other innovation sparks, is the following change to the allocation of blockspace:

> The block is split into two parts, above (referred to as $\alpha$) and below (referred to as $\beta$). The above part of a block starts at the top and contains all gas up to a threshold $\tau$. From $\tau$ to the bottom of the block extends the $\beta$ part.

So, instead of selling the block as one monolithic block, it will be split into parts, to be sold separately. We do not claim to have invented anything particularly novel here, as splitting the block in two has been already suggested, see for example [here](https://ethresear.ch/t/how-much-can-we-constrain-builders-without-bringing-back-heavy-burdens-to-proposers/13808).

The $\alpha$ part will be more or less allocated as currently the whole block is allocated under PBS. In particular, the whole space from 0 to $\tau$ is sold as one object. Again, this does not differ much from existing research.

The $\beta$ part will be handled differently.

## Selling future block space

> The beta part will be allocated *in advance* as inclusion options: For each 100k gas the protocol will sell a token on a specialized L2, that guarantess the inclusion of transaction bundles of maximally that size in a pre-determined future block (two epochs in advance). The initial auction design will follow a [discriminatory price auction](https://en.wikipedia.org/wiki/Multiunit_auction#Discriminatory_price_auction).

At the point of when the $\alpha$ auction concludes, the block proposals by the $\alpha$ builder as well as the bundles sent by the $\beta$ token holders will be merged.

## Design rationale

Why do we want to split up the block? The current state of affairs in Ethereum entails a block monopoly where heterogenous builders with different demands compete for a homogenous good. Splitting the block will introduce a differentiated block structure that can serve different purposes.

Top of the block, which is at times very valuable due to CEX-DEX arbitrage, will be relevant for the subset of builders who specialize in this trading. They will basically continue to use the $\alpha$ part of the block as they now use mev-boost.

At the same time, actors who are mostly interested in including transactions and do not care much about the positioning of their bundles in a block can buy block space exactly for this. Moreover, actors who want to hedge the inclusion risk can use the $\beta$ part as well.

In short, we believe that splitting up the block and introducing separate markets will increase the efficiency of how block space is used.

We also believe that splitting the block could serve as an impulse for testing different demand patterns as well as sparking a differentiated and non-monopolized value chain of block building. 

## How can this be achieved?

To enable the design we rely on the principled interaction of several components.

1. First of all, MEV Protocol runs a number of protocol-owned validators, which listen to a dedicated relay *exclusively*; through these validators the protocol knows two epochs in advance when it will be proposing a block. This enables MEV Protocol to run an in-advance market for $\beta$ deterministically - it only allocates inclusion options when it knows that it will build the block. 
    
    MEV Protocol validators just run mev-boost like everyone else, the only important thing is that they use a fixed relay endpoint exclusively.
2. A specialized MEV Protocol L2 sequencer runs the $\beta$ part auction (fee-)efficiently. Blockspace options are represented as tokens in this L2.
3. The $\alpha$ part of the auction will be allocated as it is currently handled by any relay running mev-boost. So nothing really changes from the point of view of an $\alpha$ builder.
4. Shortly before the $\alpha$ auction ends, possessors of options for the $\beta$ part will submit their bundles by burning their tokens on MEV Protocol L2.
5. The MEV Protocol relay selects the winning $\alpha$ block, merges it with the $\beta$ bundles, builds the final block, and handles the fee attribution to the different builders involved.
6. The finalized block is shipped over to validators via mev-boost, as it usually happens.

These components are all necessary. Without one of them, the design would not be realizable (in that form). Notice how, in particular, relay exclusivity is of crucial importance: Without it, MEV Protocol could not sell blockspace options deterministically.

## An evolving design

The design changes we propose are complex and will require adjustment along the way. We will carefully evaluate the performance of the market(s) and introduce these changes step-by-step and in conversations with users and stake-holders.

In the upcoming blogposts, we will discuss the core components mentioned above in detail.

Lastly, we have further plans in the drawer for future versions of MEV Protocol. This includes a secondary market for the $\beta$ tokens that can be traded until the inclusion - this is one of the driving forces around developing a separate L2 for $\beta$ auctions. Moreover, we will propose a novel market design for the $\alpha$ auction, which has interesting formal properties that current MEV-boost auctions do not have.

Stay tuned!
