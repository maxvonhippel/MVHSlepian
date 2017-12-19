dom='greenland';
Signal=200;
Ls=[60];
buffers=[0];
Ldata=60;
% Make signal
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
[~,~,~,~,~,lmcosiS]=geoboxcap(Ldata,dom);
factor1=Signal*10^12/spharea(dom)/4/pi/6370000^2/365;
deltadates=thedates-thedates(1);
fullS=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k);
  fullS(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  counter=counter+1;
end
L=Ls(1);
B=buffers(1);
% Recover signal
TH={dom B};
% We want the G from glmalpha, but we also want the eigenfunctions,
% so use grace2slept to load both
[slepcoffs,~,~,TH,G,CC,~,N]=grace2slept('CSRRL05',dom,B,L,[],[],[],[],'SD',1);
N=round(N);
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

% Compare answers:
format long g;

% Answer 1 from slept2resid (just the relevant code)
eigfunINT=zeros(1,N);
for h=1:N
  [Int,A]=plm2avg(CC{h},dom);
  eigfunINT(h)=Int;
end
eigfunINT=eigfunINT*4*pi*6370000^2/10^12;
total=eigfunINT*slept(:,1:N)';
disp('answer 1 from slept2resid: ')
Answer1=total(11)-total(1)

% Answer 2 from plm2avg
% 
result=zeros(1891,2);
for h=1:N
  result=result+(CC{h}(:,3:4)*slept(11,h));
end
[Int,A]=plm2avg([lmcosipad(:,1:2) result],dom);
Int=Int*4*pi*6370000^2/10^12;
disp('answer 2 from plm2avg: ')
Answer2=Int

disp('difference in answers: ')
Answer1-Answer2