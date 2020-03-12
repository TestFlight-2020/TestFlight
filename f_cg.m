% clear all;
% close all;
% clc;
load('matlab.mat')
%inputs in pounds unless other unit is stated behind it

pounds_seat1 = 95/0.453592;
pounds_seat2 = 92/0.453592;
pounds_seat3 = 66/0.453592;
pounds_seat4 = 61/0.453592;
pounds_seat5 = 75/0.453592;
pounds_seat6 = 78/0.453592;
pounds_seat7 = 86/0.453592;
pounds_seat8 = 68/0.453592;
pounds_seat10 = 74/0.453592;
pounds_nose = 0;
pounds_aft1 = 0;
pounds_aft2 = 0;
pounds_FuelStart = 4050;

%seats contain 9x2 matrix with [x_cg_fromfront[inches],mass[pounds]] per
%seat
seats = [131 pounds_seat1; 131 pounds_seat2; 214 pounds_seat3; 214 pounds_seat4; 251 pounds_seat5; 251 pounds_seat6; 288 pounds_seat7; 288 pounds_seat8; 170 pounds_seat10];

baggage = [74 pounds_nose; 321 pounds_aft1; 338 pounds_aft2];

A_payload = [seats;baggage];

pounds_payload = sum(A_payload(:,2));

BEM = [9165.0 291.65];      % [pounds inches]

pounds_ZFM = pounds_payload + BEM(1,1);


A = [100 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400 2500];

B = [298.16 591.18 879.08 1165.42 1448.40 1732.53 2014.80 2298.84 2581.92 2866.30 3150.18 3434.52 3718.52 4003.23 4287.76 4572.24 4856.56 5141.16 5425.64 5709.90 5994.04 6278.47 6562.82 6846.96 7131.00];

C = [2600 2700 2800 2900 3000 3100 3200 3300 3400 3500 3600 3700 3800 3900 4000 4100 4200 4300 4400 4500 4600 4700 4800 4900 5008];

D = [7415.33 7699.60 7984.34 8269.06 8554.05 8839.04 9124.80 9410.62 9696.97 9983.40 10270.08 10556.84 10843.87 11131.00 11418.20 11705.50 11993.31 12281.18 12569.04 12856.86 13144.73 13432.48 13720.56 14008.46 14320.34];

A_fuel = [transpose(A) transpose(B); transpose(C) transpose(D)];


Wlh = flightdata.lh_engine_FMF.data/3600;       %pounds/s
Wrh = flightdata.rh_engine_FMF.data/3600;       %pounds/s
time = flightdata.time.data;                    %s

W(3062,pounds_ZFM,pounds_FuelStart,Wlh,Wrh)
% cg(500,A_payload,BEM,pounds_FuelStart,pounds_ZFM,A_fuel,Wlh,Wrh)


function [Wans] = W(t,pounds_ZFM,pounds_FuelStart,Wlh,Wrh)
%This function calculates W(t1) = ramp mass - int_0^t1(fuelflow * dt) 
%The answer is in [lbs kg]
time = 9:0.1:t;
Wlhu = Wlh(1:length(time),1);
Wrhu = Wrh(1:length(time),1);
F_used = trapz(time,Wlhu)+trapz(time,Wrhu);                                     %needs to look at time in 
%measurement data and give F_used for that t --> FTIS
W_lbm = pounds_ZFM + pounds_FuelStart - F_used;
W_kg = W_lbm*0.453592;
Wans = [W_lbm W_kg];
end



function [cgans] = cg(t,A_payload,BEM,pounds_FuelStart,pounds_ZFM,A_fuel,Wlh,Wrh)
%This function calculates the cg location and gives at in 
%[inch meter fractionofMAC]
time = 9:0.1:t;
Wlhu = Wlh(1:length(time),1);
Wrhu = Wrh(1:length(time),1);
F_used = trapz(time,Wlhu)+trapz(time,Wrhu);                           %FTIS must give this
Fuel = pounds_FuelStart - F_used;    %pounds
s = transpose(A_payload(:,2));
b = A_payload(:,1);
Fuel2M = griddedInterpolant(A_fuel(:,1),A_fuel(:,2)*100);         %pound-inch
Mtot = s*b + Fuel2M(Fuel) + BEM(1,1)*BEM(1,2);
a = W(t,pounds_ZFM,pounds_FuelStart,Wlh,Wrh);
cg_in = Mtot/a(1,1) - 261.56;            %inch from the leading edge of the MAC
cg_m = cg_in*0.0254;
cg_pMAC = cg_in/80.98;
cgans = [cg_in cg_m cg_pMAC];
end
