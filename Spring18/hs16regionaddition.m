function hs16regionaddition
% 
% Here we compare the sums of individual Ice Mass Trend Estimates for some
% regions to the Ice Mass Trend Estimate for the union of those regions.
% NOTE: We assume that the regions do NOT overlap/intersect.
% 
% Authored by maxvonhippel-at-email.arizona.edu on 01/20/18

defval('regionA','iceland');
defval('regionB','greenland');
defval('L',60);
defval('b',0.5);
defval('res',10);

[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',0);
fullS=fullS(:,:,1:4);
nmonths=length(thedates);

[slepcoffsA,~,~,THA,GA,CCA,~,~]=grace2slept('CSRRL05',regionA,...
  b,L,[],[],[],[],'SD',1);
[slepcoffsB,~,~,THB,GB,CCB,~,~]=grace2slept('CSRRL05',regionB,...
  b,L,[],[],[],[],'SD',1);

[~,~,~,lmcosipad,~,~,~,~,~,ronm]=addmon(L);
sleptA=zeros(nmonths,(L+1)^2);
sleptB=zeros(nmonths,(L+1)^2);
for k=1:nmonths
  lmcosi=squeeze(fullS(k,:,:));
  if size(lmcosi,1) < addmup(L)
    lmcosi=[lmcosi; lmcosipad(size(lmcosi,1)+1:end,:)];
  else
    lmcosi=lmcosi(1:addmup(L),:);
  end
  sleptA(k,:)=GA'*lmcosi(2*size(lmcosi,1)+ronm(1:(L+1)^2));
  sleptB(k,:)=GB'*lmcosi(2*size(lmcosi,1)+ronm(1:(L+1)^2));
end
% Estimate the total mass change
[~,~,~,~,~,~,totalparamsA,~,~,~,~]=slept2resid(sleptA,thedates,[1 365.0],...
  [],[],CCA,THA);
[~,~,~,~,~,~,totalparamsB,~,~,~,~]=slept2resid(sleptB,thedates,[1 365.0],...
  [],[],CCB,THB);
regionAtrend=totalparamsA(2)*365;
regionBtrend=totalparamsB(2)*365;
disp(sprintf('%s: %d Gt/yr\n%s: %d Gt/yr\nSum of trends: %d Gt/yr',...
  regionA,regionAtrend,regionB,regionBtrend,regionAtrend+regionBtrend));