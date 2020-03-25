clear all;
close all;
clc;

run("Cit_par.m")

% Asimp_sp = zeros(2,2);
% 
 Dc = c/V0;
% 
% Asimp_sp(1,1)=CZa/(2*muc*Dc);
% Asimp_sp(1,2)=1/Dc;
% Asimp_sp(2,1)=(CZa*Cmadot/(4*muc^2*KY2*Dc))+(Cma/(2*muc*KY2*Dc));
% Asimp_sp(2,2)=(Cmadot+Cmq)/(2*muc*KY2*Dc);
% 
% Asimp_sp
% eig(Asimp_sp)

% Asimp_dr = zeros(2,2);
% 
 Db = b/V0;

% Asimp_dr(1,1) = CYb/(2*mub*Db);
% Asimp_dr(1,2) = -2/Db;
% Asimp_dr(2,1) = Cnb/(4*mub*KZ2*Db);
% Asimp_dr(2,2) = Cnr/(4*mub*KZ2*Db);
% 
% Asimp_dr
% eig(Asimp_dr)
% 
% C1_dr = zeros(2,2);
% C1_dr(1,1)=-2*mub*Db;
% C1_dr(2,2)=-4*mub*KZ2*Db;
% 
% C2_dr = zeros(2,2);
% 
% C2_dr(1,1)=CYb;
% C2_dr(1,2)=-4*mub;
% C2_dr(2,1)=Cnb;
% C2_dr(2,2)=Cnr;
% 
% Asimp_dr2 = -inv(C1_dr)*C2_dr
% Asimp_dr
% eig(Asimp_dr)
% 
% 
% C1_ph = zeros(3,3);
% C1_ph(1,1) = -2*muc*Dc;
% C1_ph(3,2)=-Dc;
% 
% C2_ph = zeros(3,3);
% C2_ph(1,1)=CXu;
% C2_ph(1,2)=CZ0;
% C2_ph(2,1)=CZu;
% C2_ph(2,3)=2*muc;
% C2_ph(3,3)=1;
% 
% Asimp_ph_inv = -C1_ph*inv(C2_ph)
% eigenv=eig(Asimp_ph_inv)
% eigenv.^(-1)
% 
% 
C1_sp = zeros(4,4);
C1_sp(2,2)=-(1/2)*Db;

C2_sp = zeros(4,4);
C2_sp(1,1)=CYb;
C2_sp(1,2)=CL;
C2_sp(1,4)=-4*mub;
C2_sp(2,3)=1;
C2_sp(3,1)=Clb;
C2_sp(3,3)=Clp;
C2_sp(3,4)=Clr;
C2_sp(4,1)=Cnb;
C2_sp(4,3)=Cnp;
C2_sp(4,4)=Cnr;

Asimp_sp_inv = -C1_sp*inv(C2_sp)
eigenv=eig(Asimp_sp_inv)
eigenv.^(-1)
