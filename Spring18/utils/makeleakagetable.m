domA='iceland';
bA=1.0;
domB='greenland';
bB=0.5;
L=60;
% iceland -> greenland
[slope1,slopeerror1,~,~,~]=measureleakage(domA,domB,bA,bB,0,L,'Paulson07');
[slope2,slopeerror2,~,~,~]=measureleakage(domA,domB,bA,bB,0,L,'Wangetal08');
[slope3,slopeerror3,~,~,~]=measureleakage(domA,domB,bA,bB,0,L,'none');
% greenland -> iceland
[slope4,slopeerror4,~,~,~]=measureleakage(domB,domA,bB,bA,0,L,'Paulson07');
[slope5,slopeerror5,~,~,~]=measureleakage(domB,domA,bB,bA,0,L,'Wangetal08');
[slope6,slopeerror6,~,~,~]=measureleakage(domB,domA,bB,bA,0,L,'none');
% make a table
headers='signal domain,recover domain,GIA model,trend'
sprintf('iceland(1.0),greenland(0.5),Paulson07,%d +- %d',slope1,slopeerror1)
sprintf('iceland(1.0),greenland(0.5),Wangetal08,%d +- %d',slope2,slopeerror2)
sprintf('iceland(1.0),greenland(0.5),none,%d +- %d',slope3,slopeerror3)
sprintf('greenland(0.5),iceland(1.0),Paulson07,%d +- %d',slope4,slopeerror4)
sprintf('greenland(0.5),iceland(1.0),Wangetal08,%d +- %d',slope5,slopeerror5)
sprintf('greenland(0.5),iceland(1.0),none,%d +- %d',slope6,slopeerror6)