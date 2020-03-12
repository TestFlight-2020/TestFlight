clear all;
close all;
clc;
load("matlab.mat")
load("Thrust.m")
%parameters
Cmdelta = -0.1293;
Weight0 = 60500 ;%N 

time = [2239,2351,2484,2576,2741,2840,2920];

%hp,IAS,a,de,detr,Fe,FFl,FFr,Fused,TAT
data = [6060	161	5.3	0	2.8	0	462	486	664	5.5;
6350	150	6.3	-0.4	2.8	-23	458	482	694	4.5;
6550	140	7.3	-0.9	2.8	-29	454	477	730	3.5;
6880	130	8.5	-1.5	2.8	-46	449	473	755	2.5;
6160	173	4.5	0.4	2.8	26	465	489	798	5.0;
5810	179	4.1	0.6	2.8	40	472	496	825	6.2;
5310	192	3.4	1	2.8	83	482	505	846	8.2];

V = transpose(data(:,2))*0.51444;%kts to m/s
Fe = transpose(data(:,6)); %N
alpha = transpose(data(:,3))/180*pi;%deg to rad
de = transpose(data(:,4))/180*pi; %deg to rad
Fe_reduced = [];

%Reducing the Force
for a=1:1:length(Fe) ;
    temp = Fe(a)*((Weight0/9.81-data(a,9)*0.4535)/(Weight0/9.81))^(-1);
    Fe_reduced = [Fe_reduced temp];
end


%Reducing Velocity
V_reduced = [];
for a=1:1:length(V);
    temp = V(a)*sqrt((Weight0/9.81-data(a,9))/(Weight0/9.81))^(-1);
    V_reduced = [V_reduced temp];
end

%plotting
%elevator deflection
xq = min(V_reduced):0.01:max(V_reduced)
yq = interp1(V_reduced, de,xq,"spline")
figure();
hold on
scatter(V_reduced,de);
plot(xq,yq)
hold off
xlabel('Vreduced (m/s)');
ylabel('Elevator deflection (rad)');
grid on
ax = gca;
set(ax, 'Ydir', 'reverse')
ax.XAxisLocation = 'origin'
ax.YAxisLocation = 'origin'

%Stick force
xq2 = min(V_reduced):0.01:max(V_reduced)
yq2 = interp1(V_reduced, Fe_reduced,xq,"spline")
figure();
hold on
scatter(V_reduced,Fe_reduced);
plot(xq2,yq2)
hold off
xlabel('Vreduced (m/s)');
ylabel('Stick force reduced(N)')
grid on
ax2 = gca;
set(ax2, 'Ydir', 'reverse');
ax2.XAxisLocation = 'origin'
ax2.YAxisLocation = 'origin'



[r,m,b] = regression(alpha,de);



x = 0:0.01:0.2
y = m*x+b

figure();
scatter(alpha,de);
hold on 
plot(x,y)
hold off
xlabel("Alpha (rad)");
ylabel("Elevator deflection (rad)");


grid on
ax2 = gca;
set(ax2, 'Ydir', 'reverse');
ax2.XAxisLocation = 'origin'
ax2.YAxisLocation = 'origin'


Cmalpha = -Cmdelta*m
m 

Hp        = 2060; %m
Mach      = 0.50;
fuelleft  = 0.0400; %kg/s
fuelright = 0.0300;%kg/s
Delta_T   =  5;    %degrees


Thrustcalc(Hp, Mach,Delta_T,fuelleft,fuelright)