dom='iceland';
b=1.0;
L=60;
GIAmodel='Paulson07';
% Wangetal08
% GIAmodel='Wangetal08';
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
[~,GIAt,~,~,trendg]=correct4gia(thedates,GIAmodel,TH,L);
slept=slept-GIAt;
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
fill(x2,y2,[0.85 0.85 0.85],'LineStyle','None');
yyaxis left;
% Do ylim from -200 to 100 Gt
ylim([-200 100]);
plot(thedates,y,'Color','black','LineWidth',1.5,'LineStyle','-');
yfit=totalfit(:,2)-firsty;
plot(thedates,yfit,'Color','blue','LineWidth',1.5,'LineStyle','-');
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

labelstr={sprintf('Slope = %.1f $\\pm$ %.1f Gt/yr',slope,slopeerror),...
	sprintf('Acceleration = %.1f $\\pm$ %.1f Gt/yr$^2$',acc,accerror)};
text(thedates(95),70,labelstr,'Interpreter','latex','FontSize',13,...
  'FontName','Times');

leftlim=ylim;
yyaxis right;
yyl=ylabel('Eustatic Sea Level (mm)');
ylim(leftlim*0.00278);
% line([thedates(93),thedates(93)],ylim,'Color','red');
eruptionStart=datenum(datetime(2010,3,20));
% eruptionEnd=datenum(datetime(2010,6,23));
line([eruptionStart,eruptionStart],ylim,'Color','red');
% line([eruptionEnd,eruptionEnd],ylim,'Color','red');
fill(xEruption,yEruption,'red');
set(xl,'FontSize',13,'FontName','Times');
set(yl,'FontSize',13,'FontName','Times');
set(yyl,'FontSize',13,'FontName','Times');

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 20 20];
set(gca,'ycolor',[0,0,0]);
box on;
hold off

filename='iceland_total_trend';
figdisp(filename,[],[],1,'epsc');

% psconvert -A -Tf iceland_total_trend.eps