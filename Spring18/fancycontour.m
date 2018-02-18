function fancycontour(realFile,syntheticFile,regionName)
% Example:
% [slopes]=hs12realrecovery('GREENLAND_REAL.dat','GG_WITH_NOISE.dat',...
% 							'Greenland');
% 
% Here we plot the contour of recovered trends from real data and overlay
% the 100% contour from the synthetic experiments.  Then we export the figure
% to be a well-formatted PDF which we can insert into our LATEX document
% down the line.
% 
% Authored by maxvonhippel-at-email.arizona.edu on 02/15/18

% Do we have any inputs?
if not(exist('realFile','var')) | not(exist('syntheticFile','var'))
	disp('Please provide realFile and syntheticFile arguments to script')
	return
end

% Read in the input files
% Solution adapted from: 
% https://www.mathworks.com/matlabcentral/answers/
% 	79885-reading-dat-files-into-matlab
% First, real data.
reald=fopen(realFile,'r');
data=textscan(reald,'%f%f%f','HeaderLines',1,'Collect',1);
fclose(reald);
reald=data{1};
% Next, synthetic data.
synthd=fopen(syntheticFile,'r');
data=textscan(synthd,'%f%f%f','HeaderLines',1,'Collect',1);
fclose(synthd);
synthd=data{1};

% Next, we want to draw the real recovery figure.
Ls=reald(:,1);
buffers=reald(:,2);
recovered=reald(:,3);
% Ranges of axes
LsRange=min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange=min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% Contour data
[LsRange, buffersRange]=meshgrid(LsRange,buffersRange);
recoveredTrends=griddata(Ls,buffers,recovered,LsRange,buffersRange);
% Chart it
figure;
hold on;
% First, we want to add the 100% contour from the synthetic data
LsSynthetic=synthd(:,1);
buffersSynthetic=synthd(:,2);
recoveredSynthetic=synthd(:,3);
labeled=linspace(-300,-100,11);
percentRecovered=griddata(LsSynthetic,buffersSynthetic,recoveredSynthetic,...
	LsRange,buffersRange);
contour(LsRange,buffersRange,percentRecovered/200,[1,1],'ShowText','Off',...
   'LineColor','Green');
% Then contour the actual data
contour(LsRange,buffersRange,recoveredTrends,labeled,'ShowText','On',...
	'LineColor','Black');
% Add title and axes
title(sprintf('GRACE data trend (Gt/yr) over %s',regionName));
xlabel('bandwidth L');
ylabel('buffer extent (degrees)');
box on;
hold off;