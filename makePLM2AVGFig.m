dom='greenland';
Signal=200;
Ls=[60];
buffers=[0.5];
Ldata=60;
% Make signal
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
[~,~,~,~,~,lmcosiS]=geoboxcap(Ldata,dom);
factor1=Signal*10^12/spharea(dom)/4/pi/6370000^2/365;
deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k);
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  counter=counter+1;
end
fullS=lmcosiSSD;
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallcount=1;
for L=Ls
  for B=buffers
    % Recover signal
    TH={dom B};
    % We want the G from glmalpha, but we also want the eigenfunctions,
    % so use grace2slept to load both
    [slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',dom,B,L,[],[],[],[],'SD',1);

    % ------------ experiment in plm2avg -------------------
    keyboard
    

    % keyboard, send CC to eigfunINT, compare 0.5 to 0 degree buffer results
    % 0.5 deg ones should be ~10% larger for CC{1}
    % compare CC{1} with plotplm to CC{1} from other buffer (0.5 vs 0)
    % 1 possibility is it's tiny, 2 

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
    % Estimate the total mass change
    [ESTsignal,ESTresid,tests,extravalues,total,alphavarall,...
     totalparams,totalparamerrors,totalfit,functionintegrals,...
     alphavar]=slept2resid(slept,thedates,[1 365.0],[],[],CC,TH);
    % Index allslopes by L and B
    format long g;
    result=[L B totalparams(2)*365];
    slopes(overallcount,:)=result;
    overallcount=overallcount+1;
  end
end

% slopes =

%                         45                         0          164.241764286433
%                         45                       0.5           9.7589000826311
%                         45                         1           20.063257124219
%                         50                         0          164.020750768261
%                         50                       0.5          7.13458714018997
%                         50                         1          17.2629745475065
%                         55                         0          172.058937882016
%                         55                       0.5          4.32042902322509
%                         55                         1          18.8023427582291
%                         60                         0          178.130334722536
%                         60                       0.5          4.38841535376908
%                         60                         1          17.0645164456699


% figure stuff with plm 2 avg
% results=zeros([1 nmonths]);
% for x=1:nmonths
%   lmcosi=squeeze(lmcosiSSD(x,:,:));
%   [Int,~,~,~]=plm2avg(lmcosi,dom);
%   results(x)=Int*surfaceAreaDom;
% end
% x=deltadates/365;
% y=results*10^-12;
% hold on;
% xlabel('years');
% ylabel('Gt');
% scatter(x,y);
% hold off;