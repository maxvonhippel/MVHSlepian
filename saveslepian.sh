#!/bin/bash

# Copy and paste your script here
cd Documents/NASA/Matlab\ Scripts/;
cp /Users/maxvonhippel/Slepian/slepian_alpha/mvhfunction.m .;
cp /Users/maxvonhippel/Slepian/SyntheticCaseA.m .;
cp /Users/maxvonhippel/Slepian/SyntheticExperiments.m .;
git add . && git commit -m "$1" && git push -u origin master;
cd ;
say "SAVED";

exit 0;
