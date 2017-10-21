function varargout=SyntheticExperiments(myCase)
% []=SYNTHETICEXPERIMENTS(Case)
%
% This function runs one of several synthetic experiments to recover a 
% mass loss trend in the presence of noise, estimated from GRACE data
%
% INPUT:
%
% Case    Which case you want to run.
%           A - 
%           B - 
%           C -  
%
% OUTPUT:
%
% 
%
% SEE ALSO: SYNTHETICCASEA
%
% Last modified by charig-at-princeton.edu on 6/25/2012


%%%
% INITIALIZE
%%%

% Top level directory
% For Chris
%IFILES=getenv('IFILES');
% For FJS, who has a different $IFILES
%IFILES='/u/charig/Data/';

defval('myCase','C');
defval('xver',0)
defval('TH','greenland');
defval('THS','greenland');
defval('Pcenter','CSR')
defval('Ldata',60)
defval('Signal',200) % Gt/yr
defval('pars',10);
defval('wantnoise',0)
defval('Ls',[60]);
defval('thebuffers',[0.5]);
defval('truncations',[0]);

% INITIALIZE

% Get data
[potcoffs,cal_errors,thedates] = grace2plmt(Pcenter,'SD');
nmonths=length(thedates);
% Find the noise
[ESTresid]=plmt2resid(potcoffs,thedates,[1 1 365.0],cal_errors);
% Find the noise covariance
[Clmlmp,Clmlmpr,Clmlmpd,EL,EM]=plmresid2cov(ESTresid,Ldata);


%%%
% RUN THE CASES
%%%

switch myCase
    case 'A'
        tic;
        allslopes=SyntheticCaseA(Clmlmp,thedates,Ls,thebuffers,truncations);
        casetime=toc;
        disp(['Elapsed time for this case was ' num2str(casetime) ' seconds']);
    case 'B'
        
    case 'C'
        %tic;
        allslopes=SyntheticCaseC(Clmlmp,thedates,Ls,thebuffers,truncations);
        %casetime=toc;
        %disp(['Elapsed time for this case was ' num2str(casetime) ' seconds']);
end



%%%
% PLOTTING
%%%

% i=thebuffers;
% j=Ls;
% allslopes2=reshape(allslopes{5},length(i),length(j));
% figure
% contour(j,i,allslopes2,-1*[150 160 170 180 190 200 210 220])
% colorbar
% xlabel('Bandlimit L')
% ylabel('Region buffer, in degrees')
% title('Contour of mass loss slope (counter level 10Gt/yr)')

  
% Save relevant data for use in something like GMT

for h=1:length(truncations)
   mydata=reshape(allslopes{h},length(i),length(j));
    
   [m,n]=size(mydata);

   theL=repmat(j,m,1);
   theXYBuf=repmat(i,1,n);
   theL=reshape(theL,m*n,1);
   theXYBuf=reshape(theXYBuf,m*n,1);
   mydata=reshape(mydata,m*n,1);

   tosave1 = [theL theXYBuf mydata]';
   fp1 = fopen(['figures/figdata/SyntheticSignalContourCASE' myCase '_N' num2str(truncations(h),'%+i') '.dat'],'wt');
   fprintf(fp1,'%.5f %.5f %.5e\n',tosave1);
   fclose(fp1);

end


