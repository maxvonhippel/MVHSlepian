function Fig_slepfuncs
%
% Plot what some slepian functions look like.
%
% Last modified by charig-at-princeton.edu on 6/21/2012


%%%
% INITIALIZE
%%%

defval('L',60);
defval('TH',{'iceland' 0.5});
defval('pars',10);
defval('phi',0);
defval('theta',0);
defval('omega',0);
defval('J',(L+1)^2);
defval('K',19);
defval('rotb',1);

IFILES=getenv('IFILES');
% path(path,'~/src/m_map');

XYbuffer=TH{2};
dom=TH{1};

%%%
% GET THE FUNCTIONS
%%%

%Get domain coordinates
eval(sprintf('XY=%s(10,%f);',dom,XYbuffer));
 
[~,~,~,lmcosiW,~,~,~,~,~,ronmW]=addmon(L);
% Get the Slepian basis; definitely not block-sorted as for the rotated
% versions this will make no sense at all anymore
[G,V,EL,EM,N,GM2AL,MTAP,IMTAP]=glmalpha(TH,L,[],0,[],[],J);

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
for i=1:K
    [r{i},lon,lat]=plm2xyz(CC{i},1);
end

% Prepare for differently-ordered degree and order output
[dems,dels,mz,lmc,mzin]=addmon(L);

%%%
% PLOTTING
%%%

% Figure 1
% Figure of Slepian Functions for Greenland for the chosen bandwidth
figure
ah1=krijetem(subnum(3,3));
fig2print(gcf,'landscape')
  
%Main top text
axes('position',[0,0,1,1]);  % Define axes for the text.
% In this case, the axes are for the entire page.
% Write some text: 
htext = text(.5,0.98,['Functions from PLM2SLEP:  dom = '...
    num2str(dom) '+' num2str(XYbuffer) 'buffer, Lwindow = '...
    num2str(L)], 'FontSize', 12  );
% Specify that the coordinates provided above are for the middle
% of the text string: 
set(htext,'HorizontalAlignment','center');
set(gca,'Visible','off');

% The integrals here are expressed as fractional sphere area

indeks1=repmat(lon,length(1:181),1);
indeks2=repmat(lat(1:181)',1,length(lon));
XY2=greenland(0,0);
XY1=iceland(0,0);
for panel=1:9
%   Current subplot axes
    axes(ah1(panel));
    ah1(panel)=axesm('mercator','Origin',[70 318 0],...
     'FLatLimit',[-20 20],...
     'FLonLimit',[-20 20]);
    geoshow(indeks2,indeks1,r{panel}(1:181,:),'DisplayType','texturemap')
    % Draw greenland
    geoshow(XY2(:,2),XY2(:,1),'DisplayType','line')
    % Draw iceland
    geoshow(XY1(:,2),XY1(:,1),'DisplayType','line')
    caxis([-max(abs(reshape(peaks,[],1))) max(abs(reshape(peaks,[],1)))]);
    [Int,A,miniK,XY]=plm2avg(CC{panel},XY);
    if XYbuffer ~= 0, linem(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
    t=title(['alpha=1, lambda_1 = ' num2str(V(panel),3) ', Avg Val= ' num2str(A,3)]);
    P=get(t,'position');
    P(2)=P(2)*1.05;
    set(t,'position',P);
end

%   Color code everything
kelicol
colorbar 