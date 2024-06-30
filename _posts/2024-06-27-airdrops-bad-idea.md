---
layout: post
title:  "Rekt time: Why Airdrops and point systems are a bad idea"
author: Fabrizio Genovese
categories: ["mechanism design", "aidrops", "points"]
excerpt: Now that many people got fucked once more good and well, it is time to shine some game theoretic light on this matter.
usemathjax: true
thanks: "Notice: We'll call this post an 'opinion piece', since it is not based on any formal calculations, but only on a healthy dose of common sense."
---

So, it's that time of the year again. ZK sync aidrop [happened](https://claim.zknation.io/) and countless people feel utterly fucked. Blast token launch [happened](https://www.coindesk.com/markets/2024/06/26/blast-token-debuts-at-3b-value-as-17-of-supply-airdropped-to-early-adopters/) and again many people feel utterly fucked, whereas at least equally many people are lucky enough to be able to feel only pre-fucked -- we're still waiting for Phase II airdrop after all!

In light of all this, many of you are probably starting to wonder that

> "Spending that much money on gas fees in the hope of getting an aidrop, and then not getting shit, is probably not a viable way to spend my money"

You are indeed correct, but fret not! In this post, I'll explain in simple words why airdops do not destroy just your expectations, they also fuck up the airdroppers long-time. For the versed reader, this will be nothing new. Still, for the laymen it is probably useful information enough to be written down somewhere.


## Good old days

The good old days of aidrops where really nice. You didn't do absolutely anything, you just used a given product sparingly, and got surprised by a massive token gift that sometimes exceeded tens of thousands of dollars. These *early aidrop models* had a few interesting characteristics:

1. The majority of people weren't expecting any airdrop;
2. Since people weren't expecting an aidrop, they weren't farming for it. As a consequence, choosing a subset of people to airdrop a token to was easier.

The consequence of such an aidrop are negligible for the rational actor. If the token has no interest for you, it has no real value, and you may just say 'thank you very much for the gift' and flip it right away. I admit though that these aidrops could have a big psychological effect: Some users may feel grateful enough for having been considered worthy of receiving tokens to actually hodl them and, in some cases, even get involved with the community. In this respect, one may argue that airdrops could be used as a good tool for customer fidelization.


## And then words spread

When you get airdropped the equivalent of a Mercedes to your wallet, words spread quick. 

> "How the fuck did you make these 80K?!"
>
> "I just registered a couple of [ENS domains]() and set them to resolve to my wallet"

was the typical kind of conversation that would at the same time amaze your interlocutor and gave him the irresistible urge of punching you straight in the face. As time went by, more and more users were able to claim to have been gifted by one of these *too good to be true* airdrops. Even more strikingly, since these airdrops often awarded people that just used blockchain services in their day to day life, they often tended to reward always the same people in a disproportionate manner. And as time went by, more and more users that didn't receive any airdrop so far started thinking

> "Next time it's gotta be my turn. Actually, I gotta do *something* to *make it* my turn next time."


## And then marketing happened

As usual in any economic cycle, almost invariably things are nice only when they are available for a restricted number of people, the people that we often refer to as *the left tail of the adoption cycle curve*. When the airdrop lore spread to the middle portion of the curve, marketeers understood that aidrops could really be a great tool to incentivize adoption.

> "We can *make* people use our platform in the hope to get an aidrop!"

they thought. But marketeers aren't economists. Actually, the average marketeer is as far from being an economist as a human being can be. To be perfectly honest, most often a marketeer's knowledge of how economic mechanisms work is so abysmally low that, not by chance, 20[ ] has since forever stubbornly refused to have a marketing department, to the point of not having even a Twitter account or a Telegram group.

So, what I am very politely trying to say is that a bunch of idiots decided to turn an ex-post reward mechanism into an adoption incentive mechanism without having any clue about what they were doing. As it is usual with this kind of things, it proved to be a very popular design and many, many companies soon followed suit.

## So why doesn't it work?

Oh, it does! It does big, big time! But only for a short while. What happens is this. You're basically saying to potential users:

> If you are using the platform, you will be eventually rewarded.

But here's the catch: You cannot be less handwavy than this, because if you give people precise instructions, then:

1. Many people will just do the bare minimum to qualify, resulting in a bunch of very obviously detectable fake activity, which is not what you want to justify the value of your product.
2. Many people will complete the tasks you described, because they do not have to be creative about it. If it is simple enough, many people will do it. 

So now you have a huge crowd of people you have to reward, for a bunch of activities that are not even that useful to prove real adoption. So, wasted money. *But if you keep it vague enough*, then people really need to get creative about it, and start engaging with the platform in many ways.

This is great! Now you can go to a VC and *undeniably prove™* adoption! Again tho, nothing is really that good if it is available to a vast crowd of only vaguely motivated users. As Voltaire used to say,

> “Ice-cream is exquisite. What a pity it isn't illegal.”

...And airdrops are no different! The best contexts in which an aidrop can work are:

- When a very big project drops a token that is worth a lot, but does an airdrop that is totally unexpected, so that the crowd to reward is very small.
- When a small project does an aidrop and it then becomes very, very, very big. Again, this means that the crowd of farmers was very small in the first place.

As you can see, these are pretty much the conditions of the [good old days](#good-old-days). In any other context, what happens is that you have a very big number of people that you now have to reward. *They all behaved well*. They literally did all the things that you hoped they'd do to boost adoption. Yet they're too many and you simply cannot airdrop tokens to all of them because, well, tokens are a finite, limited resource. So you gotta become creative. You start cutting corners. You start shaping the qualification requirement in a way that cuts out a lot of people that really acted in good faith, and shouldn't have been cut out.


## And then the time comes

And then the time comes, indeed. Airdrop is announced, and a lot of people that put a massive effort to qualify got fucked. Furthermore, and as usual, people that qualified are almost invariably either lucky or insiders. Now, even the stupidest people do not like to get fucked. Like, at all. So they complain. They rage quit your platform or, at the very least, they engage much less than they were doing before. This has the opposite effect in terms of fidelization: People basically hate you now, because they built incredibly high expectations that, even if you acted in good faith, you could never satisfy in the first place.

This is why airdrops work in the short term. Almost invariably, once the airdrop is out, your *undeniable proof of adoption™* goes down the drain. All things considered, airdrops are a very nice tool if you want to raise some capital and you want to use said capital as exit money at the expense of everyone else. I really do not see many other applications from a mechanism design standpoint unfortunately.


## And points are fucking worse

Points are worse, indeed. The why is evident: Point systems give you the impression of creating well-defined rules: There's a clear, spelled out list of things you can do to earn points. That's great! You have your recipe now, just go farming!

Well guess what, the catch though is that you don't know - and most likely never will until the very last moment - what's the *points/tokens conversion rate*. So maybe you earn a monstrous amount of points, but still, that results in a meager amount of tokens.

It is important to understand that this is not an inclination, but a *requirement* from the issuing side. The issuing side simply *cannot sustain* spending too much money to incentivize usage, *especially* given that these incentives work *ex-post*! If too many people farm, the rewards will have to be shared among many people, and by definition they will shrink. 


## Wrapping up

Basically, as an aidrop farmer you are putting yourself in a position where:

- You do all the work without knowing how much you will get paid;
- You will get (MAYBE) paid only after all the work is done.
  
I hope this makes it evident how airdrops can fuck you badly, and why they are:

- A great mechanism to incentivise adoption short-term;
- A shit mechanism to incentivise adoption long-term.
 
They were great once, but nothing great lasts forever. Now they make people sad, they make issuers sad, they make everyone sad. The only silver lining is that you can blame marketing departments for this, which is always a very nice, morally right thing to do.

That's it. For what it's worth, don't cry because the good old days of aidrops are over. Smile because they happened! 'Till the next time!