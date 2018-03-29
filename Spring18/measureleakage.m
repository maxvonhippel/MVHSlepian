function varargout=measureleakage(domSignal,domRecover,...
  signalB,recoverB,forcenew,L,GIAmodel)
% This script recovers Iceland(b=1.0) from Greenland(b=0.5)

% Returns: slope,slopeerror,acc,accerror,giaMagnitude

defval('domSignal','iceland');
defval('domRecover','greenland');
defval('signalB',1.0);
defval('recoverB',0.5);
defval('forcenew',0);
defval('L',60);
defval('GIAmodel','Wangetal08');

[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',forcenew);

thedates=thedates(1:157);
fullS=fullS(1:157,:,1:4);
nmonths=length(thedates);

[slepcoffs,~,~,TH,G,CC,~]=grace2slept('CSRRL05',domSignal,signalB,L,[],[],[],[],'SD',forcenew);

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

if strcmp(GIAmodel,'none')
	[~,GIAt,~,~,giaMagnitude]=correct4gia(thedates,GIAmodel,TH,L);
	slept=slept-GIAt;
else
	giaMagnitude=0;
end

recoverTH={domRecover recoverB};
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,...
	totalparamerrors,totalfit,functionintegrals,alphavar]...
	=slept2resid(slept,thedates,[3 182.625 365.25],[],[],CC,recoverTH);

slope=totalparams(2,2)*365;
slopeerror=totalparamerrors(2,2);
acc=totalparams(3,2)*365*365*2;
accerror=totalparamerrors(3,2)*365*2;

varns={slope,slopeerror,acc,accerror,giaMagnitude};
varargout=varns(1:nargout);