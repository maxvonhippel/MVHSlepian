function varargout=iceland(res,buf) 
% XY=ICELAND(res,buf,nearby)
% ICELAND(...) % Only makes a plot
%
% Finds the coordinates of Iceland, potentially buffered by some amount.
%
% INPUT:
%
% res      0 The standard, default values
%          N Splined values at N times the resolution
% buf      Distance in degrees that the region outline will be enlarged
%          by BUFFERM, not necessarily integer, possibly negative
%          [default: 0]
%
% OUTPUT:
%
% XY       Closed-curved coordinates of the continent
%
% Last modified by maxvonhippel-at-email.arizona.edu, 09/23/2017

regn='iceland';
defval('res',0);
defval('buf',0);

c11=[-25.2246 66.861];
cmn=[-12.9199 63.0748];
xunt=1:453;

% Inspired by orinoco.m
% XY=load(fullfile(getenv('IFILES'),'COASTS',regn));
% XY=XY.XY;

% Do it! Make it, load it, save it
XY=regselect([],c11,cmn,xunt,res,buf);


if nargout==0
% I don't understand why this image looks weird
% geoshow(XY(:,1), XY(:,2)); <-- works perfectly...
    plot(XY(:,1),XY(:,2),'k-'); axis image; grid on
end

% Prepare optional output
varns={XY};
varargout=varns(1:nargout);