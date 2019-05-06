[~,~,thedates]=grace2plmt('CSR','RL05','SD',0);
thedates=thedates(1:157);
% data=zeros(157,4);
% dates=cell(157-6-5,1);
i=0;
maxk=0;
maxdiff=0;
for k=77:114
  i=i+1;
  [slopeB,slopeerrorB,accB,accerrorB]=eruptionMatters(k-25,k);
  [slopeB,slopeerrorB,accB,accerrorB]=eruptionMatters(k-12,k);
  [slopeA,slopeerrorA,accA,accerrorA]=eruptionMatters(k+1,k+25);
  % data(k,:)=[slopeB,slopeerrorB,slopeA,slopeerrorA];
  % dates{i}=datestr(thedates(k));
  diffd=abs(slopeB-slopeA);
  if diffd>maxdiff
  	maxdiff=diffd;
    maxk=k;
  end
  disp(i)
end
% csvwrite('trends.csv',data);
% csvwrite('trendsDates.csv',dates);


[~,~,thedates]=grace2plmt('CSR','RL05','SD',0);
thedates=thedates(1:157);
yearSlopes=zeros(116-75);
i=1;
maxk=0;
maxdiff=0;
for k=75:116
  [trendit,~,~,~]=eruptionMatters(k-12,k);
  yearSlopes(i)=trendit;
  i=i+1;
end
besttotal=0;
besttotalk=0;
for j=12:116-75
  left=0.5*(yearSlopes(j-2)+yearSlopes(j-1));
  right=0.5*(yearSlopes(j)+yearSlopes(j+1));
  lrdiff=abs(left-right);
  if lrdiff>besttotal
  	besttotal=lrdiff;
  	besttotalk=j+75;
  end
end
