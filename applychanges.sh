#!/bin/bash

cp mvhfunction.m /Users/maxvonhippel/Slepian/slepian_alpha/mvhfunction.m &&
cp SyntheticCaseA.m /Users/maxvonhippel/Slepian/SyntheticCaseA.m &&
cp SyntheticExperiments.m /Users/maxvonhippel/Slepian/SyntheticExperiments.m &&
cp SyntheticCaseAA.m /Users/maxvonhippel/Slepian/SyntheticCaseAA.m &&
cp slept2resid.m /Users/maxvonhippel/Slepian/slepian_delta/slept2resid.m &&
cp iceland.m /Users/maxvonhippel/Slepian/slepian_alpha/REGIONS/iceland.m &&
git add . && git commit -m "auto-saving in applychanges.sh script" &&
say "COPIED PROGRESS";

exit 0;
