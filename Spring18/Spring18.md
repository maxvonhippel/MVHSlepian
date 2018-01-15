The folder structure for Spring18 is as follows:

````
.
├── figures						- Figures for paper (WIP)
│   ├── FIGURES.md				- Documentation of Figures
│   ├── GG						- Same as GG_with_noise, but without noise
│   │   ├── GG.dat
│   │   ├── GG.fig
│   │   └── GG.txt
│   ├── GG_with_noise			- Recover Greenland from Greenland
│   │   ├── GG_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── GG_with_noise.fig	- Contour chart of recovery
│   │   └── GG_with_noise.txt	- Documentation of experiment
│   ├── GI						- Same as GI_with_noise, but without noise
│   │   ├── GI.dat
│   │   ├── GI.fig
│   │   └── GI.txt
│   ├── GI_with_noise			- Recover Iceland from Greenland
│   │   ├── GI_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── GI_with_noise.fig	- Contour chart of recovery
│   │   └── GI_with_noise.txt	- Documentation of experiment
│   ├── IG						- Same as IG_with_noise, but without noise
│   │   ├── IG.dat
│   │   ├── IG.fig
│   │   └── IG.txt
│   ├── IG_with_noise			- Recover Greenland from Iceland
│   │   ├── IG_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── IG_with_noise.fig	- Contour chart of recovery
│   │   └── IG_with_noise.txt	- Documentation of experiment
│   ├── II						- Same as II_with_noise, but without noise
│   │   ├── II.dat
│   │   ├── II.fig
│   │   └── II.txt
│   ├── II_with_noise			- Recover Iceland from Iceland
│   │   ├── II_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── II_with_noise.fig	- Contour chart of recovery
│   │   └── II_with_noise.txt	- Documentation of experiment
│   └── REAL_DATA_GI			- Recover Iceland from real Greenland data
│       ├── REAL_DATA_GI.fig	- Gt/yr rather than %
│       └── REAL_DATA_GI.txt	- Documentation of experiment
├── hs12realrecovery.m			- Script used for real recovery experiments
├── hs12syntheticrecovery.m		- Script used for synthetic recovery experiments
├── notes						- Notes for paper (WIP)
│   ├── notes.txt				- Notes (general purpose)
│   └── references.txt			- Notes (citations for paper - WIP)
└── utils						- Utility scripts I write & use
	├── makecontour.m			- Makes a contour chart of [X Y Z] matrix
	└── makecontour.sh			- TODO: write script to make contour chart of
								  [X Y Z] matrix using Genaric Mapping Tools 
								  (GMT).  Should take a .dat file as input.
````
