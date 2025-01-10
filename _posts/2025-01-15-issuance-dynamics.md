# Ethereum Macroeconomics

This is the first of two posts on Ethereum macroeconomics.

Ethereum has grown into a [major economic
force](https://www.grayscale.com/research/reports/the-battle-for-value-in-smart-contract-platforms);
between its native asset Ether (ETH), the smart contract ecosystem
this supports, and the Layer-2 blockchains, a conservative valuation
might be half a trillion dollars.  At the core of Ethereum's "brand",
distinguishing it from other smart contract platforms, is the
consistent effort put into decentralized governance.  Via its
[consensus mechanism]() no central authority can censor a
transaction, freeze the native asset of a user, etc.  This depends in
turn on a sufficient diversity of validators staking ETH to
participate in consensus.

The share of Ether staked by "centralized" staking services, such as
exchanges and Liquid Staking Providers (LSTs) [is
considerable](https://dune.com/queries/2394100/3928083), and continues
to grow.  This has provoked [concerns](https://issuance.wtf/), among
Ethereum researchers that the future of Ethereum might involve (1)
nearly all Ether staked, such that (2) the de facto currencies used by
most users are controlled by a confederation of centralized services
with much less transparent governance, and no practical alternative.

## Lookahead

First, a warning!  In an act of hubris, but not without
reasons[^reasons], we have chosen $S$ to refer to Staked ETH, while
others have at times used $S$ for "circulating (S)upply", which we
call instead accessible ETH supply $A$, so $s=S/A$.  [Here]() is a
python script for converting between our variables and those most
commonly used on [issuance.wtf](https://issuance.wtf).

In this blog post we address the first of these concerns "runaway
(near 100\%) staking" using a "stock and flow" macroecnomics model
built with guidance from dynamical system theory.  In contrast with
other research we find inflation playing a positive but temporary role
in moderating runaway staking, though most likely $$s\to1$ eventually.
In the second post, we look more closely at governance centralization
and discuss a means for evaluating macroeconomic interventions inspred
by bifurcation theory.  Briefly, we are not optimstic that reducing
issuance will prevent governance centralization, either.

In both posts, we provide a few code examples using [ethode](https://github.com/20squares/ethode/) a thin
units-aware wrapper we built around `scipy.odeint` to streamline model
evaluation.  Readers desiring to follow our derivations, dive into
technical mathematical points not covered here, run their own
simulations, or learn some dynamical systems are recommended to look
at our ethode [guide](https://github.com/20squares/ethode/blob/master/guide/guide.md), and references therein.  It is certainly
incomplete, but should have enough to get you going.

## For The Impatient!

We use our macroeconmics model to identify a "low inflation; even
lower fees" regime (LI;ELF).  Outside of LI;ELF convergence to a
desirable staking future without runaway staking is not possible.
Strong deflation likely corresponds to unstable dynamics, where it is
difficult to predict wether staking fraction approaches 0 or 100\%.
Under zero or low deflation, the tendency toward runaway staking can
only be moderated by very high churn and/or slashing.

In contrast within LI;ELF staked ETH fraction approaches near the
reinvestment ratio.  Thus, runaway staking can be avoided only while
inflation is held

1. low enough, that concerns over inflation do not dominate the
reinvestment of profits by staking businesses at equilibrium,
$$\frac{dr}{d\alpha}|^\star\leq0$$ (no news here) but simultaneously

1. high enough to numerically dominate priority fees and MEV, as a
fraction of unstaked Ether; $$\alpha^\star\gg f^\star$$.

The bad news for opponents of runaway staking is that long
$$t\to\infty$$ term, the inflation fixed point $$\alpha^\star$$
approaches zero, so $$s^\star\to1$$. Ethereum would undergo cycles of
inflation/deflation which we expect to die down, until an "L2 future"
is reached, which we'll discuss next time.
This is the scenario, recognized by many others where
most Ether is staked, with the majority used for settlement of L2
rollups.

Given all the above, we advise caution.  Intervening to reduce the
issuance yield curve seems quite capable of exaccerbating the very
problems we seek to avoid, or causing even worse problems.

## Modeling an Open Zeppelin[^humor]

![Ethereum as a balloon with compartments.](
    ../assetsPosts/2025-01-15-issuance-dynamics/eth-balloon.jpg)

Consider a "balloon" with variable internal compartments.  The average
size of each is measured by *stocks*

- ($S$)taked Ether (participating in [consensus]()) is a compartment, as is
- ($U$)nstaked unburnt Ether,
  -- containing the ($V$)alidator reward queue.
- ($\cancel{O}$) is all irrecoverable (burned, lost, etc.) Ether, and
- ($A$)ccessible Ether supply, $A=S+U\approx120.4\times10^6$ in Dec 2024.
- $\mathcal{Q}_\pm$ the Ether in the staking ($+$) and unstaking $-$) queues

The net change in time of a stock is written using a dot, such as
$\frac{dA}{dt}:=\dot{A}$[^partial], the net change in accessible
Ether.  Stocks grow or shrink based on flows which add to or subtract
from their derivatives.  Here all flows are positive real numbers with
units \[ETH/yr\].  By averaging over "long" timescales (at least
quarterly)[^aves] we approximate the staking and unstaking queues as
equilibrated; $\mathcal{Q}_+\approx0\approx\mathcal{Q}_-$.  So, our
conceptual model:

$$\dislaystyle
\begn{array}{rcl}
\dot{A} &=& I - B - J\\
\dot{V} &=& I + P - R - K
\dot{U} - \dot{V} &=& K + Q_- - Q_+ - F\\
\dot{S} &=& R + Q_+ - Q_- - J\\
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

In response to the concerns about $s\to1$, the Deneb upgrade
implemented EIP 7153, an upper limit on $R+Q_+$ chosen to not limit
any present flows.[^deneb] We also ignore the pre-existing symmmetric
limits on (un)staking $Q_\pm$.  The purpose of our models is to show,
in the absence of such limits, where the dynamics push the system.  We
will revisit EIP 7153 in our next post, on staking *composition*.  So
the constraints ($Q_-<S,Q_+<U$) could be tightened significantly, but
more accurate upper limits would play little role in our analysis.

A few flows *do* deserve further comment: $I$ and $(R,Q_+,K)$.

### Bounding Issuance $I$

All of these stocks and flows, $(I,S,\ldots)$, are moving
time-averages over *spot values* $(I^\bullet,S^\bullet,\ldots)$
defined at a given block; $S:=\tau^{-1}\int_{t-\tau}^t
S^\bullet(t')dt'$, etc.  In the case of issuance, we
can express spot issuance as a known function of the yield curve
$I^\bullet = y^\bullet S^\bullet$.  We'll assume that

1. Issuance is sublinear $\boxed{1\ll I\approx yS\ll S}$[^asym] to avoid
[discouragement attacks](https://github.com/20squares/ethode/blob/master/guide/guide.md), and that
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
within.  That is $\dot{V}=0$, so $R+K=1+P$ so $R\leq I+P$.  The
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
$\dot{V}\approx0$[^flowfrac] allows us to reshape our conceptual model into one
that is defined in its own dynamical and intensve variables, a
*dynamical system*.  We'll build this up one step at a time.

### Supply growth, Crudely in One Dimension

Consider $\dot{A}=I-B-J$ in light of the [above
table](#table-of-flows), $\dot{A} = y(S)S - bf(A-S) - jS$.  To
understand the dynamics of circulating supply, we need to understand
that of staked ETH.  As a crude approximation, lets temporarily hold
staking fraction $s=S/A$ constant.

$$\displaystyle
\dot{A}=\left(y(sA)-\beta(1-s)-js\right)A=y_0(1)\sqrt{sA}-[bf(1-s)+js]A
$$

You can explore this system using the following code.

```python
class ACrude(ODESim):
    beta: One/Yr
    j: One/Yr
    y1: One/Yr = 166.3 / Yr
    s: One = .5 * One
    def yield(self, S:ETH) -> One/Yr: return self.y1 / math.sqrt(S)
    @staticmethod
    def func(A:ETH, t:Yr, p:Params) -> ETH/Yr:
    	gain = p.yield(p.s * A)
	loss = p.beta * (1 - p.s) + p.j * p.s
        return (gain - loss) * A
model = ACrude(beta = 8e-3/Yr,  j = 1e-6/Yr,  y1 = 166.3/Yr,  s = .3 * One)
model.sim()	      
```

If you have an opinion about $j(A),\beta(A)$ you can replace the parameter
entries with functions, like what we did for `yield`: replace `pass`
with your desired behavior, using `self.b` etc. to access parameters.
Within `func` use `p.burn` instead of `self.burn`; `ODESim` takes care
of the plumbing.

```python
class ALessCrude(ACrude):
    def slash(self, A:ETH) -> One/Yr:
        pass # Your insights here 
    def burn(self, A:ETH) -> One/Yr:
        pass # Your insights here
    @staticmethod
    def func(A:ETH, t:Yr, p:Params) -> ETH/Yr:
    	gain = p.yield(p.s * A) * A 
	loss = p.slash(A) + p.burn(A) 
        return gain - loss
```

$A$ grows when the right hand side (RHS) is positive, and shrinks
otherwise.  Pretending $s=s^\star$ constant, we obtain the *fixed
points* $A^\star$ at which $\dot{A}=0$.  Because $0<\beta,j<1$ the
parameters cannot contribute fixed points themselves, only influence
where they occur.[^params] Let $\beta^\star=f(A^\star,s^\star,\ldots)$
represent the burn fractional rate $\beta=bf=B/U$ evaluated at the fixed point.
There are two trivial fixed points, trivial $A^\circ=0$, and a
non-trivial fixed point

$$\displaystyle
A^\star = \left(
\frac{y(1)\sqrt{s^\star}}{\beta^\star(1-s^\star)+j^\star s^\star}
\right)^2
$$

### Stability in One Dimension

In general the *stability* of a fixed point for a one-dimensional flow is
determined by the derivative of the RHS at the fixed point: if its
negative, then small perturbations shrink and the fixed point is
stable.  Otherwise, it is unstable.[^centers]

![1D Stability Conditions](../assetsPosts/1d-stab.png)
Specifically, the sign of $\left.\frac{\partial\dot{A}}{\partial
A}\right|^\star$ determines wether $A^\star$ is (un)stable.  After
some manipulations, a *sufficient*[^if-vs-iff] condition for
stability is

$$\displaystyle
\left.\frac{\partial\log~B}{\partial\log~A}\right|^\star~~\mathrm{or}~~
\left.\frac{\partial\log~J}{\partial\log~A}\right|^\star~~~>~~~\frac{1}{2}.
$$

If either is satisfied, the fixed point is stable, and $A^\star$
represents the equilibrium supply value, at which Ether acheives zero
growth.  Essentially the leading component of the loss term must
increase faster than $\sqrt{A}$ near the fixed point.  Note that
constant $\beta,j$ correspond to scaling exponent $1$, so satisfy.

To simplify, assume negligible slashing; there must be sufficient
economic activity so that the burn scales at least as the square-root
of supply, or else $A^\star$ is unbounded.  That is true inflation,
not just in the sense of supply expansion, but the *demand not growing
sufficiently with the supply*.  This is similar to the concern raised
by [Elowsson 2020]().

### Positive Inflation cannot maintain

What happens to equilibrium supply $A^\star$ then, if $s\to1$ and
slashing is negligible, or the partials $\partial_AB,\partial_AJ$ are
insufficient such that $A^\star\to\infty$?

Inflation is used to refer to many things, but here we mean
specifically the quarterly fractional change in accessible
Ether. Let's express inflation $\alpha:=\frac{d\log~A}{dt}$ in
terms of $s$ and the intensives

$$\displaystyle
\begin{array}{rcl}
\dot{A} &=& \alpha A\\
\alpha &=& (I-B-J)/A \approx y(sA)s - bf(1-s) - js
\end{array}
$$

A key feature of $\dot{A} under the current yield curve is sublinear
issuance $I\leq yS\lesssim S$, chosen to avoid [discouragement
attacks](https://raw.githubusercontent.com/ethereum/research/master/papers/discouragement/discouragement.pdf).
Because of this, the positive term continues to get smaller as
Accessible ETH supply grows; $\dot{A}\leq y(As)A$, under the current
yield curve $\dot{A}(s,A)\leq y_0(1)\sqrt{sA}$.  So, at any point,
given supply $A$, the inflation rate $\alpha = \dot{A}/A$ cannot be
larger than $\alpha_{max}=y_0(1)\sqrt{s/A}$.  Constant positive
inflation corresponds to $A$ growing, and for
any positive constant $\alpha=\epsilon$ there is some $A$ at which
$\epsilon=\alpha_{max}(A)$.  Total circulating suopply $A$ is
bounded above by a subexponential function for all time.

That is, inflation must eventually return toward zero, even in the
pressence of very weak burn, slashing, and very high staking fraction.
This is not emphasized enough in our discussions.

### Two Dimensional $(A,s)$ System

We know well that $s$ is *not constant*.  We have equations for
$\dot{A},\dot{S}$, what about $\dot{s}=d(S/A)/dt$?  Using the quotient
rule $\dot{s}=\frac{\dot{S}}{A}-s\frac{\dot{A}}{A}$, and after an
algebraic massage, we obtain for staking fraction

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
yield $y$ is $x\to r$, *not* $x\to1$, unless $r\geq1$.

As expressed by the quotient rule, an increase in staking fraction
can be driven by more people staking, and/or it can be driven by a
reduction of the inflation rate.  The latter can be acheived in
principle by a reduction of issuance relative to the base fee "burn
rate".  Because of this quotient rule tradeoff, issuance plays a
beneficial "infrastructure" role in moderating staking fraction,
drawing itb toward $r$, which may be less than one.

Other aspects are harder to read, as this is quite a complicated
equation, but we finally have a dynamical system.  You can simulate a
general version of it, filling in your desired behavior for `pass` and
adding inflation as an output, as follows:

```python
class AsSys(ODESim):
    def yield(self, S:ETH) -> One/Yr: pass
    def burnfrac(self, A:ETH, s:One) -> One: pass
    def feefracrate(self, A:ETH, s:One) -> One/Yr: pass
    def slashfracrate(self, A:ETH, s:One) -> One/Yr: pass
    def rnvstfrac(self, A:ETH, s:One) -> One: pass
    def qstake(self, A:ETH, s:One) -> One/Yr: pass
    def qunstake(self, A:ETH, s:One) -> One/Yr: pass
    def _hlpr(self, A:ETH, s:One) -> tuple[One/Yr,One/Yr,One,One/Yr]:
    	beta = (b := self.burnfrac(A,s)) * (f := self.feefracrate(A,s))
	return s * self.slashfracrate(A,s), beta * (1 - s), b, f
    @output
    def inflation(self, A:ETH, s:One) -> One/Yr:
        slash, burn = self._hlpr(A,s)[:2]
        return self.yield(A * s) - burn - slash
    @staticmethod
    def func(v:tuple[ETH,One], t:Yr, p:Params) -> tuple[ETH/Yr,ETH/Yr]:
        x = {'A': (A := v[0]), 's': (s := v[1])}
	slash, burn, b, f = p._hlpr(A, s)
	to0 = j * (1 - s - (r := p.rnvstfrac(**x)))  +  p.qunstake(**x)
	to1 = p.qstake(**x)  +  f * (1-s) * (b * s  +  (1-b) * r)
	dA = p.inflation(A,s) * A
	ds = yld * (r - s) + to1 * (1 - s) - to0 * s
	return dA, ds
```

# The $(A,\alpha,s)$ Dynamical System

There are many reasons, especially in the context of the world
economy, to care about total circulating supply $A$.  Recent
discussions however have focused most on inflation.  It also turns out
that modeling inflation $\alpha$ directly simplifies our analysis
considerably.

Let subscripts denote partial derivatives
$x_y:=\frac{\partial{x}}{\partial{y}}$.  Using the product rule
$\dot{xy}=\dot{x}y+x\dot{y}$ and the correct partial derivative
relations for variables $(A,\alpha,s,t)$[^partial] we have

$$\displaystyle
\begin{array}{rcl}
\dot{A} &=& \pm\alpha A\\
\dot{s} &=& \pm\alpha(r-s) + (rf+q_+)(1-s) - (q_-+(1-r)j)s
\dot{\alpha} &=& \pm\frac{\xi}{1+\mu}\dot{s} - \frac{\gamma}{1+\mu}\alpha s \pm \frac{\chi}{1+\mu}
\end{array}
$$

Where the new greek letters are fractional rates, defined below, and
$y':=\frac{dy}{dS}$.

* $\mu:=\beta_\alpha(1-s)+\jmath_\alpha s$ is the implicit
  sensitivity of the inflation loss term to increases in inflation.
  We judge $0\leq\mu$; if anything inflation increases burn and
  slashing fractional rates.[^mu]

* $\xi:=y+y'A+\beta-\beta_s(1-s)-j-j_s$ is the net
  correlation between changes in $s$ and changes in $\alpha$, it can
  be of either sign.  Under the current yield curve
  $y_0+\frac{dy}{dS}A=y_0(sA)(1-1/(2s))$.

* $\gamma:=\left(j_As+\beta_A(1-s)+s|y'|\right)A$ is a positive
  coefficient expressing how quickly $\alpha\to\alpha^\star$, and the
  partials are constant when initial supply is known.[^ics] We have
  extracted the sign from the final term because sublinear issuance
  implies $y'<0$; under the current yield curve the term
  $sA|y'|=\frac{1}{2}y_0(sA)$.

* $\chi:=-j_ts-\beta_t(1-s)$ represents externalities affecting the
  inflation loss term encoded as explicit time-dependencies.

In what follows we will obtain and asses the nature of the long-term
externality-free fixed point cooridnate $(\alpha^\star=0,s^\star=1)$.
We will observe that it is not hard for $|\dot{\alpha}|\ll|\dot{s}|$
to obtaon, leading to a seperation of timescales where an $\alpha>0$
may change slowly enough that we can still use equilibrium arguments
at intermediate times.  We extract the behavior of
$x^\star(\alpha~\mathrm{const.},\ldots)$ and break down the fixed
point stability into LI;ELF vs. deflation.  We close with a dicussion
of the potential for oscillations in our model vs. actual market data.

## Local Stability of $\alpha^\star=0$ and Oscillations





## Separation of Timescales and $\alpha>0$

Observe that every term in $(\xi,\gamma)$ are fractions, fractional
rates, or derivatives thereof, so if $|\xi|,\gamma\ll1$ then the
derivatives obey $|\dot{\alpha}|\ll|\dot{s}|$: a [seperation of
timescales]().  For durations when this obtains, short periods at
intremediate times, inflation could be treated as a parameter instead
of its own dynamic variable, with staking fraction equilibrating to
$s^\star$ more quickly than $\alpha^\star$.

Does this hold presently?  For a sanity-check, a quick look at
YCharts since The Merge shows that $$s,\dot{s}$$ do indeed vary over a much
greater range than $$(\log{A},\alpha)$$.

![The staking fraction from YCharts](../assetsPosts/2025-01-15-issuance-dynamics/YCharts-x.jpg)
![The inflation rate from YCharts](../assetsPosts/2025-01-15-issuance-dynamics/YCharts-alpha.jpg)

## The Intermediate s^\star

So, let us examine the fixed point $s^\star$ with $\alpha^\star$ treated as
a parameter.

$$\displaystyle
s^\star = \frac{
   r^\star(\alpha^\star + f^\star) + q_+^\star
}{
   \alpha^\star + r^\star f^\star + q_+^\star + q_-^\star + \jmath^\star
}
$$

If $\dot{A}=0=\alpha$ (no inflation nor deflation) then an interior
market equilibrium $s^\star<1$ requires very high slashing.

We reason as follows.  In the absence of in/de-flation, an interior
fixed point $s^\star<1$ would require a persistent
unstaking/capitulation of existing validators $q_->0$.  This in turn
either requires churn, a persistent
supply of new validators to take their place $q_+^\star>0$, or it is
only a transient and $q_-^\star\approx0$; recall that reinvestment by
existing validators is not counted in $q_+$.

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
s^\star = r^\star \frac{
    \alpha^\star + f^\star
}{
    \alpha^\star + r^\star f^\star + \jmath^\star
}
$$

#### Stability of $x^\star$



### LI;ELF Conditions

A positive role for inflation can be seen in the contours of the
market equilibrium staking fraction $$s^\star$$ corresponding to
$$\dot{s}=0$$, shown in [figure
1](../assetsPosts/2025-01-15-issuance-fundamentals/staking-fixpoint.png).

To find the equilibrium values
$$(\alpha^\star/f^\star,\,r^\star)$$ necessary to acheive a desired
staking fraction $$x^\star$$, simply pick a colored contour in the
figure: these are the values of constant $$x^\star$$.  For every point
on this curve, the equilibrium inflation:fee ratio
$$\alpha^\star/f^\star$$ is the x-coordinate, and the equilibrium
reinvestment ratio $$r^\star$$ is the y-value.

A breakdown of limitng behaviors is illustrative under positive
inflation.  For any value of non-negative inflation, $$r^\star$$ is a
lower bound for the equilibrium staking fraction we should expect.  If
inflation dominates fees, $$\alpha\gg f$$ then $s^\star$ is larger by
a small amount than $r^\star$, while if fees dominate inflation
$$\alpha\ll f$$ and $s^\star$ becomes insensitive to non-zero
reinvestment ratio and $$s^\star\to1$$.  For a numerical comparison,
eyeballing charts (so *extremely* rough approximations here) $$f
\approx .002<.005\approx\alpha$$ so to within 10\% error above,
$$s^\star\approx r^\star$$ over the range of $$r\in(.5,.75)$$ inferred
from the Lido yield rate.

How these transient values $$(\alpha/f,r)$$ relate to their
equilibrium values $$(\alpha^\star/f^\star,r^\star)$$ depends on
some considerations:

* If indeed churn dies down and slashing stays relatively rare, then
  $r$ increases to reflect the growing share of businesses that
  reinvest the most; $r^\star\approx r_{max}$, where $r_{max}$ is
  assesed over all staking pools with at least 10\% of $S$.

* As we have seen from $\dot{\alpha}$ above, once $\dot{s}\to0$,
  inflation decays toward zero unless externalities intervene, but
  with a small relaxation term.  So *very roughly*
  $\alpha_{now}\approx\alpha^\star$ as an overestimate rule of thumb,
  that more detailed simulation work could improve.

#### Runaway $r$

Could the sensitivity $r_\alpha$ be sufficient such that even at
intermediate timescales we see $s\to1$?  This is certainly possible.

### Zero-growth and Deflation

### Reflexivity and Oscillations

One puzzle is that unless $s^\star\to1$ the fixed point of the
intermediate dynamics $0<\alpha\approx$const. is incompatiable with
$\alpha=0$ the externality-free fixed point from $\dot{alpha}$.  This
again indicates the endogenous dynamics are oscillation prone.

The simplest conceptual source of oscillations can be found by
modelling the $(S,U)$ system:

$$\displaystyle
\begn{array}{rcrlcrl}
\dot{S} &=& (ry-\jmath-q_-) & S & + & \left(q_++r(1-b)f\right) & U\\
\dot{U} &=& \left((1-r)y+q_-\right) & S & - & \left(rf+(1-r)bf+q_+\right) & U\\
\end{array}
$$

Specifically, so long as $ry>\jmath+q_-$ staked ETH $S$ just continues
growing and growing, while $U$ cannot get too big, before its own loss
term $-\left(rf+(1-r)bf+q_+\right)\cdot U$ dominates.  At some point
$S$ becomes big enough that $ry<\jmath+q_-$ and the system is capable
of oscillation, depending on a zoo of partial derivatves.  Readers
wishing for more detail are encouraged to use the two dimensional
local stability criterion to solve for the condition of eigenvalues
with an imaginary part.

We have not emphasized the oscillation in the introduction because we
expect market participants can profit from them without having to
coordinate their behavior.  Oscillations in supply will die down if
they are big enough to arbitrage: buy "toward the end" of an
inflationary phase, sell "toward the end" of a deflationary phase.
This behavior would enter our model via slow oscillations arising in
the parameters which will eventually sync with the endogenous dynamics
so as to dampen these cycles.  Fourier methods and good data
collection are recommended if this potential business-opportunity
interests you.

Contrast this to runaway staking... there's no obvious mechanism to
profit from an increase in staking fraction, other than by joining in.
So this is a challenge: can you, the reader, design a cryptoeconomic
mechanism by which runaway staking is moderated, in a way that allows
individuals to profit?  Can you prove that is impossible?












# Conclusions

Why does this happen, though?

* Short $Q_+$ vs. Long Term $R$ Investment
* The Quotient Rule $\dot{S}=\dot{S}/A-s\dot{A}/A$

Short Term vs. Long Term.  Novel investment in staking $Q_+$ is driven
largely by speculation, and new users encountering Ethereum.  $Q_+$
acts to increase staking fraction, as seen above, and indeed the glut
in $Q_+$ since the Merge may have been the source for all of the alarm
that prompted this study. Novel speculative investment must eventually dry up,
and be replaced by long-term investmemnt $R$, because (1) everyone
with money who wants to stake eventually will, so will be counted in
$R$ not $Q_+$, and any business that wants to stay in business cannot
consistently reinvest more than its revenue $R\leq I+P$.  Of the long
term signal $R$, only the issuance portion of reinvestment, that is
the part that contributes to inflation, can moderate $s$, which brings
us to...

The Quotient Rule $\dot{s}=\frac{\dot{S}}{A}-s\frac{\dot{A}}{A}.  What
increases $s$ is any increase in staked Ether $S$, but also any net
decrease in $A=S+U$. Inflation $\alpha$ increases
*both* $U$ and $S$, because some of that increase is used to meet
costs and take profit $(1-r)\alpha$, which increases $U$ relative to
$S$.  In contrast, the reinvestment of transaction fees can only ever
increase $S$ at the expense of $U$.  Thus transaction fees always act
to increase staked fraction, while the effect of inflation depends on
the relative values of reinvestment ratio and staking fraction.

So, while we could certainly model reinvestment differently, and there
are lags we are blithely integrating over, we think that these market
forces will still act as described above in a different model.  It is
possible that even during sustained inflation, these effects will be
unable to prevent the upward creep in $s$, because $r$ is too large,
or the sensitivity of $r$ to inflation at equilibrium is too great, a
condition which we mathematized above.  In fact we expect that every
argument about inflation effects driving increased staking, overpaying
for security, etc. could (perhaps should) be rephrased in terms of
reinvestment of staking rewards.

Regarding the possible effects of reflexivity.  We have not emphasized
the potential for oscillations very much, even thoughh a dynamical
systems person who looks at the $(S,U)$-model is likely to find this
its most striking potential.  The reason is reflexivity.
Specifically, if the oscillations in inflation are sufficient to not
be drowned out by the externalities and sources of noise, then market
participants will try to profit off of them.  The simplest strategy,
to buy toward the end of an inflationary phase, and sell toward the
end of a deflationary phase, should over time reduce any oscillations
that do arise.  Notably though, we only expect this to happen because
it does not require the coordination of market participants: each
individual blindnly pursuing their own utility should help en masse
control these oscillations, or they were never very great to begin
with.

Could there be a similar effect with staking fraction or inflation?
In short we have no idea, but put it as a challenge to the reader.
Can you devise a cryptoeconomic protocol or trading strategy that
forestalls the seemingly inevitable $s^\star\to1$?  If not, can you
prove this is impossible?  Regardless, planning for a low-inflation
high staked-fraction future is highly reommended.

So, finally... should the Ethereum community reduce issuance?

* Glib answer:

Nope.

* Short answer:

If you don't like the medium term future of inflation or you want to
slow down the transition to high staking, please consider and study
downward adjusting the constants in EIP 7153, adopted during the Deneb
upgrade.  EIP 7153 already directly limits $R+Q_+$, but was very
nicely designed to not interfere with existing staking flows.  EIP
7153 does not solve, and does not claim to solve, the long term
problems, but we have been forced to conclude that reducing issuance
doesn't solve them either!

* Long answer:

Ask the users, especially the validators, especially the LSTs.  Model
user preferences so that the demand curve becomes semi-empirical
instead of theorized.  Near-100\% staking seems to be baked-in long
term pretty much no matter what we do, and high inflation cannot
sustain under an issuance yield curve designed to avoid
discouragement.  So the question becomes essentially "How bad will it
get in the meantime?"  This is actually a question about user
preferences.  Austrian School devotees may be so inflation-averse that
they are already staking all their previously-liquid ETH at
$\alpha\approx0.5$\%/yr.  In contrast users who were content to grow up
with fiat currencies during periods of $\approx$3\% inflation or even
worse might not care, or would just stake in Compound or buy stETH.

For users seeking to passively preserve wealth, staking in Compound
(or Aave, or whatever) is ideal in terms of raw Ether demand, of
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
short of details.  So, since you have insisted on reading the "long
answer", we will end with the classic and cowardly refrain of
academics and academic-adjacents everywhere "it requires more
research!"




The reinvestment of issuance rewards
adds to both staked ETH $$S$$ and circulating ETH $$C$$, so the effect
on staking fraction depends on the relative size of these two.
However, the reinvestment of priority fees plus MEV is simply a net
value transfer from $$C$$ to $$S$$, which can only ever increase
staking fraction.

In a future post we turn to the challenges facing governance
centralization, sketch a potential solution, and propose a framework
by which macroeconomics interventions can be assesed.
Briefly, for the impatient:
- LST market is indeed winner take all, as many have described
- canging the yield curve doesn't change this at all
- if decreasng issuance does prevent gov capture by CEXes and LSTs then it is because
  solo staers are subsidizing the protocol
- bifurcaton theory quantifies our intuitions



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
  