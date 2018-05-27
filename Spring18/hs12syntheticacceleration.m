function varargout=hs12syntheticacceleration(...
  InitialSignal,YearlyAcceleration,months,L,buffer,domSignal,...
  domRecover,wantnoise,forcenew)
% Example: 
% [slopes]=hs12syntheticrecovery('iceland','iceland',1,[],[],[],[],'II')
% 
% Here we attempt to determine the minimum data range at which we can measure
% acceleration.
% 
% Authored by maxvonhippel-at-email.arizona.edu on 01/11/18
% Last modified by maxvonhippel-at-email.arizona.edu on 02/11/18

defval('filename','II');
defval('domSignal','iceland');
defval('wantnoise',1);
defval('forcenew',1);
if wantnoise
  filename=sprintf('%s_WITH_NOISE', filename);
end
defval('domRecover','iceland')
defval('InitialSignal',200);
defval('YearlyAcceleration',1.0);
defval('months',120);
defval('L',60);
defval('buffer',1.0);

% Get the original data
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',forcenew);
thedates=thedates(1:months);
potcoffs=potcoffs(1:months,:,:);
nmonths=length(thedates);
% Get the fitted results
[ESTresid,~,~,~,~,~]=plmt2resid(potcoffs(:,:,1:4),thedates,[1 1 181.0 365.0]);
[Clmlmp,~,~,~,~]=plmresid2cov(ESTresid,60,[]);
[~,~,~,lmcosidata,~,~,~,~,~,ronmdata]=addmon(60);
% Decompose the covariance matrix
T=cholcov(Clmlmp);
[n,m]=size(T);
if isempty(T)
  disp('Empty covariance matrix, something is wrong.');
  return
end

[~,~,~,~,~,lmcosiS]=geoboxcap(2*60,domSignal);
if size(lmcosiS,1) > addmup(60)
  lmcosiS=lmcosiS(1:addmup(60),:);
end

deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  AdjustedSignal=InitialSignal+((counter-1)/12)*YearlyAcceleration;
  factor1=k*AdjustedSignal*10^12/spharea(domSignal)/4/pi/6370000^2/365;
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor1];
  if wantnoise
    % Make a synthetic noise realization
    syntheticnoise=randn(1,n)*T;
    % Reorder the noise
    temp1=lmcosidata(:,3:4);
    temp1(ronmdata)=syntheticnoise(:);
    syntheticnoise=[lmcosidata(:,1:2) temp1];
    fullS(counter,:,:)=[lmcosidata(:,1:2)...
       squeeze(lmcosiSSD(counter,:,3:4))+syntheticnoise(:,3:4)];
  end
  counter=counter+1;
end
if ~wantnoise
  fullS=lmcosiSSD;
end

overallCount=1;
TH={domRecover buffer};
[slepcoffs,~,~,TH,G,CC,~,N]=grace2slept('CSRRL05',domRecover,buffer,L,...
	[],[],[],[],'SD',forcenew);
[~,~,~,lmcosipad,~,~,~,~,~,ronm]=addmon(L);
slept=zeros(nmonths,(L+1)^2);
for k=1:nmonths
	lmcosi=squeeze(fullS(k,:,:));
  % Truncation happens here, hence why oversampling isn't problematic
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
acc=totalparams(3,2)*365*365*2;

accerror=100*acc/YearlyAcceleration;
slopeerror=100*slope/InitialSignal; % not a useful error if acc != 0

varns={slopeerror,accerror};
varargout=varns(1:nargout);