x=10:20:500;
ya=zeros(25,1);
ys=zeros(25,1);
counter=1;
for i=10:20:500
  [~,ya(counter)]=hs12syntheticacceleration(200,1.0,i);
  [ys(counter),~]=hs12syntheticacceleration(200,0.0,i);
  counter=counter+1;
end

% ---- SLOPE ----

num=8;
fig=figure;
hold on;

yl=ylabel('% Error');
xl=xlabel('Years');
tl=title('Slope Recovery');

yss=abs(1-ys);
yas=abs(1-ya);

x=x(1:num)/12;
plot(x,yss(1:num),'Color','blue','LineWidth',1,'LineStyle','-');

set(xl,'FontSize',12);
set(yl,'FontSize',12);

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 24 24];
set(gca,'ycolor',[0,0,0]);
hold off;

filename='slope_error';
figdisp(filename,[],[],1,'epsc');

% ---- ACCELERATION ----

fig2=figure;
hold on;

yl=ylabel('% Error');
xl=xlabel('Years');
tl=title('Acceleration Recovery');

plot(x,yas(1:num),'Color','red','LineWidth',1,'LineStyle','-');

set(xl,'FontSize',12);
set(yl,'FontSize',12);

fig.PaperUnits='centimeters';
fig.PaperPosition=[0 0 24 24];
set(gca,'ycolor',[0,0,0]);
ylim([0 100]);
hold off;

filename='acceleration_error';
figdisp(filename,[],[],1,'epsc');

% psconvert -A -Tf iceland_total_trend.eps