function varargout=SyntheticExperiments(myCase, dom)
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
% OUTPUT: none
% 
% SEE ALSO: SYNTHETICCASEA
%
% Modified by charig-at-princeton.edu on 6/25/2012
% Last modified by maxvonhippel-at-email.arizona.edu on 21/10/2017

%%%
% INITIALIZE
%%%

defval('myCase','C');
defval('xver',0);
defval('TH','greenland');
defval('THS','greenland');
defval('Pcenter','CSR');
defval('Rlevel','RL05');
defval('Ldata',60);
defval('Signal',200); % Gt/yr
defval('pars',10);
defval('wantnoise',0);
defval('Ls',[60]);
defval('thebuffers',[0.5]);
defval('truncations',[0]);

% Get data
[potcoffs,cal_errors,thedates] = grace2plmt(Pcenter,Rlevel,'SD',1);
nmonths = length(thedates);
% Find the noise
[ESTresid] = plmt2resid(potcoffs,thedates,[1 1 365.0],cal_errors);
% Find the noise covariance
[Clmlmp,Clmlmpr,Clmlmpd,EL,EM] = plmresid2cov(ESTresid,Ldata,[]);
% The critical line that is returning []
T = cholcov(Clmlmp);
if isempty(T)
  disp('Empty covariance matrix, something is wrong.');
  return
end

%%%
% RUN THE CASES
%%%
tic;
switch myCase
    case 'A'
      % Geoboxcap for dom (eg Iceland), run recovery, see what we get
      allslopes = SyntheticCaseA(Clmlmp,thedates,Ls,thebuffers,truncations);
    case 'AA'
      % A but with synthetic noise
      disp('Synthetic Experiment AA not yet implemented');
    case 'B'
      % Use uniform mass on dom1 (eg Greenland), recover dom2 (eg Iceland)
      disp('Synthetic Experiment BB not yet implemented');
    case 'C'
      % Use actual noise from dom1 (eg Greenland) to recover dom2 (eg Iceland)
      % (unless this is currently implemented to do something else?)
      % (I don't have SyntheticCaseC script ...)
      % allslopes = SyntheticCaseC(Clmlmp,thedates,Ls,thebuffers,truncations);
      disp('Synthetic Experiment C not yet integrated into this codebase');
    case 'D'
      disp('Case D not yet implemented');
    otherwise
      disp('Invalid case name. Try A, B, C, or D.');
end
casetime = toc;
disp(['Elapsed time for case ' myCase ' was ' num2str(casetime) ' seconds']);



%%%
% PLOTTING - need to define allslopes for following code to do anything
%%%

% i = thebuffers;
% j = Ls;
% allslopes2 = reshape(allslopes{5},length(i),length(j));
% figure
% contour(j,i,allslopes2,-1*[150 160 170 180 190 200 210 220])
% colorbar
% xlabel('Bandlimit L')
% ylabel('Region buffer, in degrees')
% title('Contour of mass loss slope (counter level 10Gt/yr)')

  
% Save relevant data for use in something like GMT

% for h = 1:length(truncations)
%    mydata = reshape(allslopes{h},length(i),length(j));
    
%    [m,n] = size(mydata);

%    theL = repmat(j,m,1);
%    theXYBuf = repmat(i,1,n);
%    theL = reshape(theL,m*n,1);
%    theXYBuf = reshape(theXYBuf,m*n,1);
%    mydata = reshape(mydata,m*n,1);

%    tosave1 = [theL theXYBuf mydata]';
%    fp1 = fopen(['figures/figdata/SyntheticSignalContourCASE' myCase ...
%                '_N' num2str(truncations(h),'%+i') '.dat'],'wt');
%    fprintf(fp1,'%.5f %.5f %.5e\n',tosave1);
%    fclose(fp1);
% end