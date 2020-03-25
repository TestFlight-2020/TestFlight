clear all;
close all;
clc;

run("Cit_par.m")

% Symmetric Motion
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
C1(4,4) = -2*muc*KY2*Dc;

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
C(2,4) = -7.16/V0;
D = [0;0;0;0];

symmetric = ss(A,B,C,D);
symmetric.OutputName = ["Velocity deviation", "Angle of Attack", "Pitch angle", "Pitch Rate"];

A
t = 0:0.01:30;
[P,D] = eig(symmetric.A)
first = P(:,1) .* [exp(1).^(D(1,1)*t)];
second = P(:,2) .* [exp(1).^(D(2,2)*t)];
third = P(:,3) .* [exp(1).^(D(3,3)*t)];
fourth = P(:,4) .* [exp(1).^(D(4,4)*t)];

tiledlayout(2,2);
nexttile
plot(t, real(first(1,:)), t, real(second(1,:)), t, real(third(1,:)), t, real(fourth(1,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Speed deviation")
ylabel("[m/s]");
xlabel("[s]");

nexttile
plot(t, real(first(2,:)), t, real(second(2,:)), t, real(third(2,:)), t, real(fourth(2,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Angle of attack deviation");
ylabel("[deg]");
xlabel("[s]");

nexttile
plot(t, real(first(3,:)), t, real(second(3,:)), t, real(third(3,:)), t, real(fourth(3,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Pitch deviation");
ylabel("[deg]");
xlabel("[s]");

nexttile
plot(t, real(first(4,:)), t, real(second(4,:)), t, real(third(4,:)), t, real(fourth(4,:)))
legend("First Eigenmotion", "Second Eigenmotion", "Third Eigenmotion", "Fourth Eigenmotion")
title("Pitch rate deviation");
ylabel("[deg]");
xlabel("[s]");

%  u = -0.5/180*pi*ones(size(t));
%  u(1:5/0.01) = 0;
%  u(7/0.01:end) = 0;
% lsim(symmetric, u, t)
%initial(symetric, [0, 2/180*pi, 2/180*pi, 0], t)
%impulse(symmetric, 100)
