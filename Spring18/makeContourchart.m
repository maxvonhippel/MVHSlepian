% demo data for chart
slopes = [50 0 170.948370045596;...
		  50 0.5 190.339992955744;...
		  55 0 172.957943872825;...
		  55 0.5 194.831637127521;...
		  60 0 177.973770329032;... 
		  60 0.5 197.527703564053;];
% solution adapted from: https://stackoverflow.com/a/19560522/1586231
% define the axes
Ls = slopes(:,1);
buffers = slopes(:,2);
% divide by 200 (total unit signal applied) to get fraction
% then multiply by 100 to get percent
% hence * 1/2
recovered = slopes(:,3)/2;
% round to 2 digits for nice labels
recovered = round(recovered, 2);
% ranges of axes
LsRange = min(Ls):(max(Ls)-min(Ls))/200:max(Ls);
buffersRange = min(buffers):(max(buffers)-min(buffers))/200:max(buffers);
% contour data
[LsRange, buffersRange] = meshgrid(LsRange, buffersRange);
percentRecovered = griddata(Ls, buffers, recovered, LsRange, buffersRange);
% chart it
contour(LsRange, buffersRange, percentRecovered, 5, 'ShowText', 'On');
title('Synthetic recovered trend');
xlabel('bandwidth L');
ylabel('buffer extent (degrees)');