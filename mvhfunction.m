function varargout=mvhfunction(L, degres)
% Last modified by maxvonhippel-at-email.arizona.edu, 09/27/2017
% regn: the name of the region (eg, 'greenland')
% n: the max number of slepian functions to optimize L for
% The Iceland.mat file I use is built out of a ShapeFile my good friend
% Vivian Arriaga, a GIS major at ASU, made for me: varriag1@asu.edu

% degres must be >= 1
% for example, mvhfunction(4,1) should work

reg=iceland(0,1);
% For iceland:
c11=[-25.2246 66.861];
cmn=[-12.9199 63.0748];
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
    'CSRRL05','iceland',1,L,0,0,0,J,'POT',1);

% Make a nice plot
% data=plotplm(lmcosi,[],[],5,degres);
[r,lon,lat,Plm]=plm2xyz(lmcosi,degres);
% plotplm(lmcosi,[],[],4,1)
indeks1=repmat(lon,length(1:181),1);
indeks2=repmat(lat(1:181)',1,length(lon));
figure
% axesm('mercator','Origin',[70 318 0],...
%      'FLatLimit',[-7 1],...
%      'FLonLimit',[4 14]);
axesm('mercator','Origin',[70 318 0],...
     'FLatLimit',[-20 20],...
     'FLonLimit',[-20 20]);
axis off; framem on; gridm on; tightmap
geoshow(indeks2,indeks1,r,'DisplayType','texturemap')
% Get border of greenland and iceland
XY2=greenland(0,0);
XY1=iceland(0,0);
% Draw greenland
geoshow(XY2(:,2),XY2(:,1),'DisplayType','line')
% Draw iceland
geoshow(XY1(:,2),XY1(:,1),'DisplayType','line')
kelicol
caxis([-max(abs(reshape(peaks,[],1))) max(abs(reshape(peaks,[],1)))]);
colorbar

% Prepare outputs
varns={G,V,lmcosi,N,GM2AL,MTAP,IMTAP,Klmlmp};
varargout=varns(1:nargout);