# Mathematics Notes

## Noise

````
% Step 1
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
% Step 2
[ESTresid,~,~,~,~,~]=plmt2resid(potcoffs(:,:,1:4),thedates,[]);
% Step 3
[Clmlmp,~,~,~,~]=plmresid2cov(ESTresid,Ldata,[]);
% Step 4
T=cholcov(Clmlmp);
% Step 5
syntheticnoise=randn(1,n)*T;
% Then add the noise
temp1=zeros(size(lmcosiS,1),2);
temp1(ronmdata)=syntheticnoise(:);		
syntheticnoise=[lmcosidata(:,1:2) temp1];
fullS(counter,:,:)=[lmcosidata(:,1:2)...
	squeeze(lmcosiSSD(counter,:,3:4))+...
	syntheticnoise(:,3:4)];
````