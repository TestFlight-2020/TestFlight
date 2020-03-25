clear all;
close all;
clc;

run("Cit_par.m")

% Asymmetric Motion
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

asymmetric = ss(A,B,C,D);
asymmetric.OutputName = ["Side Slip Angle", "Bank Angle", "Roll Rate", "Yaw Rate"];

eig(asymmetric.A)
t = 0:0.01:30;
[P,D] = eig(asymmetric.A)
first = P(:,1) .* [exp(1).^(D(1,1)*t)];
second = P(:,2) .* [exp(1).^(D(2,2)*t)];
third = P(:,3) .* [exp(1).^(D(3,3)*t)];
fourth = P(:,4) .* [exp(1).^(D(4,4)*t)];

tiledlayout(2,2);
nexttile
plot(t, real(first(1,:)), t, real(second(1,:)), t, real(third(1,:)), t, real(fourth(1,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Sideslip")
ylabel("[deg]");
xlabel("[s]");

nexttile
plot(t, real(first(2,:)), t, real(second(2,:)), t, real(third(2,:)), t, real(fourth(2,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Roll angle deviation");
ylabel("[deg]");
xlabel("[s]");

nexttile
plot(t, real(first(3,:)), t, real(second(3,:)), t, real(third(3,:)), t, real(fourth(3,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Roll rate");
ylabel("[deg/s]");
xlabel("[s]");

nexttile
plot(t, real(first(4,:)), t, real(second(4,:)), t, real(third(4,:)), t, real(fourth(4,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Yaw Rate");
ylabel("[deg]");
xlabel("[s]");

% u = zeros(size(t, 2), 2);
% u(5/0.01:7.5/0.01, 1) = 1 * pi/180;
% u(7.5/0.01:10/0.01, 1) = -1 * pi/180;
% lsim(asymmetric, u, t)
