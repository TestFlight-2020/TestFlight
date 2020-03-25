

Asimp_sp = zeros(2,2);

Dc = c/V0;

Asimp_sp(1,1)=CZa/(2*muc*Dc);
Asimp_sp(1,2)=1/Dc;
Asimp_sp(2,1)=(CZa*Cmadot/(4*muc^2*KY2*Dc))+(Cma/(2*muc*KY2*Dc));
Asimp_sp(2,2)=(Cmadot+Cmq)/(2*muc*KY2*Dc);

Asimp_sp
eig(Asimp_sp)

Asimp_dr = zeros(2,2);

Db = b/V0;

Asimp_dr(1,1) = CYb/(2*mub*Db);
Asimp_dr(1,2) = -2/Db;
Asimp_dr(2,1) = Cnb/(4*mub*KZ2*Db);
Asimp_dr(2,2) = Cnr/(4*mub*KZ2*Db);

Asimp_dr
eig(Asimp_dr)

C1_dr = zeros(2,2);
C1_dr(1,1)=-2*mub*Db;
C1_dr(2,2)=-4*mub*KZ2*Db;

C2_dr = zeros(2,2);

C2_dr(1,1)=CYb;
C2_dr(1,2)=-4*mub;
C2_dr(2,1)=Cnb;
C2_dr(2,2)=Cnr;

Asimp_dr2 = -inv(C1_dr)*C2_dr
Asimp_dr
eig(Asimp_dr)

