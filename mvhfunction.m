function varargout=mvhfunction(L)
% Last modified by maxvonhippel-at-email.arizona.edu, 09/27/2017
% regn: the name of the region (eg, 'greenland')
% n: the max number of slepian functions to optimize L for
% The Iceland.mat file I use is built out of a ShapeFile my good friend
% Vivian Arriaga, a GIS major at ASU, made for me: varriag1@asu.edu

% For iceland:
c11=[-25.2246 66.861];
cmn=[-12.9199 63.0748];
[Ao4p,~]=spharea(c11,cmn);
n = ((L+1)^2) * Ao4p;
% Get the kernelc
[Klmlmp,XY]=kernelc(L,iceland(0,1));
% Run glmalpha
J=max(int8(n), 1);
[G,V,~,~,N,GM2AL,MTAP,IMTAP]=glmalpha(XY,L,1,[],[],[],J,0);
% Reorder
[~,~,~,lmcosi,~,~,~,~,~,ronm]=addmon(sqrt(length(G))-1);
lmcosi(2*length(lmcosi)+ronm)=G(:,1);
data=plotplm(lmcosi,[],[],4,1);
[ah,ha,~,~,H]=plotstuff(iceland(0,1),1,L);
set(ah,'xlim',cmn)
set(ah,'ylim',c11)
set(ah,'XTick',cmn,'XTickLabel',cmn,...
	 'YTick',c11,'YTickLabel',c11)
kelicol
% nolabels(ah(1:8),1); nolabels(ha(4:12),2); deggies(ah)
% serre(H,1/3,'across')
% serre(H',1/3,'down')
% set(ah,'camerav',8)

% Prepare outputs
varns={G,V,data,N,GM2AL,MTAP,IMTAP,Klmlmp};
varargout=varns(1:nargout);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ah,ha,bh,th,H]=plotstuff(reg,fi,L)
% Number of basis function to show
defval('np',12)
% Legend location
defval('lox','ll')
% Tick mark switching option
defval('swti','no')
% Axis expansion
defval('num',40)
% Data exaggeration
defval('swl',1)
% Font Size
defval('fozo',6)
% Panel geometry
defval('fi',0);
% Bandwidth
defval('L',18)
% Index to draw
defval('index',1)

if fi==0
  [ah,ha,H]=krijetem(subnum(4,3));
else
  [ah,ha,H]=krijetem(subnum(3,4));
end
[dems,dels]=addmon(L);

infl=1;
[V,C,~,~,~]=localization(L,reg,[],np*infl);
defval('XY',reg)
% Modify to do only partial reconstruction to save time
r=NaN([181 361 np]);
if L>48
  h=waitbar(0,sprintf(...
      'Expanding spherical harmonics up to degree %i',L));
end
% Get a file with the harmonics to reuse
[r(:,:,1),~,~,Plm]=plm2xyz([dels dems C{1}],1);
whichone=1+(index-1)*infl;
if L>48
    waitbar(index/12,h)
end
if index>1
% In the next line should expand only in the region to save time
r(:,:,index)=plm2xyz([dels dems C{whichone}],1,[],[],[],Plm);
end
ka=swl*r(:,:,index);
% Use setnans for this, rather
ka=ka/max(max(abs(ka)));
ka(abs(ka)<0.01)=NaN;
axes(ah(index))
sax=[-1 1];
cola='kelicol';
imagefnan([0 90-100*eps],[360 -90],ka,cola,sax)

axis image
set(ah,'FontSize',fozo-2)

[axl,pc]=plotcont;
axis([0 360 -90 90])
set(pc,'Linew',0.5);
t{index}=sprintf('%s = %i','\alpha',whichone);
title(sprintf('%s = %.13g','\lambda',V(whichone)));
% Box labeling
[bh(index),th(index)]=boxtex(lox,ah(index),t{index},fozo,[],[],1.1,0.8,1.2);

longticks(ah)
set(ah,'xgrid','off','ygrid','off')

if fi==0
  nolabels(ah(1:9),1)
  nolabels(ha(5:12),2)
  serre(ah(1:3),1/2,'across')
  serre(ah(4:6),1/2,'across')
  serre(ah(7:9),1/2,'across')
  serre(ah(10:12),1/2,'across')
  serre(ha(1:4),2/3,'down')
  serre(ha(5:8),2/3,'down')
  serre(ha(9:12),2/3,'down')
end
seemax(ah,3) 
fig2print(gcf,'landscape')  
figdisp('sdwregions',sprintf('%s_%i',reg,L))