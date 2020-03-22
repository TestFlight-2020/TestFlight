clear all;
close all;
clc;

%run("Cit_par.m")

%parameters\
R = 287;
Cmdelta = -1.4227;% Also change in functions
Ws= 60500 ;%N 
M_empty = 9165*0.45359 ;%kg
d = 0.686;
rho0 = 1.225;
gamma = 1.4;
p0 = 101325;
%Payload+fuel
Wet_mass0= 2562.7; %kg
%Initial mass
W0 = (6329.8)*9.81; %N



%hp,IAS,a,de,detr,Fe,FFl,FFr,Fused,TAT
data = [6510	161	5.4	0.1	3.3	0	454	500	636	1.8;
6780	150	6.5	-0.4	3.3	-20	450	496	662	0.2;
7200	140	7.4	-1	3.3	-34	440	488	697	-0.5;
7540	130	8.6	-1.3	3.3	-45	437	484	721	-1.8;
6900	170	4.8	0.4	3.3	23	455	500	745	1.5;
6540	180	4	0.7	3.3	33	460	505	764	2.5;
6050	190	3.5	0.9	3.3	64	469	515	790	4];


hp = transpose(data(:,1))*0.3048; %m 
Vc = transpose(data(:,2))*0.51444;%kts to m/s
alpha = transpose(data(:,3))/180*pi;%deg to rad
de = transpose(data(:,4))/180*pi; %deg to rad
Fe = transpose(data(:,6)); %N
FFl = transpose(data(:,7))*1.25997e-4; %lbs/hr to kg/s
FFr = transpose(data(:,8))*1.25997e-4; %lbs/hr to kg/s
TAT = transpose(data(:,10));
Fe_reduced = [];
Fuel_standard = 0.048


%Reducing the Force
for a=1:1:length(Fe) ;
    temp = Fe(a)*Ws/(W0-data(a,9)*4.45);
    Fe_reduced = [Fe_reduced temp];
end


%Reducing Velocity
V_reduced = [];
Mach = [];
TAS  = [];
EAS  = [];
Tcorrect = [];
for a=1:1:length(Vc);
p = p0*((1-(0.0065*hp(a))/273.15)^(-9.81/(-0.0065*R)));
M025 = 1 + ((gamma-1)/(2*gamma)) * (rho0/p0) * Vc(a).^2; 
M05 = M025.^(gamma/(gamma-1));
M1 = M05 - 1;
M2 = 1 + (p0./p).*M1; 
M3 = M2.^((gamma-1)/gamma);
M4 = M3 - 1 ;
M5 = (2/(gamma-1))*M4 ;
M6 = sqrt(M5);
Mach = [Mach M6];
Tlocal = (TAT(a)+273.15)/(1+(gamma-1)/2*M6^2);
Tcorrect = [Tcorrect Tlocal];
asound = sqrt(gamma*R*Tlocal);
rho = p/(R*Tlocal);
TASl = M6*asound;
TAS = [TAS TASl];
EASl = TASl*sqrt(rho/rho0);
EAS  = [EAS EASl];
temp = EASl*sqrt(Ws/(W0-data(a,9)*4.45));
V_reduced = [V_reduced temp];
end

%Reducing Elevator
de_reduced = []
for b=1:1:length(Vc);
    Delta_T = Tcorrect(b)-(288.15-0.0065*hp(b))
    T = Thrustcalc(hp(b),Mach(b),Delta_T,FFl(b),FFr(b));
    T_stand = Thrustcalc(hp(b),Mach(b),Delta_T,Fuel_standard,Fuel_standard);
    detemp = elreduced(de(b),sum(T),sum(T_stand), EAS(b),rho0,d);
    de_reduced = [de_reduced detemp];
end

%\delta_{e_{e q}}^{*} \text { versus } \tilde{V}_{e}
%plotting
%elevator deflection
xq = min(V_reduced):0.01:max(V_reduced);
yq = interp1(V_reduced, de_reduced,xq,"spline");
figure();
hold on;
scatter(V_reduced,de_reduced);
plot(xq,yq);
hold off;
xlabel('V_{e}');
ylabel('\delta_{e_{e q}}^{*} (rad)');
grid on;
ax = gca;
set(ax, 'Ydir', 'reverse');
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';

%Stick force
xq2 = min(V_reduced):0.01:max(V_reduced);
yq2 = interp1(V_reduced, Fe_reduced,xq,"spline");
figure();
hold on;
scatter(V_reduced,Fe_reduced);
plot(xq2,yq2);
hold off;
xlabel('V_{e}');
ylabel('(F_{e}^{*}(N)')
grid on;
ax2 = gca;
set(ax2, 'Ydir', 'reverse');
ax2.XAxisLocation = 'origin';
ax2.YAxisLocation = 'origin';



[r,m,b] = regression(alpha,de);



x = 0:0.01:0.2;
y = m*x+b;

figure();
scatter(alpha,de);
hold on ;
plot(x,y);
hold off;
xlabel("\alpha (rad)");
ylabel("\delta_{e} (rad)");


grid on;
ax2 = gca;
set(ax2, 'Ydir', 'reverse');
ax2.XAxisLocation = 'origin';
ax2.YAxisLocation = 'origin';


Cmalpha = -Cmdelta*m;
m ;


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
close all;

%output
load("thrust.dat");
Thrustlr = thrust;
end

function[dereduced] = elreduced(de,T,T_stand,Vlocal,rho0,d);

CmT = -0.0064;
Cmdelta = -1.4227;
Tcs = T_stand/(0.5*rho0*Vlocal^2*d^2);
Tc = T/(0.5*rho0*Vlocal^2*d^2); % N ;
dereduced = de - 1/Cmdelta*CmT*(Tcs-Tc);
end

