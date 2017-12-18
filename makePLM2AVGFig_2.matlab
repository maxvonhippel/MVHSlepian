% Make a signal for 200 Gt, its in Spherical Harmonics (SH), and use
% use plm2avg on Jan 2004 and got basically 200 back.
% -----------------------------------------------------
% First: Make the signal
dom='greenland';
Signal=200;
L=60;
B=0;
Ldata=60;
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
[~,~,~,~,~,lmcosiS]=geoboxcap(Ldata,dom);
factor1=Signal*10^12/spharea(dom)/4/pi/6370000^2/365;
deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k);
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  counter=counter+1;
end
fullS=lmcosiSSD;
% Second: Get slepcoffs
TH={dom B};
[slepcoffs,~,~,TH,G,CC,V,N]=grace2slept('CSRRL05',dom,B,L,[],[],[],[],'SD',1);
% Third: Pull out january 2004 (exactly 1 year of data)
jan2004=slepcoffs(19,:);
% Loop over N functions
for n=1:N
	% Multiply each slepcoff by its corresponding eigenvector.
	CCN=CC{n};
	slepcoffs(n)=slepcoffs(n)*CCN(:,3:4);
end
% Add those vectors together

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

