pounds_seat1r = 95/0.453592;
pounds_seat2r = 92/0.453592;
pounds_seat3r = 66/0.453592;
pounds_seat4r = 61/0.453592;
pounds_seat5r = 75/0.453592;
pounds_seat6r = 78/0.453592;
pounds_seat7r = 86/0.453592;
pounds_seat8r = 68/0.453592;
pounds_seat10r = 74/0.453592;
pounds_noser = 0;
pounds_aft1r = 0;
pounds_aft2r = 0;
pounds_FuelStartr = 4050;

%seats contain 9x2 matrix with [x_cg_fromfront[inches],mass[pounds]] per
%seat
seatsr = [131 pounds_seat1r; 131 pounds_seat2r; 214 pounds_seat3r; 214 pounds_seat4r; 251 pounds_seat5r; 251 pounds_seat6r; 288 pounds_seat7r; 288 pounds_seat8r; 170 pounds_seat10r];

baggager = [74 pounds_noser; 321 pounds_aft1r; 338 pounds_aft2r];

A_payload = [seatsr;baggager];

pounds_payloadr = sum(A_payload(:,2));

BEM = [9165.0 291.65];      % [pounds inches]

pounds_ZFMr = pounds_payloadr + BEM(1,1);