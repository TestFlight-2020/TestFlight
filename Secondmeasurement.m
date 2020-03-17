clear all;
close all;
clc;





%parameters\
Mach = 0.26 %CHAAAAAAAAAAAAAAAAAAAANGE
Cmdelta = -0.1293;% Also change in functions
Ws= 60500 ;%N 
M_empty = 9165*0.45359 %kg
d = 0.686
rho = 1.225
%Payload+fuel
Wet_mass0= 2648.7; %kg
%Initial mass
W0 = (M_empty+Wet_mass0)*9.81 %N

time = [1800, 1877,1920,1980,2100,2160,2220];

%hp,IAS,a,de,detr,Fe,FFl,FFr,Fused,TAT
data = [7120	162	5.5	-0.2	2.6	0	472	513	580	8.5;
7420	152	6.3	-0.7	2.6	-11	465	506	602	7.8;
7730	142	7.4	-1.2	2.6	-29	462	500	626	6.5;
8020	133	8.6	-1.7	2.6	-37	456	494	644	5.8;
7390	172	4.6	0.1	2.6	17	471	512	671	8.2;
7130	182	4.1	0.5	2.6	36	476	516	681	9.2;
6780	192	3.5	0.7	2.6	58	483	523	700	10.5];

hp = transpose(data(:,1))*0.3048 %m 
V = transpose(data(:,2))*0.51444;%kts to m/s
alpha = transpose(data(:,3))/180*pi;%deg to rad
de = transpose(data(:,4))/180*pi; %deg to rad
Fe = transpose(data(:,6)); %N
FFl = transpose(data(:,7))*1.25997e-4 %lbs/hr to kg/s
FFr = transpose(data(:,8))*1.25997e-4 %lbs/hr to kg/s
Delta_T = transpose(data(:,10))
Fe_reduced = [];
Fuel_standard = 0.048


%Reducing the Force
for a=1:1:length(Fe) ;
    temp = Fe(a)*Ws/(W0-data(a,9)*4.45);
    Fe_reduced = [Fe_reduced temp];
end


%Reducing Velocity
V_reduced = [];
for a=1:1:length(V);
    temp = V(a)*sqrt(Ws/(W0-data(a,9)*4.45));
    V_reduced = [V_reduced temp];
end

%Reducing Elevator
de_reduced = []
for b=1:1:length(V);
    T = Thrustcalc(hp(b),Mach,Delta_T(b),FFl(b),FFr(b))
    T_stand = Thrustcalc(hp(b),Mach,Delta_T(b),Fuel_standard,Fuel_standard)
    detemp = elreduced(de(b),sum(T),sum(T_stand), V(b),rho,d)
    de_reduced = [de_reduced detemp];
end


%plotting
%elevator deflection
xq = min(V_reduced):0.01:max(V_reduced);
yq = interp1(V_reduced, de_reduced,xq,"spline");
figure();
hold on;
scatter(V_reduced,de_reduced);
plot(xq,yq);
hold off;
xlabel('Vreduced (m/s)');
ylabel('Elevator deflection (rad)');
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
xlabel('Vreduced (m/s)');
ylabel('Stick force reduced(N)')
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
xlabel("Alpha (rad)");
ylabel("Elevator deflection (rad)");


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

function[dereduced] = elreduced(de,T,T_stand,Vlocal,rho,d);
run("Cit_par")
CmT = -0.0064
Cmdelta = -0.1293
Tcs = T_stand/(0.5*rho*Vlocal^2*d^2)
Tc = T/(0.5*rho*Vlocal^2*d^2) % N 
dereduced = de - 1/Cmdelta*CmT*(Tcs-Tc)
end

