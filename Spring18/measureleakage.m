function varargout=measureleakage(domSignal,domRecover,...
  signalB,recoverB,forcenew,L,GIAmodel)
% This script recovers Iceland(b=1.0) from Greenland(b=0.5)

% Returns: slope,slopeerror,acc,accerror,giaMagnitude

defval('domRecover','greenland');
defval('domSignal','iceland');
defval('signalB',1.0);
defval('recoverB',0.5);
defval('forcenew',0);
defval('signalRecover',238.20);
defval('signalSignal',9.68);
defval('res',10);
defval('L',60);
defval('GIAmodel','Paulson07');

[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',forcenew);

thedates=thedates(1:157);
potcoffs=potcoffs(1:157,:,1:4);
nmonths=length(thedates);

[ESTresid,~,~,~,~,~]=plmt2resid(potcoffs(:,:,1:4),thedates,[1 1 181.0 365.0]);
[Clmlmp,~,~,~,~]=plmresid2cov(ESTresid,L,[]);
[~,~,~,lmcosidata,~,~,~,~,~,ronmdata]=addmon(L);
% Decompose the covariance matrix
T=cholcov(Clmlmp);
[n,m]=size(T);
if isempty(T)
  disp('Empty covariance matrix, something is wrong.');
  return
end

% BOXCAP GREENLAND + ICELAND
[~,~,~,~,~,lmcosiSignal]=geoboxcap(2*L,domSignal);
[~,~,~,~,~,lmcosiRecover]=geoboxcap(2*L,domRecover);
% Then truncate
if size(lmcosiSignal,1) > addmup(L)
  lmcosiSignal=lmcosiSignal(1:addmup(L),:);
end
if size(lmcosiRecover,1) > addmup(L)
  lmcosiRecover=lmcosiRecover(1:addmup(L),:);
end

% * 10^12 converts Gt / unit sphere to kg / unit sphere / day
% / [spharea(domSignal) * 4 * pi * 6370000^2] divides by area in m^2 of the
% domain domSignal, putting us into units of kg / m^2 / day
% Then / 365 converts to units of kg / m^2 / yr
factorSignal=signalSignal*10^12/spharea(domSignal)/4/pi/6370000^2/365;
factorRecover=signalRecover*10^12/spharea(domRecover)/4/pi/6370000^2/365;
deltadates=thedates-thedates(1);
lmcosiSSDsignal=zeros([nmonths,size(lmcosiSignal)]);
lmcosiSSDrecover=zeros([nmonths,size(lmcosiRecover)]);
lmcosiSSDcombined=zeros([nmonths,size(lmcosiRecover)]);
counter=1;
for k=deltadates
  factor2Signal=(factorSignal*k);
  factor2Recover=(factorRecover*k);
  lmcosiSSDsignal(counter,:,:)=[lmcosiSignal(:,1:2) ...
  	lmcosiSignal(:,3:4)*factor2Signal];
  lmcosiSSDrecover(counter,:,:)=[lmcosiSignal(:,1:2) ...
  	lmcosiRecover(:,3:4)*factor2Recover];
  lmcosiSSDcombined(counter,:,:)=[lmcosiSignal(:,1:2) ...
  	lmcosiSignal(:,3:4)*factor2Signal + lmcosiRecover(:,3:4)*factor2Recover];
  counter=counter+1;
end
fullSsignal=lmcosiSSDsignal;
fullSrecover=lmcosiSSDrecover;
fullScombined=lmcosiSSDcombined;

TH={domRecover recoverB};
[slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',domRecover,recoverB,L,...
       	[],[],[],[],'SD',forcenew);
[~,~,~,lmcosipad,~,~,~,~,~,ronm]=addmon(L);
sleptRecover=zeros(nmonths,(L+1)^2);
sleptCombined=zeros(nmonths,(L+1)^2);
for k=1:nmonths
	lmcosiRecover=squeeze(fullSrecover(k,:,:));
	lmcosiCombined=squeeze(fullScombined(k,:,:));
	if size(lmcosiRecover,1) < addmup(L)
		lmcosiRecover=[lmcosiRecover; lmcosipad(size(lmcosi,1)+1:end,:)];
	else
		lmcosiRecover=lmcosiRecover(1:addmup(L),:);
	end
	if size(lmcosiCombined,1) < addmup(L)
		lmcosiCombined=[lmcosiCombined; lmcosipad(size(lmcosi,1)+1:end,:)];
	else
		lmcosiCombined=lmcosiCombined(1:addmup(L),:);
	end
	sleptRecover(k,:)=G'*lmcosiRecover(2*size(lmcosiRecover,1)+ronm(1:(L+1)^2));
	sleptCombined(k,:)=G'*lmcosiCombined(2*size(lmcosiCombined,1)+ronm(1:(L+1)^2));
end
[~,~,~,~,~,~,totalparamsRecover,~,~,~,~]=...
	slept2resid(sleptRecover,thedates,[1 181.0 365.0],[],[],CC,TH);
[~,~,~,~,~,~,totalparamsCombined,~,~,~,~]=...
	slept2resid(sleptCombined,thedates,[1 181.0 365.0],[],[],CC,TH);
format long g;

resultRecover=totalparamsRecover(2)*365;
resultCombined=totalparamsCombined(2)*365;

disp(resultRecover)
disp(resultCombined)