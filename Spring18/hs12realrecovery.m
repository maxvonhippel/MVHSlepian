function hs12realrecovery
% 
% Here we plot the contour of recovered trends from real data
% 
% Authored by maxvonhippel-at-email.arizona.edu on 01/15/18

defval('domSignal','greenland');
defval('domRecover','iceland')
defval('Signal',200);
defval('Ls',[20 25 30 35 40 45 50 55 60]);
defval('buffers',[0 0.5 1 1.5 2 2.5 3]);
defval('Ldata',60);

numberTests=numel(Ls)*numel(buffers);

% Get the original data
[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',0);
nmonths=length(thedates);
fullS=fullS(:,:,1:4);

% Recover the signal from the recovery domain
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallCount=1;

for L=Ls
  for B=buffers
    try
      % FIRST: recover domRecover from domSignal
      % ----------------------------------------
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
      [~,~,~,~,~,~,totalparams,~,~,~,~]=...
        slept2resid(slept,thedates,[1 365.0],[],[],CC,TH);
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
% PLOTTING
%%%

% Solution adapted from: https://stackoverflow.com/a/19560522/1586231
% Define the axes
Ls=slopes(:,1);
buffers=slopes(:,2);
recovered=slopes(:,3);
% Ranges of axes
LsRange=min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange=min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% Contour data
[LsRange, buffersRange]=meshgrid(LsRange,buffersRange);
percentRecovered=griddata(Ls,buffers,recovered,LsRange,buffersRange);
% Chart it
contour(LsRange,buffersRange,percentRecovered,5,'ShowText','On');
title('Recovered trend');
xlabel('bandwidth L');
ylabel('buffer extent (degrees)');

%%%
% OUTPUT
%%%

% Save relevant data for use in something like GMT
fp2=fopen(['REAL' domSignal domRecover ...
    datestr(thedates(1),28) datestr(thedates(end),28) '.dat'],'wt');
fprintf(fp2,'L buffer Gt/yr\n');
for row=1:size(slopes,1)
  fprintf(fp2,'%.4f %.4f %.4f\n',slopes(row,:));
end
fclose(fp2);