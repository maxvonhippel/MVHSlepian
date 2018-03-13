% Matlab creation of data for geoboxcap:
[Bl,dels,r,lon,lat,lmcosi]=geoboxcap(2*60,'iceland');
[r,lon,lat,Plm]=plm2xyz(lmcosi);
fp=fopen('geoboxcap_iceland.dat','wt');
fprintf(fp,'lat lon r\n');
for lo=1:numel(lon)
for la=1:numel(lat)
fprintf(fp,'%.4f %.4f %.4f\n',lat(la),lon(lo),r(la, lo));
end
end
fclose(fp);

% Make the outlines for buffer 0 and buffer 1
XY0=iceland(10,0);
XY1=iceland(10,1);
fp=fopen('border_0.0_iceland.dat','wt');
fprintf(fp,'lat lon\n');
for y=1:size(XY0,1)
fprintf(fp,'%.4f %.4f\n',XY0(y,1),XY0(y,2));
end
fclose(fp);
fp=fopen('border_1.0_iceland.dat','wt');
fprintf(fp,'lat lon\n');
for y=1:size(XY1,1)
fprintf(fp,'%.4f %.4f\n',XY1(y,1),XY1(y,2));
end
fclose(fp);

% Make the slepian functions map
[slept,~,thedates,TH,G,CC,V,N]=grace2slept(...
	'CSRRL05','iceland',1.0,60,[],[],[],[],'SD',1);
thedates=thedates(1:157);
slept=slept(1:157,:);
[thedates,PGRt]=correct4gia(thedates,'Paulson07',{'iceland' 1.0},60);
sleptcorrected=slept-PGRt;
% get the delta
sleptdelta=squeeze(slept(157,:)-slept(1,:));
% TODO: multiply by corresponding Slepian functions
% TODO: then add them up
% TODO: then expand using plm2xyz