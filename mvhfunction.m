function varargout=mvhfunction(n)
% Last modified by maxvonhippel-at-email.arizona.edu, 09/21/2017
% regn: the name of the region (eg, 'greenland')
% n: the max number of slepian functions to optimize L for

% For iceland:
c11=[-25.2246 66.861];
cmn=[-12.9199 63.0748];

% Figure out good value of L
[Ao4p,~]=spharea(c11,cmn);
L=0;
for L = 1:10
    n0 = ((L+1)^2) * Ao4p;
    if (n0 >= n)
        break
    end
end
disp(L)

% Get the kernelc
% Needs to be modified for other countries, right now iceland
% hard-coded in.
[Klmlmp,XY]=kernelc(L,'iceland');
% Run glmalpha
J=max(int8(n), 1);
[G,V,~,~,N,GM2AL,MTAP,IMTAP]=glmalpha(XY,L,1,[],[],[],J,0);
% Reorder
[~,~,~,lmcosi,~,~,~,~,~,ronm]=addmon(sqrt(length(G))-1);
lmcosi(2*length(lmcosi)+ronm)=G(:,1);

% Plot
defval('meth',4);
defval('degres',1);
data=plotplm(lmcosi,[],[],meth,degres);
kelicol

% Prepare outputs
varns={G,V,data,N,GM2AL,MTAP,IMTAP,Klmlmp};
varargout=varns(1:nargout);