Hp        = 2060; %m
Mach      = 0.50;
fuelleft  = 0.0400; %kg/s
fuelright = 0.0300;%kg/s
Delta_T   =  5;    %degrees

Thrustcalc(Hp,Mach,Delta_T,fuelleft,fuelright)

function[Thrustlr] = Thrustcalc(Hp,Mach,Delta_T,fuelleft,fuelright)
%Hp [m],Mach [-],Delta_T[deg],fuelleft[kg/s],fuelright[kg/s]
%writing to file
array= [Hp, Mach,Delta_T,fuelleft,fuelright];
fileID = fopen('matlab.dat','w');
for i = 1:1:length(array);
fprintf(fileID,"%d\n",array(i));
end
fclose(fileID);


system('thrust.exe &');

%output
load("thrust.dat");
Thrustlr = thrust;
end