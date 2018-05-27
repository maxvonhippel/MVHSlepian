x=6:6:162;
ya=zeros(size(x));
ys=zeros(size(x));
counter=1;
for i=x
  [~,ya(counter)]=hs12syntheticacceleration(200,1.0,i,[],[],[],[],[],0);
  [ys(counter),~]=hs12syntheticacceleration(200,0.0,i,[],[],[],[],[],0);
  counter=counter+1;
end

% ---- SLOPE ----

fig=gcf;
ax1=subplot(1,2,1);
hold on;

yl=ylabel('% Recovered');
xl=xlabel('Months');
tl=title('a) Slope Recovery');

% yss=abs(1-ys);
% yas=abs(1-ya);

plot(x,ys,'Color','blue');

set(yl,'FontSize',12);
set(gca,'ycolor',[0,0,0]);
xlim([6 162]);
ylim([95 115]);

box on;
hold off;

% ---- ACCELERATION ----

ax2=subplot(1,2,2);
hold on;

tl=title('b) Acceleration Recovery');
xl=xlabel('Months');

plot(x,ya,'Color','red');

set(gca,'ycolor',[0,0,0]);
xlim([6 162]);
ylim([-400 400]);

box on;
hold off;

p1=get(ax1,'pos');
p2=get(ax2,'pos');
p1(1)=p1(1)+0.03;
p2(1)=p2(1)-0.03;
set(ax1,'pos',p1);
set(ax2,'pos',p2);

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 24 10];

filename='fit_error';
figdisp(filename,[],[],1,'epsc');

% psconvert -A -Tf iceland_total_trend.eps