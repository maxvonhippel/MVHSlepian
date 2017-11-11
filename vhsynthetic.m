function varargout=vHSynthetic(Case,dom1,dom2,Signal,Ldata,Ls,buffers)
% [rate]=VHSYNTHETIC(experiment,dom1,dom2)
% 
% This function runs one of several synthetic experiments to recover a 
% mass loss trend in the presence of noise, estimated from GRACE data
% 
% INPUT:
% 
% Case		Which case you want to run:
%           	A  - Recover dom1 from uniform mass on dom1
%           	AA - A but with synthetic noise
%           	B  - Recover dom1 from uniform mass on dom2
% 				BB - B but with synthetic noise
% 				C  - Recover dom1 from actual data of dom2
%				CC - C but with synthetic noise
% 			[default: A]
% dom1		The domain to recover.  Should be a name, eg 'iceland'.
% 			[default: 'iceland']
% dom2		The domain to recover from, for cases B, BB, C, or CC.
% 			Should be a name, eg 'greenland'.  [default: 'greenland']
% Signal	The expected Signal back, which we compare to when measuring loss.
% 			[default: 200]
% Ldata		The bandwidth of the data we are recovering from. [default: 60]
% Ls		The bandwidths of the bases that we are looking at, 
%           e.g. [10 20 30].  [default: [60]]
% buffers	Distances in degrees that the region recovered from will be
% 			enlarged by BUFFERM. [default: [0 1 2]]
% 
% OUTPUT:
% 
% slopes	The slopes of the recovered mass loss trends.  This is a
% 			Ls x buffers size matrix.
% 
% EXAMPLE: [rate]=VHSYNTHETIC('A','iceland','greenland',60,[60],[0.5]);
% 
% First authored by maxvonhippel-at-email.arizona.edu on 11/10/2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Start timer, because it's interesting to know how slow/fast this is
tic;
% Start parpool if none already exists.  Note that we do this explicitly
% because we can't use dynamically sized for loops in parfor.
gcp();
% Initialize our return value to nothing.  This is an unnecesarry step, but
% I'm keeping it in for now as it makes some of my debugging a little easier.
slopes=[];
% Define default values.
defval('Case','A');
defval('dom1','iceland');
defval('dom2','greenland');
defval('Signal',200);
defval('Ldata',60);
defval('Ls',[60]);
defval('buffers',[0 1 2]);

% If Case is a 2-letter string then it's AA or BB, meaning
% we want noise.
wantNoise=logical(strlength(Case)==2);

% Check that we have valid input
cases=["A","AA","B","BB","C"];
if ~ismember(Case,cases)
	% In this case an invalid Case has been supplied, so we should end
	sprintf('%s is not a valid Case. Please try one of: %s', ...
		Case, strjoin(cases,', '))
	return
end
% Check that we are not attempting to project onto a basis of larger bandwidth
% than our actual data.  To be clear, the Ls should be truncations (or the
% trivial trunctation, that is to say, equal to ...) of Ldata, the L bandwidth
% value of our GRACE data.  Is there a valid reason to want to upscale
% the bandwidth?  Am I missing something here?
for L=Ls
	if L>Ldata
		sprintf('L %d in Ls is > Ldata = %d.', L, Ldata)
		disp('This is suboptimal behaviour and will break the code.')
		return
	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 1: Get the data to be recovered from
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the original data
[potcoffs,~,thedates]=grace2plmt('CSR','RL05','SD',0);
[~,~,~,lmcosidata,~,~,~,~,~,ronmdata]=addmon(Ldata);
% If we want noise we need the covariance matrix
if wantNoise
	% Get residuals from plot coefficients from grace data
	[ESTresid,~,~,~,~,~]=plmt2resid(potcoffs(:,:,1:4),thedates,[]);
	[Clmlmp,~,~,~,~]=plmresid2cov(ESTresid,Ldata,[]);
	% Decompose the covariance matrix
	disp('Decomposing the covariance...');
	T=cholcov(Clmlmp);
	[n,m]=size(T);
	if isempty(T)
  		disp('Empty covariance matrix, something is wrong.');
  		return
	end
end

% Get the region to recover from
if Case(1)=='C'
	% In this case use GRACE data
	% First get the grace data projected onto a basis of Slepian coefficients
	[slept,~,otherdates,~,~,~,~,~]=grace2slept('CSRRL05',dom2,1,Ldata,...
		0,0,0,[],'SD',0);
	% Not sure if this could be a problem or even could happen, but just in case
	if otherdates~=thedates
		disp('Warning: ')
		disp('otherdates != thedates on line 104.  This might be problematic.')
		keyboard
	end
	% Next get the difference in the data, rather than just a geoid
	fullS=slept(1:end,:)-repmat(mean(slept(1:end,:),1),size(slept,1),1);
else
	% In this case use uniform mass over a region
	% Case(1) is the first char in Case, so this is triggered for A or AA
	if Case(1)=='A'
		% Set dom2=dom1 so we can proceed as in B or BB
		dom2=dom1;
	end
	% Make a synthetic unit signal over the region
	[~,~,~,~,~,lmcosiS]=geoboxcap(Ldata,dom2,[],[],1);
	% Convert desired Gt/yr to kg
	factor1=Signal*907.1847*10^9;
	% Then get an average needed for the region (area in meters)
	factor1=factor1/spharea(dom2)/4/pi/6370000^2;
	% So now we have kg/m^2
	% Get relative dates to make a trend
	% How many time units since the start of the data?
	deltadates=thedates-thedates(1);
	% lmcosiSSD will be used in the iterative construction of fullS
	% If we don't want noise, then lmcosiSSD actually is fullS
	lmcosiSSD=zeros(length(thedates),size(lmcosiS,1),size(lmcosiS,2));
	% fullS will hold the combined synthetic signal and synthetic noise
	fullS=zeros(length(thedates),size(lmcosiS,1),size(lmcosiS,2));
	% Now we can iterate over the dates
	counter=1;
	for k=deltadates
		% Caltulate the desired trend amount for this month,
		% putting the mean approximately in the middle (4th year)
		factor2=factor1*4-k/365*factor1;
		% Scale the unit signal for this month
		lmcosiSSD(counter,:,:)=[lmcosiS(:,1:2) lmcosiS(:,3:4)*factor2];
		% Add this to the signal
		if wantNoise
			% Make a synthetic noise realization
    		syntheticnoise=randn(1,n)*T;
    		% Reorder the noise

    		% ==================================================================
    		% Revisit the below code block and rewrite it myself to make sure I
    		% can see why it is how it is (or if it even should be this way)
    		% ----------------------------- I don't understand this part fully -
    		temp1=lmcosidata(:,3:4);
    		temp1(ronmdata)=syntheticnoise(:);
    		syntheticnoise=[lmcosidata(:,1:2) temp1];
    		fullS(counter,:,:)=[lmcosidata(:,1:2)...
       			squeeze(lmcosiSSD(counter,:,3:4))+...
       			syntheticnoise(:,3:4)];
       		% ------------------------------------------------------------------
       		% ================================================================== 
		end
		counter=counter+1;
	end
	% If we don't want noise, then fullS == lmcosiSSD already, so let's just rename
	% fullS to lmcosiSSD and that way either way we can operate on fullS in the
	% next step.
	if ~wantNoise 
		fullS=lmcosiSSD
	end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PART 2: Recover the mass loss trend
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for L=Ls
	for B=buffers
		% The domain we want to recover, at the current buffer
		TH={dom1 B};
        XY=eval(sprintf('%s(%i,%f)',TH{1},10,TH{2}));
        % The current Shannon number
        N=round((L+1)^2*spharea(XY));

	end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONCLUSION: Print time & return slopes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

casetime = toc;
disp(['Elapsed time for case ' Case ' was ' num2str(casetime) ' seconds']);

varns={slopes};
varargout=varns(1:nargout);