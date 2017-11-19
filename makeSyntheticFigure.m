% Working on simple script to eventually recreate figures on page 7 of:
% http://polarice.geo.arizona.edu/papers/
% Harig.Simons.GreenlandMassLossGRACE.PNAS.SOM.2012.pdf
tic;
Ls=[20 25 30 35 40 45 50 55 60];
Buffers=[0.0 0.5 1.0 1.5 2.0 2.5 3.0];
[slopes]=vHSynthetic('AA','greenland','greenland',200,60,Ls,Buffers);
toc
disp('done processing slopes, ready to chart')
keyboard