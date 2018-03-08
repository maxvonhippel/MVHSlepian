x=thedates;
y=total;
ylow=total-(ones(1,length(thedates))*sqrt(alphavarall)*1.99);
yhigh=total+(ones(1,length(thedates))*sqrt(alphavarall)*1.99);
x2=[thedates,fliplr(thedates)];
y2=[ylow,fliplr(yhigh)];
hold on
fill(x2,y2,[0.85 0.85 0.85],'LineStyle','None');
plot(thedates,y,'Color','black');
plot(thedates,totalfit(:,2),'-b');
datetick('x');
tl=title(['Integrated Mass Change for Iceland, L = 60, buffer = 1.0 deg']);
yl=ylabel('Mass (Gt)');
xl=xlabel('Date')
hold off
% At this point I manually wrote a Latex textbox with slope and
% acceleration, and I manually edited the title in Latex
set(tl,'FontSize',10);
set(xl,'FontSize',10);
set(yl,'FontSize',10);

fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 20 20];