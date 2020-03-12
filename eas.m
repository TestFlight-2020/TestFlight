function [V_e]= eas(t, lambda, Temp0, g, R, flightdata, pounds_ZFM,pounds_FuelStart,Wlh,Wrh, time)
%This function calculates the Equivalent Aispeed
%Constants:
run("Cit_par.m");
p0 = 101325;
gamma = 1.4;
W_s = 60500; %N
t_0 = 9;
%Inputs:
alt = flightdata.Dadc1_alt.data;
hp = alt.*0.3048;
cas = flightdata.Dadc1_cas.data;
V_c = cas.*0.514444;
sat = flightdata.Dadc1_sat.data;
Tm = sat + 273.15;

%tHZ = 10*(t-t_0) + 1;
tHZ = find(time==t);

hp_t = hp(tHZ);
V_c_t = V_c(tHZ);
Tm_t = Tm(tHZ);



W1=W(t,pounds_ZFM,pounds_FuelStart,Wlh,Wrh);
W2=W1(2);


%P 
p = p0* ( (1 + ((lambda*hp_t)/Temp0)).^(-(g/(lambda*R))));
%M
M025 = 1 + ((gamma-1)/(2*gamma)) * (rho0/p0) * V_c_t.^2; 
M05 = M025.^(gamma/(gamma-1));
M1 = M05 - 1;
M2 = 1 + (p0./p).*M1; 
M3 = M2.^((gamma-1)/gamma);
M4 = M3 - 1 ;
M5 = (2/(gamma-1))*M4 ;
M6 = sqrt(M5);
%T 
T = Tm_t./(1+((gamma-1)/2).*M6.^2);
%a
a = sqrt( gamma*R*T);
%V_t
V_t = M6.*a;
%rho --> from perfect gas law
rhoreduction1 = R .* T;
rhoreduction2 = p.* (1./rhoreduction1);
%V_e
V_e = V_t .* sqrt((rhoreduction2./rho0))
V_e_bar = V_e * sqrt(W_s/W2)
end
