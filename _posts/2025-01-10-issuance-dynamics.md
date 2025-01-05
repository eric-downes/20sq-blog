# Ethereum Macroeconomics

This is the first of two posts on Ethereum macroeconomics.

Ethereum has grown into a [major economic
force](https://www.grayscale.com/research/reports/the-battle-for-value-in-smart-contract-platforms);
between its native asset Ether (ETH), the smart contract ecosystem
this supports, and the Layer-2 blockchains, a conservative valuation
might be half a trillion dollars.  At the core of Ethereum's "brand",
distinguishing it from other smart contract platforms, is the promise
of decentralized governance: via its [consensus layer]() no centtral
authority can censor a transaction, freeze the native asset of a user,
etc.  This depends in turn on a sufficient diversity of validators
staking ETH to participate in consensus.

The share of Ether staked by "centralized" staking services, such as
exchanges and Liquid Staking Providers (LSTs) [is
considerable](https://dune.com/queries/2394100/3928083), and continues
to grow.  This has provoked [concerns](https://issuance.wtf/), among
Ethereum researchers that the future of Ethereum might involve (1)
nearly all Ether staked, such that (2) the de facto currencies used by
most users are controlled by a confederation of centralized services
with much less transparent govrnance, and no practical alternative.

## Lookahead

First, a warning!  In an act of hubris, but not without
reasons[^reasons], we have chosen $S$ to refer to Staked ETH, while
others have at times used $S$ for "circulating (S)upply", which we
call instead accessible ETH supply $A$, so $s=S/A$.  [Here]() is a
python script for converting between our variables and those most
commonly used on [issuance.wtf](https://issuance.wtf).

In this blog post we address the first of these concerns "runaway
staking" using a "stock and flow" macroecnomics model built with
guidance from dynamical system theory.  In contrast with other
research we find inflation playing a positive but temporary role in
moderating runaway staking, but most likely $$s\to1$ eventually,
regardless of what we do.  In the second post, we look more closely at
governance centralization and discuss a means for evaluating
macroeconomic interventions inspred by bifurcation theory.  Briefly,
we are not optimstic that reducing issuance will prevent governance
centralization, either.

In both posts, we provide a few code examples using `ethode` a thin
units-aware wrapper we built around `scipy.odeint` to streamline model
evaluation.  Readers desiring to follow our derivations, dive into
technical mathematical points not covered here, run their own
simulations, or learn some dynamical systems are recommended to look
at our ethode [guide](), and references therein.  It is certainly a
work in progress, but should have enough to get you going.

## For The Impatient!

We use our macroeconmics model to identify a "low inflation; even
lower fees" regime (LI;ELF).  Outside of LI;ELF convergence to a
desirable staking future without runaway staking is not possible; high
deflation pushes staking toward 0 or 100\%, while under zero or low
deflation, the tendency toward runaway staking can only be moderated
by very high churn.

In contrast within LI;ELF staked ETH fraction approaches near the
reinvestment ratio.  Thus, runaway staking can be avoided only while
inflation is held

1. low enough, that concerns over inflation do not dominate the
reinvestment of profits by staking businesses at equilibrium,
$$\frac{dr}{d\alpha}|^\star\leq0$$ (no news here) but simultaneously

1. high enough to numerically dominate priority fees and MEV, as a
fraction of unstaked Ether; $$\alpha^\star\gg f^\star$$.

The bad news for opponents of runaway staking is that long
$$t\to\infty$$ term, $$\alpha^\star$$ approaches zero, suggesting
$$s^\star\to1$$ anyway. Ethereum would undergo cycles of
inflation/deflation or obtain an "L2 future" that is sometimes
described where most Ether is staked, with the majority used for
settlement of L2 rollups.

Given all the above, we advise caution.  Intervening to reduce the
issuance yield curve seems quite capable of exaccerbating the
very problems we seek to avoid.

## Modeling an Open Zeppelin[^humor]

![Ethereum as a balloon with compartments.](
    ../assetsPosts/2024-12-30-issuance-dynamics/eth-balloon.jpg)

### Stocks

Consider a balloon with variable internal compartments.  The averaged
size of each is measured by *stocks*

- ($S$)taked Ether (participating in [consensus]()) is a compartment, as is
- ($U$)nstaked unburnt Ether,
  - containing the ($V$)alidator reward queue, while
- ($\cancel{O}$) is all irrecoverable (burned, lost, etc.) Ether, and call
- ($A$)ccessible Ether, $A=S+U\approx120.4\times10^6$ in Dec 2024.

The net change in time of a stock is written using a dot, such as
$\frac{dA}{dt}:=\dot{A}$[^partial], the net change in accessible
Ether.  The staking $\mathcal{Q}_+$, unstaking $\nathcal{Q}_-$, and
reward $V$ queues could also have been treated as stocks.  By
quarterly averaging[^aves] we *approximate* these queues as
equilibrated $\dot{V}\approx0$ etc.  This gives rise to $Q_\pm,R$ below.

Stocks grow or shrink based on flows which add to or subtract from
their derivatives.  Here all flows are positive real numbers with
units \[ETH/yr\].  Flows have a domain (where its coming from) and a
codomain (where is going to).[^cats]  They also obey (in)equalities, usually as
a fraction of the source, but sometimes as a fraction of other
flows.[^flowfrac]

We convert these inequalities; for each uppercase *extensive* flow
$J,F,R\ldots$ we define a lowercase *intensive variable* $j,f,r$: the
fractions \[1\] and fractional rates \[1/yr\].  In forming these,
the ideal is to apply the tightest available bounds that still capture
the [asymptotic behavior]() in the limit of interest $S\to A$; see below.

### Flows and Equations

We are not assuming these intensive parameters are constant, rather we
are supressing their dependence for readability. Except in cases (like
$y$) where the dependence is known, the intensives are assumed to be a
function of the dynamical variables and time, so the burn:
$b(A,S,t)=B/F$.[^time]

| Name  | Symbol | Source$\to$Target(s) | Constraint | Intensive | Range \[Units\] |
| :--   | :--    | :-:                  | :--        | :--       | :--             |
| Tx Fees  | $F$ | $U\to\cancel{O},SS$ | $B+P=F$  | $f:=F/U$ | $f\in(\varepsilon_b,1)$ [1/yr] |
| Base Fees[^aves] | $B$ | $U\to\cancel{O}$ | .. | $b:=B/F$ | $b\in[\varepsilon_b,1) \[1\] |
| Priority Fees   | $P$ | $U\to S$     | ..       | $1-b=P/F | $1-b\in(0,1)$ \[1\] |
| Issuance[^aves] | $I$ | $\cdot\to V$ | $yS\leq I$ | $\imath:=I/S= y-\kappa$ | $y\in(0,1)$\[1/yr\] |
| Slashing | $J$ | $S\to\cancel{O}$    | $J\leq S$ | $j:=J/S$ | $j\in(0,1)$ \[1/yr\] |
| Reinvestment[^whencer] | $R$ | $V\to S$ | $R+K\approx I+P$ | $r:=R/(I+P)$ \[1\] | $r\in(0,1)$ \[1\] |
| Costs & Profit  | $K$ | $V\to U$     | ..        | $1-r=K/(I+P)$ | $1-r\in(0,1)$ \[1\] |
| New Staking | $Q_+$ | $U\to S$       | $Q_+\leq U-V$ | $q_+:=Q_+/U | $q_+\in(0,1)$ \[1/yr\] |
| Unstaking | $Q_-$ | $S\to U$       | $Q_-\leq S$ | $q_-:=Q_-/S | $q_-\in(0,1)$ \[1/yr\] |

The result of all these decisions, about which you can read more in
our [modeling guide](), is to create and transform this conceptual
model

$$\dislaystyle
\begn{array}{rcl}
\dot{A} &=& I - B - J\\
\dot{S} &=& R + \Delta{Q}_\pm - J\\
\dot{V} &=& I + P - R - K
\dot{U} - \dot{V} &=& K - F - \Delta{Q}_\pm
$$

Into one that is defined in its own dynamical and intensve variables,
a *dynamical system*.

$$\displaystyle
\begn{array}{rcrlcrl}
\dot{S} &=& (ry-\jmath-q_-) & S & + & \left(q_++r(1-b)f\right) & U\\
\dot{U} &=& \left((1-r)y+q_-\right) & S & - & \left(rf+(1-r)bf+q_+\right) & U\\
\end{array}
$$

#### Simulating the $(S,U)$ Model

You can explore some behaviors of this model using a simulation; see
[guide]().  Here is an unrealistically simplified example where all
coefficients are held constant that still extracts some broad
features.

```python
from ethode import *
class Toy(ODESim):
    cSS: 1/Yr
    cSU: 1/Yr & Pos
    cUS: 1/Yr & Pos
    cSS: 1/Yr & Pos
    @staticmethod
    def func(v:UnitTuple(ETH, 2), t:Yr, p:Params) -> UnitTuple(ETH/Yr, 2):
        S, U = v
	dS = p.cSS * S + p.cSU * U
	dU = p.cUS * S - p.cUU * U
	return dS, dU
Toy(1, 1, 1, 1).sim()
Toy(-1, 1, 1, 1).sim()
```

Specifically, so long as $ry>\jmath+q_-$ staked ETH $S$ just continues
growing and growing, while $U$ cannot get too big, before its own loss
term $-\left(rf+(1-r)bf+q_+\right)\cdot U$ dominates.  At some point
$S$ becomes big enough that $ry<\jmath+q_-$ and the system is capable
of oscillation, depending on a zoo of partial derivatves.  Here is a
less trivial code example where all intensves other than issuance yield are
held constant.

```python
from math import sqrt
from ethode import *
class SUconst(ODESim):
    y1: 1/Yr & Pos
    f: 1/Yr & PosFrac
    b: NoDim & PosFrac
    r: NoDim & PosFrac
    qu: 1/Yr & PosFrac
    qs: 1/Yr & PosFrac
    j: 1/Yr & PosFrac
    S1: ETH = 1 * ETH
    def y(self, S:ETH, *args) -> ETH/Yr:
        return self.y1 * sqrt(self.S1 / S)
    @staticmethod
    def func(v:UnitTuple(ETH,2), t:Yr, p:Params) -> UnitTuple(EPY, 2):
        x = {'S': (S = v[0]),
	     'U': (U = v[1])}
	y = p.y(**x)
	beta = p.b * p.f
	rf = p.r * p.f
	dS = (p.r * y - p.j - p.qu) * S   +   (rf * (1 - p.b) + p.qs) * U
	dU = ((1 - p.r) * y + p.qu) * S   -   (rf + (1 - p.r) * beta + p.qs) * U
	return dS, dU
su = SUConst.sim(y1 = 166.3 / Yr, f = .002 / Yr, \
                 b = .8, r = .5, \
		 qu = 1e-4 / Yr, qs = 1e-2 / Yr, j = 1e-6 / Yr)
su.verify()
su.sim()
```

If you have an opinion about how, for instance $r$ should depend on
$(S,U)$, you can define, instead of `r: NoDim` your own function
within the class declaration.

```python
    def rnvst(self, S:ETH, U:ETH, *args) -> NoDim:
        return S * U / (S + U) ** 2 / 2
```

Of course the variables we really care about are inflaion and staking
fraction.  You can designate these as outputs of the model withn
the class declaration.

```python
    @output
    def alpha(self, S:ETH, U:ETH, *args) -> 1/Yr:
        return p.y(S) * S - p.b * p.f * U - p.j * S
    @output
    def sfrac(self, S:ETH, U:ETH, *args) -> 1/Yr:
        return S / (S + U)
    ...
su.sim(graph_outputs = ('alpha', 'sfrac'))
```

Below we transform from staked/unstaked variables $(S,U)$ into
modeling directly accessible supply, inflation, and staking $(A,\alpha,s)$.
But first we need to emphasize what, in our view, makes our model
different from others.

#### Reinvestment; Only F@%$ Up the limits when it doesn't matter!

When forming intensve variables it is *critical* that the modeler's
choices reflect the correct asymptotic behavior in the limits of
concern, in his case $U\to 0$.

If for instance, instead of assuming $R\leq I+P$, we had assumed $R$
is bounded by unstaked ETH $U$ (which is necessary but not
sufficient), and so defined $r_{bad}=R/U$ we get a *very* different
model, but this is wrong in a way that matters.  It is wrong because
validator rewards $I+P$ can go to zero *independently* of the size of
$U$.  It matters because reinvestment
$S\overset{+}{\rightsquigarrow}S$ is quite evidently related to the
positive-feedback loop between staking and issuance that people are so
worried about.  Other examples abound.[^elowex]

Concerns over staking-issuance feedback are in fact exactly why we
have split staking into new investment $Q_+$ and reinvestment $R$.
The quantity $r=R/(I+P)$ is one of the distinguishing feature of our model, and
important for staking fraction under "low inflation; even lower fee"
conditions, see below.

1. Modelling $r$ is necessary to model LSTs,[^rlst] and
2. we want to separate the transient external forcing $Q_+$ from the
long-term feedback $R$,[^rdyn] and.
3. $r$ should be measurable with onchain data.

## Infation and Staking Fraction

Inflation is used to refer to many things, but here we mean
specifically the quarterly fractional change in accessible
Ether. Let's express inflation $\alpha:=\frac{d\log~A}{dt}$ in
terms of $s$ and the intensives

$$\displaystyle
\alpha = (I-B-J)/A \approx y(sA)s - bf(1-s) - js
$$

### Positive Inflation cannot maintain

A key feature of $\dot{A} concerns discouragement [Buterin](), which
requires sublinear issuance $I\lesssim S$ to avoid instability to
certain attacks.  Because of this, the positive term continues to get
smaller as Accessible ETH supply grows; consistent with the
$(S,U)$-model above, eventually average inflation tends to zero.

In contrast, while slashing can go to zero, so long as blocks are
produced, these is some minimal burn. $A$ could get quite large; for
$s=1-\epsilon$ and the current yield curve we have $A^\star\sim
(y(1)/b^\star f^\star)^2\epsilon^{-2}$; as $\epsilon$ is very small
$\epsilon^{-2}$ is very large.  Nonetheless, we should expect
$\alpha^\star=0$ to be the inflation fixed point as $t\to\infty$.

### Changing Variables

So, our new dynamical variables are $(A,\alpha,s)$.  Two important
points now require mention.

* The quotient rule $\dot{s}=\frac{\dot{S}{A}-s\alpha$ emphasizes that
  changes in a fraction occur from *both* changes in the numerator $S$
  and its denominator $A$.
  
* Making conclusions about market equilibria requires us to look at *all*
  of the dynamical variables, and perform a [local stability analysis]().
  - Solve $\dot{x}:=(\dot{A},\dot{\alpha},\dot{s})=(0,0,0)$, obtaining a fixed point
    $x^\star=(A^\star,\alpha^\star,s^\star)$.
  - This $x^\star$ is a market equilibrium when it is (possibly meta-)stable, and
    *the* market equiibrium just when it is unique.[^metastable]

That is, an increase in staking fraction can be driven by more people
staking, and/or it can be driven by a reduction of the inflation rate.
The latter can be acheived in principle by a reduction of issuance
relative to the base fee "burn rate".  Because of this quotient rule
tradeoff, low-but-positive inflation actually plays a positive almost
"infrastructure" role in moderating staking fraction.

After some calculus, and a lot of algebra, we obtain the following

$$\displaystyle
\begin{array}{rcl}
\dot{A} &=& \alpha A\\
\dot{\alpha} &=& \zeta\dot{s}-\gamma\alpha s + X\\
\dot{s} &=& \alpha\cdot(r-s)~+~(rf+q_+)\cdot(1-s)~-~\eft(q_-+(1-r)j\right)\cdot s\\
\end{array}
$$

* $X= ...$ represents externallities to the $(A,\alpha,s)$ system
* $\zeta = ... $

At intremediate times we believe inflation can be treated as a parameter instead of as its own dynamic
variable

$\dot{s}\ll\dot{\alpha}$

For a sanity-check, a quick look at
YCharts since The Merge shows that $$s,\dot{s}$$ vary over a much
greater range than $$(\ln{A},\alpha)$$.

![The staking fraction from YCharts](../assetsPosts/2024-12-05-issuance-fundamentals/YCharts-x.jpg)
![The inflation rate from YCharts](../assetsPosts/2024-12-05-issuance-fundamentals/YCharts-alpha.jpg)

At present we judge the lack of empirical data on $$r$$ would obviate
the added precision of a more sophisticated treatment.  We will
proceed assuming $$\dot{\alpha}\approx0$$ and treating $$\alpha$$ as a
parameter.

So, let us examine the fixed point $x^\star$

We find that if $\dot{A}=0=\alpha$ (no inflation nor deflation) then
an interior market equilibrium $$s^\star<1$$ requires ver high slashing.  We reason
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




# Conclusions

Why does this happen, though?  The reinvestment of issuance rewards
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
not appreciable; see [guide]() for details.  As we are averaging
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
[ethode guide]() for more discussion

[^regex]: This regex script is provided to translate the $\LaTeX$
within the markdown source to (our esimatimate of) terminology more
common at [issuance.wtf](https://issuance.wtf)

[^partial]: Sometimes $\dot{x}$ is used e.g. for the partial
derivative $\frac{\partial x}{\partial t}$, *but not here*.  For a model
in which you assume dynamical variables $(x,y,z)$, these derivatives
are thus related

$$\displaystyle \frac{dx}{dt} := \dot{x} =
\frac{\partial x}{\partial t} +
\frac{\partial x}{\partial y}\dot{y} +
\frac{\partial x}{\partial z}\dot{z}
$$

in which each partial is taken holding the other variables constant,
and $\frac{\partial x}{\partial t}$ is used in practice to capture any
variability from non-dynamical variables.

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

[^whencer]: Intensives expressed as fractions of flows such as $R/(I+P)$), instead
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



# Open Questions

Reinvestment within each quarter may not be realistic, and could
introduce interesting oscillations.  Some averaging timescale $\tau$,
at least monthly, is necessary to integrate over the short-term burn
dynamics, and (un)staking queue lags.  The shorter $\tau$, the better
the approximations $I\approx yS$ and
$\frac{d\log~y}{d\log~S}\approx\frac{d\log~y^\bullet}{d\log~S^\bullet}$.
Yet, $\tau$ must be long enough so that $\dot{V}\approx0$ holds,
allowing us to define reinvestment without a time lag $r:=R/(I+P)$.
Once we have better data on how long the tail of reinvestment is we
could model selling rewards for revenue $K$ and reinvestment $R$ in a
more nuanced fashion, allowing $V$ to be its own dynamical variable.

We would like to pay more closer attention to how the Deneb hardfork's
limit on staking queue interacts with inflation and reinvestment.  We
have ignored this affect in our dynamics, because it does not
presently limit staking flows, and we see inflation decreasing long
term.  However for finer questions, it depends on the resources and
patience of the validators.  How does a potential race condition
change the composition of the staking queue, in terms of old $R$
vs. new $Q_+$ and LSTs $L$ vs. everybody else $S-L$.

