// ############################################################################
// Scilab Script zum 2 Praktikum
//
// Reglerentwurf eines invertierten Pendels,
// Frequenzkennlinienverfahren und Simulation
// ############################################################################

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 2a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 1b/Scilab/"


// Fehlermeldung bei neudefinition vermeiden
funcprot(1);

// Funktion "bode_w" einbinden
exec("bode_w_farbe.sci", -1);
exec("bode_w.sci", -1);
exec("globalPlot.sci", -1);

PROCESS_PLOTS = 1;

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
G1_nul = roots(G1.num);
G1_pol = roots(G1.den);

// - - - - - - - Regler - - - - - - - - - - - - - - - -//
K=1;
alphanull = 16//-G1_pol(1);
betapol = -0.2;
K1 = K*(s+alphanull)*1/(s+betapol);

// - - - - - - - Nyquistkurve - - - - - - - - - - - - -//

offenerKreis_1 = G1*K1;
offenerKreis = syslin('c',real(offenerKreis_1.num),real(offenerKreis_1.den))
// Plotten der Wurzelortskurve (WOK) von Gui*K
clf(2);scf(2);
nyquist(offenerKreis)
xgrid();

// - - - - - - - WOK - - - - - - - - - - - - - - - - -//

//clf(13);scf(13);
//evans(offenerKreis,100);
//legend("WOK des offenen Regelkreises",3);
//xgrid();

// - - - - - - - Bodeplot - - - - - - - - - - - - - - -//

clf(3);scf(3);
 
//legend("Offener Regelkreis",3);
[w, db, phi] = bode_w(offenerKreis, 10^(-3), 10^3);
[w, db, phi] = bode_w(G1, 10^(-3), 10^3);
xgrid(3);

// - - - - - - - Sprungantwort- - - - - - - - - - - - -//

//// Übertragungsfunktion des geschlossenen Regelkreises
GKgeschlossen = (G1*K1/(1+G1*K1))
GKgeschlossen = syslin('c',real(GKgeschlossen.num),real(GKgeschlossen.den))

//erstellen der Sprungantwort auf den Geschlossenen Kreis
t1=[0:0.01:40];
h1=csim('step',t1,GKgeschlossen);

//Plotten der Sprungantwort auf den Geschlossenen Kreis

clf(15);scf(15);
plot2d(t1,h1)

//integrate('step','t',0, max(t1));

// - - - - - - - Stoersprungantwort - - - - - - - - - - -//

xtitle("Sprungantwort des Geschlossene Kreises","Zeit [s]","Winkel ");
xgrid();

//Übertragungsfunktion der Störfunktion bei einer Störung auf den Eingang des 
//Leistungsverstärkers
Gstoer = (1)/(1+G1*K1);

//erstellen der Spungantwort auf die Störung
t2=[0:0.01:40];
h2=csim('step',t2,Gstoer);


clf(16);scf(16);
plot2d(t2,h2)

// - - - - - - - Sensitivitätsfunktion - - - - - - - - - - -//

//Sensitivitätsfunktion
Si = 1/(1+G1*K1)
//Komplimentäre Sensitivitätsfunktion
Tw = (G1*K1)/(1+G1*K1)
