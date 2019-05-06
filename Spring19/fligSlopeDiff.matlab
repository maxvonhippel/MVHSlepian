set(0,'defaulttextinterpreter','none');
dom='iceland';
b=1.0;
L=60;
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',0);
thedates=thedates(1:157);
fullS=potcoffs(1:157,:,1:4);
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
fig=figure;
x=thedates;
thefit=totalfit(:,2);
firsty=thefit(1);
y=total-firsty;
% ylow=y-(ones(1,length(thedates))*sqrt(alphavarall)*1.99);
% yhigh=y+(ones(1,length(thedates))*sqrt(alphavarall)*1.99);
% x2=[thedates,fliplr(thedates)];
% y2=[ylow,fliplr(yhigh)];
hold on
eruptionStart=datenum(datetime(2010,3,20));
eruptionEnd=datenum(datetime(2010,6,23));
% fill(x2,y2,grey,'LineStyle','None');
red=[1 0 0];
grey=[0.85 0.85 0.85];
rectangle('Position',[eruptionStart -200 eruptionEnd-eruptionStart 300],...
  'FaceColor',red,'EdgeColor',red);
% plot(x,yhigh,'Color',grey,'LineWidth',1,'LineStyle','-');
% plot(x,ylow,'Color',grey,'LineWidth',1,'LineStyle','-');
text(datenum(datetime(2007,8,0)),-180,{sprintf('Eyjafjallaj%ckull',char(252)),'eruption'},'FontSize',12,'Color','red');

yyaxis left;
theDeltas=zeros(157);
for i=2:156
  slopeLeft=polyfit(thedates(1:i),y(1:i),1);
  slopeRight=polyfit(thedates(i:157),y(i:157),1);
  theDeltas(i)=abs(slopeLeft-slopeRight);
end

plot(thedates,theDeltas,'Color','black');
% GET THEDATES, Y FROM HERE

yl=ylabel('Change in Trend (Gt/yr)');
xl=xlabel('Time');

set(xl,'FontSize',12);
set(yl,'FontSize',12);
set(yyl,'FontSize',12);

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 24 18];
set(gca,'ycolor',[0,0,0]);
box on;
datetick('keeplimits');
hold off

filename='figSLOPEDIFF';
figdisp(filename,[],[],1,'epsc');