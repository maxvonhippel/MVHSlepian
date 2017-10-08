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
fig2print(gcf,'tall')
  
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
  
% Panel 1
axes(ah1(1));
indeks1=repmat(lon,length(1:181),1);
indeks2=repmat(lat(1:181)',1,length(lon));
ah1(1)=axesm('mercator','Origin',[70 318 0],...
     'FLatLimit',[-20 20],...
     'FLonLimit',[-20 20]);
geoshow(indeks2,indeks1,r{1}(1:181,:),'DisplayType','texturemap')
% Get border of greenland and iceland
XY2=greenland(0,0);
XY1=iceland(0,0);
% Draw greenland
geoshow(XY2(:,2),XY2(:,1),'DisplayType','line')
% Draw iceland
geoshow(XY1(:,2),XY1(:,1),'DisplayType','line')
% Color code, add colorbar, and set up axis
kelicol
caxis([-max(abs(reshape(peaks,[],1))) max(abs(reshape(peaks,[],1)))]);
colorbar

%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{1},XY);
if XYbuffer ~= 0, linem(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=1, lambda_1 = ' num2str(V(1),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 2
axes(ah1(2));
[Int,A,miniK,XY]=plm2avg(CC{2},XY);
if XYbuffer ~= 0, linem(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=2, lambda_2 = ' num2str(V(2),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 3
axes(ah1(3));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{3}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{3},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=3, lambda_3 = ' num2str(V(3),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 4
axes(ah1(4));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{4}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{4},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=4, lambda_4 = ' num2str(V(4),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 5
axes(ah1(5));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{5}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{5},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=5, lambda_5 = ' num2str(V(5),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 6
axes(ah1(6));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{6}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{6},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=6, lambda_6 = ' num2str(V(6),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);

% Panel 7
axes(ah1(7));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{7}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{7},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=7, lambda_7 = ' num2str(V(7),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 8
axes(ah1(8));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{8}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{8},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=8, lambda_8 = ' num2str(V(8),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
% Panel 9
axes(ah1(9));
m_proj('oblique mercator','longitudes',[220 220],'latitudes',[75 40],'aspect',1.0);
m_pcolor(lon,lat(1:100),r{9}(1:100,:)); % 90 to 10, resolution is 1 degree
shading flat;
m_grid;
m_coast('color','w');
%t = colorbar('peer',gca);
[Int,A,miniK,XY]=plm2avg(CC{9},XY);
if XYbuffer ~= 0, m_line(XY(:,1),XY(:,2),'color','white','linestyle','--'); end
t=title(['alpha=9, lambda_9 = ' num2str(V(6),3) ', Avg Val= ' num2str(A,3)]);
P=get(t,'position');
P(2)=P(2)*1.05;
set(t,'position',P);
  
  keyboard

  
  
%%%
% OUTPUT
%%%

% Save relevant data for plotting in something like GMT

if strcmp(dom,'greenland') || strcmp(dom,'gulfofalaskaN')...
        || strcmp(dom,'gulfofalaskaS') || strcmp(dom,'ellesmere')...
        || strcmp(dom,'baffin')
    mylimit = [1 71];
    XY=eval(sprintf('%s(%i,%f)',TH{1},10,TH{2}));
elseif strcmp(dom,'wantarctica')...
        || strcmp(dom,'wantarcticaG') || strcmp(dom,'wantarcticaCoasts')...
        || strcmp(dom,'pantarctica') || strcmp(dom,'pantarcticaOceanBuf')...
        || strcmp(dom,'wantarcticaGOceanBuf')
    mylimit = [131 181];
    XY=eval(sprintf('%s(%i,%f)',TH{1},10,TH{2}));
elseif strcmp(dom,'eantarcticaCoasts1') || strcmp(dom,'eantarcticaInt')...
        || strcmp(dom,'eantarcticaCoasts2') || strcmp(dom,'eantarcticaIntGOceanBuf')...
        || strcmp(dom,'eantarcticaCoasts1OceanBuf') || strcmp(dom,'eantarcticaCoasts2OceanBuf')...
        || strcmp(dom,'antarcticaGP') || strcmp(dom,'antarctica')
    mylimit = [131 181];
    XY=eval(sprintf('%s(%i,%f)',TH{1},10,TH{2}));
    [thetap,phip,rotmats]=rottp((90-XY(:,2))*pi/180,XY(:,1)/180*pi,0,-pi/2,0);
    XY = [phip*180/pi 90-thetap*180/pi];
end

% Clip the data to our limit, and scale it by its maximum
for temp = 1:K
    mydata1{temp} = r{temp}(mylimit(1):mylimit(2),:)/max(max(abs(r{temp})));
    mydata1{temp}(abs(mydata1{temp}(:))<0.01)=0;
end

[m,n]=size(mydata1{1});
indeks1 = repmat(lon,length(mylimit(1):mylimit(2)),1);
indeks2 = repmat(lat(mylimit(1):mylimit(2))',1,length(lon));

indeks1 = reshape(indeks1,m*n,1);
indeks2 = reshape(indeks2,m*n,1);

fp1 = fopen(['figures/figdata/SlepEigfuncs' dom num2str(XYbuffer) num2str(L) '.dat'],'wt');
fp2 = fopen(['figures/figdata/SlepFuncs_region_' dom num2str(XYbuffer) '.dat'],'wt');

fprintf(fp2,'%.4e %.4e \n',XY');

for temp1=1:(m*n)
    if temp1==1
        fprintf(fp1,'%i %.1f \n',L,XYbuffer);
        fprintf(fp1,'%s \n',num2str(V(1:K),3)); % the lambdas
    end    
    tosave1=[];
    formatstring1=['%i %i']; % Lon Lat
    for temp2=1:K
      tosave1 = [tosave1 mydata1{temp2}(temp1)];
      formatstring1 = [formatstring1 ' %.4e'];
    end
    formatstring1 = [formatstring1 '\n'];
    %tosave1 = [functimeseries(1,temp1) alphavar(temp1)];
    fprintf(fp1,formatstring1,indeks1(temp1),indeks2(temp1),tosave1);
end
fclose(fp1);
fclose(fp2);

  
