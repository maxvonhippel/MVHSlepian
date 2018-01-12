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


% L     B     recovered            percent      expected
% ______________________________________________________
% 50    0     170.948370045596     85.47%       ~ 86 ish
% 50    0.5   190.339992955744     95.17%       ~ 95 ish
% 55    0     172.957943872825     86.48%       ~ 88 ish
% 55    0.5   194.831637127521     97.42%       ~ 96 ish
% 60    0     177.973770329032     88.99%       ~ 92 ish
% 60    0.5   197.527703564053     98.76%       ~ 99 ish


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