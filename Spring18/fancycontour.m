function fancycontour(realFile,syntheticFile,regionName,labeled)
% This function takes as input .dat files and makes a nice contour graph.
% It can make a contour for the real recovery, with the 100% synthetic recovery
% trend overlaid, or for the synthetic recovery.
% 
% INPUT:
% realFile			The file path to the real recovery file, if you want to make
% 					a real recovery contour graph.  File should be in .dat 
% 					format, of the type made by hs12realrecovery.m.
% syntheticFile		The file path to the synthetic recovery file, if you want to
% 					overlay a 100% synthetic recovery contour over the real
% 					recovery graph.  Note that if not realFile is given, then we
% 					will make a synthetic recovery graph instead.
% regionName		The name of the region.  This informs the filename we save
% 					to as well as the title of the figure we make.
% labeled			Optional linspace to determine the contours that will be 
% 					drawn.  Default is a decent choice for Greenland.  For other
% 					locations, this should be specified.
% 
% Authored by maxvonhippel-at-email.arizona.edu on 02/15/18

% Do we have any inputs?
if not(exist('realFile','var')) & not(exist('syntheticFile','var'))
	disp('Please provide realFile and/or syntheticFile arguments to script')
	return
end

if not(exist('realFile','var')) & exist('syntheticFile','var')
	% In this case we are doing percents, so 0 through 200
	defval('labeled',linspace(0,200,41));
elseif (exist('realFile','var'))
	% These are the contours to label in the chart
	% This choice is good for Greenland but not for Iceland
	% If you want to do Iceland, a the contour will go from about -21 to 1
	% In this case a better choice would be linspace(-21,1,11)
	defval('labeled',linspace(-300,-100,11));
	% Read in the input files
	% Solution adapted from: 
	% https://www.mathworks.com/matlabcentral/answers/
	% 	79885-reading-dat-files-into-matlab
	% First, real data.
	reald=fopen(realFile,'r');
	data=textscan(reald,'%f%f%f','HeaderLines',1,'Collect',1);
	fclose(reald);
	reald=data{1};
	% Next, we want to draw the real recovery figure.
	Ls=reald(:,1);
	buffers=reald(:,2);
	recovered=reald(:,3);
end

if exist('syntheticFile','var')
	% Next, synthetic data.
	synthd=fopen(syntheticFile,'r');
	data=textscan(synthd,'%f%f%f','HeaderLines',1,'Collect',1);
	fclose(synthd);
	synthd=data{1};
	if not(exist('Ls','var'))
		Ls=synthd(:,1);
		buffers=synthd(:,2);
		recovered=synthd(:,3);
	end
	LsSynthetic=synthd(:,1);
	buffersSynthetic=synthd(:,2);
	recoveredSynthetic=synthd(:,3);
end

% Ranges of axes
LsRange=min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange=min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% Contour data
[LsRange, buffersRange]=meshgrid(LsRange,buffersRange);
recoveredTrends=griddata(Ls,buffers,recovered,LsRange,buffersRange);
% Chart it
fig=gcf;
hold on;
% First, we want to add the 100% contour from the synthetic data

if not(exist('realFile','var')) & exist('syntheticFile','var')
	% Synthetic Recovery Figure
	percentRecovered=griddata(LsSynthetic,buffersSynthetic,...
	recoveredSynthetic/2,LsRange,buffersRange);
	labeled=setdiff(labeled,[100]);
	contour(LsRange,buffersRange,percentRecovered,labeled,...
		'LineColor','Black','ShowText','On');
	contour(LsRange,buffersRange,percentRecovered,[100,100],...
		'LineColor','Green','ShowText','On');
	% Add title and axes
	tl=title(sprintf('Synthetic recovered trend over %s',regionName));
	filename=sprintf('%s_SyntheticRecovery', regionName);
elseif exist('realFile','var')
	% Real Recovery Figure
	percentRecovered=griddata(LsSynthetic,buffersSynthetic,recoveredSynthetic,...
		LsRange,buffersRange);
	contour(LsRange,buffersRange,percentRecovered/200,[1,1],'ShowText','Off',...
	   'LineColor','Green');
	% Then contour the actual data
	contour(LsRange,buffersRange,recoveredTrends,labeled,'ShowText','On',...
		'LineColor','Black');
	% Add title and axes
	tl=title(sprintf('GRACE data trend (Gt/yr) over %s',regionName));
	filename=sprintf('%s_RealRecovery', regionName);
end

xl=xlabel('bandwidth L');
yl=ylabel('buffer extent (degrees)');
box on;
hold off;

% Next, we want to format the figure for export
set(tl,'FontSize',10);
set(xl,'FontSize',10);
set(yl,'FontSize',10);

fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 20 20];

figdisp(filename,[],[],1,'epsc');
system(['psconvert -A -Tf ' filename '.eps']);