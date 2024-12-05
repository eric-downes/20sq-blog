# Some danger in reducing Issuance to avoid Runaway Staking.

## Acknowledgements

This is a blog post on Runaway Staking in a series summarizing our
research funded by EF GRANT INFO.  The author, Eric Downes, is
grateful for useful discussions with Eric Siu, Andrew Sudbury, and the
the 20 Squares team; especially Danieli Palombi and Philipp Zahn.

## The Problem

The share of Ether staked by exchanges such as Coinbase and Liquid
Staking Providers (LSTs) such as Lido ("centralized" staking services)
continues to grow.  This has provoked concerns, first raised by
Ethereum researchers, and which we share, that the future of Ethereum
might involve (1) all of its native asset being staked, such that (2)
the de facto liquid Ether is controlled by a confederation of
centralized un-transparent govrnance. In this blog post we address the
first of these concerns.

We use "stock and flow" differential equation models to study Ethereum
macroeconomics, specifically how changing issuance impacts these
questions.  We will publish several blog posts on this topic:

0. Basics of applying Dynamics to Ethereum
1. (This post) Will reducing issuance avoid Runaway Staking?
2. Will reducing issuance avoid Governance Centralization?
3. Other Levers besides Issuance, and a means of evaluating levers.
4. Some tools to help the community study and resolve policy debates.

## TLDR

### For the extraordinarily impatient reader.

* The staking reinvestment ratio is central to understanding the
  quantitative future of Ethereum macroeconomics.  We believe it can
  be well-estimated with onchain data.

* Under weak inflation, runaway staking may occur.  If it does *not*,
  this is because
  -- (1) inflation is low enough, that concerns over inflation
     do not dominate the reinvestment of profits by staking businesses,
     but simultaneously
  -- (2) inflation is high enough to numerically dominate priority fees
     and MEV, as a fraction of circulating Ether.

* Outside of the "low inflation, lower fees" regime, convergence to a
  reasonable staking future is not possible.
  -- Under strong deflation, Ethereum faces a choice between zero staking
     or runaway staking
  -- Under no growth or weak deflation, runaway staking is inevitable.

* Given the above, we emphasize that changing the yield curve could
  backfire, *raising* long term staking fraction.

### For the moderately impatient reader.

#### Dynamics Supporting Market Equilibrium

In some more detail, a sketch of the reasons behind our conclusions.
The quantity of most importance to this debate is the staked ETH
fraction $$s$$, currently roughly .33. Staking fraction is calculated
$$s=S/A$$ where $$S$$ is all staked ETH, $$C$$ is "circulating"
(unstaked, unburnt) ETH, and $$A=S+C$$ is the total "accessible"
(unburnt) ETH. Differential changes, such as changes in time
$$\frac{ds}{dt}:=\dot{s}$$ are given by the quotient rule
$$\dot{s}=\dot{S}/A-s\dot{A}/A$$.  The quantity $$\alpha = \dot{A}/A$$
is the average on-paper inflation rate (supply expansion APY) averaged
on at-least-quarterly timescales.

That is, an increase in staking fraction can be driven by more people
staking, and/or it can be driven by a reduction of the inflation rate.
The latter can be acheived in principle by a reduction of issuance
relative to the base fee "burn rate".  Because of this quotient rule
tradeoff, low-but-positive inflation actually plays a positive
infrastructural role in moderating staking fraction.  This can be seen
in the market equilibrium staking fraction $$s^\star$$, shown here and
derived below.

$$\displaystyle
s^\star = r^\star\frac{\alpha^\star + f^\star}{\alpha^\star + r^\star f^\star}
$$

Here $$r^\star$$ etc. means the function $$r(s,\alpha,\ldots)$$ at the
equilibrium coordinates $$(s^\star,\alpha^\star,\ldots)$$.  Speaking
of which, the fraction $$0\leq r\leq 1$$ is the ratio of profits
reinvested quarterly by validators, $$0\leq f\leq 1$$ is the fraction
of unstaked ETH spent on transaction fees (base and priority)
quarterly, and as above $$\alpha$$ is inflation.  The two extremes are
$$\alpha^\star\ll f^\star$$ fees dominate and $$\alpha^\star\gg
f^\star$$ inflation dominates.  In the former, staking fraction is
driven closer to 1, while in the latter, staking is driven to match
reinvestment $$s^\star\approx r^\star$$.

#### Good Scenario 

Under current market conditions, low inflation and lower fees, the
long-term equilibrium staking fraction approaches the average ratio
$$r$$ at which validators reinvest their staking rewards.  When there
are different types of validators, $$r$$ is the average of $$r_i$$ for
each validator type $$i$$, weighted by the amount of Ether each
stakes.  For LSPs $$r_{LST}$$ is bounded below by the ratio of token
yield to total yield, and we can use this to roughly estimate some
full $$r$$ values.

Approximate present values from YCharts are very roughly
$$f\approx.001$$/year, $$\alpha\approx.005$$/year, $$r\in(.5,.75)$$.
So if current market conditions (low inflation, lower fees) were to
persist at long times, we expect the staking ratio converges to no
more than +10\% of the the reinvestment ratio.  Good news: if issuance
is reduced such that inflation is reduced by half, while fees
etc. maintain, equilibrium is still around $$r$$ + 15\%, so
$$s^\star\in(.58,.8)$$.

Wether this is acceptable, depends on $$r$$.  That is, under current
market conditions, reinvestment ratio is the proxy by which inflation
must act, if it affects long term staking fraction.  Thankfully, a
staking business $$i$$ should be able to calculate the reinvestment of
its own profits $$r_i$$.  The global $$r$$ is then the market-share
weighted average of all these, a bridge between Ethereum micro- and
macro-economics.

#### Bad Scenario

Consider this "backfire" scenario, though, in which reductions of
inflation decouple $$s^\star$$ from $$r$$.

Issuance is reduced, as per the yield curve $$y(S)=kS^{-1/2}(1+k'S)$$.
The burn rate and transaction fees as a fraction of circulating Ether
do not change appreciably.  LSPs adjust their yields to maintain the
current proportion $$r$$ of the yield from issuance plus fees, and
LST-holders maintain their balances because they simply wish to
passively chase a small percentage yield.  Solo validators reinvest at
about the same rate they have been, in order to chase priority fees
and MEV despite the reduction in issuance.  So, we are pushed into the
higher part of the yield curve, forcing inflation below fees
$$\alpha^\star/f^\star\lesssim10^{-2}$$.  Inflation hawks might even
have considered this a desirable scenario before reading this post!
After (un)staking queue transients die out, staking fraction would
equilibrate to $$s^\star\in(.97,.99)$$.

Essentially, we really need to be sure of what drives validaor
behavior.  If enough validators persist in reinvestment beyond where
we would expect them to, Ethereum could become deflationary, and this
is dangerous.  We recommend surveys to gauge sentiment and
calculations of the distribution of $$r_i$$.

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
1 < \left.\frac{\partial\log r}{\partial\log\alpha}\right|^\star
\cdot \frac{1 + \alpha^\star/f^\star}{1 - r^\star} +
\left.\frac{\partial\log f}{\partial\log\alpha}\right|^\star
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

Consider the quantity $$E$$ of all Ether in existence.  Let the
issuance of new Ether as per The Merge be quantified by $$I$$.  Then
the change in time of total Ether is $$\dot{E}:=dE/dt=I$$.

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
average tx fee might be $$3\times10^{-4}$$ ETH (about \$1~USD), and
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

We understand the long-time behavior of staking by studying what
controls stable fixed points $$s^*$$ corresponding to $$\dot{s}=0$$.
Briefly, we check that at least the position of this fixed point will
not be altered by considering dynamics of inflation.

### Aside on Inflation Dynamics

Above we treat inflation as a parameter instead of as its own dynamic
variable.  How dangerous is this?  For a sanity-check, a quick look at
YCharts since The Merge shows that $$s,\dot{s}$$ vary over a much
greater range than $$(\ln{A},\alpha)$$.

-- FIGURES --

At present we judge the lack of empirical data on $$r$$ would obviate
the added precision of a more sophisticated treatment.  We will
proceed assuming $$\dot{\alpha}\approx0$$ and treating $$\alpha$$ as a
parameter.  Curious or skeptical readers are encouraged to study the
full $$(\alpha,s,\beta)$$-system using the modelling framework we have
developed.

### Fixed Point

Returning from our commercial break, recall we have found a supportive
role played by inflation in moderating staking fraction.  We now wish
to study the fixed point $$s^*$$ given by solving
$$0=\dot{s}=\frac{\dot{A}}{A}(r-s)+(rf+q_+)(1-s)-q_-s$$
yielding
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
$$\alpha/f\approx5$$ while its derivative depends on the slope of the
yield curve $$y$$ via $$\alpha/f=ys/f-b(1-s)=\left(I/(F+B)-b\right)(1-s)$$.

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
been insufficien interest in staking thusfar, then why bother staking at
all?  But we must emphasize that what instability *really* means is
that "market externalities take over", rather than supporting any
specific trajectory due to endogenous dynamics.

We feel it is extremely important that policy interventions, such as
changes to issuance, maintain a stable fixed point -- a fixed point
where small changes shrink instead of growing.  Otherwise staking
fraction is no longer influenced by equilibrium arguments and becomes
much harder to predict or control.  Potential for instability would
manifest as large groups of validators and other market participants
taking very different bets on the future of Ethereum.  Which future
manifests would probably depend on details not observable from
macroeconomics alone.  In what follows we will assume stability for
the sake of discussion, but must stress that while we judge it likely
under current conditions, this matter is not settled without further
and more careful study.

### Inflation Concerns

As we have seen, reducing issuance in a vacuum decreases inflation,
and increases the relative strength of the $$rf(1-s)$$ term.  This
leads to an increase in staking fraction if $$r$$ etc. do not reduce
sufficiently, in response.  Very likely $$x_{now}<r<1$$, so currently
the effects of both inflation and fee-reinvestment push in the same
direction right now.  But we are less interested in such temporary
effects, than the long term behavior of the system.  To study this, we
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

Some good news is that under current conditions, we have some leeway.
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
1 ~~ < ~~ \left.\frac{\partial\,\log r}{\partial\,\log\alpha}\right|^\star
\cdot\frac{1+\alpha^\star/f^\star}{1-r^\star} +
\left.\frac{\partial\,\log f}{\partial\,\log\alpha}\right|^\star
$$

This gives us a condition expressing how the macroeconomic effects of
inflation on reinvestment and tx fees impact the staking fraction
equilibrium.  If reinvestment is steady with small increases in
inflation, then tx fees must respond superlinearly.  If tx fees
respond only weakly, then reinvestment must increase with inflation.
The smaller reinvestment has been and the more inflation dominates
fees, the weaker the increase of reinvestment needs to be to satisfy
this conditions.

## In Conclusion

We find a potentially nuetral and even positive role for inflation in
maintaining moderate staking levels under various scenarios.  We do
not contest the logic that runaway inflation *could* drive staking
fraction unreasonably high.  If so, it must act through reinvestment,
and we emphasize that zero-growth or deflationary conditions would
only make matters worse.

We find that the reinvestment of staking rewards plays a critical role
in staking dynamics.  This is especially true under present market
conditions post-EIP-1557, where inflation dominates fees, and we
expect the equilibrium staking fraction to approach the reinvestment
rate $$r$$.  The formulas for the staking fixed point, stability
criteria, and criteria for inflation to contribute on net to runaway
staking, appear new and we hope they will likewise prove useful to the
community.  In principle, all of these could be tracked.

We propose at least that $$r$$ be added to the list of macroeconomic
indicators routinely tracked for Ethereum, and that the economic
forces, and internal variability affecting $$r$$ be modelled and
measured.  Specifically, policy advisors need to know how and indeed
if solo validators and LSTs will alter their reinvestment strategies,
especially under a regime of lower issuance yield.

It may well, as some have predicted, that fears about runaway
inflation will turn out to be the dominant factor affecting
reinvestment.  If so we expect this will emerge from microeconomic
surveys of large validators and LSTs.  Each staking business $$i$$
can, and probably already does, calculate its desired $$r_i$$.  The
global $$r$$ is then the market-share weighted averaged of all of
these.  We hope these calculations will bridge the macro- and
micro-economics to help the community see a unified and actionable big
picture on the future of Ethereum staking.

