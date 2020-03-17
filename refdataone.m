pounds_seat1 = 95/0.453592;
pounds_seat2 = 92/0.453592;
pounds_seat3 = 66/0.453592;
pounds_seat4 = 61/0.453592;
pounds_seat5 = 75/0.453592;
pounds_seat6 = 78/0.453592;
pounds_seat7 = 86/0.453592;
pounds_seat8 = 68/0.453592;
pounds_seat10 = 74/0.453592;
pounds_nose = 0;
pounds_aft1 = 0;
pounds_aft2 = 0;
pounds_FuelStart = 4050;

%seats contain 9x2 matrix with [x_cg_fromfront[inches],mass[pounds]] per
%seat
seats = [131 pounds_seat1; 131 pounds_seat2; 214 pounds_seat3; 214 pounds_seat4; 251 pounds_seat5; 251 pounds_seat6; 288 pounds_seat7; 288 pounds_seat8; 170 pounds_seat10];

baggage = [74 pounds_nose; 321 pounds_aft1; 338 pounds_aft2];

A_payload = [seats;baggage];

pounds_payload = sum(A_payload(:,2));

BEM = [9165.0 291.65];      % [pounds inches]

pounds_ZFM = pounds_payload + BEM(1,1);