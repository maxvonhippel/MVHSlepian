dom='greenland';
Signal=200;
L=60;
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
[~,~,~,~,~,lmcosiS]=geoboxcap(L,dom);
factor1=Signal*10^12;
[fractionalAreaDom,~]=spharea(dom);
factor1=factor1/fractionalAreaDom;
deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k)/365;
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  counter=counter+1;
end
% resid
fullS=lmcosiSSD;
B=0.5;
TH={dom B};
XY=eval(sprintf('%s(%i,%f)',TH{1},10,TH{2}));
% The current Shannon number
N=round((L+1)^2*spharea(XY));
% We want the G from glmalpha, but we also want the eigenfunctions,
% so use grace2slept to load both
[~,~,~,~,G,CC]=grace2slept('CSRRL05',XY,B,L,[],[],[],[],'SD',1);
[~,~,~,lmcosipad,~,~,~,~,~,ronm]=addmon(L);
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
% Estimate the total mass change
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,...
 totalparams,totalparamerrors,totalfit,functionintegrals,...
 alphavar]=slept2resid(slept,thedates,[1 365.0],[],[],CC,TH);
% Index allslopes by L and B
slopes(counter,:)=[L B totalparams(2)*365];

% figure stuff with plm 2 avg
% results=zeros([1 nmonths]);
% for x=1:nmonths
%   lmcosi=squeeze(lmcosiSSD(x,:,:));
%   [Int,~,~,~]=plm2avg(lmcosi,dom);
%   results(x)=Int*surfaceAreaDom;
% end
% x=deltadates/365;
% y=results*10^-12;
% hold on;
% xlabel('years');
% ylabel('Gt');
% scatter(x,y);
% hold off;