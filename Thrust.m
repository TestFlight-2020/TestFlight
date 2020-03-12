Hp        = 6060 %ft
Mach      = 10
fuelleft  = 400
fuelright = 300
Delta_T   =  10
array= [Hp, Mach,fuelleft,fuelright,Delta_T]

fileID = fopen('matlab.dat','w');
for i = 1:1:length(array);
fprintf(fileID,"%d\n",array(i))
end
fclose(fileID);
