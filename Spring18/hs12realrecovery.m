function varargout=hs12realrecovery(domSignal,domRecover,...
  forcenew,Ls,buffers,Ldata,filename,bDivide,LDivide,GIAmodel)
% Example:
% [slopes]=hs12realrecovery('greenland','greenland',1,[],[],[],'GG',0,0);
% 
% Here we plot the contour of recovered trends from real data
% 
% Authored by maxvonhippel-at-email.arizona.edu on 01/15/18
% Last modified by maxvonhippel-at-email.arizona.edu on 02/15/18

defval('domSignal','greenland');
defval('domRecover','greenland');
defval('forcenew',1);
defval('Ls',[20 25 30 35 40 45 50 55 60]);
defval('buffers',[0 0.5 1 1.5 2 2.5 3]);
defval('Ldata',60);
defval('filename','GG');
numberTests=numel(Ls)*numel(buffers);

% Get the original data
[fullS,~,thedates]=grace2plmt('CSR','RL05','SD',forcenew);
nmonths=length(thedates);
fullS=fullS(:,:,1:4);

% Recover the signal from the recovery domain
slopes=zeros([(length(Ls)*length(buffers)) 3]);
overallCount=1;

divideBy=1;
% Note that by def-val'ing these to 0, we establish that they won't get
% accidentally picked up, because a L of 0 would be silly and worthless
% to include in Ls.  This way we get a contour of the Gt/yr recovered if no
% bDivide and LDivide params are provided, whereas we get a percent recovered
% if a bDivide and LDivide are recovered.
defval('bDivide',0);
defval('LDivide',0);

defval('GIAmodel','Paulson07');

for L=Ls
  for B=buffers
    try
      % FIRST: recover domRecover from domSignal
      % ----------------------------------------
      % We want the G from glmalpha, but we also want the eigenfunctions,
      % so use grace2slept to load both
      [slepcoffs,~,~,TH,G,CC,~,~]=grace2slept('CSRRL05',domRecover,B,L,...
        [],[],[],[],'SD',forcenew);
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
      % Do GIA correction, since CSR GRACE data doesn't do it by default
      % Note that JPL data does, so if you are using JPL data then you
      % need to comment this out.
      [~,GIAt,~,~,giaMagnitude]=correct4gia(thedates,GIAmodel,TH,L);
      slept=slept-GIAt;
      % Estimate the total mass change
      [~,~,~,~,~,~,totalparams,~,~,~,~]=...
        slept2resid(slept,thedates,[1 365.0],[],[],CC,TH);
      % Index allslopes by L and B
      format long g;
      result=[L B totalparams(2)*365];
    catch
      result=[L B 0];
    end
    % If we want to divide by a specific result for a percent contour
    % graph, get that result now
    if L==LDivide && B==bDivide
      divideBy=result(3);
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
% Note that if divideBy returns 0 this will error.  But that's great!  Because
% if divideBy is 0 then you made a terrible choice of 100% (L, b) tuple, so
% the error will lead you to read this comment in the code and re-evaluate
% the synthetic experiments you ran to choose that (L, b) tuple.

% This is unnecessary if you use the fancycontour.m routine (in which case
% you should skip straight to the .dat output creation)

Ls=slopes(:,1)/divideBy;
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
fp2=fopen([filename '.dat'],'wt');
fprintf(fp2,'L buffer Gt/yr\n');
for row=1:size(slopes,1)
  fprintf(fp2,'%.4f %.4f %.4f\n',slopes(row,:));
end
fclose(fp2);

varns={slopes};
varargout=varns(1:nargout);