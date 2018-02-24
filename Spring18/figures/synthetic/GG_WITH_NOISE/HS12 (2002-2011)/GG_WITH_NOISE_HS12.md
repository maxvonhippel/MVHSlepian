## `GG_WITH_NOISE_HS12.md`

In this experiment I create a synthetic boxcap signal of 200 Gt/year distributed uniformly across Greenland.  Next, I apply white gaussian noise to the signal, matching the covariance of the synthetic data.  I then recover Greenland's mass loss trend from that synthetic signal, at varying bandwidths (L) and buffer sizes (b).  Finally, I create a contour chart representing the percent signal recovered (of the initial 200) for each tested buffer and bandwidth pair.

Data spans 17-Apr-2002 12:00:00 to 16-Aug-2011 12:00:00

Date: 24 February 2018
Script: hs12syntheticrecovery.m
Git hash: a7ada0f923ecc49b996db08fef38450ac1007042