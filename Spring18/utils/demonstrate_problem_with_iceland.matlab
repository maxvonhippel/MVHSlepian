theyfail=[];
for L=1:61
  [~,~,~,~,~,lmcosiS]=geoboxcap(L,iceland(0,0.5),[],[],1);
  % [Bl,dels]=plm2spec(lmcosiS,2);
  % Ltest=Bl(1);
  Ltest=max(lmcosiS(:,3))+max(lmcosiS(:,4));
  if Ltest==0
    theyfail(end+1)=L;
  end
end
disp(theyfail)

min(theywork1==theywork2)

% work=[20,21,27,28,29,34,35,36,40,41,42,43,44,47,48,49,50,51,54,55,56,57,58,59,61]


L60=60;
L61=61;
XY=eval(sprintf('%s(%i)','iceland',10));
XY(:,1)=XY(:,1)-360*[XY(:,1)>360];
% 60
degN60=180/sqrt(L60*(L60+1));
% 61
degN61=180/sqrt(L61*(L61+1));
% 60
degres60=degN60;
% 61
degres61=degN61;
% --
c11cmn=[0 90 360 -90];
% 60
nlon60=ceil([c11cmn(3)-c11cmn(1)]/degres60+1); % 122
nlat60=ceil([c11cmn(2)-c11cmn(4)]/degres60+1); % 62
lon60=linspace(c11cmn(1),c11cmn(3),nlon60); % 1 x 122 - [0, 360]
lat60=linspace(c11cmn(2),c11cmn(4),nlat60); % 1 x 62 - [-90, 90]
r60=repmat(0,nlat60,nlon60); % 62 x 122 - all zeros
[LON60,LAT60]=meshgrid(lon60,lat60);
r60(inpolygon(LON60,LAT60,XY(:,1),XY(:,2)))=1;
% 61
nlon61=ceil([c11cmn(3)-c11cmn(1)]/degres61+1); % 124
nlat61=ceil([c11cmn(2)-c11cmn(4)]/degres61+1); % 63
lon61=linspace(c11cmn(1),c11cmn(3),nlon61); % 1 x 124 - [0, 360]
lat61=linspace(c11cmn(2),c11cmn(4),nlat61); % 1 x 63 - [-90, 90]
r61=repmat(0,nlat61,nlon61); % 63 x 124 - all zeros
[LON61,LAT61]=meshgrid(lon61,lat61);
r61(inpolygon(LON61,LAT61,XY(:,1),XY(:,2)))=1;