function varargout=mvhfunction(L)
% Last modified by maxvonhippel-at-email.arizona.edu, 09/27/2017
% L: the bandwidth to count up to in the LWindow
% The Iceland.mat file I use is built out of a ShapeFile my good friend
% Vivian Arriaga, a GIS major at ASU, made for me: varriag1@asu.edu

defval('L',60);
defval('TH',{'iceland' 0.5});
defval('pars',10);
defval('phi',0);
defval('theta',0);
defval('omega',0);
defval('J',(L+1)^2);
defval('K',19);
defval('rotb',1);

XYbuffer=TH{2};
dom=TH{1};
eval(sprintf('XY=%s(10,%f);',dom,XYbuffer));
[~,~,~,lmcosiW,~,~,~,~,~,ronmW]=addmon(L);
% Get the Slepian basis; definitely not block-sorted as for the rotated
% versions this will make no sense at all anymore
[G,V,~,~,~,~,MTAP,~]=glmalpha(TH,L,[],0,[],[],J);
% Sort by decreasing eigenvalue
[V,vi]=sort(V,'descend');
G=G(:,vi); if ~isnan(MTAP); MTAP=MTAP(vi); end
% Collect the eigenvector output into a format that PLM2XYZ knows how to interpret
for j=1:size(G,2)
   % Create the blanks
   cosi=lmcosiW(:,3:4);
   % Stick in the coefficients of the 1st eigentaper
   cosi(ronmW)=G(:,j);
   % Construct the full matrix
   CC{j} = [lmcosiW(:,1:2) cosi]; 
end
% Expand eigenfunctions into space
for i=1:K; [r{i},lon,lat]=plm2xyz(CC{i}, 1); end
[dems,dels,mz,lmc,mzin]=addmon(L);

figure
ah1=krijetem(subnum(3,3));
fig2print(gcf, 'landscape');
  
% Define axes for the main top text.
axes('position', [0, 0, 1, 1]);
% Write some text: 
htext = text(.5, 0.98, ['Functions from PLM2SLEP:  dom = '...
    num2str(dom) '+' num2str(XYbuffer) 'buffer, Lwindow = '...
    num2str(L)], 'FontSize', 14, 'FontName', 'Times New Roman');
% Specify that the coordinates provided above are for the middle
% of the text string: 
set(htext, 'HorizontalAlignment', 'center');
set(gca, 'Visible', 'off');

% Set up the 9 individual plots
indeks1=repmat(lon,length(1:181),1);
indeks2=repmat(lat(1:181)',1,length(lon));
XY2=greenland(0,0);
XY1=iceland(0,0);
for panel=1:9
%   Current subplot axes
    axes(ah1(panel));
    ah1(panel)=axesm('mercator',...
                     'Origin', [70 318 0],...
                     'FLatLimit',[-20 20],...
                     'FLonLimit',[-20 20]);
    geoshow(indeks2, indeks1, r{panel}(1:181,:),...
            'DisplayType', 'texturemap')
%   Draw greenland, then iceland
    geoshow(XY2(:,2),XY2(:,1),'DisplayType','line')
    geoshow(XY1(:,2),XY1(:,1),'DisplayType','line')
%   Shape axes
    caxis([-max(abs(reshape(peaks, [], 1)))...
            max(abs(reshape(peaks, [], 1)))]);
    [~,A,~,XY]=plm2avg(CC{panel}, XY);
    if XYbuffer ~= 0, linem(XY(:,1) ,XY(:,2),...
            'color', 'white', 'linestyle', '--'); end
    t=title(['$a$ = ' num2str(panel)...
             ', $l_{1}$ = ' num2str(V(panel),3) newline...
             'Avg = ' num2str(A,3)],...
             'FontName', 'Times New Roman',...
             'FontSize', 10,...
             'Interpreter', 'LaTeX');
    P = get(t, 'position');
    P(2) = (P(2)*1.05) - 0.02;
    set(t, 'position', P);
    pos = get(gca, 'Position');
    pos(2) = pos(2) - 0.05;
    set(gca, 'Position', pos)
end

kelicol
colorbar('location', 'Manual', 'position', [0.93 0.1 0.02 0.81]);

% Now get the monthly grace data
[potcoffs,cal_errors,thedates]=grace2plmt('CSR', 'RL05', 'POT', 0);
% Project it into Slepians
[slept,cal_errors,thedates,TH,G,CC,V,N]=grace2slept(...
    'CSRRL05', 'iceland', 1, L, 0, 0, 0, J, 'POT', 1);
[dems,dels,mz,lmcosi,mzi,mzo,bigm,bigl,rinm,ronm,demin] = addmon(L);
% Reference the following script:
% https://github.com/harig00/Harigit/blob/026e270e0c5ca2b21ddcb92f48d79c1d5bc65bb9/hs12totaltrend.m

% Prepare outputs
varns={G,V,lmcosiW,dems,dels,mz,lmc,mzin};
varargout=varns(1:nargout);