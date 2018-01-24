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
      [~,~,~,~,~,~,totalparams,~,~,~,~]=...
        slept2resid(slept,thedates,[1 365.0],[],[],CC,TH);
[thedates,GIAt,GIAtU,GIAtL,trend]=correct4gia(thedates,'Paulson07',{'greenland' B},L,[],[],[]);
trend
B
[thedates,GIAt,GIAtU,GIAtL,trend]=correct4gia(thedates,'Paulson07',{'greenland' B});
trend
thedates
size(thedates)
datestr(thedates(163))
datestr(thedates(140))
datestr(thedates(150))
[thedates,GIAt,CIAtU,GIAtL,trend]=correct4gia(thedates(1:150),'Paulson07',{'greenland' 0.5});
trend
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',1);
defval('domSignal','greenland');
defval('domRecover','greenland')
defval('Ls',[20 25 30 35 40 45 50 55 60]);
defval('buffers',[0 0.5 1 1.5 2 2.5 3]);
defval('Ldata',60);
numberTests=numel(Ls)*numel(buffers);
% Get the original data
[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
fullS=fullS(:,:,1:4);
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallCount=1;
L=60;
B=0.5;
[slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',domRecover,B,L,...
        [],[],[],[],'SD',1);
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
size(thedates)
[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',1);
datestr(thedates(163))
[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',1);
datestr(thedates(157))
[thedates,GIAt,CIAtU,GIAtL,trend]=correct4gia(thedates(1:150),'Paulson07',{'greenland' 0.5});
trend
size(GIAt)
size(slept)
[slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05','greenland',0.5,60,[],[],[],[],'SD',1);
[~,~,~,~,~,~,totalparams,~,~,~,~]=slept2resid(GIAt,thedates,[1 365.0],[],[],CC,TH);
totalparams(2)*365
[thedates,GIAt,GIAtU,GIAtL,trend]=correct4gia(thedates,'Paulson07',{
[thedates,GIAt,GIAtU,GIAtL,trend]=correct4gia(thedates,'Paulson07',{'greenland' 0.5},60);
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,totalparamerrors,totalfit,functionintegrals,alphavar]=slept2resid(GIAt,thedates,[1 365.0],[],[],CC,'greenland',[]);
size(total)
size(thedates)
plot(thedates,total)
plot((thedates-thedates(1))/365,total)
size(slept)
[~,~,~,~,totalREAL]=slept2resid(slept,thedates,[1 365.0],[],[],CC,'greenland',[]);
size(thedates)
size(slept)
[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
fullS=fullS(:,:,1:4);
size(thedates)
datestr(thedates(157))
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallCount=1;
B=0.5;L=60;
[slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',domRecover,B,L,...
        [],[],[],[],'SD',1);
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
[~,~,~,~,total2,~,totalparams,~,~,~,~]=...
        slept2resid(slept,thedates,[1 365.0],[],[],CC,TH);
hold on
plot((thedates-thedates(1))/365,total);
size(thedates)
size(total)
size(total2)
plot((thedates-thedates(1))/365,total2);
hold off
title('Debugging GIA Correction for Greenland')
xlabel(sprintf('Time in years since %s',datestr(thedates(1))))
ylabel('Gt of change (total from slept2resid)')
prefdir
ls /home/maxvonhippel/.matlab/R2017a/
exit
