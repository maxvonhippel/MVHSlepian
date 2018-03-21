dom='iceland';
b=1.0;
L=60;
[potcoffs,cal_errors,thedates]=grace2plmt('CSR','RL05','SD',0);
thedates=thedates(1:157);
fullS=potcoffs(1:157,:,1:4);
nmonths=length(thedates);
L=60;
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
[~,GIAt,~,~,~]=correct4gia(thedates,'Paulson07',TH,L);
slept=slept-GIAt;
% Estimate the total mass changes
[~,~,~,~,total,alphavarall,totalparams,totalparamerrors,totalfit,~,~]=...
  slept2resid(slept,thedates,[2 365.0],[],[],CC(1:round(N)),TH);
% Slope: -9.6797 +- 0.9681 Gt/yr
% Acceleration: 1.0665 +- 0.5040 Gt/yr^2

fig=figure;
box on;
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
plot(thedates,y,'Color','black');
plot(thedates,totalfit(:,2)-firsty,'-b');
datetick('x');
yl=ylabel('Mass (Gt)');
xl=xlabel('Time');

slope=totalparams(2,2)*365;
slopeerror=totalparamerrors(2,2);
acc=totalparams(3,2)*365*365*2;
accerror=totalparamerrors(3,2)*365*2;

labelstr={sprintf('Slope = %.4f $\\pm$ %.4f Gt/yr',slope,slopeerror),...
	sprintf('Acceleration = %.4f $\\pm$ %.4f Gt/yr$^2$',acc,accerror)};
text(thedates(80),90,labelstr,'Interpreter','latex');

leftlim=ylim;
yyaxis right;
yyl=ylabel('Eustatic Sea Level (mm)');
ylim(leftlim*0.00278);
set(tl,'FontSize',10);
set(xl,'FontSize',10);
set(yl,'FontSize',10);

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 20 20];
set(gca,'ycolor',[0,0,0]); 
hold off

filename='iceland_total_trend';
figdisp(filename,[],[],1,'epsc');

% psconvert -A -Tf iceland_total_trend.eps