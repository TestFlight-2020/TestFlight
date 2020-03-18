
%inputs in pounds unless other unit is stated behind it

pounds_seat1 = 80/0.453592;
pounds_seat2 = 102/0.453592;
pounds_seat3 = 71/0.453592;
pounds_seat4 = 77/0.453592;
pounds_seat5 = 76/0.453592;
pounds_seat6 = 64/0.453592;
pounds_seat7 = 74/0.453592;
pounds_seat8 = 99/0.453592;
pounds_seat10 = 60/0.453592;
pounds_nose = 0;
pounds_aft1 = 0;
pounds_aft2 = 0;
pounds_FuelStartflight = 4100;

%seats contain 9x2 matrix with [x_cg_fromfront[inches],mass[pounds]] per
%seat
seatsflight = [131 pounds_seat1; 131 pounds_seat2; 214 pounds_seat3; 214 pounds_seat4; 251 pounds_seat5; 251 pounds_seat6; 288 pounds_seat7; 288 pounds_seat8; 170 pounds_seat10];

baggageflight = [74 pounds_nose; 321 pounds_aft1; 338 pounds_aft2];

A_payloadflight = [seatsflight;baggageflight];

pounds_payloadflight = sum(A_payloadflight(:,2));

BEM = [9165.0 291.65];      % [pounds inches]

pounds_ZFMflight = pounds_payloadflight + BEM(1,1);


