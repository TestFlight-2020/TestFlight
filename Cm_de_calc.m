%This script calculates the elevator control derivative Cm_de

% Aircraft Data
g = 9.81;
S = 30;
c = 2.0569;
b = 15.911;

% Inputs
TAT = 5
hp = 5760*0.3048
p0=101325
R = 287
gamma = 1.4
rho0 = 1.225
m = 6465.86095; % result is independent of mass
%rho = 0.6601;
vc = 82;    % TAS=113 , IAS=82
%TAS calculation-------------------------------------------------------
p = p0*((1-(0.0065*hp)/273.15)^(-9.81/(-0.0065*R)));
M025 = 1 + ((gamma-1)/(2*gamma)) * (rho0/p0) * vc.^2; 
M05 = M025.^(gamma/(gamma-1));
M1 = M05 - 1;
M2 = 1 + (p0./p).*M1; 
M3 = M2.^((gamma-1)/gamma);
M4 = M3 - 1 ;
M5 = (2/(gamma-1))*M4 ;
M6 = sqrt(M5);

Tlocal = (TAT+273.15)/(1+(gamma-1)/2*M6^2);

asound = sqrt(gamma*R*Tlocal);
rho = p/(R*Tlocal);
TAS = M6*asound;
%TAS
%calculation-------------------------------------------------------------------
x_cg = 261.56*0.0254+0.25*c;
m_pax = 99;
x1 = 288*0.0254;
x2 = 134*0.0254;
de1 = 0.1*(pi/180);
de2 = -0.5*(pi/180);

Cm_de = calcCm_de(g,c,m,rho,TAS,S,x_cg,m_pax,x1,x2,de1,de2)

function [Cm_de] = calcCm_de(g,c,m,rho,TAS,S,x_cg,m_pax,x1,x2,de1,de2)

Cn = m*g/(0.5*rho*TAS^2*S);

DeltaCm = -Cn / c * -2.357922652*0.0254 %m_pax*(x2-x1)/(m*g);
DeltaDe = de2-de1;

Cm_de = DeltaCm / DeltaDe;

end


