---
layout: post
title: Some danger in reducing Issuance to avoid Runaway Staking.
author: Eric Downes
categories: [ethereum, issuance]
excerpt: This is a blog post on Runaway Staking in a series summarizing our issuance research for the Ethereum Foundation.
usemathjax: true
thanks: I am grateful for useful discussions with Eric Siu, Andrew Sudbury, and the the 20 Squares team; especially Daniele Palombi and Philipp Zahn.  We are grateful to the EF for funding this research.
---

## The Problem

The share of Ether staked by exchanges such as Coinbase and Liquid
Staking Providers (LSTs) such as Lido ("centralized" staking services)
[is considerable](https://dune.com/queries/2394100/3928083) continues
to grow.  This has provoked [concerns](https://issuance.wtf/), first
raised by Ethereum researchers, and which we share, that the future of
Ethereum might involve (1) all of its native asset being staked, such
that (2) the de facto currency is controlled by a confederation of
centralized entities wiith less transparent govrnance. In this blog
post we address the first of these concerns.

We use "stock and flow" differential equation models to study Ethereum
macroeconomics, specifically how changing issuance impacts these
questions.  We will publish several blog posts on this topic:

0. Basics of applying Dynamics to Ethereum
1. (This post) Will reducing issuance avoid Runaway Staking?
2. Will reducing issuance avoid Governance Centralization?
3. Other Levers besides Issuance, and a means of evaluating levers.
4. Conclusions, tools to study and resolve policy debates.

Even if runaway staking does not directly concern you, this post is
essential to understand our view of the interaction between inflation
and staking, a picture in tension with other research.


## TLDR

### For the extraordinarily impatient reader, our conclusions.

* We identify a "low inflation; even lower fees" regime (LI;ELF) in
  which there the amount of Ether staked is stable and (potentially)
  less than 100%; $$s^\star<1$$.

* Staking rewards do *not* simply enter circulation. So long as LSTs
  exist some fraction of these are necessarily "reinvested" in
  staking at a non-zero ratio $$r$$.
  -- When LI;ELF persists, the fraction of Ether staked approaches the
     reinvestment ratio from above.
  -- Reinvestment can be estimated with onchain data, and its
     sensitivity to inflation measured with
     validator surveys.

* Outside of LI;ELF, convergence to a reasonable staking future is not
  possible.
  -- Under high deflation, Ethereum faces a choice between zero staking
     $$s^\star\to0$$ or runaway staking $$s^\star\to1$$.
  -- Under no growth or low deflation, runaway staking *is inevitable*.

* Within LI;ELF, runaway staking may still occur. If it does *not*,
  this is because
  -- (1) inflation is held low enough, that concerns over inflation
     do not dominate the reinvestment of profits by staking businesses
     at equilibrium, $$d_\alpha{r}|^\star\leq0$$, but simultaneously
  -- (2) inflation is held high enough at equilibrium to numerically
     dominate priority fees and MEV, as a fraction of circulating
     Ether; $$\alpha^\star\gg f^\star$$.

* The medium term future of ethereum we see is one in which inflation
  $$\alpha$$, while higher than that prefered by inflation hawks,
  plays a *positive* role to mediate staking fraction and
  centralization.  In long $$t\to\infty$$ term, though $$\alpha\to0$$ forcing
  $$s\to1$$.  We will revisit the consequences of this for Ethereum in
  a future blog post.

* Given all the above, we advise caution.  Intervening to reeduce the
  issuance yield curve seems dangerously capable of exaccerbating the
  very problems we seek to avoid.

### For the moderately impatient reader.

#### Dynamics Supporting Market Equilibrium

In some more detail, a sketch of the reasons behind our conclusions.
The quantity of most importance to this debate is the staked ETH
fraction $$s$$, as of Dec 2024 is [roughly
.28](https://dune.com/queries/1933048/3188490). Staking fraction is
calculated $$s=S/A$$ where $$S$$ is all staked ETH, $$C$$ is
"circulating" (unstaked, unburnt) ETH, and $$A=S+C$$ is the total
"accessible" (unburnt) ETH. Differential changes, such as changes in
time $$\frac{ds}{dt}:=\dot{s}$$ are given by the quotient rule
$$\dot{s}=\dot{S}/A-s\dot{A}/A$$.  The quantity $$\alpha = \dot{A}/A$$
is the average on-paper inflation rate (supply expansion APY) averaged
on at-least-quarterly timescales.

That is, an increase in staking fraction can be driven by more people
staking, and/or it can be driven by a reduction of the inflation rate.
The latter can be acheived in principle by a reduction of issuance
relative to the base fee "burn rate".  Because of this quotient rule
tradeoff, low-but-positive inflation actually plays a positive almost
"infrastructure" role in moderating staking fraction.

This positive role for inflation can be seen in the contours of the
market equilibrium staking fraction $$s^\star$$ corresponding to
$$\dot{s}=0$$, shown in [figure
1](../assetsPosts/2024-12-05-issuance-fundamentals/staking-fixpoint.png).
The equation graphed is as follows:

$$\displaystyle
s^\star = r^\star\frac{\alpha^\star/f^\star + 1}{\alpha^\star/f^\star + r^\star}
$$

The fraction $$0\leq r\leq 1$$ is the ratio of profits reinvested
quarterly by validators, $$0\leq f\leq 1$$ is the fraction of unstaked
ETH spent on transaction fees (base and priority) quarterly, and as
above $$\alpha$$ is inflation.  Here $$r^\star$$ etc. means the
function $$r(s,\alpha,\ldots)$$ at the equilibrium coordinates
$$(s^\star,\alpha^\star,\ldots)$$.  To find the equilibrium values
$$(\alpha^\star/f^\star,\,r^\star)$$ necessary to acheive a desired
staking fraction $$x^\star$$, simply pick a colored contour in the
figure: these are the values of constant $$x^\star$$.  For every point
on this curve, the equilibrium inflation:fee ratio
$$\alpha^\star/f^\star$$ is the x-coordinate, and the equilibrium
reinvestment ratio $$r^\star$$ is the y-value.

The two extremes are $$\alpha^\star\ll f^\star$$ fees dominate and
$$\alpha^\star\gg f^\star$$ inflation dominates.  In the former,
staking fraction becomes insensitive to reinvestment, raising
$$x^\star$$.  Equivalntly, for any value of positive inflation,
$$r^\star$$ is a lower bound for the equilibrium staking fraction we
should expect.

Approximate present values from YCharts are very roughly
$$f\approx.001$$/year, $$\alpha\approx.005$$/year, $$r\in(.5,.75)$$.
How these transient values $$(\alpha/f,\,r)$$ relate to their
equilibrium values $$(\alpha^\star/f^\star,\,r^\star)$$ depends on
some considerations.

### Maintaining LI;ELF while changing Issuance

Under current market conditions, low inflation and even lower fees
(LI;ELF), the long-term equilibrium staking fraction approaches the
average ratio $$r$$ at which validators reinvest their staking
rewards.  This makes staking fraction responsive to economic
interventions that affect the reinvestment decisions of participants.

So if LI;ELF conditions persist, we expect the staking
ratio converges to no more than +10\% of the the equilibrium
reinvestment ratio.  Good news: if issuance can be reduced such that
inflation is reduced by half, while fees etc. maintain, equilibrium is
still around $$r$$ + 15\%, so $$s^\star\in(.58,.8)$$, at present values.

If the yield curve is reduced from $$y_0=\frac{k}{\sqrt{S}}$$ to
$$y'=\frac{y_0}{1+k'S}$$ as proposed in ----------, what is likely to
happen?



#### Macroeconomics at the Equilibrium Point

Per the arguments of Ethereum researchers, high inflation could lead
to runaway staking.  This has motivated the drive to reduce issuance
and thus inflation.  Our model offers a perspective here as well.

In our model the net effect of inflation on staking fraction at
equilibrium is reflected by taking the derivative
$$0<\left.\frac{ds^\star}{d\alpha}\right|^\star$$ assuming $$r,f$$ are
implicit functions of $$\alpha$$.  That is, the necessary condition
for inflation to push the market equilibrium $$s^\star$$ itself into
runaway staking is (see below for explanation):

$$\displaystyle
1 ~~ < ~~
\left.\frac{\partial\log\ r}{\partial\log\ \alpha}\right|^\star
\cdot \frac{1 + \alpha^\star/f^\star}{1 - r^\star} ~~ + ~~
\left.\frac{\partial\log\ f}{\partial\log\ \alpha}\right|^\star
$$

We hope that this work can be built upon to focus inflationary
pressure arguments into empirically measurable assertions that can be
tracked as a metric for Ethereum health.  If inflation pressures are
indeed the dominant consideration for Ethereum users considering
staking, this should emerge from microeconomic surveys of validators'
reinvestment sentiments.  A semi-empirical measurement of correlations
between transaction fees and inflation, using our model or similar to
control for staking queue flows, etc. should also shed light on wether
the above condition is satisfied or not.
    
## Modelling Staking

Now some more details!

### Splitting Up A Growing Pie

Consider the quantity $$E$$ of all Ether in existence, averaged
qaurterly.  Let the issuance of new Ether as per The Merge be
quantified by $$I$$.  Then the change in time of total Ether is
$$\dot{E}:=dE/dt=I$$.

Now, let us separate $$E$$ into three smaller boxes;
$$S+C+\cancel{O}=E$$, representing (S)taked, (C)icrulating, and burnt
Ether $$\cancel{O}$$, respectively.  By considering each quantity a
quarterly average we can plausibly ignore the detailed dynamics of the
staking, unstaking, and withdrawal queues.

### How Pie is Pushed Around The Plate

This is our model:

$$
\displaystyle
\begin{array}{rcl}
\dot{E} &=& I\\
\dot{S} &=& R+Q_+-Q_-\\
\dot{A} &=& I-B\\
\end{array}
$$

Where all quantities are assesed quarterly:
* $$I$$: Total Issuance in a certain quarter
* $$R$$: Total Reinvestment of Validator Yields, in that quarter
* $$Q_\pm$$: Total (Un)Staking Queue Flows, in that quarter
* $$B$$: Total Base Fee (burn) assed, in that quarter.

Transaction fees $$F+B$$ are split into the base fee $$B$$ which is
burned, and priority fees plus MEV $$F$$ which go to validators via
the wihdrwal queue.  Fees obey the inequality $$0\leq F+B\leq C$$.  We
ae interested in the limit $$C\to0$$ and pull this dependence out by
defining $$f$$ such that $$fC = F+B$$. The fraction $$f$$ need not be
a constant, but whatever values it takes, $$f$$ must be a fraction:
$$0<f<1$$ with units of 1/year.  Looking at YCharts for 2024, an
average tx fee might be $$3\times10^{-4}$$ ETH, and with
$$\approx1.2\times10^6$$ transactions per day on a supply of 120M,
70\% of which is unstaked, corresponding to an $$f\approx.001$$/year.

En masse, validators withdraw their rewards $$I+F$$ into circulating
ETH.  They reinvest some amount of rewards $$R$$ into staking more
validators.  Reinvestment into one's business is a natural practice,
and we expect $$R$$ to respond meaningfully to macroeconomic forces.
Reinvestment is also a part of every LST smart contract; via rebaisng,
a certain fraction of yield is the value proposition for the
token-holder; so any model with LSTs must include reinvestment.  Again
we define a variable fraction $$r:=R/(I+F)$$ which obeys
$$0\leq{r}\leq1$$. As of Nov 23, 2024 the stETH token yield is
$$\approx3$$\%.  Over the same period, without MEV-Boost validator
yield is $$\approx4$$\%, and with MEV-Boost it is $$\approx5.7$$\%.
So probably, $$r$$ currently lies in the range $$.5\leq r\leq.75$$.

The quarterly flows from the staking and unstaking queues must obey
$$0\leq Q_+\leq C$$ and $$0\leq q_-\leq S$$, which we use below via
variable fractions $$q_+=Q_+/C,~q_-=Q_-/S$$.  Finally, we rewrite
$$\dot{S}$$ the change in total staked ETH, anticipating that we wish
to understand the relationship to inflation rate $$\dot{A}/A$$,
obtaining $$\dot{S} = r\dot{A} + r(B+F) + Q_+-Q_-$$.  For about the
past 6 months Ethereum supply has been growing pretty linearly,
corresponding to an inflation rate of about .5\%, that is
$$\alpha\approx.005$$/year.

The variable of primary interest is the staking fraction $$s=S/A$$;
recalling the quotient rule $$\dot{S}=\dot{S}/A-s\dot{A}/A$$ and
$$C=A-s$$, we obtain:

$$
\displaystyle
\dot{s} ~~ = ~~ \frac{\dot{A}}{A}(r-s) ~~ + ~~ (rf+q_+)(1-s) ~~ - ~~ q_-s
$$

The first term captures the effect of inflation/deflation.  Under
inflation $$\dot{A}/A>0$$, the staking fraction receives a boost when
it is less than reinvestment rate $$s<r$$, and a drag when $$s>r$$.
Under deflation $$\dot{A}/A<0$$ the effects are reversed, though see
below.  The second term combines new staking $$q_+$$ and the
reinvestment of priority fees and MEV $$rf$$, and is always
non-negative.  The third term represents unstaking and is always
non-positive.

### Equilibrium

#### Fixed Point

We now wish to study the fixed point $$s^\star$$ given by solving
$$0=\dot{s}=\frac{\dot{A}}{A}(r-s)+(rf+q_+)(1-s)-q_-s$$.  Recall from
our last post that since the Merge it seems
$$|\dot{\alpha}|\ll|\dot{s}|$$ and at medium timescales there is
support for a stable slowly changing value of $$\alpha^\star$$,
supporting a study of the fixed point $$x^\star$$ *given* a value for
$$\alpha^\star$$.



This yields the solution

$$s^\star = \frac{r^\star (\alpha^\star + f^\star) + {q_+}^\star}{
\alpha^\star + r^\star f^\star - {q_-}^\star}$$

We find that if $\dot{A}=0=\alpha$ (no inflation nor deflation) then
an interior market equilibrium $$s^\star<1$$ is impossible.  We reason
as follows.  In the absence of in/de-flation, an interior fixed point
$$s^\star<1$$ would require a persistent unstaking/capitulation of
existing validators $$q_->0$$.  This in turn either requires "churn",
a persistent supply of new validators to take their place
$$q_+^\star>0$$, or it is only a transient and $$q_-^\star\approx0$$;
recall that reinvestment by existing validators is not counted in
$$q_+$$.

Net unstaking $$q_->0$$ could only describe a market equilibrium if
one group of stakers was actively capitulating and withdrawing their
stake, while another group with a higher $$r$$ were aggressively
reinvesting in their business, and their reinvestment of fees and MEV
offset the unstaking, adjusted for inflation.  This cannot maintain
forever: eventually there will be no new Capitulators left, and
$$s^\star$$ must once again grow as required by the Reinvestors'
higher $$r$$, so $$s^\star$$ was not a fixed point at all.  Similarly,
at some point everyone who wants to stake should have staked.  If we
judge the quarterly fluxes due to the issuance of new humans and the
burn rate of legacy humans to be small and/or likely to take over
existing businesses, additional validators count overwhelmingly toward
$$r$$, so $$q_+^\star\approx0$$.  Thus, the fixed point $$s^\star$$
simplifies to

$$\displaystyle
s^\star ~~ = ~~ r^\star ~
\frac{\alpha^\star + f^\star}{\alpha^\star + r^\star f^\star}
$$

A calculation is illustrative under the current regime of positive
inflation.  If inflation dominates fees, $$\alpha\gg f$$ then
$$s^\star\sim r^\star<1$$, while if fees dominate inflaton $$\alpha\ll
f$$ and $$s^\star\to1$$.  For a numerical comparison, at present $$f
\approx .001<.005\approx\alpha$$ so to within 10\% error above,
$$s^\star\approx r$$ over the range of $$r$$ inferred from Lido yield
rate.

So if these conditions persist at long times, and to be clear there is
no reason to be certain they will, we should expect $$s^\star\approx
r\in(.55,.77)$$.  This places the lower range of $$s^\star$$ near the
50% staking target proposed by Elowsson.  This is hopeful!  However
ittle weight can be attached to such back-of-envelope extrapolations
as these.  To make reliable projections we need systematic measurement
of both the statistics of individual validator reinvestment and
metrics or at least surveys reflecting validator sentiment and
(in)capacity to absorb reduced revenue.

### Market Equilibrium: Stability

The fixed-point $$x^\star$$ represents "the" market equilibrium when it
is both unqiue and stable.

Non-uniqueness requires another solution to $$\dot{s}=0$$, thus a
shared and repeated root among all terms $$\alpha,rf+q_+,q_-$$.  That
is, each economic flow would have to nearly disappear at a particular
value of staking fraction.  Lacking any supporting data or a mechanism
for this, we cannot really analyse such an alternate equilibria, but
intuitively it seems unlikely, so for now we move on, assuming
uniqueness.

Stability requires that small perturbations shrink;
$$\left.\frac{\partial\dot{x}}{\partial x}\right|^\star<0$$, where
$$\left.\frac{d}{d\xi}\right|^\star$$ denotes a derivative with
respect to $$\xi$$ at the fixed point $$\xi^\star$$.  The full
stability condition is

$$\displaystyle
1 + \left.\frac{r^\star}{\alpha^\star/f^\star}
~~ > ~~
\frac{\partial\log\ r}{\partial\log\ s}\right|^\star +
\left(1 - \frac{r^\star}{s^\star}\right)
\left.\frac{\partial\log(\alpha/f)}{\partial\log\ s}\right|^\star
$$

Where presently, we estimate the dimensionless quantity
$$\alpha/f\in(2,5)$$ while its derivative depends on the slope of the
yield curve $$y$$.

*If* the derivatives are all small in comparison (and there is no a
priori gaurantee of this), then we can say something useful.
Stability is automatic under inflation so long as
$$\alpha^\star+r^\star f^\star>0$$.  If again derivatives are all
small but $$\alpha<0,~rf<|\alpha|<f$$, then the fixed point is
negative $$x^\star<0$$ and unstable, so runaway staking is inevitable;
here deflation and tx fees shrink circulating Ether $$C$$ so quickly
that no amount of profit-taking by validators short of en masse
unstaking is sufficient to preserve $$C>0$$.  The strong deflation
$$\alpha<-f<0$$ fixed point appears interior unstable, predicting
either runaway staking or a catastrophic loss of staking, depending on
initial considitions. Our interpretation of the latter behavior is
that if raw Ether is appreciating in value so quickly, and there has
been insufficient interest in staking thusfar, then why bother staking at
all?  But we must emphasize that what instability *really* means is
that "market externalities take over", rather than supporting any
specific trajectory due to endogenous dynamics.

We feel it is extremely important that policy interventions, such as
changes to issuance, not disrupt desirable stable fixed points.
Otherwise staking fraction is in danger of no longer influenced by
equilibrium arguments and becomes much harder to predict or control.
Potential for instability would manifest as large groups of validators
and other market participants taking very different bets on the future
of Ethereum.  Which future manifests would probably depend on details
not observable from macroeconomics alone.  In what follows we will
assume stability for the sake of discussion, but must stress that
while we judge it likely under current conditions, this matter is not
settled without further and more careful study.

### Inflation Concerns

As we have seen, reducing issuance in a vacuum decreases inflation,
and increases the relative strength of the $$rf(1-s)$$ term.  This
leads to an increase in staking fraction if $$r$$ etc. do not reduce
sufficiently, in response.  Very likely $$x_{now}<r<1$$, so currently
the effects of both inflation and fee-reinvestment push in the same
direction right now.  But we are less interested in such transient
effects, than the medium term behavior of the system.  To study this, we
looked at the fixed point $$s^\star=r(\alpha+f)/(\alpha+rf)$$, and
note it reflects a role for inflation more nuanced than has usually
been communicated.  In fact, we want to emphasize that deflation or
zero growth could actually be quite dangerous; for instance when
$$\alpha^\star<0,~|\alpha^\star|<rf$$ we have $x^\star>1$$; and there is no
interior fixed point.

Why does this happen, though?  The reinvestment of issuance rewards
adds to both staked ETH $$S$$ and circulating ETH $$C$$, so the effect
on staking fraction depends on the relative size of these two.
However, the reinvestment of priority fees plus MEV is simply a net
value transfer from $$C$$ to $$S$$, which can only ever increase
staking fraction.

A moderate reduction of inflation to half or even a third of its
present value would still result in a comfortably positive inflation
rate, $$\alpha>f$$ and maintain the dominance of reinvestment in the
long term $$s^\star\to r^\star$$.

The effect of $$\alpha$$ on $$r$$ then becomes quite salient, and this
is where previous market equilibrium arguemnts come into play.  We
agree with issuane hawks that there must be *some* $$(s,\alpha)$$ past
which fears of runaway inflation will drive $$r\to1$$ and therefore
$$s^\star\to1$$.  How does our model account for such effects?

The derivative of staking fraction by inflation near equilibrium
$$\left.\frac{\partial x^\star}{\partial\alpha}\right|^\star$$ shows the response to
small endogenous changes, but not to a market crash, or protocol
hardfork.  The condition that gently rising inflation causes an
*increase* in staking is that this derivative should be positive.
Assuming $$r,f$$ are (unknown) implicit funcions of $$\alpha$$ the
positive derivative condition becomes after some manipulation

$$
\displaystyle
1 ~~ < ~~ \left.\frac{\partial\log\ r}{\partial\log\ \alpha}\right|^\star
\cdot\frac{1+\alpha^\star/f^\star}{1-r^\star}
~~ + ~~
\left.\frac{\partial\log\ f}{\partial\log\ \alpha}\right|^\star
$$

This gives us a condition expressing how the macroeconomic effects of
inflation on reinvestment and tx fees impact the staking fraction
equilibrium.  If reinvestment is steady with small increases in
inflation, then tx fees must respond superlinearly.  If tx fees
respond only weakly, then reinvestment must increase with inflation.
The smaller reinvestment has been and the more inflation dominates
fees, the weaker the increase of reinvestment needs to be to satisfy
this conditions.

Note that $$x^\star/r^\star-1=(1-r^\star)/(1+\alpha^\star/f^\star)$$
the same quantity that appears in the stability condition, suggesting
a link between the boundary of the stable manifold and the conditions
for inflation-led runaway-staking.

## In Conclusion

