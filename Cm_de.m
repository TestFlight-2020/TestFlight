%This script calculates the elevator control derivative Cm_de

% Aircraft Data
g = 9.81;
S = 30;
c = 2.0569;
b = 15.911;

% Inputs
m = 6660; % result is independent of mass
rho = 0.6601;
v_tas = 113;    % TAS=113 , IAS=82
x_cg = 261.56*0.0254+0.25*c;
m_pax = 75;
x1 = 288*0.0254;
x2 = 134*0.0254;
de1 = 0*(pi/180);
de2 = -0.5*(pi/180);

Cm_de = calcCm_de(g,c,m,rho,v_tas,S,x_cg,m_pax,x1,x2,de1,de2)

function [Cm_de] = calcCm_de(g,c,m,rho,v_tas,S,x_cg,m_pax,x1,x2,de1,de2)

Cn = m*g/(0.5*rho*v_tas^2*S);

DeltaCm = -Cn / c * m_pax*(x2-x1)/(m*g);
DeltaDe = de2-de1;

Cm_de = DeltaCm / DeltaDe;

end


