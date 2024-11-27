# Will Reducing Issuance Avoid Runaway Staking?

## Acknowledgements

This is the first blog post in a series summarizing our research
funded by EF GRANT INFO.  The author, Eric Downes, is grateful for
useful discussions with the 20 Squares team especially Danieli
Palombi and Philipp Zahn, as well as Eric Siu, Angsar Dietrichs, and
Andrew Sudbury.

## The Problem

The share of Ether staked by exchanges such as Coinbase and Liquid
Staking Providers such as Lido ("centralized" staking services)
continues to grow.  This has provoked concerns, first raised by
Ethereum researchers, and which we share, that the future of Ethereum
might involve (1) all of its native asset being staked, such that (2)
the de facto liquid Ether is controlled by a confederation of
centralized un-transparent govrnance. In this blog post we address the
first of these concerns.

We use "stock and flow" differential equation models to study Ethereum
macroeconomics, specifically how changing issuance impacts these
questions.  We will publish four blog posts on this topic:

1. (This post) Will reducing issuance avoid Runaway Staking?
2. Will reducing issuance avoid Governance Centralization?
3. Other Levers besides Issuance, and a means of evaluating levers.
4. Summary and community tools to help study and resolve issuance debates.

We may also publish bonus posts, if there is sufficient community
engagement, so dear reader stay vigilant!

## TLDR

### For the extraordinarily impatient reader.

* Roughly speaking, under strong deflation, Ethereum faces an
  unenviable choice of futures:
  - zero staking, or
  - runaway staking

* Under no growth or weak deflation, runaway staking is inevitable.

* Under inflation, runaway staking may still occur.

* If runaway staking does *not* occur under inflation, it is because
  -- (1) inflation is low enough, that concerns over inflation do not
     dominate the microeconomic considerations governing the
     reinvestment of profits by staking businesses, but simultaneously
  -- (2) inflation is high enough to numerically dominate the quantity of
     priority fees and MEV reinvested as profit.

* Outside of the "low inflation, lower fees" regime, we expect
  reductions of inflation to backfire, *raising* staking fraction.

* Regardless, the staking reinvestment ratio is central to
  understanding the quantitative future of Ethereum macroeconomics.
  We believe it can be well-estimated with onchain data.

### For the moderately impatient reader.

In some more detail, a sketch of the reasons behind our conclusions.
The quantity of most importance to this debate is the staked ETH
fraction $$s$$, currently roughly .33. Staking fraction is calculated
$$s=S/A$$ where $$S$$ is all staked ETH, $$C$$ is "circulating"
(unstaked, unburnt) ETH, and $$A=S+C$$ is the total "accessible"
(unburnt) ETH. Differential changes, such as changes in time
$$\frac{ds}{dt}:=\dot{s}$$ are given by the quotient rule
$$\dot{s}=\dot{S}/A-s\dot{A}{A}$$.  The quantity $$\alpha = \dot{A}/A$$
is the average on-paper inflation rate (supply expansion APY) averaged
on at-least-quarterly timescales.

That is, an increase in staking fraction can be driven by more people
staking, and/or it can be driven by a reduction of the inflation rate.
The latter can be acheived in principle by a reduction of issuance
relative to the base fee "burn rate".  Because of this quotient rule
tradeoff, low-but-positive inflation actually plays a positive
infrastructural role in moderating staking fraction.

This can be seen in the market equilibrium staking fraction, which we
derive below:

$$\displaystyle
s^\star = r\frac{\alpha + f}{\alpha + rf}
$$

Here $$0\leq r\leq 1$$ is the ratio of profits reinvested quarterly by
validators, $$0\leq f\leq 1$$ is the fraction of unstaked ETH spent on
transactions fees (base and priority) quarterly, and as above
$$\alpha$$ is inflation.  The two extremes are $$\alpha\ll f$$ fees
dominate and $$\alpha\gg f$$ inflation dominates.  In the former,
staking fraction is driven closer to 1, while in the latter, staking
is driven to match reinvestment $$x^*\approx r$$.

Under current market conditions, low inflation and lower fees, the
long-term equilibrium staking fraction approaches the average ratio
$$r$$ at which validators reinvest their staking rewards. For LSTs
$$r$$ is bounded below by the ratio of token yield to total yield, and
we can use this to roughly estimate some real values.

Approximate present values from YCharts are very roughly
$$f\approx.001$$/year, $$\alpha\approx.005$$/year, $$r\in(.5,.75)$$.
So if current market conditions (low inflation, lower fees) were to
persist at long times, we expect the staking ratio to convergence to
within +10\% of the the reinvestment ratio.  If issuance is reduced by
half and fees maintain, $$x^\star$$ is still around $$r$$ plus 15\%.

However, if issuance is reduced too much, such that fees dominate
inflation, we enter a regime in which reducing issuance *raises*
equilibrium staking fraction, and becomes insensitive to $$r$$.  This
could occur by adopting too severe a yield curve, or by validaators
continuing to chase MEV yield, long after the yield from issuance has
become irrelevant. 

Under present conditions $$r$$ is the proximate mechanism by which
inflation must act, in affecting long term staking fraction.  As per
all the arguments of researchers, a sufficient increase in inflation
$$\alpha^*\mapsto\alpha^*+\Delta\alpha$$ could well drive an runaway
increase in reinvestment $$\Delta{r}/\Delta\alpha\gesim 1-r$$.

Thankfully, the reinvestment of profits $$r_i$$ is a microeconomic
quantity every staking business $$i$$ calculates, even if they do not
use those words.  The global $$r$$ is then the market-share weighted
average of all these.  If inflation pressures are indeed the dominant
consideraton for Ethereum users considering staking, this should
emerge from microeconomic surveys of validators' reinvestment
sentiments.

We hope that this work can be built upon to focus inflationary
pressure arguments into empirically measurable assertions that can be
tracked as a metric for Ethereum health.

## Modelling Staking

Now the details!

### Splitting Up A Growing Pie

Consider the quantity $$E$$ of all Ether in existence.  Let the
issuance of new Ether as per The Merge be quantified by $$I$$.  Then
the change in time of total Ether is $$\dot{E}:=dE/dt=I$$.

-- FIGURE 1 (see notability) --

Now, let us separate $$E$$ into three smaller boxes;
$$S+C+\cancel{O}=E$$, representing (S)taked, (C)icrulating, and burnt
Ether $$\cancel{O}$$, respectively.  By considering each quantity a
quarterly average we can plausibly ignore the detailed dynamics of the
staking, unstaking, and withdrawal queues.

-- FIGURE 2 (see notability) --

### How Pie is Pushed Around The Plate

This is our model:
$$
\displaystyle
\begin{array}rcl}
\dot{E} &=& I\\
\dot{S} &=& R+Q_+-Q_-\\
\dot{A} &=& I-B\\
\end{array}
$$

Where all quantities are assesed quarterly:
* $$I$$ -- Total Issuance
* $$R$$ -- Total Reinvestment of Validator Yields
* $$Q_\pm$$ -- Total (Un)Staking Queue Flows
* $$B$$ -- Total Base Fee, aka Burn Rate.

Transaction fees $$F+B$$ are split into the base fee $$B$$ which is
burned, and priority fees plus MEV $$F$$ which go to validators via
the wihdrwal queue.  Fees obey the inequality $$0\leq F+B\leq C$$.  We
ae interested in the limit $$C\to0$$ and pull this dependence out by
defining $$f$$ such that $$fC = F+B$$. The fraction $$f$$ need not be
a constant, but whatever values it takes, $$f$$ must be a fraction:
$$0<f<1$$ with units of 1/year.  Looking at YCharts for 2024, an
average tx fee might be $$3\times10^{-4}$$ ETH (about $1 USD), and
with $$\approx1.2\times10^6$$ transactions per day on a supply of
120M, 70\% of which is unstaked, corresponding to an $$f\approx.001$$/year.

En masse, validators withdraw their rewards $$I+F$$ into circulating
ETH.  They reinvest some amount of rewards $$R$$ into staking more
validators.  Reinvestment into one's business is a natural practice,
and we expect $$R$$ to respond meaningfully to macroeconomic forces.
Reinvestment is also a part of every LST smart contract; via rebaisng,
a certain fraction of yield is the value proposition for the
token-holder; so any model with LSTs must include reinvestment.  Again
we define a variable fraction $$r:=R/(I+F)$$ which obeys
$$0\leq{r}\leq1$$.  As of Nov 23, 2024 the stETH token yield is
$$\approx$$3\%.  Over the same period, without MEV-Boost validator
yield is $$\approx$$4\%, and with MEV-Boost it is $$\approx$$5.7\%.
So probably, $$r$$ currently lies in the range $$.5\leq r\leq.75$$.

The quarterly flows from the staking and unstaking queues must obey
$$0\leq Q_+\leq C$$ and $$0\leq q_-\leq S$$, which we use below via
variable fractions $$q_+=Q_+/C,~q_-=Q_-/S$$.  Finally, we rewrite
$$\dot{S}$$ the change in total staked ETH, anticipating that we wish
to understand the relationship to inflation rate $$\dot{A}/A$$,
obtaining $$\dot{S} = r\dot{A} + r(B+F) + Q_+-Q_-$$.  For about the
past 6 months Ethereum supply has been growing pretty linearly,
corresponding to an inflation rate of about .5\%, or
$$\alpha=.005$$/year.

The variable of primary interest is the staking fraction $$s=S/A$$;
recalling the quotient rule $$\dot{S}=\dot{S}/A-s\dot{A}/A$$ and
$$C=A-s$$, we obtain:

$$
\displaystyle
\dot{s} ~~=~~ \frac{\dot{A}}{A}(r-s)~~+~~(rf+q_+)(1-s)~~-~~q_-s
$$

The first term captures the effect of inflation/deflation.  Under
inflation $$\dot{A}/A>0$$, the staking fraction receives a boost when
it is less than reinvestment rate $$s<r$$, and a drag when $$s>r$$.
Under deflation $$\dot{A}/A<0$$ the effects are reversed, though see
below.  The second term combines new staking $$q_+$$ and the
reinvestment of priority fees and MEV $$rf$$, and is always
non-negative.  The third term represents unstaking and is always
non-positive.

### Fixed Point

If quarterly inflation $$\alpha:=\dot{A}/A$$, governed by the tension
between issuance and burn, changes quickly enough, we have at least a
two dimensional system.  Thankfully, if all ones cares about is the
(in)stability of market equilibria, and the potential response to
issuance changes, the varieties of qualitative behavior of this higher
dimensonal system are all present in the above one-dimensional system.
That is, we find the same supportive role is played by inflation in
moderating staking fraction, and that $$r$$ plays a prominent role in
the character of the fixed point.  The primary difference, over
existing market conditions, is that oscillations are possible.

If instead, $$\alpha$$ varies slowly enough
$$\alpha\approx\alpha^\star$$, a fixed point $$s^\star$$ where
$$\dot{s}=0$$ can obtain:
$$ \displaystyle
s^\star=\frac{r^\star(\alpha^\star + f^\star) + {q^\star}_+}{\alpha +
r^\star f^\star - {q^\star}_-}
$$

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
$$x^*$$ must once again grow as required by the Reinvestors' higher
$$r$$, so $$x^*$$ was not a fixed point at all.  Similarly, at some
point everyone who wants to stake should have staked, and other than
influxes due to the issuance of new humans, further validators count
only toward $$r$$, so $$q_+^\star\approx0$$.

Thus, the fixed point $$s^\star$$ is likely to be
$$s^\star\approx r\frac{\alpha + f}{\alpha + rf}$$

A calculation is illustrative under the current regime of positive
inflation.  If inflation dominates fees, $$\alpha\gg f$$ then
$$s^\star\sim r^\star<1$$, while if fees dominate inflaton $$\alpha\ll
f$$ and $$s^\star\to1$$.  For a numerical comparison, at present $$f
\approx .001\lessim .005\approx\alpha$$ so to within 10\% error
$$x^*\approx r$$ over the range of $$r$$ inferred from Lido yield
rate.

So if these conditions persist at long times, and to be clear there is
no reason to be certain they will, we should expect $$x^\star\approx
r\in(.55,.77)$$.  This places the lower range of $$x^\star$$ near the
50% staking target proposed by Elowsson.  This is hopeful but little
weight can be attached to such back-of-envelope extrapolations.  To
make reliable projections we need systematic measurement of both the
statistics of individual validator reinvestment and metrics or at
least surveys reflecting validator sentiment and (in)capacity to
absorb reduced revenue.

### Market Equilibrium

The fixed-point $$x^\star$$ represents the market equilibrium when it
is unqiue and stable.

Non-uniqueness requires a shared and repeated root (the other
equilibrium point) among all terms $$\alpha,rf+q_+,q_-$$.  That is,
each economic flow would have to nearly disappear at a particular
value of staking fraction.  Lacking any supporting data or a
mechanism, we cannot really analyse such an alternate equilibria, and
intuitively it seems unlikely, so we move on, assuming uniqueness.

Stability requires that small perturbations shrink;
$$\frac{\partial\dot{x}}{\partial x}\big|_{x^\star}<0$$.  The full
condition is quite complicated, especially under deflation.
If however inflation is positive and $$r,\alpha,f$$ are
relatively insensitive to small changes in $$x$$ near $$x^\star$$, this
conditions is satisfied immediately; $$\alpha+rf>0$$.

This stable equilibrium seems plausible, and worthy of consideration.
How does it behave?

### Qualitative Behavior

The fixed point $$x^\star=r(\alpha+f)/(\alpha+rf)$$ represents
behavior distinct in flavor from the arguments forwarded by Ethereum
researchers, in which inflation is held to blame for a 100% ETH Staked
scenario.  To be clear, very likely $$x_{now}<r<1$$, so currently the
effects of both inflation and fee-reinvestment push in the same
direction.  Also we acknowledge that certainly there must be an
$$x,\alpha$$ past which fears of runaway inflation will drive
$$r\to1$$ just as predicted by others.  However, we should not reduce
inflation to a mere villain, as for long times we find that the system
dynamics reflect a picture in which inflation directly moderates the
effect of fee reinvestment, which can only increase $$x$$.  In fact,
we want to emphasize for this reason that deflation or zero growth
could actually be quite dangerous.

Why does this happen, though?  The reinvestment of issuance rewards adds to
both staked ETH $$S$$ and circulating ETH $$C$$, so the effect on
staking fraction depends on the relative size of these two.  However,
the reinvestment of priority fees plus MEV is simply a net value
transfer from $$C$$ to $$S$$, which can only ever increase staking
fraction.

We have argued, hopefully convincingly, that reducing issuance in a
vacuum decreases inflation, and increases the relative strength of the
$$rf(1-x)$$ term.  If current conditions affecting $$f$$ etc. persist
what will be the end effect on inflation $$\alpha$$ and $$x^\star$$?
Inflation in terms of the above variables is:

$$\alpha = \dot{A}/A = (I - B)/A = ys~~-~~bf(1-s)$$

Where $$y(S)\sim S^{-1/2}$$ is the yield curve.  Presently, the
$$bf(1-s)$$ term does not seem to play a numerically significant role
in reducing inflation; total fees assesed in 2023 were
~\$$$2\times10^9$$, on a market-cap of \$$$240\times10^9$$, roughly
70\% of which is circulating, so $$f\approx.02$$ for this period.

Under these conditions, any moderate reduction of issuance to half or
a third of its present value would still result in a comfortably
positive inflation rate.  We assume, admittedly without any strong
evidence, that transaction fees are driven by trading volume,
etc. which should persist wether inflation is .5\% or 3\%, so
$$f\ll\alpha$$ and $$x^\star\approx r$$ could plausibly maintain.

The most dangerous likely scenario is one in which the issuance curve
is reduced, followed at some point by a sustained bull market
elevating priority and base fees moderately higher than present, while
reinvestment is not strongly reduced (perhaps driven by breakthroughs
in MEV, or an unexpectedly low elasticity in staking demand), such
that $$\alpha\sim rf$$.  In this hypothetical scenario, reinvestment
of fees will shrink $$C$$ consderably relative to $$S$$, potentially
leading to runaway staking.  This mechanism requires no need for more
new validators.

## In Conclusion

We find a nuetral and even positive role for inflation in maintaining
moderate staking levels under various scenarios.  We do not contest
the logic that runaway inflation could drive staking fraction
unreasonably high, but the picture emerging from our model appears far
more nuanced.

We find that the reinvestment of staking rewards plays a critical role
in staking dynamics.  This is especially true under present market
conditions post-EIP-1557, where inflation dominates reinvested fees,
and we expect the equilibrium staking fraction to approach the
reinvestment rate $$r$$.

We propose that $$r$$ be added to the list of macroeconomic indicators
routinely tracked for Ethereum, and that the economic forces, and
internal variability affecting $$r$$ be modelled and measured.
Specifically, policy advisors need to know how and indeed if solo
validators and LSTs will alter their reinvestment strategies,
especially under a regime of lower issuance yield.

It may well be that fears about runaway inflation will turn out to be
the dominant factor affecting reinvestment.  If so this should emerge
from microeconomic surveys of large validators and LSTs.  Each staking
business $$i$$ can, and probably already does, calculate its desired
$$r_i$$.  The global $$r$$ is then the market-share weighted averaged
of all of these.  We hope these calculations will bridge the macro-
and micro-economics to help the community see a unified and actionable
big picture on the future of Ethereum staking.

