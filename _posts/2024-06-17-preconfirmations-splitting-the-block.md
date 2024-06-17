---
layout: post
title:  "Preconfirmations: On splitting the block, mev-boost compatibility and relays"
author: Daniele Palombi
categories: Ethereum Preconfirmations MEV XGA
excerpt: Where we present the XGA project.
usemathjax: true
crosspostURL: "https://ethresear.ch/t/preconfirmations-on-splitting-the-block-mev-boost-compatibility-and-relays/19837"
crosspostName: "ethresear.ch"
thanks: Thanks to <a href="https://ethresear.ch/u/fabrizioromanogenove">@FabrizioRomanoGenove</a>, <a href="https://ethresear.ch/u/meridian">@meridian</a> and Philipp Zahn for helpful comments and feedback on this post.
---

## ❓ What is a Preconfirmation?
There have been a lot of variations on the definition of preconfirmation going around recently in the Ethereum community. In this post we will keep the definition as simple and broad as possible in order to generate the least amount of confusion and avoid arguing on semantics as much as possible:
> We call a **_preconfirmation mechanism_** any mechanism that ensures (non-positional) inclusion of a (bundle of) transaction(s), if execution is successful, in a finite and bounded amount of time from the emission of the preconfirmation.

### 🔍 XGA-Style Preconfirmations
We will analyze a specific kind of preconfirmation mechanism -- as hinted to in [this post on ethresearch](https://ethresear.ch/t/a-simple-small-mev-boost-compatible-preconfirmation-idea/19800/3) -- that we came up with some time ago and have been building since then:
> An **_XGA-style preconfirmation mechanism_** is a preconfirmation mechanism that guarantees (non-positional) inclusion of a sized bundle of transactions **in the bottom portion of a predetermined block to be minted 2 epochs after the preconfirmation was emitted**. Maximum bundle size is determined at the time of emission of the preconfirmation.

## ✂️ Splitting the Block
Looking at the previous definition, I assume the first couple of questions that would come to mind is "what do you mean exactly by the bottom portion of a block?" and "how is the block to include the bundle predetermined?". Our idea is pretty simple: Partition the block in such a way to keep a top-of-the-block (ToB)[^1], high-priority section, in which traditional builders do their usual thing and is allocated through a traditional mev-boost auction or whatever the relay running it prefers; and a reserved bottom-of-the-block (BoB) section, which will serve as allocation space for preconfirmations. In this design, preconfirmation bundles will be allocated via a separate auction in the form of **_forward contracts_**.

### 👥 A Two-Auction Format
As briefly mentioned above, in the XGA-style split-block design, preconfirmations are allocated in a completely separate way from the traditional mev-boost auction, allowing them to coexist without excessively disrupting the ecosystem. Traditional builders will be able to do their own thing with minimal adjustments, while everyone else can still enjoy the benefits of preconfirmations.

In simple terms: An XGA-style BoB auction is a multi-unit auction selling gas tokens for a specific block $B$ in fixed-size units (e.g. $100$ K gas). These tokens can then be used to submit a bundle[^2] that is guaranteed inclusion in $B$ if execution is successful.

As an example, picture this scenario: 
- 🕑 At the start of epoch $N-2$ we know that the validator $V$, serving XGA-style preconfirmations, will be the proposer for the $K$-th slot of epoch $N$. 
- 🛢️ $5$M gas out of the standard $30$ M will be auctioned off into $50$ gas tokens, each representing a capacity of $100$ K gas.
- 🛒 At some fixed time $t$ before the start of slot $K$, a multi-unit auction allocating the tokens is run. Aki manages to win 5 tokens for $K$, for a combined capacity of $500$ K.
- ⏰ Within the deadline fixed at some time $d$ before the end of $K$, Aki uses the $5$ tokens to submit a bundle of size just over $400$ K gas.
- 📤 In the meantime, other BoB auction winners submit their own bundles.
- 💵 At the start of $K$, a traditional mev-boost auction for $25$ M gas is run as usual by all relays, and is won by Bogdan via relay $R$.
- 🧱 After deadline $d$ is reached and the mev-boost auction is over, the BoB part is assembled and attached at the bottom of the max-$25$ M block submitted by Bogdan via relay $R$. 
- 🎉 Since Aki's bundle contained no reverting transactions, it is included without any problem -- together with the non-reverting bundles submitted by the other BoB winners -- somewhere after the portion built by Bogdan.
- 📡 The block for $K$ gets broadcasted as usual.
- ❌ Excess tokens for $K$ that didn't get spent can no longer be used.

### 🧱 Who Builds the Blocks, then?
Block building, in the case of XGA-style preconfirmations, is handled by multiple parties:
- 📦 The ToB part is built by traditional mev-boost builders as usual.
- 🎁 The BoB part is assembled by the party running the BoB auction.
- 🧱 Merging the two parts and sending the block over is handled by the relay.

In this setup, the relay takes on more work and responsibilities than it currently does. We will explore a potentially beneficial approach to this change later.

### 💸 What Are the Economic Advantages of Preconfirmations?
Well... In general, for the whole range of designs that are being discussed right now this is not clear yet! **Conjecturally**, some of the proposed preconfirmation mechanisms will allow more value to trickle down to validators, but since the preconfirmation design landscape is so broad and confused right now it's hard to take into account all the possible market effects that could come out of such designs. For example, most of the preconf mechanisms currently being discussed are pretty unfriendly towards what has been one of the main APY-cows for validators since the dawn of mev-boost: competitive builder/searchers.

#### 🎲 Why Are We Betting on XGA-Style Preconfs?
It seems clear to us that reserving a spot for non-priority-sensitive transactions can offer several benefits:
- Users and platforms (e.g. rollups) that are not involved in competitive building/searching just doesn't care about running HFT operations on L1 can greatly benefit from separating their concerns from those of competitive builder/searchers.
- On the other end, it eases some of the pressure on the competitive builder/searcher side by removing some of the burden of having to include _"filler transactions"_ to keep their blocks competitive. E.g. freeing them from needing to include blob-bearing transactions that could negatively impact latency.
- It makes actually pricing inclusion preconfirmations simpler, since it is still regulated by the usual gas pricing model, and at the same time the preconf inclusion market is kept separate from the traditional priority market for position-sensitive transactions.
- Moreover, we believe in gradual change, allowing time for everyone to adapt to and observe the effects of new, potentially disruptive features in a controlled manner. A split-block design compatible with traditional mev-boost block building offers a less intrusive path to adoption.


## 💡 Rethinking Relays
At the moment running a relay naively is mostly a non remunerative gig. Under XGA-style preconfirmations, the relay does significantly more work and takes on more risk than before, e.g. if a block is missed and/or already sold preconfirmation tokens end up not getting included due to the relay malfunctioning, whoever bought them incurs an active loss of assets. While this sounds scary, it is also a good opportunity to rethink the role of relays in the Ethereum ecosystem.

### 🛡️ Insurance and Reward Mechanisms for Relays
What we are proposing is that a relay can subscribe to an XGA-style preconf platform by staking a collateral that could be used to offer the damaged parties a refund in case of the relay malfunctioning, while sharing a percentage of the platform revenue each time it submits a successful block that includes XGA-enabled preconfirmations[^3].


## 📣 Introducing XGA
![image](https://hackmd.io/_uploads/ByHPWZwrC.png)
	![image](upload://9Mo35AM8nSixIAAxYZf9Vtws6Tc.png)
XGA -- eXtensible Gas Auctions -- is the first L2 platform for XGA-style preconfirmations (lol), designed and built by the combined efforts of [Manifold Finance](https://www.manifoldfinance.com/) and [20Squares](https://20squares.xyz/). We're very willing to make this an open and collaborative effort, so if you have any feedback and/or are interested in building this together with us, please reach out!

Right now we have released on mainnet our v1.0 (yes, this is not a beta, **we're ready to go** and currently onboarding validators), with the caveat that in v1.0, the ToB mev-boost auction can only be run on a single relay. We're currently working on shipping v2.0, which will allow a **relay-agnostic** auction to be run in the ToB part. You can find more about it at [docs.xga.com](https://docs.xga.com/).


[^1]: We have specific terms for ToB and BoB auctions, namely α and β-auctions respectively.
[^2]: Note that this doesn't exclude the possibility of overwriting an already submitted bundle, if re-submitted before the deadline.
[^3]: We are already iterating on designs for captive insurance mechanisms for XGA-style platforms. We will upload a new post detailing some of the possible designs soon.
	XGA -- eXtensible Gas Auctions -- is the first L2 platform for XGA-style preconfirmations (lol), designed and built by the combined efforts of [Manifold Finance](https://www.manifoldfinance.com/) and [20Squares](https://20squares.xyz/). We're very willing to make this an open and collaborative effort, so if you have any feedback and/or are interested in building this together with us, please reach out!

Right now we have released on mainnet our v1.0 (yes, this is not a beta, **we're ready to go** and currently onboarding validators), with the caveat that in v1.0, the ToB mev-boost auction can only be run on a single relay. We're currently working on shipping v2.0, which will allow a **relay-agnostic** auction to be run in the ToB part. You can find more about it at [docs.xga.com](https://docs.xga.com/).


[^1]: We have specific terms for ToB and BoB auctions, namely α and β-auctions respectively.
[^2]: Note that this doesn't exclude the possibility of overwriting an already submitted bundle, if re-submitted before the deadline.
[^3]: We are already iterating on designs for captive insurance mechanisms for XGA-style platforms. We will upload a new post detailing some of the possible designs soon.