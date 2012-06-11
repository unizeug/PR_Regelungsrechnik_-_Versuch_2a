// ############################################################################
// Scilab Script zum 2 Praktikum
//
// Reglerentwurf eines invertierten Pendels,
// Frequenzkennlinienverfahren und Simulation
// ############################################################################

// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_1b/PR Regelungsrechnik - Versuch 2a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_2a/PR Regelungsrechnik - Versuch 2a/Scilab/"


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
//clf(2);scf(2);
//nyquist(offenerKreis)
//xgrid();

// - - - - - - - WOK - - - - - - - - - - - - - - - - -//

//clf(13);scf(13);
//evans(offenerKreis,100);
//legend("WOK des offenen Regelkreises",3);
//xgrid();

// - - - - - - - Bodeplot - - - - - - - - - - - - - - -//

//clf(3);scf(3);
 
//legend("Offener Regelkreis",3);
//[w, db, phi] = bode_w(offenerKreis, 10^(-3), 10^3);
//[w, db, phi] = bode_w(G1, 10^(-3), 10^3);
//xgrid(3);

// - - - - - - - Sprungantwort- - - - - - - - - - - - -//

//// Übertragungsfunktion des geschlossenen Regelkreises
GKgeschlossen = (G1*K1/(1+G1*K1))
GKgeschlossen = syslin('c',real(GKgeschlossen.num),real(GKgeschlossen.den))

//erstellen der Sprungantwort auf den Geschlossenen Kreis
t1=[0:0.01:40];
h1=csim('step',t1,GKgeschlossen);

//Plotten der Sprungantwort auf den Geschlossenen Kreis

//clf(15);scf(15);
//plot2d(t1,h1)


// - - - - - - - Stoersprungantwort - - - - - - - - - - -//
//
//xtitle("Sprungantwort des Geschlossene Kreises","Zeit [s]","Winkel ");
//xgrid();

//Übertragungsfunktion der Störfunktion bei einer Störung auf den Eingang des 
//Leistungsverstärkers
Gstoer = (1)/(1+G1*K1);

//erstellen der Spungantwort auf die Störung
t2=[0:0.01:40];
h2=csim('step',t2,Gstoer);


//clf(16);scf(16);
//plot2d(t2,h2)

// - - - - - - - Sensitivitätsfunktion - - - - - - - - - - -//

//Sensitivitätsfunktion
Si = 1/(1+G1*K1)
//Komplimentäre Sensitivitätsfunktion
Tw = (G1*K1)/(1+G1*K1)


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//
// - - - - - - - Positionsregelung - - - - - - - - - - - - -//
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - -//


// Übertragungsfunktion des inneren Reglers dz/dt zu phi
Ginnen = K1*(1/s)/(1+K1*G1);

// - - - - Reglerentwurf ohne Integrator - - - - - - - - - -//
// Ordnung der Strecke
ordGden = length(roots(Ginnen.den))

n=ordGden
// erstellen der Streckenmatrix
As=zeros(2*n,2*n);
//As(Zeile,Spalte)
for i = 1:2*n+1
    for j = 1:2*n
        if i<n+2 then
            if j < n+1 then
                As(i+j-1,j) = coeff(Ginnen.den,n+1-i);
            end
            if j > n then
                As(i+j-1-n,j) = coeff(Ginnen.num,n+1-i);
            end
        end
    end
end

// erstellen des Polvorgabevektors

cvek = polvorgabe(4,0.97)

//cvek=zeros(2*n,1);
//cvek(1,1) = 1;
//cvek(2,1) = 2;
//cvek(3,1) = 3;

kcoeff=inv(As)*cvek;
Kpos = syslin('c',kcoeff(n+1)*s^(n-1)+kcoeff(n+2)*s^(n-2) + kcoeff(n+3)*s^(n-3)+kcoeff(n+4)*s^(n-4),kcoeff(1)*s^(n-1)+kcoeff(2)*s^(n-2)+kcoeff(3)*s^(n-3)+kcoeff(4)*s^(n-4));


// - - - - Reglerentwurf mit Integrator - - - - - - - - - -//
// Ordnung der Strecke

// erstellen der Streckenmatrix
AsI=As

//kcoeff=invr(AsI)*cvek;
kcoeff=inv(AsI)*cvek;
KposI = syslin('c',kcoeff(n+1)*s^(n-1)+kcoeff(n+2)*s^(n-2) + kcoeff(n+3)*s^(n-3)+kcoeff(n+4)*s^(n-4),s*(kcoeff(1)*s^(n-1)+kcoeff(2)*s^(n-2)+kcoeff(3)*s^(n-3)+kcoeff(4)*s^(n-4)));

// - -  Sensitivitätsfunktion und kompl. Sensistivitätsfunktion - -//

S = 1/(1+Ginnen*Kpos)
T = (Ginnen*Kpos)/(1+Ginnen*Kpos)

clf(6);scf(6);
bode(S);

//bode_w_farbe(S, -3, 3, 'Bodeplot', 'false', 1000, 2);
//bode_w_farbe(T, -3, 3, 'Bodeplot', %f, 1000, 5);
legend("Sensitivitätsfunktion","Komplimentäre Sensitivitätsfunktion",3);
xgrid();

SI = 1/(1+Ginnen*KposI)
TI = (Ginnen*KposI)/(1+Ginnen*KposI)

clf(7);scf(7);
//bode_w_farbe(SI, -3, 3, 'Bodeplot', 'false', 1000, 2);
//bode_w_farbe(TI, -3, 3, 'Bodeplot', %f, 1000, 5);
//legend("Sensitivitätsfunktion","Komplimentäre Sensitivitätsfunktion",3);
xgrid();