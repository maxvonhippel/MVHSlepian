dom='greenland';
Signal=200;
L=60;
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
[~,~,~,~,~,lmcosiS]=geoboxcap(L,dom);
factor1=Signal*10^12;
factor1=factor1/spharea(dom);
deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k)/365;
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  counter=counter+1;
end
results=zeros([1 nmonths]);
for x=1:nmonths
  lmcosi=squeeze(lmcosiSSD(x,:,:));
  [Int,~,~,~]=plm2avg(lmcosi,dom);
  results(x)=Int;
end
x=deltadates/365;
y=results*10^-12;
hold on;
xlabel('years');
ylabel('Gt');
scatter(x,y);
hold off;