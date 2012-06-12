clear


// - - - - - - - Konstanten - - - - - - - - - -  - - - -//
// Pendel
mp=0.3475;        //[kg]Masse des Pendelstabs
a=0.459;          //[m] Distanz Drehachse-Pendelschwerpunkt
c=0.007;          //[Nms] reibungskoeffizent
JS=3.4E-2;        //[Nms^2] Trägheitsmoment bezüglich Schwerpunkt
g=9.81            //[m/s^2] Gravitationskonstante

// - - - - - - - Übertragungsfunktion - - - - - - - - -//

// Definiert ein Polynom s mit Nullstelle = 0
s = poly(0, 's');

G1 = syslin('c', mp*a*s , (JS + mp*a^2)*s^2+s*c-mp*a*g);




s = poly(0,'s');

k = 1;

a = -1;
b = 1;


g = k * (s + a)/(s + b);

scf(123);clf(123);
evans(G1 * g)
