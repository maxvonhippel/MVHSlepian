The folder structure for Spring18 is as follows:

````
.
├── figures						- Figures for paper (WIP)
│   ├── FIGURES.md				- Documentation of Figures
│   ├── GG_with_noise			- Recover Greenland from Greenland
│   │   ├── GG_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── GG_with_noise.fig	- Contour chart of recovery
│   │   └── GG_with_noise.txt	- Documentation of experiment
│   ├── GI_with_noise			- Recover Iceland from Greenland
│   │   ├── GI_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── GI_with_noise.fig	- Contour chart of recovery
│   │   └── GI_with_noise.txt	- Documentation of experiment
│   ├── IG_with_noise			- Recover Greenland from Iceland
│   │   ├── IG_with_noise.dat	- Data of recovery for Ls & buffers
│   │   ├── IG_with_noise.fig	- Contour chart of recovery
│   │   └── IG_with_noise.txt	- Documentation of experiment
│   └── II_with_noise			- Recover Iceland from Iceland
│       ├── II_with_noise.dat	- Data of recovery for Ls & buffers
│       ├── II_with_noise.fig	- Contour chart of recovery
│       └── II_with_noise.txt	- Documentation of experiment
├── hs12syntheticrecovery.m		- Script used for recovery experiments
├── notes						- Notes for paper (WIP)
│   ├── notes.txt				- Notes (general purpose)
│   └── references.txt			- Notes (citations for paper - WIP)
└── utils						- Utility scripts I write & use
    └── makecontour.m			- Makes a contour chart of [X Y Z] matrix
````