Hp        = 2060 %m
Mach      = 0.50
fuelleft  = 0.0400
fuelright = 0.0300
Delta_T   =  5
array= [Hp, Mach,Delta_T,fuelleft,fuelright]

fileID = fopen('matlab.dat','w');
for i = 1:1:length(array);
fprintf(fileID,"%d\n",array(i))
end
fclose(fileID);

system('thrust.exe &')

%Results of thrust right and thrust left engine are in thrust.dat