function varargout=eruptionMatters(startN,endN)
dom='iceland';
b=1.0;
L=60;

[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',0);
thedates=thedates(startN:endN);
fullS=potcoffs(startN:endN,:,1:4);
nmonths=length(thedates);
[slepcoffs,~,~,TH,G,CC,~,N]=grace2slept('CSRRL05',dom,...
  b,L,[],[],[],[],'SD',0);
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

[~,~,~,~,total,alphavarall,totalparams,totalparamerrors,totalfit,~,~]=...
  slept2resid(slept,thedates,[3 182.625 365.25],[],[],CC(1:round(N)),TH);

slope=totalparams(2,2)*365;
slopeerror=totalparamerrors(2,2);
acc=totalparams(3,2)*365*365*2;
accerror=totalparamerrors(3,2)*365*2;

varargout={slope,slopeerror,acc,accerror};