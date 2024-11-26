# Will Reducing Issuance Avoid 100\% ETH Staked?

## Acknowledgements

This is the first blog post in a series summarizing our research
funded by EF GRANT INFO.  E.M.D. acknowledges useful discussions with
Philipp Zahn, Eric Siu, Angsar Dietrichs, and Andrew Sudbury.

## The Problem

The share of Ether staked by Coinbase and LSTs such as Lido
("centralized" staking services) continues to grow quite considerably.
This has provoked fears, first raised by Ethereum researchers, and
which we share, that the future of Ethereum might involve (1) all of
its native asset being staked, such that (2) the de facto liquid Ether
is controlled by a confederation of centralized un-transparent
govrnance. In this blog post we address the first of these concerns.

We use "stock and flow" differential equation models to study Ethereum
macroeconomics, specifically how changing issuance impacts these
questions.  We will publish four blog posts on this topic:

1. (This post) Will reducing issuance avoid 100% ETH Staked?
2. Will reducing issuance avoid Governance Centralization?
3. Other Levers besides Issuance, and a means of evaluating them.
4. Summary and community tools to help study and resolve issuance debates.

We may also publish bonus posts, if there is sufficient community
engagement, so dear reader stay vigilant!

## TLDR

For the extraordinarily impatient our message is a bit of a downer: we
find that the proposed reduction of issuance, unfortunately, does not
necessarily solve either of problems (1) or (2) over parameter ranges
we judge to be plausible, and in fact, it could actually make things
worse.

In some more detail, our conclusions on (1), the subject of this post,
for those who are only moderately impatient.

The quantity of most importance to this debate is the staked ETH
fraction $$s=S/A$$ where $$S$$ is all staked ETH, $$C$$ is
"circulating" (unstaked, unburnt) ETH, and $$A=S+C$$ is the total
"accessible" (unburnt) ETH. Differential changes, such as changes in
time $$\frac{ds}{dt}:=\dot{s}$$ are given by the quotient rule
$$\dot{s}=\dot{S}/A-s\dot{A}{A}$$.  The quantity $$\dot{A}/A$$ is the
inflation rate averaged on at-least-quarterly timescales.

That is, an increase in staking fraction can be driven by more people
staking, and/or it can be driven by a reduction of the inflation rate.
The latter can be acheived by a reduction of issuance relative to the
base fee "burn rate".  Because of this, there is a mathmatical regime
in which reducing issuance actually *increases* $$s^\star$$, the market
equilibrium staking ratio.  We argue this regime is likely to be
realistic, and thus worthy of attention.  So, we urge caution before
rushing to reduce issuance.

## 100% Ether Staked

### Splitting Up A Growing Pie

Consider the quantity $$E$$ of all Ether in exitence.  Let the
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
\begin{align}
\dot{E} &= I\\
\dot{S} &= R+Q_+-Q_-\\
\dot{A} &= I-B\\
\end{align}
$$

Where all quantities are assesed quarterly:
* $$I$$ -- Total Issuance
* $$R$$ -- Total Reinvestment of Validator Yields
* $$Q_\pm$$ -- Total (Un)Staking Queue Flows
* $$B$$ -- Total Base Fee, aka Burn Rate.

Transaction fees $$F+B$$ are split into the base fee $$B$$ which is
burned, and priority fees plus MEV $$F$$ which go to validators via the
wihdrwal queue.  Fees obey the inequality $$0\leq F+B\leq C$$.  We ae
interested in the limit $$C\to0$$ and pull this dependence out by
defining $$f$$ such that $$fC = F+B$$. The fraction $$f$$ need not
be a constant, but whatever values it takes, $$f$$ must be a fraction:
$$0<f<1$$.

En masse, validators withdraw their rewards $$I+F$$ into circulating
ETH.  They reinvest some amount of rewards $$R$$ into staking more
validators.  Reinvestment into one's business is a natural practice,
and we expect $$R$$ to respond meaningfully to macroeconomic forces.
Reinvestment is also a part of every LST smart contract; via rebaisng,
a certain fraction of yield is the value proposition for the
token-holder; so any model with LSTs must include reinvestment.  Again
we define a variable fraction $$r:=R/(I+F)$$ which obeys
$$0\leq{r}\leq1$$.  As of Nov 23, 2024 the stETH yield is 3\%.  Over
the same period, without MEV-Boost validator yield is $$\approx4\%$$,
and with MEV-Boost it is $$\approx5.7\%$$.  So probably, $$r$$
currently lies in the range $$.53\leq r\leq.75$$.

The quarterly flows from the staking and unstaking queues must obey
$$0\leq Q_+\leq C$$ and $$0\leq q_-\leq S$$, which we use below via
variable fractions $$q_+=Q_+/C,~q_-=Q_-/S$$.

Finally, we rewrite $$\dot{S}$$ the change in total staked ETH,
anticipating that we wish to understand the relationship to inflation
rate $$\dot{A}/A$$, obtaining $$\dot{S} = r\dot{A} + r(B+F) + Q_+-Q_-$$.

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
Under deflation $$\dot{A}/A<0$$ the effects are reversed.  The second
term combines new staking $$q_+$$ and the reinvestment of priority
fees and MEV $$rf$$, and is always non-negative.  The third
term represents unstaking and is always non-positive.

### Fixed Point

If quarterly inflation $$\alpha:=\dot{A}/A$$, governed by the tension
between issuance and burn, changes quickly enough, we have a two
dimensional system.  The varieties of qualitatuive behavior of this
system are however essentially similar to that of the one-dimensional
system, if all ones cares about is the stability of market equilibria,
and the response to issuance changes, which we do.

If $$\alpha$$ varies lowly enough $$\alpha\approx\alpha^\star$$, a fixed
point $$s^\star$$ where $$\dot{s}=0$$ can obtain:

$$
\displaystyle
s^\star=\frac{r^\star(\alpha^\star + f^\star) + q_+^\star}{\alpha + r^\starf^\star - q^\star_-}
$$

Perhaps surprisingly we find that if $\dot{A}=0=\alpha$ (no inflation
nor deflation) then counter-intuitively, an interor market equilibrium
$s^\star<1$ seems unlikely.  We reason as follows.  In the absence of
in/de-flation, an interior fixed point $$s^\star<1$$ would require a
persistent unstaking/capitulation of existing validators $$q_->0$$.
This in turn either requires "churn", a persistent supply of new
validators to take their place $$q_+^\star>0$$, or it is only a transient
and $$q_-^\star\approx0$$; recall that reinvestment by existing validators is
not counted in $$q_+$$.

Net unstaking $$q_->0$$ could only describe a market equilibrium if
one group of stakers was actively capitulating and withdrawing their
stake, while another group with a higher $$r$$ were aggressively
reinvesting in their business, and their reinvestment of fees and MEV
offset the unstaking, adjusted for inflation.  This cannot maintain:
eventually there will be no new Capitulators left, and the fraction of
stake will grow again as Reinvestors take up more market share.
Similarly, at some point everyone who wants to stake should have
staked, and other than influxes due to humanity's issuance of new
humans etc., further validators count only toward $$r$$, so
$$q_+^\star\approx0$$.

Thus, the fixed point $$s^\star$$ is likely to be

$$s^\star\approx r\frac{\alpha + f}{\alpha + rf}$$

A few limits are illustrative under the current regime of positive
inflation.  If inflation dominates fees, $$\alpha\gg f$$ then
$$s^\star\sim r^\star<1$$, while if fees dominate inflaton $$\alpha\ll f$$ and
$$s^\star\to1$$.

### Market Equilibrium

The fixed-point $$x^\star$$ represents a market equilibrium just when it
is unqiue and stable.

Non-uniqueness would seem to require a shared and repeated root (the
other equilibrium point) among terms $$\alpha,rf+q_+,q_-$$.  The root
must be repeated because these quantities are strictly non-negative.
It's unclear how this would occur.  For now, lacking any supporting
data or a mechanism, we move on, assuming uniqueness.

Stability requires that small perturbations shrink;
$$\frac{\partial\dot{x}}{\partial x}\big|_{x^\star}<0$$.  The full
condition is quite complicated, especially under deflation. Perhaps
onchain measurements and surveys/metrics of validator preferences will
allow us to estimate the full extent of the stability basin around
$$x^\star$$.  If however inflation is positive and $$r,\alpha,f$$ are
relatively nsensitive to small changes in $$x$$ near $$x^\star$$, this
conditions is satisfied immediately; $$\alpha+rf>0$$.

While we expect dependence on other macroeconomic factors, we find it
quite believable that reinvestment, inflation, and priority fees are
relatively insensitive to small changes in staking fraction near the
fixed point under small levels of inflation.

So our takeaway is that this stable equilibrium is at least plausible,
and worthy of consideration.  How does it behave?

### Qualitative Behavior

We have argued above that the fixed point
$$x^\star=r(\alpha+f)/(\alpha+rf)$$ is then this behavior is quite distinct
from the arguments forwarded by Ethereum researchers, in which
inflation is held responsible for a 100% ETH Staked scenario.  To be
clear, vey likely $$x_{now}<r<1$$, but for long times we find that
inflation moderates the effect of fee reinvestment, with more
inflation lowering the fraction of staked ETH at the same levels of
$$rf$$.

-- FIGURE 3 --

Why does this happen?  The reinvestment of issuance rewards adds to
both staked ETH $$S$$ and circulating ETH $$C$$, so the effect on
staking fraction depends on the relative size of these two.  However,
the reinvestment of priority fees plus MEV is simply a net value
transfer from $$C$$ to $$S$$, which can only ever increase staking
fraction.

Thus, reducing issuance in a vacuum increases the relative strength of
the $$rf(1-x)$$ term.  Unless there is a compensatingly large drop
in reinvestment ratio $$r$$,
