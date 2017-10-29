function varargout=SyntheticCaseA(Clmlmp,thedates,Ls,buffers,truncations,dom)
% [allslopes]=SYNTHETICCASEA(Clmlmp,thedates,Ls,buffers,truncations)
%
% This function runs a synthetic experiment to recover a mass loss trend in
% the presence of noise, estimated from GRACE data, for a variety of 
% bases, buffer regions, and
% truncation levels.  The Case A experiment is for a uniform mass change
% over the region.
%
% INPUT:
%
% Clmlmp     The estimated noise covariance matrix that you estimated from
%             the GRACE data.  If this has changed, such as when you add
%             new months, then you will want to force a new calculation.
% thedates   An array of dates corresponding to the slept timeseries.  These
%             should be in Matlab's date format. (see DATENUM)
% Ls         The bandwidths of the bases that we are looking at, 
%             e.g. [10 20 30]
% buffers    Distances in degrees that the region outline will be enlarged
%             by BUFFERM [default: [0 1 2]]
% truncations  The number of functions that we want to vary away from the
%                Shannon number, e.g. [-2 -1 0 1 2].  The Shannon number
%                will be added to this array to end up with something like 
%                [N-2 N-1 N N+1 N+2]
% dom       The region. 
% 
% OUTPUT:
%
% allslopes
%
% SEE ALSO: SYNTHETICEXPERIMENTS
%
% Modified by charig-at-princeton.edu on 6/22/2012
% Last modified by maxvonhippel-at-email.arizon.edu on 10/28/2017

%%%
% INITIALIZE
%%%

disp('Initializing values for Synthetic Case A');   % <--   

defval('xver',1);
defval('dom','iceland');
defval('Ldata',60);
defval('Signal',200); % Gt/yr
defval('wantnoise',0);
defval('Ls',[45 50 55]);
defval('buffers',[0 1 2]);
defval('nmonths',length(thedates));
defval('truncations',[-2 -1 0 1 2]);

% Decompose the covariance matrix
disp('Decomposing the covariance...');
T=cholcov(Clmlmp);
[n,m]=size(T);

% Check if this is right
if xver
    % Generate a lot of data that averages to the correct covariance 
    % (aside from random variation).
    SYNClmlmp=cov(randn(10000,n)*T);
    Clmlmp(1:10,1:10);
    SYNClmlmp(1:10,1:10);
end

disp('Finding bandlimit data info over region');   % <-- 

% Get info for the data bandlimit
[~,~,~,lmcosidata,~,~,~,~,~,ronmdata]=addmon(Ldata);
% Make a synthetic unit signal over the region
[~,~,~,~,~,lmcosiS]=geoboxcap(Ldata,dom,[],[],1);
% Convert desired Gt/yr to kg
factor1=Signal*907.1847*10^9;
% Then get an average needed for the region (area in meters)
factor1=factor1/spharea(dom)/4/pi/6370000^2;
% So now we have kg/m^2

disp('Finding dates and preallocating null or 0 arrays');   % <-- 

% Get relative dates to make a trend
deltadates=thedates-thedates(1);
% Preallocate
lmcosiSSD=zeros(length(thedates),size(lmcosiS,1),size(lmcosiS,2));
fullS=zeros(length(thedates),size(lmcosiS,1),size(lmcosiS,2));
% fullS holds the combined synthetic signal and synthetic noise
disp('Iterating through building signal, noise');   % <-- 

counter=1;
for k=deltadates
    % Caltulate the desired trend amount for this month, putting the mean
    % approximately in the middle (4th year)
    factor2=factor1*4 - k/365*factor1;
    % Scale the unit signal for this month
    lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
    % Make a synthetic noise realization
    syntheticnoise=randn(1,n)*T;
    % Reorder the noise
    temp1=lmcosidata(:,3:4);
    temp1(ronmdata)=syntheticnoise(:);
    syntheticnoise=[lmcosidata(:,1:2) temp1];
    % Add this to the signal
    if wantnoise
        fullS(counter,:,:)=[lmcosidata(:,1:2)...
           squeeze(lmcosiSSD(counter,:,3:4))+syntheticnoise(:,3:4)];
    else
        fullS(counter,:,:)=[lmcosiS(:,1:2) squeeze(lmcosiSSD(counter,:,3:4))];
    end
    counter=counter+1;
end
keyboard
% So now the first synthetic month should be 4*Signal Gt but expressed as an
% average kg/m^2 over Greenland

% INITIALIZATION COMPLETE

%%%
% PROCESS THE BASES
%%%

disp('Processing the bases');

counter=1;
for L=Ls
    for XY_buffer=buffers
        TH={dom XY_buffer};
        % Something like {'greenland' 0.5}
        XY=eval(sprintf('%s(%i,%f)',TH{1},10,TH{2}));
        N=round((L+1)^2*spharea(XY));
        
        % We could use plm2slep for each month, but since we have so many
        % months, it would be much faster to load it once, and do the
        % computation ourselves.
        
        % We want the G from glmalpha, but we also want the eigenfunctions,
        % so use grace2slept to load both
        [~,~,~,XY,G,CC]=grace2slept('CSRRL05',XY,XY_buffer,L,[],[],[],'N','SD',0);
        % Get the mapping from LMCOSI into not-block-sorted GLMALPHA
        [~,~,~,lmcosipad,~,~,~,~,~,ronm]=addmon(L);
        % Preallocate a slept
        slept=zeros(nmonths,(L+1)^2);  
        % Loop over the months
        for k=1:nmonths
            lmcosi=squeeze(fullS(k,:,:));
            % Make sure that the requested L acts as truncation on lmcosi
            % or if we don't have enough, pad with zeros
            if size(lmcosi,1) < addmup(L)
                lmcosi=[lmcosi; lmcosipad(size(lmcosi,1)+1:end,:)];
            else
                lmcosi=lmcosi(1:addmup(L),:);
            end
  
            % Perform the expansion of the signal into the Slepian basis
            % If we want a specific truncation, we limit it here.
            numfun=N+truncations;
            falpha=G'*lmcosi(2*size(lmcosi,1)+ronm(1:(L+1)^2));
            slept(k,:)=falpha;
        end
        for h=1:length(truncations)
            if numfun(h) > 0
                % Estimate the total mass change
                [ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,...
                 totalparams,totalparamerrors,totalfit,functionintegrals,...
                 alphavar]=slept2resid(slept,thedates,[3 30 180 365.0],...
                                       [],[],CC,TH,numfun(h));
                % allslopes{h}(counter)=totalparams(2)*365;
                allslopes{h}(counter)=totalparams*365;
            else
                allslopes{h}(counter)=NaN;
            end
        end
        counter=counter+1;
        
        if xver && L==60 && XY_buffer==0.5
            mydata=slept(11,:) - slept(1,:);
            tempplms=[zeros(size(CC{1}(:,3:4)))];
            for v=1:N
                tempplms=tempplms + CC{v}(:,3:4)*mydata(v);
            end
            tempplms=[CC{1}(:,1:2) tempplms];
            plotplm(tempplms,[],[],5);
            colorbar
            kelicol
        end       
    end
end
varns={allslopes};
varargout=varns(1:nargout);