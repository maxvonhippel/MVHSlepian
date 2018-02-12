function varargout=hs12syntheticrecovery(domSignal,domRecover,wantnoise,...
  Signal,Ls,buffers,Ldata,filename)
% Example: 
% [slopes]=hs12syntheticrecovery('iceland','iceland',1,[],[],[],[],'II')
% 
% Here we plot the contour of recovered trends from synthetic experiments
% 
% Authored by maxvonhippel-at-email.arizona.edu on 01/11/18
% Last modified by maxvonhippel-at-email.arizona.edu on 02/11/18

defval('filename','II');
defval('domSignal','greenland');
defval('wantnoise',1);
if wantnoise
  filename=sprintf('%s_WITH_NOISE', filename);
end
defval('domRecover','greenland')
defval('Signal',200);
defval('Ls',[20 25 30 35 40 45 50 55 60]);
defval('buffers',[0 0.5 1 1.5 2 2.5 3]);
defval('Ldata',60);

numberTests=numel(Ls)*numel(buffers);

% Get the original data
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
% Get the fitted results
[ESTresid,~,~,~,~,~]=plmt2resid(potcoffs(:,:,1:4),thedates,[1 1 181.0 365.0]);
[Clmlmp,~,~,~,~]=plmresid2cov(ESTresid,Ldata,[]);
[~,~,~,lmcosidata,~,~,~,~,~,ronmdata]=addmon(Ldata);
% Decompose the covariance matrix
T=cholcov(Clmlmp);
[n,m]=size(T);
if isempty(T)
  disp('Empty covariance matrix, something is wrong.');
  return
end

% Apply a unit signal over the domain
% Oversample so that lmcosiS isn't all 0
[~,~,~,~,~,lmcosiS]=geoboxcap(2*Ldata,domSignal);
% Then truncate
if size(lmcosiS,1) > addmup(Ldata)
  lmcosiS=lmcosiS(1:addmup(Ldata),:);
end

% * 10^12 converts Gt / unit sphere to kg / unit sphere / day
% / [spharea(domSignal) * 4 * pi * 6370000^2] divides by area in m^2 of the
% domain domSignal, putting us into units of kg / m^2 / day
% Then / 365 converts to units of kg / m^2 / yr
factor1=Signal*10^12/spharea(domSignal)/4/pi/6370000^2/365;
deltadates=thedates-thedates(1);
lmcosiSSD=zeros([nmonths,size(lmcosiS)]);
counter=1;
for k=deltadates
  factor2=(factor1*k);
  lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
  if wantnoise
    % Make a synthetic noise realization
    syntheticnoise=randn(1,n)*T;
    % Reorder the noise
    temp1=lmcosidata(:,3:4);
    temp1(ronmdata)=syntheticnoise(:);
    syntheticnoise=[lmcosidata(:,1:2) temp1];
    fullS(counter,:,:)=[lmcosidata(:,1:2)...
       squeeze(lmcosiSSD(counter,:,3:4))+syntheticnoise(:,3:4)];
  end
  counter=counter+1;
end
if ~wantnoise
  fullS=lmcosiSSD;
end

% Recover the signal from the recovery domain
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallCount=1;

for L=Ls
  for B=buffers
    try
      TH={domRecover B};
      % We want the G from glmalpha, but we also want the eigenfunctions,
      % so use grace2slept to load both
      [slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',domRecover,B,L,...
      	[],[],[],[],'SD',1);
      [~,~,~,lmcosipad,~,~,~,~,~,ronm]=addmon(L);
      slept=zeros(nmonths,(L+1)^2);
      for k=1:nmonths
      	lmcosi=squeeze(fullS(k,:,:));
        % Truncation happens here, hence why oversampling isn't problematic
        if size(lmcosi,1) < addmup(L)
        	lmcosi=[lmcosi; lmcosipad(size(lmcosi,1)+1:end,:)];
        else
          lmcosi=lmcosi(1:addmup(L),:);
        end
      	slept(k,:)=G'*lmcosi(2*size(lmcosi,1)+ronm(1:(L+1)^2));
      end
      % Estimate the total mass change
      [~,~,~,~,~,~,totalparams,~,~,~,~]=...
        slept2resid(slept,thedates,[1 181.0 365.0],[],[],CC,TH);
      % Index allslopes by L and B
      format long g;
      result=[L B totalparams(2)*365];
    catch
      result=[L B 0];
    end
    slopes(overallCount,:)=result;
    overallCount=overallCount+1;
    % Print message indicating progress in script for user
    sprintf('Completed %d out of %d many tests.',overallCount,numberTests)
    sprintf('Test completed: L=%.1d, B=%.1d',L,B)
  end
end

%%%
% OUTPUT
%%%

% Save relevant data for use in something like GMT
% fp2=fopen([domSignal domRecover ...
    % datestr(thedates(1),28) datestr(thedates(end),28) '.dat'],'wt');
fp2=fopen(sprintf('%s.dat', filename),'wt');
fprintf(fp2,'L buffer Gt/yr\n');
for row=1:size(slopes,1)
  fprintf(fp2,'%.4f %.4f %.4f\n',slopes(row,:));
end
fclose(fp2);

%%%
% PLOTTING
%%%

% Solution adapted from: https://stackoverflow.com/a/19560522/1586231
% Define the axes
Ls=slopes(:,1);
buffers=slopes(:,2);
% Divide by total unit signal applied to get fraction,
% then multiply by 100 to get percent.
recovered=slopes(:,3)*100/Signal;
% Ranges of axes
LsRange=min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange=min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% Contour data
[LsRange, buffersRange]=meshgrid(LsRange,buffersRange);
percentRecovered=griddata(Ls,buffers,recovered,LsRange,buffersRange);
% Chart it
hold on;
labeled=linspace(0,200,21);
alllines=linspace(0,200,41);
unlabeled=setdiff(alllines,labeled);
contour(LsRange,buffersRange,percentRecovered,unlabeled,'ShowText','Off',...
   'LineColor','Black','LineWidth',1);
labeled=setdiff(labeled,[100]);
contour(LsRange,buffersRange,percentRecovered,labeled,'ShowText','On',...
   'LineColor','Black','LineWidth',1);
contour(LsRange,buffersRange,percentRecovered,[100,100],'ShowText','On',...
   'LineColor','Green','LineWidth',2);
title('Synthetic recovered trend');
xlabel('bandwidth L');
ylabel('buffer extent (degrees)');
box on;
hold off;

varns={slopes};
varargout=varns(1:nargout);