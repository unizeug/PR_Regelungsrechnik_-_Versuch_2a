                    // * * * * * * * * * * * * * * * * * * * * //
                    //            -- Winkelzeug --             //
                    // * * * * * * * * * * * * * * * * * * * * //


// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_2a/PR Regelungsrechnik - Versuch 2a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_2a/PR Regelungsrechnik - Versuch 2a/Scilab/"



daten1 = fscanfMat('../Messwerte/win_12');
daten1=daten1;


//t=daten1(:,1); Zeit
//z=daten1(:,2); Position
//phi=daten1(:,3); Winkel
//w=daten1(:,4); Winkelgeschwindigkeit
//v=daten1(:,5); Geschwindigkeit
//s=daten1(:,6); Startsignal
//phi_soll=daten1(:,7) ; Referenz-Winkel

t1=daten1(:,1);
z1=daten1(:,2);
phi1=daten1(:,3);
w1=daten1(:,4);
v1=daten1(:,5);
s1=daten1(:,6);
phi_soll1=daten1(:,7);




// Interessanten bereich ausschneiden
[val min_ind] = min(s1)//max(s1(1:length(s1)-1) - s1(2:length(s1)));
stoe_anfang = min_ind;
[val max_ind] = max(abs(z1))
stoe_ende = max_ind-195;



// Anfang auf null setzen
T_1 = t1 - t1(stoe_anfang);

// in Sekunden wandeln
T1 = T_1;

// interessantes Stück ausschneiden
T1 = T1(stoe_anfang:stoe_ende);


scf(5);
clf(5);

Z1 = z1(stoe_anfang:stoe_ende);

plot(T1,Z1)
xtitle("Position des Wagens","Zeit [s]","Position");
//legend("mit anti-Windup","ohne anti-Windup",1);



scf(6);
clf(6);

Phi1 = phi1(stoe_anfang:stoe_ende);

plot(T1,Phi1)
xtitle("Winkel des pendels","Zeit [s]","Winkel [rad/s]");
//legend("mit anti-Windup","ohne anti-Windup",1);


scf(7);
clf(7);

V1 = v1(stoe_anfang:stoe_ende);

plot(T1,V1)
xtitle("Geschwindigkeit des Wagens","Zeit [s]","Geschwindigkeit [m/s]");
//legend("mit anti-Windup","ohne anti-Windup",1);


scf(8);
clf(8);


Phi_soll1 = phi_soll1(stoe_anfang:stoe_ende);

plot(T1,Phi_soll1)
xtitle("Referenzwinkel","Zeit [s]","[rad/s]");
//legend("m



//// ## Simulation ##
//scf(10);
//clf(10);
//
//
//h1=csim('step',T2,Gmw);
//h1 = h1*(max(W2)/max(h1));
//
//plot2d(T2,h1+MatrizenscheissvonGmw(5),5);
//xgrid();
//xtitle("Störsprungantwort","Zeit [s]","Winkelgeschwindigkeit [rad/s]");
//legend("gemessen","simuliert",1);







