clear all;
close all;
clc;
Cm_delta = 1;
Cm_alpha = 1;
Cm_thrust = 1;
Cm0       = 0;
alpha0   = 0 ;%deg
Thrust     = 1000; %N
N=1;

deqlist = [];

for alpha = -10:0.1:10
    deq = elevator(Cm_delta,Cm0,Cm_alpha,alpha,alpha0,Cm_thrust,Thrust); 
    deqlist(N+1)=deq;
    N = N+1
end


plot(-10:0.1:10.1,deqlist);




function[deq] = elevator(Cm_delta,Cm0,Cm_alpha,alpha,alpha0,Cm_thrust,Thrust); 
deq = -1/Cm_delta*(Cm0+Cm_alpha*(alpha-alpha0)+Cm_thrust*Thrust);
end
