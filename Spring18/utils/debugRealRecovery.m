L=60;
b=0.5;
forceNew=0;
TH={'greenland' b};
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',forceNew);
fullS=potcoffs(:,:,1:4);
[slepcoffs,calerrors,thedates,TH,G,CC,V,N]=...
	grace2slept('CSRRL05','greenland',b,L,[],[],[],[],'SD',forceNew);
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
% Here note that trendG looks great @ 5.6601, matching up very nicely
% with 
slept=slept-GIAt;
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,...
	totalparamerrors,totalfit,functionintegrals,alphavar]=...
    slept2resid_fgls(slept,thedates,[1 365.0],[],[],CC,TH);

% ------------------------------------------------------

% Make a plot
y=total*10^-9;
x=thedates;
plot(x,y)
datetick('x','YYYY','keepticks');
xticks([thedates(1):360:thedates(157)]);
ylabel('Ice Mass (Gt)');
xlabel('Year');
title('Greenland Ice Mass Total');

% [fit,delta,params,paramerrors] = timeseriesfit([thedates' total'],[],1,[]);
% totalfit = [thedates' fit delta];

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
%   -2.7690e+09

% Is this what Chris was trying to show me?
% 
% coeff1FGLS = -1.0997e+10; 
% coeff1OLS = -1.2172e+10
% totalparams(2) = -2.7690e+09;
% coeff1FGLS/totalparams(2) = 3.9715

% >> (totalfit(157,1)-totalfit(1,1))/13.5
% ans =
%   395.3333
% I think this answer indicates the right track because it would show that we
% were at a periodic year high on one end and low on the other and therefore
% is basically twice the actual average (very very very rough) mass trend 
% (slope) of around 200 ish

dates=[datenum(2001,1,1) datenum(2002,1,1) datenum(2003,1,1) datenum(2004,1,1)];
fits=[10 20 30 40];
timeseries=[dates' fits'];
[fit,delta,params,paramerrors]=timeseriesfit(timeseries,[],1,[]);
params(2)*365
% Yields 10, as expected.  So totalparams(2)*365 not yielding what I expect
% probably suggests I need to dig into the fits.