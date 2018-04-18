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
clear;initialize;
% 
defval('syntheticFile','/Users/maxvonhippel/Documents/NASA/Matlab Scripts/Spring18/figures/synthetic/II_WITH_NOISE/(2002-2016)/II_WITH_NOISE.dat');
defval('realFile','/Users/maxvonhippel/Documents/NASA/Matlab Scripts/Spring18/figures/real/ICELAND/(2002-2016)/ICELAND_REAL.dat');
defval('regionName','Iceland');
defval('filename','contours');
defval('fontSize',12);
defval('labeledSynthetic',linspace(0,220,12));
defval('labeledReal',linspace(-20,-4,9));
defval('fontName','Helvetica');
defval('paperPosition',[0 0 24 10]);

% Do we have any inputs?
if not(exist('realFile','var')) & not(exist('syntheticFile','var'))
	disp('Please provide realFile and/or syntheticFile arguments to script')
	return
end

reald=fopen(realFile,'r');
data=textscan(reald,'%f%f%f','HeaderLines',1,'Collect',1);
fclose(reald);
reald=data{1};
% Next, we want to draw the real recovery figure.
Ls=reald(:,1);
buffers=reald(:,2);
recovered=reald(:,3);

synthd=fopen(syntheticFile,'r');
data=textscan(synthd,'%f%f%f','HeaderLines',1,'Collect',1);
fclose(synthd);
synthd=data{1};
LsSynthetic=synthd(:,1);
buffersSynthetic=synthd(:,2);
recoveredSynthetic=synthd(:,3);

% Ranges of axes
LsRange=min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange=min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% Contour data
[LsRange, buffersRange]=meshgrid(LsRange,buffersRange);
recoveredTrends=griddata(Ls,buffers,recovered,LsRange,buffersRange);

% Chart it
fig=gcf;
ax1=subplot(1,2,1);
hold on;

% Synthetic Recovery Figure
percentRecovered=griddata(LsSynthetic,buffersSynthetic,...
recoveredSynthetic/2,LsRange,buffersRange);
labeledSynthetic=setdiff(labeledSynthetic,[100]);
contour(LsRange,buffersRange,percentRecovered,labeledSynthetic,...
	'LineColor','Black','ShowText','On');
contour(LsRange,buffersRange,percentRecovered,[100,100],...
	'LineColor','Green','ShowText','On');
% Add title and axes
tl=title(sprintf('Synthetic data trend (%c) over %s','%',regionName),...
	'FontSize',fontSize,'FontName',fontName);
yl=ylabel('buffer extent (degrees)','FontSize',fontSize,'FontName',fontName);
xl=xlabel('bandwidth L','FontSize',fontSize,'FontName',fontName);
% Next, we want to format the figure for export
box on;
hold off;

ax2=subplot(1,2,2);
hold on;
% Real Recovery Figure
contour(LsRange,buffersRange,percentRecovered,[100,100],...
	'LineColor','Green','ShowText','Off');
% Then contour the actual data
contour(LsRange,buffersRange,recoveredTrends,labeledReal,'ShowText','On',...
	'LineColor','Black');
% Add title and axes
tl=title(sprintf('GRACE data trend (Gt/yr) over %s',regionName),...
	'FontSize',fontSize,'FontName',fontName);
xl=xlabel('bandwidth L','FontSize',fontSize,'FontName',fontName);
% Next, we want to format the figure for export
box on;
hold off;

p1=get(ax1,'pos');
p2=get(ax2,'pos');
p1(1)=p1(1)+0.03;
p2(1)=p2(1)-0.03;
set(ax1,'pos',p1);
set(ax2,'pos',p2);

fig.PaperUnits = 'centimeters';
% For now, doing twice the size and downscaling in the latex
fig.PaperPosition = paperPosition;

figdisp(filename,[],[],1,'epsc');
system(['psconvert -A -Tf ' filename '.eps']);