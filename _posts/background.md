
# Notes

- There is a problem: Centralized stakers and major LSTs could replace
  Ethereum's decentralized governance with a oligopoly of staking
  interests.

- These concerns have been felt for a few years as people watched the
  relatve [Lido stake grow](LINK)

- As the percentage of stake increases, so does issuance, and if this
  [on-paper inflation]LINK investopedia) translates into real price
  inflation, the real rate of validator yields will decrease.

- Changing the yield curve [was proposed](LINK) by some ethereum
  researchers as a potential solution to both of these interlocking
  problems.

- The arguments are laid out [in an introductory talk here](LINK), in
  more technical form [here](LINK), and in general resources on this
  issue have been collected [here](LINK to issuance.wtf)

- In this post we derive, using [dynamical systems](link to strogaz)
  and very mild economic assumptions, conditions under which changing
  the the yield curve would solve the "100% Staking Issue" and the
  "Governance Centralization" issue, vs. exaccerbate it further.

- Unfortunately, we cannot support changing the yield curve at this
  time.  We find the dynamics to be mre nuanced than the proposals
  have suggested, and express concern.

- We cannot say for certain what the parameters will be when measured,
  but we see reason for concern.  Under certain believable parameter
  ranges, changing the yield curve could have no meaninful impact on
  centralizaton, and would actally exacerbate the 100% staking
  situation.

- There are other parameter ranges that are more dangerous, but
  thankfully these can be easily designed against.

- We close with some thoughts on exploring the design space of
  possible dynamical behaviors, and propose conditions for evaluating
  potential long and short-term solutions.

- governance centralization tldr.  If a reduction in issuance reduces
  the relative staking ratio of centralized to decentralized staking,
  this occurs because solo stakers are less elastic than centralized
  stakers like Coinbase and LSTs.  Due to economy of scale, it is hard
  to believe that solo stakers have a lower cost floor per validator,
  than centralized operations.  So, it seems likely that if the growth
  of solo stakers exceeds centralized operations, it is because the
  solo stakers are deferring profit to temporarily subsidize the
  protocol.  Unless we can devise some hashcash-lke mechanism to
  disproportionately increase costs for centralized stakers this is
  probably unsustainable long term.  Even as a short term means of
  buying time, discussions with validators are strongly recommended to
  ensure they have the capital and appetite to do this.

## Background

### Ethereum Issuance Curve, Staking, and Liquid Staking

### Quarterly Averaging and Difference vs. Differential Equations

### Fixed Points, Stability, Market Equilibria

## Governance Centralization

