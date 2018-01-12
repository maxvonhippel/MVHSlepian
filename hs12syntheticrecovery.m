function hs12syntheticrecovery
% 
% Here we plot the contour of recovered trends from synthetic experiments
% 
% Authored by maxvonhippel at email.arizona.edu on 01/11/18

defval('domSignal','greenland');
defval('domRecover',domSignal)
defval('Signal',200);
defval('Ls',[20 25 30 35 40 45 50 55 60]);
defval('buffers',[0 0.5 1 1.5 2 2.5 3]);
defval('Ldata',60);

% Apply a unit signal over the domain
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
[~,~,~,~,~,lmcosiS]=geoboxcap(Ldata,domSignal);
factor1=Signal*10^12/spharea(domSignal)/4/pi/6370000^2/365;
deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k);
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  counter=counter+1;
end

% Recover the signal from the recovery domain
fullS=lmcosiSSD;
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallcount=1;

for L=Ls
  for B=buffers
    TH={domRecover B};
    % We want the G from glmalpha, but we also want the eigenfunctions,
    % so use grace2slept to load both
    [slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',domRecover,B,L,...
    										[],[],[],[],'SD',1);
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

%%%
% PLOTTING
%%%

% solution adapted from: https://stackoverflow.com/a/19560522/1586231
% define the axes
Ls=slopes(:,1);
buffers=slopes(:,2);
% divide by 200 (total unit signal applied) to get fraction
% then multiply by 100 to get percent
% hence * 1/2
recovered=slopes(:,3)/2;
% round to 2 digits for nice labels
recovered=round(recovered, 2);
% ranges of axes
LsRange=min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange=min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% contour data
[LsRange, buffersRange]=meshgrid(LsRange, buffersRange);
percentRecovered=griddata(Ls, buffers, recovered, LsRange, buffersRange);
% chart it
contour(LsRange, buffersRange, percentRecovered, 5, 'ShowText', 'On');
title('Synthetic recovered trend');
xlabel('bandwidth L');
ylabel('buffer extent (degrees)');

%%%
% OUTPUT
%%%

% Save relevant data for use in something like GMT

fp2=fopen(['figures/figdata/RecoveredSyntheticTrend' domSignal domRecover ...
    datestr(thedates(1),28) datestr(thedates(end),28) '.dat'],'wt');
fprintf(fp2,'L buffer recovered(Gt)\n',row);
for row=1:size(slopes,1)
	fprintf(fp2,'%.4f %.4f %.4f\n',row);
end
fclose(fp2);