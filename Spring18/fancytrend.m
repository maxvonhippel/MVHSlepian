set(0,'defaulttextinterpreter','none');
dom='iceland';
b=1.0;
L=60;
% GIAmodel='Paulson07';
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',0);
% pre volcano:
% thedates=thedates(1:93);
% fullS=potcoffs(1:93,:,1:4);
% post volcano:
% thedates=thedates(96:157);
% fullS=potcoffs(96:157,:,1:4);
% all:
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
% [~,GIAt,~,~,trendg]=correct4gia(thedates,GIAmodel,TH,L);
% slept=slept-GIAt;
% Estimate the total mass changes
[~,~,~,~,total,alphavarall,totalparams,totalparamerrors,totalfit,~,~]=...
  slept2resid(slept,thedates,[3 182.625 365.25],[],[],CC(1:round(N)),TH);
% Slope: -9.6797 +- 0.9681 Gt/yr
% Acceleration: 1.0665 +- 0.5040 Gt/yr^2

fig=figure;
x=thedates;
thefit=totalfit(:,2);
firsty=thefit(1);
y=total-firsty;
ylow=y-(ones(1,length(thedates))*sqrt(alphavarall)*1.99);
yhigh=y+(ones(1,length(thedates))*sqrt(alphavarall)*1.99);
x2=[thedates,fliplr(thedates)];
y2=[ylow,fliplr(yhigh)];
hold on
% Do ylim from -200 to 100 Gt
ylim([-200 100]);
eruptionStart=datenum(datetime(2010,3,20));
eruptionEnd=datenum(datetime(2010,6,23));
fill(x2,y2,grey,'LineStyle','None');
red=[1 0 0];
grey=[0.85 0.85 0.85];
rectangle('Position',[eruptionStart -200 eruptionEnd-eruptionStart 300],...
  'FaceColor',red,'EdgeColor',red);
plot(x,yhigh,'Color',grey,'LineWidth',1,'LineStyle','-');
plot(x,ylow,'Color',grey,'LineWidth',1,'LineStyle','-');
text(datenum(datetime(2007,8,0)),-180,{sprintf('Eyjafjallaj%ckull',char(252)),'eruption'},'FontSize',12,'Color','red');

yyaxis left;

plot(thedates,y,'Color','black','LineWidth',1,'LineStyle','-');
% GET THEDATES, Y FROM HERE
yfit=totalfit(:,2)-firsty;
plot(thedates,yfit,'Color','blue','LineWidth',1,'LineStyle','-');
% Add reference line for 2010 volcanic erruption
yl=ylabel('Mass (Gt)');
xl=xlabel('Time');
% tl=title({'Integrated Mass Change for Iceland ',...
%   'L = 60, buffer = 1.0^{\\circ} (01/2002 - 11/2016)'},...
%  'interpreter','latex');

slope=totalparams(2,2)*365;
slopeerror=totalparamerrors(2,2);
acc=totalparams(3,2)*365*365*2;
accerror=totalparamerrors(3,2)*365*2;

labelstr={sprintf('Slope = %.1f %c %.1f Gt/yr',slope,char(hex2dec('B1')),slopeerror),...
	sprintf('Acceleration = %.1f %c %.1f Gt/yr%c',acc,char(hex2dec('B1')),accerror,char(hex2dec('B2')))};
text(datenum(datetime(2011,0,0)),5,labelstr,'FontSize',12);

leftlim=ylim;
yyaxis right;
yyl=ylabel('Eustatic Sea Level (mm)');
ylim(leftlim*0.00278);

set(xl,'FontSize',12);
set(yl,'FontSize',12);
set(yyl,'FontSize',12);

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 24 18];
set(gca,'ycolor',[0,0,0]);
box on;
datetick('keeplimits');
hold off

filename='fig02';
figdisp(filename,[],[],1,'epsc');

% psconvert -A -Tf iceland_total_trend.eps