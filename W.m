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