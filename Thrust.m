Hp        = 2000; %m
Mach      = 0.50;
fuelleft  = 0.100546404; %kg/s
fuelright = 0.102436374;%kg/s
Delta_T   =  5;    %degrees

Thrustcalc(Hp,Mach,Delta_T,fuelleft,fuelright)

function[Thrustlr] = Thrustcalc(Hp,Mach,Delta_T,fuelleft,fuelright)
%Hp [m],Mach [-],Delta_T[deg],fuelleft[kg/s],fuelright[kg/s]
%writing to file
array= [Hp, Mach,Delta_T,fuelleft,fuelright];
fileID = fopen('matlab.dat','w');
for i = 1:1:length(array)
fprintf(fileID,"%d\n",array(i));
end
fclose(fileID);


system('thrust.exe &');

%output
load("thrust.dat");
Thrustlr = thrust;
end