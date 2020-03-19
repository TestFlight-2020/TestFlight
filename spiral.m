run("statespace_asymmetric.m");
load("ours.mat");


aoa = flightdata.vane_AOA.data;
t = flightdata.time.data;
sampling_rate = 1/(t(2)-t(1));
t_start = 36500;
t_end = t_start+3000;
t = t(t_start:t_end)-t(t_start);

hp = flightdata.Dadc1_alt.data(t_start)


V_0 = flightdata.Dadc1_cas.data(t_start)

ail_0 = flightdata.delta_a.data(t_start);
rud_0 = flightdata.delta_r.data(t_start);

ail = flightdata.delta_a.data(t_start:t_end)-ail_0;
ail = ail/180*pi;
rud = flightdata.delta_r.data(t_start:t_end)-rud_0;
rud = rud/180*pi;

r_0 =  flightdata.Ahrs1_bRollRate.data(t_start);
y_0 =  flightdata.Ahrs1_bYawRate.data(t_start);
roll_0 = flightdata.Ahrs1_Roll.data(t_start);

r =  flightdata.Ahrs1_bRollRate.data(t_start:t_end)-r_0;
ya =  flightdata.Ahrs1_bYawRate.data(t_start:t_end)-y_0;
roll = flightdata.Ahrs1_Roll.data(t_start:t_end)-roll_0;

y = lsim(asymmetric, [ail, rud], t);


tiledlayout(2,2);
% nexttile
% plot(t, input/pi*180);
% title("Elevator deflection from trim trimmed position");
% ylabel("[deg]");
% xlabel("[s]");
nexttile
plot(t, ail, t, rud);
legend("Simulation");
title("Sideslip");
ylabel("[deg]");
xlabel("[s]");
nexttile
plot(t, y(:,2), t, roll);
legend("Simulation", "Real flight");
title("Roll angle deviation");
ylabel("[deg]");
xlabel("[s]");
nexttile
plot(t, y(:,3), t, -r);
legend("Simulation", "Real flight");
title("Roll rate");
ylabel("[deg/s]");
xlabel("[s]");
nexttile
plot(t, y(:,4), t, ya);
legend("Simulation", "Real flight");
title("Yaw rate");
ylabel("[deg/s]");
xlabel("[s]");
