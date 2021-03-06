clear all;
close all;
clc;

run("Cit_par.m")

% Symetric Motion
M = eye(4);
M(1,1) = V0;
M(4,4) = V0/c;
M = inv(M);

Dc = c/V0;

C1 = zeros(4,4);
C1(1,1) = -2*muc*Dc;
C1(2,2) = (CZa-2*muc)*Dc;
C1(3,3) = -Dc;
C1(4,2) = Cma*Dc;
C1(4,4) = -2*muc*KY2*Dc;      %sqare or no square?

C2 = zeros(4,4);
C2(1,1) = CXu;
C2(1,2) = CXa;
C2(1,3) = CZ0;
C2(1,4) = CXq;

C2(2,1) = CZu;
C2(2,2) = CZa;
C2(2,3) = -CX0;
C2(2,4) = (CZq+2*muc);

C2(3,4) = 1;

C2(4,1) = Cmu;
C2(4,2) = Cma;
C2(4,4) = Cmq;

C1 = C1*M;
C2 = C2*M;

C3 = [CXde; CZde; 0; Cmde];

A = -1*inv(C1)*C2;
B = -1*inv(C1)*C3;

C = eye(4);
C(2,2) = 180/pi;
C(3,3) = 180/pi;
C(4,4) = 180/pi;
D = [0;0;0;0];

symetric = ss(A,B,C,D);

eig(symetric.A)
t = 0:0.01:300;
u = -0.4/180*pi*ones(size(t));
u(2000:end) = 0;
lsim(symetric, u, t)
