function fancycontour(realFile,syntheticFile,regionName)
defval('syntheticFile','/Users/maxvonhippel/Documents/NASA/Matlab Scripts/Spring18/figures/synthetic/II_WITH_NOISE/(2002-2016)/II_WITH_NOISE.dat');
defval('realFile','/Users/maxvonhippel/Documents/NASA/Matlab Scripts/Spring18/figures/real/ICELAND/(2002-2016)/ICELAND_REAL.dat');
defval('regionName','Iceland');

defval('labeledSynthetic',union(linspace(0,50,6),linspace(55,200,30)));
defval('labeledReal',linspace(-20,-2,10));

realD=fopen(realFile,'r');
realData=textscan(realD,'%f%f%f','HeaderLines',1,'Collect',1);
fclose(realD);
realD=realData{1};
realLs=realD(:,1);
realBuffers=realD(:,2);
realRecovered=realD(:,3);

synthD=fopen(syntheticFile,'r');
syntheticData=textscan(synthd,'%f%f%f','HeaderLines',1,'Collect',1);
fclose(synthD);
synthD=syntheticData{1};
syntheticLs=synthD(:,1);
syntheticBuffers=synthD(:,2);
syntheticRecovered=synthD(:,3);

fig=gcf;
hold on;

% Synthetic on left
ax1 = subplot(1,2,1);

% Ranges of axes
syntheticLsRange=min(syntheticLs):(max(syntheticLs)-min(syntheticLs))/200:max(syntheticLs);
syntheticBuffersRange=min(syntheticBuffers):(max(syntheticBuffers)-min(syntheticBuffers))/200:max(syntheticBuffers);
% Contour data
[syntheticLsRange, syntheticBuffersRange]=meshgrid(syntheticLsRange,syntheticBuffersRange);
syntheticRecoveredTrends=griddata(syntheticLs,syntheticBuffers,syntheticRecovered/2,syntheticLsRange,syntheticBuffersRange);
syntheticLabeled=setdiff(syntheticLabeled,[100]);
contour(syntheticLsRange,syntheticBuffersRange,syntheticRecoveredTrends,syntheticLabeled,...
	'LineColor','Black','ShowText','On','FontName','Times');
contour(syntheticLsRange,syntheticBuffersRange,syntheticRecoveredTrends,[100,100],...
	'LineColor','Green','ShowText','On','FontName','Times');
% Add title and axes
syntheticTl=title(sprintf('Synthetic recovered trend over %s',regionName));

% Real on right
ax1 = subplot(1,2,2);

% Real Recovery Figure
contour(realLsRange,realBuffersRange,syntheticRecoveredTrends/2,[100,100],'ShowText','Off',...
   'LineColor','Green','LineWidth',1.5);
% Then contour the actual data
realRecoveredTrends=griddata(realLsRange,realBuffersRange,realRecovered,realLsRange,realBuffersRange);
contour(LsRange,buffersRange,realRecoveredTrends,labeled,'ShowText','On',...
	'LineColor','Black','FontName','TimesNewRoman');
% Add title and axes
tl=title(sprintf('GRACE data trend (Gt/yr) over %s',regionName));
filename=sprintf('%s_RealRecovery', regionName);