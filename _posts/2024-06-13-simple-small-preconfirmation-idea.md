---
layout: post
title:  "A simple, small, mev-boost compatible preconfirmation idea"
author: Fabrizio Genovese
categories: Ethereum Preconfirmations MEV
excerpt: Where we present an extension of MEV-boost to enable preconfirmmations.
usemathjax: true
crosspostURL: "https://ethresear.ch/t/a-simple-small-mev-boost-compatible-preconfirmation-idea/19800"
crosspostName: "ethresear.ch"
---
**Disclaimer**: This post will not contain any nice images, because I am artistically inept.

The reasons why I'm writing this are the following:
1. Preconfs are a very hot topic right now and many people are working on them;
2. As usual, some of the proposed solutions advocate for punching changes all the way into the main Ethereum protocol. I'm personally not a fan of this, since life is already full of *oh my God, what have I done?™* moments and *more drama™* is the least thing everyone probably needs.
3. MEV-boost is probably the *only* thing this community has really almost universally agreed upon since MEV has been a thing. So I'd very much try to preserve backwards-compatibility with MEV-boost and generalize on this than coming up with more innovative ways to balkanize our ecosystem even further.

## A primer on MEV-boost

This section exists just so that everyone is on the same page. Feel free to skip it or to insult me if you think I summarised things stupidly.

In layman terms, MEV-boost works like this:

1. Proposer polls the relayer(s) for their best blocks;
2. Relayer(s) send their best block headers to proposer;
3. Proposer picks the best block by comparing the block headers received and the block built in-house. 
4. For an in-house block, proposer just signs and broadcasts. For a mev-boost block, proposer signs the header. Relay will broadcast the complete block revealing the payload.

This mechanism is nice because the only party that builders have to trust is relayer: Proposer cannot unbundle blocks and scam builders.

## The actual idea

The idea I have in mind works towards extending mev-boost by allowing for preconfs (and most likely for a lot of other stuff if one wants to). Notably, it does not change points 2,3,4 in the previous section, but only point 1. 

Suppose proposer has a stash of preconfed txs on the side. The only thing the idea assumes is the following:

> By the time Proposer starts polling, it needs to have a finalized lists of preconfed txs to include.

The reason for this will become clear shortly. Having this list at hand, proposer sends a signed JSON object to the relayer when it polls, containing the preconfed txs. This object could look, for instance, like this:

```
{
    proposer: address,
    slotNumber: int,
    gasUsed: int,
    blobsUsed: int.
    mergingPolicy: int,
    mustBeginWith: txBundle,
    mustContain: txBundle,
    mustOmit: txBundle,
    mustEndWith: txBundle,
    otherStuff: JSON,
    signature : signature
}
```

**This design is just an idea. It is by no means fixed yet and most likely can be improved upon both in conceptual and performance terms, so take it with a grain of salt.**
The fields `proposer` and `slotNumber` are obvious. The fields `mergingPolicy`, `mustBeginWith`, `mustContain`, `mustOmit`, `mustEndWith` can all be empty: They contain bundles of transactions that must (or must not) be included in the block. These fields are, effectively, the ones that proposer can use to signal relayer that 'hey, I need the block to respect these requirements, because of previous agreement I made with other parties."

How the proposer comes to define this json object is not our concern, and is outside of the scope of this idea. Just for the sake of clarity though, let's consider some examples: For instance, [XGA](https://docs.xga.com), one of the projects `20[ ]` is contributing to, provides preconfs as tokenized bottom-of-block space. As such, XGA-style preconfs will produce objects where only `mustEndWith` is not empty.

The fields `gasUsed` and `blobsUsed` tell the relay how much gas and blobs the 'preconf space' already claimed. `otherStuff` exists to be able to extend this standard in the future without *more drama™*.

### Merging policies

The `mergingPolicy` fields instructs the relay about how to deal with all this information. This is fundamental because, in the end, the relay will still run a traditional mev-boost auction for the remaining blockspace. As soon as a block is built by more than one party there's a risk that different parties may step up on each other's toes. As such, `mergingPolicy` serves as a well-defined conflict resolution policy. If you need a mental reference, think about git conflicts and automated ways to solve them if you so like.

How to define merging policies is up for debate. The community could agree on a common repository where merging policies are defined, voted and agreed upon, and where merging algos are explicitly provided. So, for instance, one merging policy could be:

> If the payload coming from the builder contains a transaction that also appears in the preconf bundle, deal with it in the following way:

As said above, XGA sells BOB as preconfs, and leaves TOB open for traditional mev-boost auctions. As such, it has already defined and implemented a merging policy for its bottom of the block case, which will hopefully be open sourced soon.

### What does the relay do?

This is probably already kinda clear at this point, but to make it explicit: The relay receives this signed JSON object when the proposer polls. What should it do with it? First of all, it should make some of these fields public to the builders, such as `mergingPolicy`, `gasUsed`, `blobsUsed` and `mustOmit`. This way builders will know what they can build.

When a block from a builder is received, the relayer will **unbundle** the block and apply the merging policy to merge it with the preconfed txs. The **relay** will sign the block header, and send it to the proposer.

From the POV of a builder, everything is kinda the same. They create their block using the info provided by the relay (in the simplest case this just means using slightly less gas than limit), and submit it as their bid.

From this point on, everything works as in traditional MEV-boost.

## Analysis

Ok, so let's run a rapid analysis of this thing.

### Pros

1. Changes to MEV-boost proper are really minimal. We just need to define an API that MEV-boost must listen to to build the polling payload, and redefine the polling logic.
2. Very little work from Proposer's side. More work may be needed depending on the preconf system a given proposer wants to use, but then again this is out of the scope of this idea.
3. Very little work from builder's side unless people go overly crazy with merging policies. I do not think this is necessarily a problem tho as an overly deranged merging policy would result in builders not submitting anything, and most likely in relayers not taking bets in the first place. So I'd bet that this could pretty much evolve as a 'let the markets decide' thing.
4. This idea is straightforwardly backwads-compatible with traditional MEV-boost: If the polling payload is empty, we collapse to a traditional MEV-boost auction with no other requisites.
5. This idea allows for gradual phasing out of MEV-boost if the community so decides. For instance, proposers may agree to produce bundles where `usedGas` is a very low parameter in the beginning (it won't exceed 5M for XGA, for instance), meaning that the majority of blockspace would come from traditional building, with only a tiny part being preconfs or more generally 'other stuff'. This parameter may then be increasingly crancked up or varied with time if the community so decides, effectively phasing out traditional block building in favor of 'something else'. In this respect yes, I know I'm being vague here but when it comes to how this thing could be adopted I can only speculate.
6. This system can be extended in many ways, and it is flexible. Merging policies could be defined democratically, and the polling info could be extended effectively implementing something akin to PEPSI, for instance. Another possible extension/evolution can be using `otherStuff` to define Jito-style auctions. I mean, there's really a plethora of ways to go from here.
7. The polling payload is signed by the proposer, and the block header is signed by the relayer. This keeps both parties in check as we accumulate evidence for slashing both. For instance:
   - Imagine I get some preconf guarantee from proposer and that I have evidence of this. Again how this happens is outside of the scope of this post, as this mechanism is agnostic wrt how preconfs are negotiated.
   - Now suppose furthermore than my preconfed tx does **not** land in the block.
   - I can use the chain of signed objects to challenge both relayer and proposer. If my tx wasn't in the polling info signed by proposer, that's proposer's fault. On the other hand, if it was, but it wasn't in the block, then it's relayer's fault. I think this is enough to build a slashing mechanism of sorts, which could for instance leverage some already available restaking solution.

   **Note:** If there's enough interest in this idea, we as 20[  ] can throw some open games at it and simulate the various scenarios. Let me know!
8. **Ethereum protocol doesn't see any of this.** So if it fucks up, we just call it a day and retire in good order without having caused the apocalypse: Relays will only accept empty payloads, proposers will only send empty payloads, and we'll essentially revert to mev-boost without anyone having to downgrade their infra. I think this is the main selling point of this idea: The amount of ways to make stuff explode in mev-related infraland are countless, so this whole idea was built with a 'it has to be failsafe' idea in mind.

### Cons 

1. Relayer must unbundle builder blocks to do the merging. I do not think this creates a huge trust issue as relayer can already do this as of now: In general, a relayer that scams builders is a relayer that won't be used again, and will go out of business quickly.
2. Relayer must do computational work. This is probably the major pain point. This idea entails slightly more latency, as an incoming bid cannot be relayed instantly because `mergingPolicy` has to be applied. The computational penalty is furthermore heavily dependent on how deranged the merging policy is. As a silver lining, this computational work is *provable* as both the merging info and the resulting block are signed. The result is that we have **provable evidence to remunerate a relay for its work if we want to**, possibly solving a major pain point for relayers in traditional mev-boost.
3. Relayer is slashable if it screws up. Again, how this should be implemented is outside of the scope of this idea as this mechanism only accounts for the needed trail of evidence to implement slashing, but does not deal with the slashing per sé. Anyway, it is still worth reasoning on the possible consequences of this: If slashing policies are implemented, Relayers will most likely need to provide some collateral or implement some form of captive insurance. Again, this may signify more complexity on one hand but also opportunity on the other, as relayers may for instance decide to tokenize said collateral and develop mechanisms to make money out of these newly created financial instruments. As relayers are private enterprises I'll leave these considerations to the interested parties.
4. **Polling info must stay fixed**. This is related to point 3 above and point 6 of the [Pros](#pros) subsection: If the polling info changes all the time, this means huge computational stress for the relayer, and it furthermore allows for malicious behavior from the proposer: For instance, a proposer could send two different polling payloads, and include a given preconfed tx only in one of them. How to resolve these inconsistencies is an open question. In my opinion, the wisest and simplest thing to do would be requiring the polling info to be fixed, meaning that if proposer signs conflicting payloads for the same slot this should be considered akin to equivocation, and thus a slashable offence.
    
    By the way, the consequence of this is that the idea proposed here necessarily excludes some preconf use cases. This is related to my comment [here](https://ethresear.ch/t/strawmanning-based-preconfirmations/19695/2) and I think it is unavoidable if we want to keep MEV-boost around. As the majority  of revenue from MEV comes precisely from the bids of very refined, high-time frame searchers, and as I am quite sure that validators don't want to give this money up at least for now, 'leaving these players be' by ruling out such preconf use-cases is in my opinion the most practical option, and exactly the rationale motivating this idea.

## Closing remarks

That's it. If the idea is interesting enough let me know, I'll be happy to start a discussion around it.  The `20[ ]` team will also be around at EthCC if you want to discuss this in person.