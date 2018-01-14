The nomenclature of the figures below is as follows:

---- Recovery Contour Charts ----

These are charts of the percent of signal recovered in a synthetic experiment.
In these, we use the nomenclature [A][B]_[boolean noise]_[boolean corrections].
Here [A] refers to the first letter of the region signal is applied to, and [B]
refers to the first letter of the region signal is recovered from.
So for instance if we apply 200 Gt/yr to Greenland, recover from Greenland, use
synthetic noise, and do no corrections, then the name would be GG_with_noise.
Alternatively, if we apply 200 Gt/yr to Greenland, recover from Iceland, use
synthetic noise, and use corrections, then the name would be 
GI_with_noise_with_corrections.  The specific corrections used and version of
the script used and other such details should be in an identically named .txt
file in the folder of the figure.

---- Geographic Charts ----

These are charts of regions, possibly with some sort of signal or data mapped
on top of them.  In this case the nomenclature is [REGION]_[with data].  So for
instance, if we show the GRACE data projected to Slepian functions for Greenland,
it would be GREENLAND_with_GRACE_SLEPIAN.  And again, a .txt file within that
folder would specify the precise details of the figure and all its useful
metadata.