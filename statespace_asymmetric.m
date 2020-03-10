clear all;
close all;
clc;

run("Cit_par.m")

% Symetric Motion
M = eye(4);
M(3,3) = 2*V0/b;
M(4,4) = 2*V0/b;
M = inv(M);

Db = b/V0;

C1 = zeros(4,4);
C1(1,1) = (CYb-2*mub)*Db;
C1(2,2) = -0.5*Db;
C1(3,3) = -4*mub*KX2*Db;
C1(4,4) = -4*mub*KZ2*Db;
C1(4,1) = Cnb*Db;
C1(4,3) = 4*mub*KXZ*Db;
C1(3,4) = 4*mub*KXZ*Db;

C2 = zeros(4,4);
C2(1,1) = CYb;
C2(1,2) = CL;
C2(1,3) = CYp;
C2(1,4) = CYr-4*mub;

C2(2,1) = 0;
C2(2,2) = 0;
C2(2,3) = 1;
C2(2,4) = 0;

C2(3,1) = Clb;
C2(3,2) = 0;
C2(3,3) = Clp;
C2(3,4) = Clr;

C2(4,1) = Cnb;
C2(4,2) = 0;
C2(4,3) = Cnp;
C2(4,4) = Cnr;

C1 = C1*M;
C2 = C2*M;

C3 = [CYda, CYdr;
      0, 0;
      Clda, Cldr;
      Cnda, Cndr];

A = -1*inv(C1)*C2;
B = -1*inv(C1)*C3;

C = eye(4);
C(1,1) = 180/pi;
C(2,2) = 180/pi;
C(3,3) = 180/pi;
C(4,4) = 180/pi;
D = [0, 0;
     0, 0;
     0, 0;
     0, 0];

symetric = ss(A,B,C,D);

eig(symetric.A)
t = 0:0.01:300;
u = -3/180*pi*ones(size(t), 2);
lsim(symetric, u, t)
