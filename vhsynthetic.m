function varargout=vHSynthetic(Case,dom1,dom2,Ls,buffers)
% [rate]=VHSYNTHETIC(experiment,dom1,dom2)
% 
% This function runs one of several synthetic experiments to recover a 
% mass loss trend in the presence of noise, estimated from GRACE data
% 
% INPUT:
% 
% Case		Which case you want to run:
%           	A  - Recover dom1 from uniform mass on dom1
%           	AA - A but with synthetic noise
%           	B  - Recover dom1 from uniform mass on dom2
% 				BB - B but with synthetic noise
% 				C  - Recover dom1 from actual data of dom2
%				CC - C but with synthetic noise
% 			[default: A]
% dom1		The domain to recover.  Should be a name, eg 'iceland'.
% 			[default: 'iceland']
% dom2		The domain to recover from, for cases B, BB, C, or CC.
% 			Should be a name, eg 'greenland'.  [default: 'greenland']
% Ls		The bandwidths of the bases that we are looking at, 
%           e.g. [10 20 30].  [default: [60]]
% buffers	Distances in degrees that the region recovered from will be
% 			enlarged by BUFFERM. [default: [0 1 2]]
% 
% OUTPUT:
% 
% slopes	The slopes of the recovered mass loss trends.  This is a
% 			Ls x buffers size matrix.
% 
% First authored by maxvonhippel-at-email.arizona.edu on 11/10/2017

%%%%%%%%%%%%
% INITIALIZE
%%%%%%%%%%%%

defval('Case','A');
defval('dom1','iceland');
defval('dom2','greenland');
defval('Ls',[60]);
defval('buffers',[0 1 2]);

% Check that we have valid input
cases=["A","AA","B","BB","C"];
if ~ismember(Case,cases)
	% In this case an invalid Case has been supplied, so we should end
	sprintf('%s is not a valid Case. Please try one of: %s', ...
		Case, strjoin(cases,', '))
	return
end
% For each L (bandwidth) value in Ls
for L=Ls
	% For each b (buffer) value in buffers
	for b=buffers
		% Get the region to recover from
		if Case(1)=='C'
			% In this case use GRACE data
		else
			if Case(1)=='A'
				% Set dom2=dom1 so we can proceed as in B or BB
				dom2=dom1;
			end
		end
		% If we want noise add noise now
	end 
end