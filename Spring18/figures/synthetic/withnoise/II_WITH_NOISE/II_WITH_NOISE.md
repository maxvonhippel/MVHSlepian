## II_WITH_NOISE.md

In this experiment I create a synthetic boxcap signal of 200 Gt/year distributed uniformly across Iceland.  Next, I apply white gaussian noise to the signal, matching the covariance of the synthetic data.  I then recover Iceland's mass loss trend from that synthetic signal, at varying bandwidths (L) and buffer sizes (b).  Finally, I create a contour chart representing the percent signal recovered (of the initial 200) for each tested buffer and bandwidth pair.

Date: 15 February 2018
Script: hs12syntheticrecovery.m
Git hash: 1034e3c0da13242f8792e44d73472069fdc8d3e5