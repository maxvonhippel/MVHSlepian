L=60;
b=0.5;
TH={'greenland' b};
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',0);
fullS=potcoffs(:,:,1:4);
[slepcoffs,calerrors,thedates,TH,G,CC,V,N]=...
	grace2slept('CSRRL05','greenland',b,L,[],[],[],[],'SD',1);
[dems,dels,mz,lmcosipad,mzi,mzo,bigm,bigl,rinm,ronm,demin]=addmon(L);
nmonths=length(thedates);
slept=zeros(nmonths,(L+1)^2);
for k=1:nmonths
	lmcosi=squeeze(fullS(k,:,:));
	if size(lmcosi,1) < addmup(L)
	  lmcosi=[lmcosi; lmcosipad(size(lmcosi,1)+1:end,:)];
	else
	  lmcosi=lmcosi(1:addmup(L),:);
	end
	slept(k,:)=G'*lmcosi(2*size(lmcosi,1)+ronm(1:(L+1)^2));
end
[thedates,GIAt,GIAtU,GIAtL,trendG]=...
	correct4gia(thedates,'Paulson07',TH,L);
slept=slept-GIAt;
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,...
	totalparamerrors,totalfit,functionintegrals,alphavar]=...
    slept2resid_fgls(slept,thedates,[1 365.0],[],[],CC,TH);

% ---------------------------------

% OLS Estimates:

%        |    Coeff         SE     
% ---------------------------------
%  Const | -4.7996e+08  5.9042e+09 
%  x1    | -1.2172e+10  5.9246e+09 
%  x2    |  4.6921e+10  8.2633e+09 
%  x3    |  8.2001e+09  8.4417e+09 

% FGLS Estimates:

%        |    Coeff         SE     
% ---------------------------------
%  Const | -1.1114e+09  7.5706e+09 
%  x1    | -1.0997e+10  7.5605e+09 
%  x2    |  4.5449e+10  9.8723e+09 
%  x3    |  8.8639e+09  1.0090e+10 


% >> totalparams(2)*365
% ans =
%   -2.0104e+09

% >> totalparams
% totalparams =
%    1.0e+12 *
%     5.5673
%    -0.0000
%          0
%          0

% >> (totalfit(157,1)-totalfit(1,1))/13.5
% ans =
%   395.3333