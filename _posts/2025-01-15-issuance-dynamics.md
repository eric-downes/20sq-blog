---
layout: post
title:  "Ethereum Macroecon via Dynamics 1/2"
author: Eric Downes
categories: ["ethereum", "macroeconomics", "dynamics", "issuance"]
excerpt: Work on ETH Macro supported by the Ethereumm Foundation
usemathjax: true
thanks: We are deeply grateful to the Ethereum Foundation for their
support of this work.  I, the author, feel indebted to the profound
patience, forebearance, and professionalism of Eric Siu, as this is
*months* overdo.  This work has benefited significantly from
conversations with Danieli and Philipp, as well as Eric Siu, Andrew
Sudbury, and Ansgar Dietrichs.
---

# Ethereum Macroeconomics

This is the first of two posts on Ethereum macroeconomics.

Ethereum has grown into a [major economic
force](https://www.grayscale.com/research/reports/the-battle-for-value-in-smart-contract-platforms);
between its native asset Ether (ETH), the smart contract ecosystem
this supports, and the Layer-2 blockchains, a conservative valuation
might be half a trillion dollars.  At the core of Ethereum's "brand",
distinguishing it from other smart contract platforms, is the
consistent effort put into decentralized governance.  Via its
[consensus
mechanism](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/gasper/)
no central authority can censor a transaction, freeze the native asset
of a user, etc.  This brand commitment depends in turn on a sufficient diversity of
validators staking ETH to participate in consensus.

The share of Ether staked by "centralized" staking services, such as
exchanges and Liquid Staking Providers (LSTs) [is
considerable](https://dune.com/queries/2394100/3928083), and continues
to grow.  This has provoked [concerns](https://issuance.wtf/), among
Ethereum researchers that the future of Ethereum might involve

1. Nearly all Ether staked $s\to1$, such that or independently
2. The de facto currency is controlled by a confederation of centralized services.

## Lookahead

In this blog post we address the first of these concerns "runaway
(near 100\%) staking" using a "stock and flow" macroecnomics model
built with guidance from dynamical system theory.  In contrast with
other research we find inflation playing a positive but temporary role
in moderating runaway staking, though most likely $$s\to1$ eventually.
In the second post, we look more closely at governance centralization
and discuss a means for evaluating macroeconomic interventions inspred
by bifurcation theory.  Briefly, we are not optimstic that reducing
issuance will prevent governance centralization, either.

In both posts, we provide a few code examples using
[ethode](https://github.com/20squares/ethode/) a thin units-aware
wrapper we built around `scipy.odeint` to streamline model evaluation.
Readers desiring to follow our derivations, dive into technical
mathematical points not covered here, run their own simulations, or
learn some dynamical systems are recommended to look at our ethode
[guide](https://github.com/20squares/ethode/blob/master/guide/guide.md),
and references therein.  It is certainly a work in progress, but should have
enough to get you going.

## For The Impatient!

Issuance does not all get dumped into liquid unstaked Ether.  Some
portion of it is reinvested by staking businesses; indeed this process is
coded into LST smart contracts.
 
It is important to distinguish between transient behavior, such as
speculation in staking, and medium/long-term behavior, such as the
reinvestment of staking rewards by staking businesses.  When staking
is dominated by reinvestment instead of speculation, inflation
persistently decreases.

We use our macroeconmics model to identify a "low inflation; even
lower fees" regime (LI;ELF).  Outside of LI;ELF convergence to a
desirable staking future without runaway staking is unlikely.  Under
strong deflation, in which the magnitude of deflation exceeds the
reinvestment of transaction fees, probably corresponds to unstable
dynamics.  Under zero or low deflation, the tendency toward runaway
staking can be moderated only by very high churn and/or slashing.

In contrast within LI;ELF staked ETH fraction approaches near the
reinvestment ratio.  Thus, runaway staking can be avoided only while
inflation is held

1. low enough, that concerns over inflation do not dominate the
reinvestment of profits by staking businesses at equilibrium,
$$\frac{dr}{d\alpha}|^\star<0$$ (no news here) but simultaneously

1. high enough to numerically dominate priority fees and MEV, as a
fraction of unstaked Ether; $$\alpha^\star\gg f^\star$$.

The importance of this last point in moderating staking fraction feels
quite different to us, than the view on inflation expressed, for instance [in
this video/podcast](https://www.youtube.com/watch?v=ivynR3RI3_Y).

Inflation should *eventually* decay, driving $s\to1$, though it will
take some time.  This "L2 future" has been recognized by many others:
most Ether is staked, with the majority used for settlement of L2
rollups.  We'll discuss it more next time.

Given all the above, we advise caution.  Intervening to reduce the
issuance yield curve seems quite capable of exaccerbating the very
problems we seek to avoid.

## Modeling an Open Zeppelin[^humor]

First, a warning!  In an act of hubris, and with apologies, but not
without reasons[^reasons], we have chosen $S$ to refer to Staked ETH,
while others have at times used $S$ for "circulating (S)upply", which
we call instead $A$, so $s=S/A$.  Please proceed!

![Ethereum as a balloon with compartments.](
    ../assetsPosts/2025-01-15-issuance-dynamics/eth-balloon.jpg)

Consider a "balloon" with variable internal compartments.  The average
size of each is measured by *stocks*

- ($S$)taked Ether (participating in [consensus]()) is a compartment, as is
- ($U$)nstaked unburnt Ether,
  -- containing the ($V$)alidator reward queue.
- ($\cancel{O}$) is all irrecoverable (burned, lost, etc.) Ether, and
- ($A$)ccessible/Circul($A$)ting Ether supply, $A=S+U\approx120.4\times10^6$ in Dec 2024.
- $\mathcal{Q}_\pm$ the Ether in the staking ($+$) and unstaking $-$) queues

The net change in time of a stock is written using a dot, such as
$\frac{dA}{dt}:=\dot{A}$[^partial], the net change in accessible Ether
supply.  Stocks grow or shrink based on flows which add to or subtract
from their derivatives.  Here all flows are positive real numbers with
units \[ETH/yr\].

By averaging over "long" timescales (at least quarterly)[^aves] we
approximate the staking and unstaking queues as equilibrated;
$\mathcal{Q}_+\approx0\approx\mathcal{Q}_-$, and average over many
cycles of the erratic base fee oscillations.

So, our conceptual model:

$$\dislaystyle
\begn{array}{rcl}
\dot{A} &=& I - B - J\\
\dot{V} &=& I + P - R - K
\dot{U} - \dot{V} &=& K + Q_- - Q_+ - F\\
\dot{S} &=& R + Q_+ - Q_- - J\\
\end{array}
$$

| Flow Name        | Symbol | Domain$\to$Codomain[^cats] | Constraint |
| :--              | :--    | :-:                        | :--        |
| Tx Fees          | $F$    | $U\to\cancel{O},V$         | $B+P=F<U$ |
| Base Fees[^aves] | $B$    | $U\to\cancel{O}$           | .. |
| Priority Fees    | $P$    | $U\to V$                   | ..       |
| Issuance[^aves]  | $I$    | $\cdot\to V$               | $yS<I$ |
| Slashing         | $J$    | $S\to\cancel{O}$           | $J<S$ |
| Unstaking[^deneb]| $Q_-$  | $S\to U$                   | $Q_-<S$ |
| New Staking      | $Q_+$  | $U\to S$                 | $Q_++R<U$ |
| Reinvestment[^whyr] | $R$ | $V\to S$                   | $R+K+\dot{V}=I+P$ |
| Costs & Profits  | $K$    | $V\to U$                   | ..        |

Flows $(B,J,Q_-,\ldots)$ have a "domain" $(U,S,S,\ldots)$, where the
flow is coming from, and a "codomain"
$(\cancel{O},\cancel{O},U,\ldots)$, where the flow is going to.[^cats]
Flows obey constraints, often expressed as (in)equalities relating a
flow to its source.

In response to the concerns about $s\to1$, the recent [Deneb
upgrade](https://github.com/ethereum/consensus-specs/blob/dev/specs/deneb/beacon-chain.md)
implemented [EIP 7514](https://eips.ethereum.org/EIPS/eip-7514), an
upper limit on $R+Q_+$ chosen so as to not limit any present flows.
We also ignore the pre-existing symmmetric limits on (un)staking
$Q_\pm$.  The purpose of our models is to show, in the absence of such
limits, where the dynamics push the system.  If you wish to study the
dynamics post-Deneb, you could make $R+Q_+$ constant; we will revisit
EIP 7514 in our next post, on staking *composition*.  So the
constraints ($Q_-<S,Q_+<U$) could be tightened significantly, but more
accurate upper limits would play little role in our analysis.

A few flows deserve specific comment: $I$ and $(R,Q_+,K)$.

### Bounding Issuance $I$

All of these stocks and flows, $(I,S,\ldots)$, are moving
time-averages over *spot values* $(I^\bullet,S^\bullet,\ldots)$
defined at a given block; $S:=\tau^{-1}\int_{t-\tau}^t
S^\bullet(t')dt'$, etc.  In the case of issuance, we
can express spot issuance as a known function of the yield curve
$I^\bullet = y^\bullet S^\bullet$.  We'll assume that

1. Issuance is sublinear $\boxed{1\ll I\approx yS\ll S}$[^asym] to
avoid [discouragement
attacks](https://github.com/20squares/ethode/blob/master/guide/guide.md),
and that

2. the large-stake scaling of yield (like, on a log-log plot) is not
substantially altered by time averaging
$\frac{\partial{d\log~y}}{\partial{d\log~S}}\approx
\frac{\partial{d\log~y^\bullet}}{\partial{d\log~S^\bullet}}$.[^vitalikp]

The first is common and almost certainly an overestimate,[^ycov]
which we deem the correct direction to err in light of our results
concerning (the lack of) runaway inflation.

### Bounding Reinvestment $R$

Reinvestment of staking rewards by validators $R$ is acheived by
staking a new validator from existing rewards.  While clearly a
stochastic process, we approximate the net effect as smooth on
timescales of at least $\tau$.  $R$ represents a feedback loop
$S\overset{+}{\rightsquigarrow}S$ quite evidently related to the
potential positive-feedback between staking and inflation that people
have found concerning.

To express this concept succinctly in one flow variable, we require
that the averaging timescale $\tau$ be adjusted upward until most
validators claim and reinvest the bulk of their staking rewards
within.  That is $\dot{V}=0$, so $R+K=I+P$ so $R\leq I+P$.  The
quantity $r=R/(I+P)$, the ratio of staking rewards reinvestment over
issuance and priority fees is one of the distinguishing features of
our model, and also why we have split the staking queue flow $R+Q_+$.
These are our motivations:

1. Modelling $r$ is absolutely necessary to model LSTs.[^rlst]
2. We want to separate the *transient* externally-driven dynamics $Q_+$ from the
long-term endogenous feedback $R$,[^rdyn] and
3. $r$ could be measured and monitored with onchain data.

If the $\tau$ required to acheive $r=R/(I+P)<1$ in practice becomes
too large, one might revisit the approximations used to model
issuance, or use data to better model $\dot{V}$.  In neither case do
we expect this to make a huge qualitative difference for the issues
consiered here, but please, prove us wrong!

## Intensive Flows give Dynamical Systems

Flows obey inequalities, usually as a fraction of the
source.[^flowfrac] We convert these inequalities; for each uppercase
*extensive* flow $(J,F,B,\ldots)$ we define a lowercase *intensive
variable* $(j,f,b,\ldots)$: the fractions \[1\] and fractional rates
\[1/yr\].  In forming these, the ideal is to apply the tightest
available bounds that still capture the [asymptotic behavior]() in the
limit of interest $S\to A$.  We do not assume the intensive parameters
are constant, but suppress their dependence for readability.  Unless
otherwise stated, the intensives are functions of the dynamical
variables and time, so the burn: $b(A,S,t)=B/F$.[^time]

### Table of Flows

| Flow Name | Symbol | Domain$\to$Codomain[^cats] | Constraint | Intensive | Range \[Units\] |    
| :--              | :--    | :-:                 | :--        | :-- | :-- |
| Tx Fees          | $F$    | $U\to\cancel{O},V$  | $0<B+P=F<U$ | $f:=F/U$ | $f\in(0,1)$ [1/yr] |
| Base Fees[^aves] | $B$    | $U\to\cancel{O}$    | ..       | $b:=B/F$ | $b\in(0,1) \[1\] |
| Priority Fees    | $P$    | $U\to V$            | ..       | $1-b=P/F | $1-b\in(0,1)$ \[1\] |
| Issuance[^aves]  | $I$    | $\cdot\to V$        | $0<I<yS$ | $y\in(0,1)$\[1/yr\] |
| Slashing         | $J$    | $S\to\cancel{O}$    | $0<J<S$ | $j:=J/S$ | $j\in(0,1)$ \[1/yr\] |
| Unstaking[^deneb]| $Q_-$  | $S\to U$            | $0<Q_-<S$ | $q_-:=Q_-0/S | $q_-\in(0,1)$ \[1/yr\] |
| New Staking      | $Q_+$  | $U\to S$            | $0<Q_++R<U$ | $q_+:=Q_+/U | $q_+\in(0,1)$ \[1/yr\] |
| Reinvestment[^whyr] | $R$ | $V\to S$            | $R+K=I+P$ | $r:=R/(I+P)$ \[1\] | $r\in(0,1)$ \[1\] |
| Costs & Profits  | $K$    | $V\to U$            | ..        | $1-r=K/(I+P)$ | $1-r\in(0,1)$ \[1\] |

The use of intensive variable parameters and the approximation
$\dot{V}\approx0$[^flowfrac] allows us to reshape our conceptual model
into one that is defined in its own dynamical and intensive variables,
a *dynamical system*.  We'll build this up one step at a time.  As you
follow along you may find it useful to look at models in python.  You
can use these *extremely* rough estimates of constant parameters as a
start for the models that follow.

```python
from ethode import *
@dataclass
class ConstParams(Params):
    y1: 1/Yr = 166.3
    b: One = 1e-1
    f: 1/Yr = 3e-3
    j: 1/Yr = 1e-4
    r: One = .45
    qs: 1/Yr = 1e-5
    qu: 1/Yr = 1e-4
    s1: ETH = 1
    def yld(self, S:ETH, **kwargs) -> 1/Yr:
        return self.y1 * sqrt(self.s1 / S)
```

### $(S,U)$; not just a UNIX Command!

With the above, you should be able to construct the following $(S,U)$ system:

$$\displaystyle
\begn{array}{rcrlcrl}
\dot{S} &=& (ry-\jmath-q_-) & S & + & \left(q_++r(1-b)f\right) & U\\
\dot{U} &=& \left((1-r)y+q_-\right) & S & - & \left(rf+(1-r)bf+q_+\right) & U\\
\end{array}
$$

These coefficients of $S,U$ are miserably complicated-looking, but as
written they are all (but one) positive, and so we can reason about
this model's evolution.  Specifically, so long as $ry(S)>\jmath+q_-$
staked ETH $S$ just continues growing and growing.  In contrast it is
harder for $U$ to get as big, limited by its own loss term
$-\left(rf+(1-r)bf+q_+\right)\cdot U$.  At some point in the (far)
future $S$ becomes big enough that $ry(S)<\jmath+q_-$ and the system
becomes *capable* of oscillation, depending on parameters and a zoo of
partial derivatives.[^SU]

```python
@dataclass
class SUSimConst(ODESim):
    ic: tuple[ETH, ETH] = (120e6 * .3, 120e6 * .7)
    tspan: tuple[Yr, Yr] = (0, 100)
    params: Params = ConstParams()
    @staticmethod
    def func(t:Yr, v:tuple[ETH, ETH], p:Params) -> tuple[ETH/Yr, ETH/Yr]:
        x = {'S': (S := v[0]), 'U': (U := v[1])}
    	dS = (p.r * (y := p.yld(S)) - p.j - p.qu) * S + \
            ((rf := p.r * p.f) * (1 - p.b) + p.qs) * U
        dU = ((1 - p.r) * y + p.qu) * S - \
            (rf + (1 - p.r) * p.b * p.f + p.qs) * U
	return dS, dU
su = SUSim()
su.sim()
```

These dynamic variables are kind of boring, but critically and unlike
$(A,S)$, there are *no extra conditions* (such as $S<A$) that we
haven't told the math about.  The equations are not
[stiff](https://en.wikipedia.org/wiki/Stiff_equation); they can be
accurately simulated.  Most importantly, the variables of interest in
the ongoing debate are functions of $S,U$, so we lose nothing by
calculating them post-simulation; we'll demonstrate how.  Even as we
change dynamical variables for intuition building, we recommend using
models like $(S,U)$ as a base for simulation whenever possible.

### Inflation

Inflation is used to refer to many things, but here we mean
specifically the quarterly fractional change in accessible Ether.
Consider $\alpha:=\dot{A}/A\approx(I-B-J)/A$ in light of the [above
table](#table-of-flows).   In general and under
the existing yield curve we have (where $\beta=bf=B/U$):

$$\displaystyle
\alpha\approx y(sA)s-\beta(1-s)-\jmath s\right) = y_0(1)\sqrt{s/A}-\beta(1-s)-\jmath s
$$

You can explore this by noting `alpha(), sfrac()` as `@output` methods

```python
@dataclass
class SUaSim(SUSim):
    @output
    def sfrac(self, S:ETH, U:ETH) -> One:
        return S / (S + U)
    @output
    def alpha(self, S:ETH, U:ETH) -> 1/Yr:
        s = self.sfrac(S,U)
	return p.yld(S) * s - p.b * p.f * (1 - s) - p.j * s
su_a = SUSim_alpha()
su_a.sim()
```

### Persistent inflation cannot maintain

A key feature of $\dot{A} under the current yield curve $y_0(S)$ is
sublinear issuance $I\leq yS\lesssim S$, chosen to avoid
[discouragement
attacks](https://raw.githubusercontent.com/ethereum/research/master/papers/discouragement/discouragement.pdf).
Because of this, positive inflation cannot maintain indeinitely.  We
will demonstrate with the existing yield curve, but the argument is
general.  Unusually for this blog post, we will show most of the steps so
the argument is hopefully understood.

$$\displaystyle
\begin{array}{rcl}
dA = \alpha dt &\leq& \left(ys-\beta(1-s)-\jmath s\right)dt\\
dA &\leq& ysdt = y_0(1)\sqrt{s/A}dt \leq y_0(1)/\sqrt{A}dt\\
\sqrt{A}dA &\leq& y_0(1)dt\\
\int_{A(0)}^{A(t)}\sqrt{A}dA &\leq& \int_0^t y_0(1)dt\\
\frac{2}{3}x^3\Big|^{\sqrt{A(t)}}_{\sqrt{A(0)}} &\leq& y_0(1)t\\
A(t) &\leq& \left(A(0)+\frac{3}{2}y_0(1)t\right)^{2/3}\\
\therefore A(t) &\ll& e^{kt} ~\forall ~\mathrm{const.}~k>0
\end{array}
$$

The last line is asymptotic notation.  For two positive functions, $g$
dominates $f$, written $f(t)\ll g(t)$ just when
$\lim_{t\to\infty}[f(t)/g(t)]=0$.  Since supply $A(t)$ is *eventually*
less than a powerlaw of $t$, it is *subexponential*.  Thus, no
positive inflation rate can maintain indefinitely.

This does not mean we would find every intermediate inflation rate
pleasant.  Following surges in $Q_+$, inflation can accelerate quite
alarmingly.  A good example will be the 2032 Ethereum staking-mania.
This can be modeled in future retrospect by the following graph
showing a simulation with `qs=.05, qu=.01`; a constant $q_+=5$\% of
unstaked ETH is added to the staking queue each year.  We aren't
excited to hodl through multiple decades of 10\% inflation, and we
expect you aren't either.

![US President-Elect Swift Endorses Ethereum!](
    ../assetsPosts/swifties.jpg)

Instead of downplaying fears of inflation, rather we mean to separate
concerns.  Unpleasantly high inflation in the medium term, even if
that "medium term" lasts decades, is a *dynamics* problem, not an
equilibrium problem, and so dynamical solutions (like EIP 7514) seem
better suited.  Unfortunately we will see that given the above,
$s\to1$ is an *equilibrium* problem.

### Staking Fraction

We have equations for $\dot{A},\dot{S}$, what about
$\dot{s}=d(S/A)/dt$?  Using the quotient rule
$\dot{s}=\frac{\dot{S}}{A}-s\frac{\dot{A}}{A}$, and after an algebraic
massage, we obtain for staking fraction

$$\displaystyle
\begin{array}{rcl}
\dot{s} &=& y(sA)\cdot(r-s) + \\
 && \left[q_++f(1-s)\left(bs +(1-b)r\right)\right]\cdot(1-s) + \\
 && \left[j(1-s+r)+q_-\right]\cdot(0-s).
\end{array}
$$

The coefficients of $(r-s),~(1-s),~(0-s)$ are variable but *positive*.
Recalling how $s$ increases just when $\dot{s}>0$, these terms draw
$s$ toward respective points $r,1,0$.  We emphasize that the action of
yield $y$ is $x\to r$, which may not be the same as $x\to1$.

As expressed by the quotient rule, an increase in staking fraction
can be driven by more people staking, and/or it can be driven by a
reduction of the inflation rate.  The latter can be acheived in
principle by a reduction of issuance relative to the base fee "burn
rate".  Because of this quotient rule tradeoff, issuance plays a
beneficial "infrastructure" role in moderating staking fraction,
drawing it toward $r$, which can be less than one.

### $(A,\alpha,s)$ Dynamical System

There are many reasons, especially in the context of the world
economy, to care about total circulating supply $A$.  Recent
discussions however have focused most on inflation $\alpha=\dot{A}/A$,
the growth in supply over time.  It also turns out that modeling
inflation $\alpha$ directly simplifies our analysis of the $(A,s)$
system considerably.

Let subscripts denote partial derivatives
$x_y:=\frac{\partial{x}}{\partial{y}}$.  Using the correct partial
derivative relations for variables $(A,\alpha,s,t)$[^partial] we have

$$\displaystyle
\begin{array}{rcl}
\dot{A} &=& \pm\alpha A\\
\dot{s} &=& \pm\alpha(r-s) + (rf+q_+)(1-s) - (q_-+(1-r)j)s
\dot{\alpha} &=& \pm\xi\dot{s} - \gamma\alpha s \pm\chi
\end{array}
$$

Where the new greek letters are fractional rates, defined below, and
$y':=\frac{dy}{dS}$.

* $\mu:=\beta_\alpha(1-s)+\jmath_\alpha s$ is the implicit
  sensitivity of the inflation loss-term to increases in inflation.
  We judge $0\leq\mu$; if anything inflation increases burn and
  slashing fractional rates.[^mu]

* $\xi:=(y+y'A+\beta-\beta_s(1-s)-j-j_s)/(1+\mu)$ is the net
  correlation between changes in $s$ and changes in $\alpha$
  normalized by $1+\mu$. $\xi$ can be of either sign.  Under the
  current yield curve $y_0+\frac{dy}{dS}A=y_0(sA)(1-1/(2s))$, which
  changes its sign at 50\% ETH staked.

* $\gamma:=j_{\log{A}}s+\beta_{\log{A}}(1-s)+s|y'|A$ is a
  positive coefficient expressing how quickly $\alpha\to\alpha^\star$,
  and the partials are constant when initial supply is known.[^ics] We
  have extracted the sign from the final term because sublinear
  issuance implies $y'<0$; under the current yield curve the term
  $sA|y'|=\frac{1}{2}y_0(sA)$.

* $\chi:=-j_ts-\beta_t(1-s)$ represents externalities affecting the
  inflation loss term encoded as explicit time-dependencies.  We
  neglect externalities $\chi\approx0$ because we have nothing
  intelligent to say about them, but you might not want to.

#### Separation of Timescales and $\alpha>0$

Observe that every term in $(\xi,\gamma)$ are small fractions,
fractional rates, or derivatives thereof.  Indeed, when
$\alpha\approx0$ and sensityivities are weak, $|\xi|\sim\gamma\sim y$
obtains.  Generally if $|\xi|,\gamma\ll1$ then the derivatives obey
$|\dot{\alpha}|\ll|\dot{s}|$: a [seperation of
timescales](https://en.wikipedia.org/wiki/Method_of_averaging).  For
durations when this obtains, one or more periods at intremediate
times, inflation can be usefully approximated as a parameter instead
of its own dynamic variable, with staking fraction equilibrating to
$s^\star$ more quickly than $\alpha^\star$ equilibrates.

Does this hold presently?  For a sanity-check, a quick look at YCharts
since The Merge shows that $$s,\dot{s}$$ do indeed seem to vary over a
much greater range than $$(\log{A},\alpha)$$.

![The staking fraction from YCharts](../assetsPosts/2025-01-15-issuance-dynamics/YCharts-x.jpg)
![The inflation rate from YCharts](../assetsPosts/2025-01-15-issuance-dynamics/YCharts-alpha.jpg)

For the remainder of this post, we will assume this obtains.
Anecdotally, even when it does not, the revealed interplay between
inflation and staking fraction shows up, and is a very important
concept for Ethereum Macroeconomics.

# Staking Fraction in 1D

Recall our approximate equation for the fraction of staked ETH $s$, in
which all coefficients are positive but inflation $\alpha$:

$$\displaystyle
\dot{s} &=& \alpha\cdot(r-s) + (rf+q_+)\cdot(1-s) + (q_-+(1-r)j)\cdot(0-s)
$$

So assuming $|\dot{\alpha}|\ll|\dot{s}|$, let us examine the fixed
point $s^\star$ during a period in which we may treat inflation as
constant $\alpha=\alpha_{const}$.

$$\displaystyle
s^\star = \frac{
   r^\star(\alpha_{const} + f^\star) + q_+^\star
}{
   m^\star := (\alpha_{const} + r^\star f^\star + q_+^\star + q_-^\star + (1-r)\jmath^\star)
}
= 1 - \frac{(1-r)\jmath+q_-}{m^star} - \frac{\alpha_0(1-r^\star)}{m^\star}
$$

We will see that without $\alpha>0$ an interior market equillibrium is
very unlikely.  First, as a thought experiment, consider $\alpha=0$.

## Concerning Churn

A fixed point $s^\star(\alpha=0)<1$ would require either high churn or
a persistent unstaking/capitulation of existing validators
$q_-+\jmath>0$.  Validators try to minimize slashing as intended, but what would a
large unstaking flow $q_-s\gtrsim rf$ at $s^\star$ mean?

High unstaking requires *churn*, a persistent supply of new validators
to take their place $q_+^\star(1-s)\sim q_-s\gtrsim rf$, or it is only
a transient and $q_-^\star\ll rf$; recall that reinvestment by
existing validators is not counted in $q_+$.  Persistently high
unstaking $$q_-\sim rf$$ could only describe a market equilibrium if
one group of stakers was actively capitulating and withdrawing their
stake, while another group with a higher $$r$$ were aggressively
reinvesting in their business, and their reinvestment of fees and MEV
offset the unstaking, adjusted for inflation.

High churn, not counting reinvestment, cannot maintain forever:
eventually there will be no new Capitulators left, and $$s^\star$$
must once again grow as required by the Reinvestors' higher $$r$$, so
$$s^\star$$ was not a fixed point at all.  So $q_-^\star\ll
(rf)^\star$$.

Similarly, at some point everyone who wants to stake should have
staked.  If we judge the $\tau$-averaged flows due to the issuance of
new humans and the burn rate of legacy humans to be small, additional
validators count overwhelmingly toward $$r^\star$$ and
$$q_+^\star\ll(rf)^\star$$.  Thus, the fixed point $$s^\star$$
simplifies to

$$\displaystyle
s^\star \approx r^\star \frac{
    \alpha_const} + f^\star}{
    \alpha_const} + r^\star f^\star + (1-r)\jmath^\star}
= 1 - \frac{
    \jmath^\star}{
    \alpha_{const} + r^\star f^\star + (1-r)\jmath^\star}
  - \frac{\alpha_{const}(1-2)}{\alpha_{const} + r^\star f^\star + (1-r)\jmath^\star}
$$

We will explore the *stability* of this fixed point below, and based on
the range of $\alpha$ categorize three basic behaviors.

## Stability in One Dimension

Fixed-points are market equilibria just when they are stable.  Every
stable fixed point in a one-dimensional flow is locally stable.  In
general a fixed point is locally stable when small changes
(*perturbations*) shrink over time.  For a continuous map like ours,
this concerns the derivative of the RHS at the fixed point: if it is
negative, then small perturbations shrink and the fixed point is a
stable *sink*.  If the derivative is zero, the fixed point is a
degenerate *center*, unrealistic outside of physics.  If positive, the
fixed point is an unstable *source*.

![1D Stability Conditions](../assetsPosts/1d-stab.png)

Specifically, we want the sign of
$\left.\frac{\partial\dot{s}}{\partial s}\right|^\star$ to determine
wether $s^\star$ is (un)stable.  We will be ignoring the partial
derivatives ("sensitivities") by assuming they are small in comparison
with their corresponding intensives.[^small-part]



### Weak Deflation

If $\alpha_{const}\in(-rf-\jmath,0]$ then an interior market equilibrium
$s^\star$ requires high slashing, as we argued before based on
Churn.  All other things being equal, it is also less stable.



### Strong Deflation

Consider now $\alpha<-rf-\jmath$.  This could happen for instance if
the issuance curve were reduced particularly bluntly, or changes in
fundamentals drove either MEV or the base fee (and thus $f$) to a
persistently higher amount, such that $ys\ll bf(1-s)+\jmath s$.

These conditions cannot maintain of course.  You don't need
differential equations to see that $\alpha<0$ shrinks $A$, which
eventually raises $y(sA)$.  But as a temporary intervention to tame
runaway staking fraction how would this work?

### Low Inflation; Even Lower Fees

Well, that was deflating!  Let's cheer ourselves up by considering the
behaviors under $\alpha_{const}>0$.  A positive role for inflation can
be seen in the contours of the market equilibrium staking fraction
$$s^\star$$ corresponding to $$\dot{s}=0$$, shown here with
$\alpha^\star=\alpha_{const}$.

![alpha vs. s Figure](../assetsPosts/2025-01-15-issuance-fundamentals/staking-fixpoint.png).

To find the equilibrium values $$(\alpha^\star/f^\star,\,r^\star)$$
necessary to acheive a desired staking fraction $$x^\star$$, simply
pick a colored contour in the figure: these are the values of constant
$$x^\star$$.  For every point on this curve, the equilibrium
inflation:fee ratio $$\alpha^\star/f^\star$$ is the x-coordinate, and
the equilibrium reinvestment ratio $$r^\star$$ is the y-value.

A breakdown of limitng behaviors is illustrative under positive
inflation.  For any value of non-negative inflation, $$r^\star$$ is a
lower bound for the equilibrium staking fraction we should expect.  If
inflation dominates fees, $$\alpha_{const}\gg f^\star$$ then $s^\star$
is larger by a small amount than $r^\star$, while if fees dominate
inflation $$0<\alpha_{const}\ll f^\star$$ then $s^\star$ becomes
insensitive to non-zero reinvestment ratio and $$s^\star\to1$$.  For a
numerical comparison, eyeballing charts (so *extremely* rough
approximations here, possibly off by an order of magnitude) $$f
\approx .002<.005\approx\alpha$$ so to within 10\% error above,
$$s^\star\approx r^\star$$ over the range of $$r\in(.5,.75)$$ inferred
from the Lido yield rate.

How the transient values $$(\alpha_{now}/f,r)$$ relate to the true
equilibrium values $$(\alpha^\star/f^\star,r^\star)$$ depends on
some considerations:

* If indeed churn dies down and slashing stays relatively rare, then
  $r$ increases to reflect the growing share of businesses that
  reinvest the most; $r^\star\approx r_{max}$, where $r_{max}$ is
  assesed over all staking pools with at least 10\% of $S$.

* We are holding $\alpha_{const}=\alpha^\star$, so
  $\alpha_{now}\approx\alpha^\star$ but a more sophisticated approximation
  is likely possible keeping within the two-timescale context... maybe
  you'll find one!

### Runaway $r$ from Inflation pressure

Could the sensitivity $r_\alpha$ be sufficient such that even at
intermediate timescales we see $s\to1$?  This is certainly possible;
per the arguments of Ethereum researchers, high inflation could still
lead to runaway staking if $r$ is sensitive enough.

In our model the net effect of inflation on LI;ELF staking fraction 
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

In practtice it all depends on what ETH users consider sufficiently
"high" inflation to respond; the above conditions just reflect a
quantification of this preference.  We hope that this work can be
built upon to determine what threshold of inflation or business
conditions satisfy the above condition.  No mean feat, but it would help focus
inflationary pressure arguments into empirically measurable assertions
that can be tracked for Ethereum health.


# Concluding Discussion

We saw above a few things:

1. Reinvestment $r$ is a lower-bound for $s^\star$.
1. Low (but positive) inflation moderates staking fraction closer to this lower bound
   at intermediate timescales
1. Positive inflation cannot maintain indefinately, so eventually $s\to1$.

Conceptually, how can inflation *moderate* staking fraction, though?
Shouldn't more staking lead to more issuance, which leads to more
inflation, etc.?  Briefly the reasons are:

* Short $Q_+$ vs. Long Term $R$ Investment
* The Quotient Rule $\dot{S}=\dot{S}/A-s\dot{A}/A$

## Short Term vs. Long Term.

Novel investment in staking $Q_+$ is driven largely by speculation,
and new users encountering Ethereum.  $Q_+$ acts to increase staking
fraction, as seen above, and indeed the glut in $Q_+$ since the Merge
may have been the source for all of the alarm that prompted this
study. Novel speculative investment must eventually dry up, and be
replaced by long-term investmemnt $R$, because

1. everyone with money who wants to stake eventually will, so will be
counted in $R$ not $Q_+$
2. any business that wants to stay in
business cannot consistently reinvest more than its revenue $R\leq
I+P$.

Of the long term signal $R$, only the issuance portion of
reinvestment, that is the part that contributes to inflation, can
moderate $s$, which brings us to the quotient rule.

## The Quotient Rule

$$\displaystyle
\dot{s}=\frac{\dot{S}}{A}-s\frac{\dot{A}}{A}=\frac{\dot{S}}{S}-s\alpha
$$

What increases $s$ is any increase in staked Ether $S$, but also any
net decrease in $A=S+U$. Inflation $\alpha$ increases *both* $U$ and
$S$, because some of that increase is used to meet costs and take
profit $(1-r)\alpha$, which increases $U$ relative to $S$.  In
contrast, the reinvestment of transaction fees can only ever increase
$S$ at the expense of $U$.  Thus transaction fees always act to
increase staked fraction, while the effect of inflation depends on the
relative values of reinvestment ratio and staking fraction.

So, while we could certainly model reinvestment differently, and there
are lags we are blithely integrating over, we think that these market
forces will still act as described above in a different model.  It is
possible that even during sustained inflation, these effects will be
unable to prevent the upward creep in $s$, because $r$ is too large,
or the sensitivity of $r$ to inflation at equilibrium is too great, a
condition which we mathematized above.  In fact we expect that every
argument about inflation effects driving increased staking, overpaying
for security, etc. could (perhaps should) be rephrased in terms of
reinvestment of staking rewards.  All these critically depend on the
preferences of ETH users for, and thus their behavior in reaction to,
inflation rate etc., which thusfar are not measured.  We encourage the
community to rectify this!

## Can reflexivity prevent $s\to1$?

Regarding the possible effects of reflexivity.  We have neglected even
discussing oscillations in $(S,U)$, even though the model is plainly
capable of such behavior under different parameters or when coupled to
price.  Why such negligence?  If cycles *do* arise, we expect market
participants, anticipating such cycles, would act to profit off of
these cycles in a way that should reduce them.  Buy late in the
inflation cycle, sell, late in the deflation cycle, etc.

Notably though, we only expect this to happen because
it does not require the coordination of market participants: each
individual blindnly pursuing their own utility should help en masse
control these oscillations, or they were never very great to begin
with.

Could there be a similar effect with staking fraction or inflation?
In short we have no idea, but put it as a challenge to the reader.
Can you devise a cryptoeconomic protocol or trading strategy that
forestalls the seemingly inevitable $s^\star\to1$?  If not, can you
prove this is impossible?

## Should We Change $y$?

So, finally... should the Ethereum community reduce issuance?

* Glib answer:

Nope.

* Short answer:

If you are very inflation averse or you want to slow down the
transition to high staking, please consider and simulate downward
adjusting the constants in EIP 7514, adopted during the Deneb upgrade.
This already directly limits $R+Q_+$, but was very nicely designed
to not interfere with existing staking flows.  EIP 7514 does not
solve, and does not claim to solve, the long term problems, but we
have been forced to conclude that reducing issuance doesn't solve them
either!

* Long answer:

Ask the users, especially the validators, especially the LSTs.  Model
user preferences so that the demand curve becomes semi-empirical
instead of theorized.  Near-100\% staking seems to be baked-in
eventually, and high inflation cannot sustain under an issuance yield
curve designed to avoid discouragement.  So the question becomes
essentially "How bad will it get in the meantime?"  This is actually a
question about user preferences.  Austrian School devotees may be so
inflation-averse that they are already staking all their
previously-liquid ETH at $\alpha\approx0.5$\%/yr.  In contrast users
who were content to grow up with fiat currencies during periods of
$\approx$3\% inflation or even worse might not care, or would just
stake in Compound or buy stETH.

For users seeking to passively preserve wealth, staking in Compound
(or Aave, or whatever) is ideal for generating raw Ether demand, of
course.  Staking in LSTs, though concerning from a governance angle,
may present less of an issue than some have feared.  LSTs must share
some yield with users to be in business, but if they want to profit
themselves must maintain $r<1$.

So how high can $r_{LST}$ go before LSTs find the loss of gross
profits unacceptable?  Great question.  We will see next time that as
many have recognized, the entity/group that can maintain the highest
$r$ wins the race eventually.  It's worth noting however that if you
apply price uncertainty via a risk-discounting rate of, well anything
really, you will see that the "maximize $r$" strategy is far from the
most profitable, risk-adjusted.  Of course, a speculative investor
seeking to profit from our analysis would find our study woefully
short of details.  Put anoher way, since you have insisted on reading
the "long answer", we will end with the classic and cowardly refrain
of academics and academic-adjacents everywhere "it requires more
research!"


# Dynamical Systems References

# Footnotes

[^humor]: [Open Zeppelin]() is an early icon of smart contract best
practices, and continues to provide templates and auditing services in
high demand.  They have absolutely no connection to this post, our
models, etc. and hopefully they will not sue us for using their name
in a bad dynamical systems joke.

[^aves]: We use moving quarterly averages, though any timescale
$\tau$ sufficiently long that the [fast dynammics]() of [the base]()
fee are [integrated out](), and the lags from (un)staking queues are
not appreciable; see [guide](https://github.com/20squares/ethode/blob/master/guide/guide.md) for details.  As we are averaging
quarterly, we set the staking $\dot{\mathcal{Q}}_+$, unstaking
$\dot{\mathcal{Q}}_-$, and reward $\dot{W}$ queues to zero, including
their respective flows ($R+Q_+,Q_-,I+P$) in their target stocks
($S,U,V$); even if ethereum produces empty blocks, so long as the
reward queue is not empty $U>0$.

[^IyS]: The approximation is due to the use of quarterly averages.  A
more precise approximation is $$\displaystyle
I=\frac{1}{\tau}\int_{t-\tau}^ty^\bullet S^\bullet dt'=yS-|\kappa| $$
where $$S^\bullet,y^\bullet$ are spot values and the quarterly
covariance between staking and yield is
$\kappa=\int_{t-\tau}^t(y^\bullet-y)(S^\bullet-S)dt'<0$.  See the
[ethode guide](https://github.com/20squares/ethode/blob/master/guide/guide.md) for more discussion.

[^regex]: This regex script is provided to translate the $\LaTeX$
within the markdown source to (our esimatimate of) terminology more
common at [issuance.wtf](https://issuance.wtf)

[^partial]: Sometimes $\dot{x}=dx/dt$ is used e.g. for the partial
derivative $\frac{\partial x}{\partial t}$, *but not here*.  For a model
in which you assume dynamical variables $(A,s,\alpha)$, these derivatives
are related for some parameter $x(A,s,\alpha,t)$
$$\displaystyle
\frac{dx}{dt} := \dot{x} =
\frac{\partial x}{\partial t} +
\frac{\partial x}{\partial A}\dot{A} +
\frac{\partial x}{\partial s}\dot{s} +
\frac{\partial x}{\partial\alpha}\dot{\alpha} =:
x_t + x_A\dot{A} + x_s\dot{s} + x_\alpha\dot{\alpha}
$$
in which each partial is taken holding all the other variables constant,
and $\frac{\partial x}{\partial t}$ is used in practice to capture any
variability from non-dynamical variables.  In principle
$\partial_A{x}$ and $\partial_\alpha{x}$ are distinct; a quantity can
depend on supply (how big ETH market cap is compared to BTC, say)
and inflation independently.

[^yield]: For anyone from finance, this is *not* the same as a [bond
yield curve](https://www.investopedia.com/terms/y/yieldcurve.asp);
there is essentially no necessary lag for vaidator rewards, accounting
quarterly.


[^reasons]: The entire human project of using symbols to refer to
things is deeply cursed and probably hopeless.  Nonetheless, we all
presist in providing excuses for

[^cats]: We use domain/codomain in imprecise analogy with category
theory mainly because we want to reserve "source" for an attractor, as
per dynamical systems.  The analogy, whie imprecise is not
inappropriate.  It is routine to implicitly use associativity to
account for fibers of flows through multiple steps; "electricity from
wind/nuclear/gas" even though the electrons are indistinguishable.
Flows such as tx fees $U\overset{F}{\longrightarrow}V,\cancel{O}$
involve a categorical product $V\times\cancel{O}$ in that the
fractional flows $U\overset{B}{\longrightarrow}\cancel{O}$ and must
factor through $V\times\cancel{O}$.  For any flow with contributions
to stocks $V,\cancel{O}$ it is not hard imagining a uu2i universal
object $V\times\cancel{O}$ mediating.  Similarly the staking queue
$V+(U-V)\overset{R+Q_+}{\longrightarrow}S$ should involve a
categorical coproduct.  Wether there is content here beyond "flows are
functions in $\sf Set$" is unclear.  None of this matters in the least
for Ethereum dynamics, of course.  If you're reading it consider this
an easter egg / attempt to detect a living and alert audience.

[^elowex]: Why not simply choose \"$B=bA$\" as was done more simply (modulo
syntax) in [Elowsson 2020]()?[^syntax] Obviously if there is no
unstaked Ether no one can afford tx fees, but this might not matter.
More importantly $S$ is a *dynamical variable*, so $b=B(A-S)$ is more
appropriate here.  The function $B$ might do all kinds of complicated
nonsense, but it can never go negative and it can never exceed $U$.

[^whyr]: Intensives expressed as fractions of flows such as $R/(I+P)$), instead
of fractional rates of sources (like $J/S$ or $Q_-/S$) occur when the
source dynamical variable, here $V$, is assumed to equilibrate
$\dot{V}\approx0$.  Then the outging flows $R+K$ must equal the
incoming flows $I+P$, so we choose $R=r(I+P)$.  If onchain data
indicates %\approx$70\% reinvestment of staking rewards into $S$ takes
a lot longer than a quarter we would revisit this assumption, though
we do not expect our qualitative results to change re inflation and
staking fraction.

[^rlst]: A non-zero $r=R/(I+P)$ is built into the smart contract of every
Liquid Staking Provider (LSP).  Here, token-holders provide Ether
and receive a redeemable token (LST) that shares some staking rewards
with them. This fraction of rewards $r_{LST}$ is a lower bound on
the long term behavior $r_{LST}\leq r_{LSP}\leq
R^\star(I^\star+P^\star)$; more on this next time.

[^rdyn]: Splitting the staking queue into $R+Q_+$ allows us to
somewhat separate short-term *transient* behavior from long-term
dynamics.  Speculative investment in staking by venture capitalists
and novice stakers is expected to die down eventually
$\lim_{t\to\infty}Q_+\approx0$; either they give up or they run
staking like a business where making a profit matters.  Every business
that wants to stay in business reinvests some portion of its profits,
so $r,R>0$ and is what matters in the long run, once most everyone who
wants to stake is indeed staking.

[^metastable]: Metastability involves a region of space where
trajectories are bounded surrounding a fixed point with at least one
eigenvalue with positive real part.  We won't rule it out, but look
first for stable fixed points.

[^time]: We can often use the dependence on $t$ to smuggle in
any forces, like market panics, etc. that we neglected to include as
dynamical variables.  If not, we must add a dynamical variable.

[^asym]: Specifically $I\ll S$ means that \lim_{S\to\infty}(I/S)=0,
which according to Buterin's [annotated spec]() is satisfied even
without the limit; see [guide](https://github.com/20squares/ethode/blob/master/guide/guide.md).

[^ycov]: The relation between quarterly averaged issuance and
the yield curve $y^\bullet$ is:
$$\displaystyle
I:=\int_{t-\tau}^t y^\bullet(S^\bullet)S^\bullet(t')dt'\approx yS-|COV(y^\bullet,S^\bullet)|
$$
where we approximate $y,S$ as constant on the interval $(t-\tau,t)$
and the covariance is negative
$0>COV(y^\bullet,S^\bullet)=\tau^{-2}\int_{t-\tau}^t(y^\bullet -
y)(S^\bullet-S)dt'$.  The use of covariance here may seem a bit silly;
$y^\bullet(S^\bullet)$ is a deterministic relationship!
We do this because the community is discussing changing the yield curve, and we want to discuss
generic features of Ethereum.
So we have used approximations that we felt err in a conservative direction without explicit
depenedence on the present-day yield curve $y^\bullet_0(S^\bullet)=y_0(1)\sqrt{S_1/S}$ where
$y_0(1)\approx166.3$/yr and $S_1=1$ETH.

[^params]: Variable parameters that are positive fractions cannot
contribute fixed-points themselves, but they can strongly influence
*where* a fixed point is. Example: as $s\to1$, if the leading terms
were $\beta\sim(1-s),j\sim(1-s)^2$ this gives increasingly larger
$A^\star$ as $s\to1$.

[^vitalikp]: Our $\frac{\partial{d\log~y}}{\partial{d\log~S}}$ is
$p-1$ in the [discouragement paper](https://github.com/20squares/ethode/blob/master/guide/guide.md)

[^deneb]:


[^noburn]: While slashing could believably go to zero on quarterly
timescales, no burn $B=0$ implies blocks are empty, at least.
Obviously this isn't really a functioning state for Ethereum, but
think of it as a limiting behavior.  A more nuanced treatment of
$s\to1$ can be obtained assuming $s^\star=1-\epsilon$ where
$\epsilon\ll1$, making $A^\star\sim (y(1)/b^\star
f^\star)^2\epsilon^{-2}$; as $\epsilon$ is very small $\epsilon^{-2}$
is very large.  Detailed treatment of the forces using expansions in
$\epsilon$ are useful, and we would need to model churn, slashing, and
burn in light of stochasticity/quantization.  One can use difference
equations, but a useful generic behavior of such systems (a "weak
coupling" limit) is that such perturbations move the dynamics away from the
fixed point, apparently randomly, yet the average rate of precession
about $s^\star=1-\epsilon$ is often still given by the imaginary
component of the largest eigenvalue.

[^mu]: If anything the fractional rates
  of slashing and burn are positive with small changes in inflation,
  due to either a single ETH potentially being of less real value, or
  stimulation of economic activity attracting more validators and
  higher average burn.

[^ics]: $\gamma$ expresses the sensitvity of inflation to supply
  initial conditions; the partial $x_A$ always holds $(\alpha,s)$
  consant, but $\dot{A}=\alpha A$, and the only partials in $\gamma$
  are $\jmath_A,\beta_A$.

[^small-part]: Small sensitivities wrt intensives is not gauranteed.
Certainly a large magnitude, say $\beta_s>1$ cannot maintain for too
long: $\beta\in(0,1)$ afterall, but locally, a large derivative
$\beta_s>\beta$ is possible.

[^stability]: Assesing the stability of very long-term
$\alpha^\star=0$ in the $(A,s,\alpha)$ model directly is interesting
but academic.  One of the eigenvalues at any fixed point with
$\alpha^\star=0$ must be zero, so higher-order terms matter (the fixed
point is degenerate), and linear-stability analysis is insufficient.
A reader imbued with mathematical athleticism and free time is
encouraged to think of a Lyapunovv function $л(y)$ for issuance yield,
and derive a contraction mapping $\dot{л}(y)<0$.

[^SU]: Readers wishing for more detail are encouraged to use the two
dimensional local stability criterion (see
[Strogatz](https://www.youtube.com/watch?v=9yh9DmNqdk4)) to solve for
the condition of eigenvalues with an imaginary part.  But simulate it
too!
