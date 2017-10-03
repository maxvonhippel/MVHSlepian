function varargout=mvhfunction(L, degres)
% Last modified by maxvonhippel-at-email.arizona.edu, 09/27/2017
% regn: the name of the region (eg, 'greenland')
% n: the max number of slepian functions to optimize L for
% The Iceland.mat file I use is built out of a ShapeFile my good friend
% Vivian Arriaga, a GIS major at ASU, made for me: varriag1@asu.edu
reg=iceland(0,1);

% For iceland:
c11=[-25.2246 66.861];
cmn=[-12.9199 63.0748];
c11cmn=[-25.2246 66.861 -12.9199 63.0748];
[Ao4p,~]=spharea(c11,cmn);
n = ((L+1)^2) * Ao4p;
% Get the kernelc
[Klmlmp,XY]=kernelc(L,reg);
% Run glmalpha
N=int8(n);
J=max(N, 1);
[G,V,~,~,N,GM2AL,MTAP,IMTAP]=glmalpha(XY,L,1,[],[],[],J,0);
% Reorder
[~,~,~,lmcosi,~,~,~,~,~,ronm]=addmon(sqrt(length(G))-1);
lmcosi(2*length(lmcosi)+ronm)=G(:,1);

% Now get the monthly grace data
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','POT',0);
% Project it into Slepians
[slepcoffs,calerrors,thedates,TH,G,CC,V,N]=grace2slept(...
    'CSRRL05','iceland',1,L,[],[],[],'N','POT',1);

% Make a nice plot
% data=plotplm(lmcosi,[],[],5,degres);
[r,lon,lat,Plm]=plm2xyz(lmcosi,degres);
indeks1 = repmat(lon,length(1:90),1);
indeks2 = repmat(lat(1:90)',1,length(lon));
figure
axesm('mercator','Origin',[70 318 0],...
     'FLatLimit',[-7 1],...
     'FLonLimit',[4 14]);
axis off; framem on; gridm on; tightmap
geoshow(indeks2,indeks1,lmcosi,'DisplayType','texturemap')
geoshow(XY(:,2),XY(:,1),'DisplayType','line')
kelicol
caxis([-max(abs(reshape(peaks,[],1))) max(abs(reshape(peaks,[],1)))]);
colorbar

% Prepare outputs
varns={G,V,lmcosi,N,GM2AL,MTAP,IMTAP,Klmlmp};
varargout=varns(1:nargout);