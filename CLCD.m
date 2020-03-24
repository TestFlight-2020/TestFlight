clear all;
close all;
clc;

run('refdataone.m');
run('flightdataone.m')

A_measurementref = [1157 5010 249 1.7 798 813 360 12.5; 
1297 5020 221 2.4 673 682 412 10.5;
1426 5020 192 3.6 561 579 447 8.8;
1564 5030 163 5.4 463 484 478 7.2;
1787 5020 130 8.7 443 467 532 6;
1920 5110 118 10.6 474 499 570 5.2];  

A_measurementflight = [1130 5030 251 1.6 770 806 367 10.2; 
1258 5030 221 2.4 638 670 422 7.8; 
1398 5020 190 3.7 533 579 456 5;
1530 5040 161 5.6 444 488 492 4; 
1664 5040 134 8.5 420 450 521 2.2; 
1763 5030 121 10.4 420 450 545 1.5]; %look in to the temperatures

T0 = [273.15;273.15;273.15;273.15;273.15;273.15];
T02 = [288.15;288.15;288.15;288.15;288.15;288.15];

Hpf        = A_measurementflight(:,2)*0.3048; %m
Machf      = M(A_measurementflight);
fuelleftf  = A_measurementflight(:,5)*0.000125998; %kg/s 
fuelrightf = A_measurementflight(:,6)*0.000125998;%kg/s
aewf       = (ones(6,1)+0.2*Machf.^2);
Delta_Tf   = (A_measurementflight(:,8)+T0)./aewf - (T02 - 0.0065*Hpf);    %degrees

Hpr        = A_measurementref(:,2)*0.3048; %m
Machr      = M(A_measurementref);
fuelleftr  = A_measurementref(:,5)*0.000125998; %kg/s 
fuelrightr = A_measurementref(:,6)*0.000125998;%kg/s
aewr       = (ones(6,1)+0.2*Machr.^2);
Delta_Tr   = (A_measurementref(:,8)+T0)./aewr - (T02 - 0.0065*Hpr);    %degrees



%Flight data processing
A = (15.911^2)/30.00;
clf = cl(pounds_ZFMflight,pounds_FuelStartflight,A_measurementflight);
clf2 = clf.^2;
cdf = cd(Hpf,Machf,Delta_Tf,fuelleftf,fuelrightf,A_measurementflight);

alphaf = A_measurementflight(:,4)*pi/180;
Xf = [ones(6,1) alphaf];
clafq = mldivide(Xf,clf);
cl0f = clafq(1,1);
claf =clafq(2,1);

Mf =  [ones(6,1) clf2];
usef = mldivide(Mf,cdf);
cd0f = usef(1,1);
ef = 1/(A*pi*(usef(2,1)));



%Reference data processing
A = (15.911^2)/30.00;
clr = cl(pounds_ZFMr,pounds_FuelStartr,A_measurementref);
clr2 = clr.^2;
cdr = cd(Hpr,Machr,Delta_Tr,fuelleftr,fuelrightr,A_measurementref);


alphar = A_measurementref(:,4)*pi/180;
Xr = [ones(5,1) alphar(1:5,1)];
clarq = mldivide(Xr,clr(1:5,1));
cl0r = clarq(1,1);
clar = clarq(2,1);

Mr =  [ones(5,1) clr2(1:5,1)];
user = mldivide(Mr,cdr(1:5,1));
cd0r = user(1,1);
er = 1/(A*pi*(user(2,1)));


% subplot(1,2,1);
% scatter(A_measurementref(:,4),clr); 
% hold on;
% ar = -2:0.1:12;
% plot(ar,(cl0r+clar*ar*pi/180));
% title("C_L_\alpha reference data");
% ylabel("C_L [-]");
% xlabel("\alpha [deg]");
% dim = [0.25 0.2 0.35 0.1];
% str1 = {'Cruise configuration','Mach range 0.1925-0.4081','Reynolds number range 7.9064-16.8090 (10^6)'}; % 7906400.177-16808993.42
% annotation('textbox',dim,'String',str1,'FitBoxToText','on');
% 
% subplot(1,2,2);
% scatter(A_measurementflight(:,4),clf);
% hold on;
% af = -2:0.1:12;
% plot(af,(cl0f+claf*af*pi/180));
% title("C_L_\alpha flight data");
% ylabel("C_L [-]");
% xlabel("\alpha [deg]");
% dim = [0.675 0.2 0.775 0.1];
% str2 = {'Cruise configuration','Mach range 0.1972-0.4115','Reynolds number range 8.1178-16.9395 (10^6)'}; %8117768.57-16939461.29
% annotation('textbox',dim,'String',str2,'FitBoxToText','on');


% subplot(1,2,1);
% plot(cdr,clr);
% title("Lift over drag curve reference data");
% ylabel("C_L [-]");
% xlabel("C_D [-]");
% dim = [0.25 0.2 0.35 0.1];
% str1 = {'Cruise configuration','Mach range 0.1925-0.4081','Reynolds number range 7.9064-16.8090 (10^6)'}; % 7906400.177-16808993.42
% annotation('textbox',dim,'String',str1,'FitBoxToText','on');
% 
% subplot(1,2,2);
% plot(cdf,clf);
% title("Lift over drag curve flight data");
% ylabel("C_L [-]");
% xlabel("C_D [-]");
% dim = [0.675 0.2 0.775 0.1];
% str2 = {'Cruise configuration','Mach range 0.1972-0.4115','Reynolds number range 8.1178-16.9395 (10^6)'}; %8117768.57-16939461.29
% annotation('textbox',dim,'String',str2,'FitBoxToText','on');


% 'cla flight data [1/rad]'
% 'cla refernce data [1/rad]'
% cl0 flight data [-]
% cl0 reference data
% 'Oswald effiency factor flight data [-]'
% 'Oswald effiency factor reference data [-]'
% 'CD0 flight data [-]'
% 'CD0 reference data [-]'
Jonasdat = [claf;clar;cl0f;cl0r;ef;er;cd0f;cd0r]

function [W_kg] = W_loc(N_m,pounds_ZFM,pounds_FuelStart,A_measurement)
F_used = A_measurement(N_m,7);                    
W_lbm = pounds_ZFM + pounds_FuelStart - F_used;
W_kg = W_lbm*0.453592;
end

function [M_TAS] = M(A_measurement)
M_ans = zeros(length(A_measurement(:,1)),1);
%V_conv = 
% IAS2CAS = griddedInterpolant(V_conv(:,1),V_conv(:,2));
for i = 1:length(A_measurement(:,1))
    gamma = 1.4;                 % constant
    p0 = 101325;                % pressure at sea level [Pa]
    rho0 = 1.2250;              % air density at sea level [kg/m^3] 
    lambda = -0.0065;           % temperature gradient in ISA [K/m]
    T0 = 288.15;                % temperature at sea level in ISA [K]
    R = 287.05;                 % specific gas constant [m^2/sec^2K]
    g0 = 9.81;                  % [m/sec^2] (gravity constant)
    S = 30.00;                  % wing area [m^2]
    V_cas = (A_measurement(i,3)-2)*0.514444;        % calibrated airspeed [m/s]
    p = p0*(1+(lambda*(A_measurement(i,2)*0.3048))/T0)^(-g0/(lambda*R));
    Ms1 = 1 + ((gamma-1)/(2*gamma))*(rho0/p0)*(V_cas)^2; 
    Ms2 = Ms1^(gamma/(gamma-1));
    Ms3 = Ms2 - 1;
    Ms4 = 1 + (p0/p)*Ms3;
    Ms5 = Ms4^((gamma-1)/gamma);
    Ms6 = Ms5 - 1;
    Ms7 = (2/(gamma-1))*Ms6;
    M = sqrt(Ms7);
    M_ans(i,1) = M;
end
M_TAS = M_ans;
end

function[Thrustlr] = Thrustcalc(Hp,Mach,Delta_T,fuelleft,fuelright)
%Hp [m],Mach [-],Delta_T[deg],fuelleft[kg/s],fuelright[kg/s]
%writing to file
array= [Hp; Mach;Delta_T;fuelleft;fuelright];
fileID = fopen('matlab.dat','w');
for i = 1:1:length(array)
fprintf(fileID,"%d\n",array(i,1));
end
fclose(fileID);


system('thrust.exe &');

%output
load("thrust.dat");
Thrustlr = thrust;
end

function [V_EAS] = VE(A_measurement)
V_ans = zeros(length(A_measurement(:,1)),1);
%V_conv = 
% IAS2CAS = griddedInterpolant(V_conv(:,1),V_conv(:,2));
for i = 1:length(A_measurement(:,1))
    gamma = 1.4;                 % constant
    p0 = 101325;                % pressure at sea level [Pa]
    rho0 = 1.2250;              % air density at sea level [kg/m^3] 
    lambda = -0.0065;           % temperature gradient in ISA [K/m]
    T0 = 288.15;                % temperature at sea level in ISA [K]
    R = 287.05;                 % specific gas constant [m^2/sec^2K]
    g0 = 9.81;                  % [m/sec^2] (gravity constant)
    S = 30.00;                  % wing area [m^2]
    V_cas = (A_measurement(i,3)-2)*0.514444;        % calibrated airspeed [m/s]
    p = p0*(1+(lambda*(A_measurement(i,2)*0.3048))/T0)^(-g0/(lambda*R));
    Ms1 = 1 + ((gamma-1)/(2*gamma))*(rho0/p0)*(V_cas)^2; 
    Ms2 = Ms1^(gamma/(gamma-1));
    Ms3 = Ms2 - 1;
    Ms4 = 1 + (p0/p)*Ms3;
    Ms5 = Ms4^((gamma-1)/gamma);
    Ms6 = Ms5 - 1;
    Ms7 = (2/(gamma-1))*Ms6;
    M = sqrt(Ms7);
    T = (A_measurement(i,8)+273.15)/(1+((gamma-1)/2)*M^2);
    a = sqrt(gamma*R*T);
    rho = p/(R*T);
    V_ans(i,1) = M*a*sqrt(rho/rho0);
end
V_EAS = V_ans;
end

function [V_TAS] = VT(A_measurement)
V_ans = zeros(length(A_measurement(:,1)),1);
rho_ans = zeros(length(A_measurement(:,1)),1);
%V_conv = 
% IAS2CAS = griddedInterpolant(V_conv(:,1),V_conv(:,2));
for i = 1:length(A_measurement(:,1))
    gamma = 1.4;                 % constant
    p0 = 101325;                % pressure at sea level [Pa]
    rho0 = 1.2250;              % air density at sea level [kg/m^3] 
    lambda = -0.0065;           % temperature gradient in ISA [K/m]
    T0 = 288.15;                % temperature at sea level in ISA [K]
    R = 287.05;                 % specific gas constant [m^2/sec^2K]
    g0 = 9.81;                  % [m/sec^2] (gravity constant)
    S = 30.00;                  % wing area [m^2]
    V_cas = (A_measurement(i,3)-2)*0.514444;        % calibrated airspeed [m/s]
    p = p0*(1+(lambda*(A_measurement(i,2)*0.3048))/T0)^(-g0/(lambda*R));
    Ms1 = 1 + ((gamma-1)/(2*gamma))*(rho0/p0)*(V_cas)^2; 
    Ms2 = Ms1^(gamma/(gamma-1));
    Ms3 = Ms2 - 1;
    Ms4 = 1 + (p0/p)*Ms3;
    Ms5 = Ms4^((gamma-1)/gamma);
    Ms6 = Ms5 - 1;
    Ms7 = (2/(gamma-1))*Ms6;
    M = sqrt(Ms7);
    T = (A_measurement(i,8)+273.15)/(1+((gamma-1)/2)*M^2);
    a = sqrt(gamma*R*T);
    rho_ans(i,1) = p/(R*T);
    V_ans(i,1) = M*a;
end
V_TAS = [V_ans rho_ans];
end

function [CD] = cd(Hp,Mach,Delta_T,fuelleft,fuelright,A_measurement)
wer = VT(A_measurement);
V_t = wer(:,1);
rho = wer(:,2);
CD_ans = zeros(length(A_measurement(:,1)),1);
for i = 1:length(A_measurement(:,1))
    g0 = 9.81;                  % [m/sec^2] (gravity constant)
    S = 30.00;                  % wing area [m^2]
    rho0 = 1.2250;              % air density at sea level [kg/m^3]
    A = Thrustcalc(Hp(i,1),Mach(i,1),Delta_T(i,1),fuelleft(i,1),fuelright(i,1));
    Th = A(1,1)+A(1,2);
    CD_ans(i,1) = Th/(0.5*(rho(i,1))*(V_t(i,1)^2)*S);
end
CD = CD_ans;
end


function [CL] = cl(pounds_ZFM,pounds_FuelStart,A_measurement)
V_e = VE(A_measurement); 
CL_ans = zeros(length(A_measurement(:,1)),1);
for i = 1:length(A_measurement(:,1))
    g0 = 9.81;                  % [m/sec^2] (gravity constant)
    S = 30.00;                  % wing area [m^2]
    rho0 = 1.2250;              % air density at sea level [kg/m^3]
    CL_ans(i,1) = (W_loc(i,pounds_ZFM,pounds_FuelStart,A_measurement)*g0)/(0.5*rho0*(V_e(i,1)^2)*S);
end
CL = CL_ans;
end
