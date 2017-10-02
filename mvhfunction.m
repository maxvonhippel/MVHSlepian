function varargout=mvhfunction(L)
% Last modified by maxvonhippel-at-email.arizona.edu, 09/27/2017
% regn: the name of the region (eg, 'greenland')
% n: the max number of slepian functions to optimize L for
% The Iceland.mat file I use is built out of a ShapeFile my good friend
% Vivian Arriaga, a GIS major at ASU, made for me: varriag1@asu.edu
reg=iceland(0,1);

% For iceland:
c11=[-25.2246 66.861];
cmn=[-12.9199 63.0748];
[Ao4p,~]=spharea(c11,cmn);
n = ((L+1)^2) * Ao4p;
% Get the kernelc
[Klmlmp,XY]=kernelc(L,reg);
% Run glmalpha
J=max(int8(n), 1);
[G,V,~,~,N,GM2AL,MTAP,IMTAP]=glmalpha(XY,L,1,[],[],[],J,0);
% Reorder
[~,~,~,lmcosi,~,~,~,~,~,ronm]=addmon(sqrt(length(G))-1);
lmcosi(2*length(lmcosi)+ronm)=G(:,1);
data=plotplm(lmcosi,[],[],5,0.1);
kelicol
caxis([-max(abs(reshape(peaks,[],1))) max(abs(reshape(peaks,[],1)))]);
colorbar
% PLOTPLM(lmcosi,[],[],meth,degres,th0,sres,cax)
% Prepare outputs
varns={G,V,data,N,GM2AL,MTAP,IMTAP,Klmlmp};
varargout=varns(1:nargout);