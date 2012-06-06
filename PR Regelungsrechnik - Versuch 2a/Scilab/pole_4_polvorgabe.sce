clear;

s = poly(0,'s');

tr = 4; //[S]
D = 0.97;


w0 = (1/tr) * exp( D/(sqrt(1-D^2) * acos(D)) );

RP = abs(roots((s^2 + 2*D*w0*s + w0^2)));
RP = RP(1);
a1 = RP*5 ;
a2 = RP*5 + 1;
a3 = RP*5 + 2;
a4 = RP*5 + 3;
a5 = RP*5 + 4;
a6 = RP*5 + 5;

C_1 = w0^2 / (  (s^2 + 2*D*w0*s + w0^2) );

//C =  C_1 /( (s-a1) * (s-a2) * (s-a3)  );

//polvorgabe = roots(C_1.den);


t = [0:0.00000001:0.00001];


STEP_C_1 = csim('step',t,C_1)
//STEP_C = csim('step',t,C)

figure(1); clf(1)
plot2d(t,STEP_C_1)
xgrid;

figure(112)
//plot(t,STEP_C)