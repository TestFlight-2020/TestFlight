% Ap =  4*muc^2*KY2;
% Bp = -2*muc*(KY2*CZa+Cmadot+Cmq);
% Cp = CZa*Cmq -2*muc*Cma;

Ap =  8*mub^2*KZ2;
Bp = -(4*mub*KZ2*CYb+2*mub*Cnr);
Cp = CYb*Cnr +4*mub*Cnb;

syms lam;

p = Ap*lam^2+Bp*lam+Cp;
R = solve(p,lam);
Rsol = vpa(R)

matri = zeros(3,3);
matri(1,1)=1;
matri(3,2)=1;
det(matri)

\begin{pmatrix}e&0&0\\ \:\:0&0&0\\ \:\:0&f&0\end{pmatrix}\cdot 