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
% sort
[V,vi]=sort(V,'descend');
% set dates
thedates=thedates(1:157);
slept=slept(1:157,:);
[thedates,PGRt]=correct4gia(thedates,'Paulson07',TH,60);
sleptcorrected=slept-PGRt;
% get total fit
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,...
	totalparamerrors,totalfit,functionintegrals,alphavar]...
	=slept2resid(slept,thedates,[1 181.0 365.0],[],[],CC,TH);
% get the delta
ESTsignalDelta=ESTsignal(157,:)-ESTsignal(1,:);
% get the average mass difference
% note that this covers 5337 total days
ESTsignalAvgDiff=ESTsignalDelta/(5337/365.24);
totalmap=CC{1}(:,3:4)*ESTsignalAvgDiff(1)/10;
% Note: why do we divide by 10 here? ^^
N=round(N);
for j=2:N
   totalmap=totalmap+CC{j}(:,3:4)*ESTsignalAvgDiff(j)/10;
end
% Expand the maps into space so we can plot them
totalmap=[CC{1}(:,1:2) totalmap];
[rtotal,lon,lat]=plm2xyz(totalmap,1);
% Write the file for us to map in GMT
fp=fopen('iceland_total_mass_change.dat','wt');
fprintf(fp,'lon lat total\n');
for lo=1:numel(lon)
	for la=1:numel(lat)
		fprintf(fp,'%.4f %.4f %.4f\n',lon(lo),lat(la),rtotal(la,lo));
	end
end
fclose(fp);