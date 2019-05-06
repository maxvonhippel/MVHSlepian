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
% Iceland
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

% Make the outlines for buffer 0 and buffer 1
% Greenland
dom='greenland';
b=1.0;
XY0=eval(sprintf('%s(10,0)',dom));
XY12=eval(sprintf('%s(10,%d)',dom,b));
fp=fopen(sprintf('border_0.0_%s.dat',dom),'wt');
fprintf(fp,'lat lon\n');
for y=1:size(XY0,1)
fprintf(fp,'%.4f %.4f\n',XY0(y,1),XY0(y,2));
end
fclose(fp);
fp=fopen(sprintf('border_%d_%s',b,dom),'wt');
fprintf(fp,'lat lon\n');
for y=1:size(XY12,1)
fprintf(fp,'%.4f %.4f\n',XY12(y,1),XY12(y,2));
end
fclose(fp);

% Make the slepian functions map
dom='greenland';
b=0.5;
[slept,~,thedates,TH,G,CC,V,N]=grace2slept(...
	'CSRRL05',dom,b,60,[],[],[],[],'SD',1);
% sort
[V,vi]=sort(V,'descend');
% set dates
thedates=thedates(1:157);
slept=slept(1:157,:);
% [thedates,PGRt]=correct4gia(thedates,'Paulson07',TH,60);
% sleptcorrected=slept-PGRt;
% get total fit
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,...
	totalparamerrors,totalfit,functionintegrals,alphavar]...
	=slept2resid(slept,thedates,[3 182.625 365.25],[],[],CC,TH);
% get the delta
ESTsignalDelta=ESTsignal(157,:)-ESTsignal(1,:);
% get the average mass difference
% note that this covers 5337 total days
% ESTsignalAvgDiff=ESTsignalDelta/(5337/365.25);
totalmap=CC{1}(:,3:4)*ESTsignalDelta(1)/10;
% http://www.antarcticglaciers.org/glaciers-and-climate/
% estimating-glacier-contribution-to-sea-level-rise/
% 1 mm water = 10^-12 Gt water = 1 kg water (over a meter)
% 1/10 cm water / m = 1 kg water / m
N=round(N);
for j=2:N
   totalmap=totalmap+CC{j}(:,3:4)*ESTsignalDelta(j)/10;
end
% Expand the maps into space so we can plot them
totalmap=[CC{1}(:,1:2) totalmap];
[rtotal,lon,lat]=plm2xyz(totalmap,1);
% Write the file for us to map in GMT
fp=fopen(sprintf('%s_total_mass_change.dat',dom),'wt');
fprintf(fp,'lon lat total\n');
for lo=1:numel(lon)
for la=1:numel(lat)
fprintf(fp,'%.4f %.4f %.4f\n',lon(lo),lat(la),rtotal(la,lo));
end
end
fclose(fp);

% Make the slepian functions maps (one for each function)
dom='greenland';
b=0.5;
[slept,~,thedates,TH,G,CC,V,N]=grace2slept(...
	'CSRRL05',dom,b,60,[],[],[],[],'SD',1);
[V,vi]=sort(V,'descend');
thedates=thedates(1:157);
slept=slept(1:157,:);
[thedates,PGRt]=correct4gia(thedates,'Paulson07',TH,60);
sleptcorrected=slept-PGRt;
[ESTsignal,ESTresid,ftests,extravalues,total,alphavarall,totalparams,...
	totalparamerrors,totalfit,functionintegrals,alphavar]...
	=slept2resid(slept,thedates,[3 182.625 365.25],[],[],CC,TH);
ESTsignalDelta=ESTsignal(157,:)-ESTsignal(1,:);
totalmap=CC{1}(:,3:4)*ESTsignalDelta(1)/10;
totalmap=[CC{1}(:,1:2) totalmap];
[rtotal,lon,lat]=plm2xyz(totalmap,1);
fp=fopen(sprintf('%s_slep_1.dat',dom),'wt');
fprintf(fp,'lon lat total\n');
for lo=1:numel(lon)
	for la=1:numel(lat)
		fprintf(fp,'%.4f %.4f %.4f\n',lon(lo),lat(la),rtotal(la,lo));
	end
end
fclose(fp);
N=round(N);
for j=2:N
    totalmap=CC{j}(:,3:4)*ESTsignalDelta(j)/10;
    totalmap=[CC{1}(:,1:2) totalmap];
	[rtotal,lon,lat]=plm2xyz(totalmap,1);
    fp=fopen(sprintf('%s_slep_%d.dat',dom,j),'wt');
    fprintf(fp,'lon lat total\n');
	for lo=1:numel(lon)
		for la=1:numel(lat)
			fprintf(fp,'%.4f %.4f %.4f\n',lon(lo),lat(la),rtotal(la,lo));
		end
	end
	fclose(fp);
end