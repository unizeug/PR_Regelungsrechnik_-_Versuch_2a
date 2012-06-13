                    // * * * * * * * * * * * * * * * * * * * * //
                    //           -- Positionszeug --           //
                    // * * * * * * * * * * * * * * * * * * * * //


// Boris: cd "/Users/borishenckell/Documents/eclipse workspace/PR_Regelungsrtechnik_-_Versuch_2a/PR Regelungsrechnik - Versuch 2a"
// Dirk: cd "/media/daten/workspace/PR_Regelungsrechnik_-_Versuch_2a/PR Regelungsrechnik - Versuch 2a/Scilab/"



daten2 = fscanfMat('../Messwerte/pos2_1');
daten2=daten2;


//t=daten2(:,1); Zeit
//z=daten2(:,2); Position
//phi=daten2(:,3); Winkescill
//w=daten2(:,4); Winkelgeschwindigkeit
//v=daten2(:,5); Geschwindigkeit
//s=daten2(:,6); Startsignal
//z_soll=daten2(:,7) ; Referenz-Winkel

t2=daten2(:,1);
z2=daten2(:,2);
phi2=daten2(:,3);
w2=daten2(:,4);
v2=daten2(:,5);
s2=daten2(:,6);
z_soll2=daten2(:,7);




// Interessanten bereich ausschneiden
[val min_ind] = min(s2)//max(s2(1:length(s2)-1) - s2(2:length(s2)));
stoe_anfang = min_ind;
[val max_ind] = max(abs(z2))
stoe_ende = length(t2)-1579//max_ind-295;



// Anfang auf null setzen
T_2 = t2 - t2(stoe_anfang);

// in Sekunden wandeln
T2 = T_2;

// interessantes Stück ausschneiden
T2 = T2(stoe_anfang:stoe_ende);


scf(9);
clf(9);

Z2 = z2(stoe_anfang:stoe_ende);

plot2d(T2,Z2,2)
xtitle('Position des Wagens','Zeit [s]','Position [m]');
//legend('mit anti-Windup','ohne anti-Windup',2);
//xs2pdf(gcf(),'../Bilder/pos_pos.pdf');



scf(10);
clf(10);

Phi2 = phi2(stoe_anfang:stoe_ende);

plot2d(T2,Phi2,2)
xtitle('Winkel des pendels','Zeit [s]','Winkel [rad]');
//legend('mit anti-Windup','ohne anti-Windup',1);
//xs2pdf(gcf(),'../Bilder/pos_win.pdf');



scf(11);
clf(11);

V2 = v2(stoe_anfang:stoe_ende);

plot2d(T2,V2,2)
xtitle("Geschwindigkeit des Wagens","Zeit [s]","Geschwindigkeit [m/s]");
//legend('mit anti-Windup','ohne anti-Windup',1);
//xs2pdf(gcf(),'../Bilder/pos_gesch.pdf');

scf(12);
clf(12);


Z_soll2 = z_soll2(stoe_anfang:stoe_ende);

plot2d(T2,Z_soll2,2)
xtitle('Referenzposition','Zeit [s]','Position [m]');
//legend('m
//xs2pdf(gcf(),'../Bilder/pos_ref.pdf');



scf(13);
clf(13);

plot2d(T2,Z2,2,rect=[5,-0.55,30,-0])
plot2d(T2,Z_soll2-0.5,5,rect=[5,-0.55,30,-0])
xtitle('Position','Zeit [s]','Position [m]');
legend('Position des Wagens','Referenzposition',2);
//xs2pdf(gcf(),'../Bilder/pos_pos_ref.pdf');




// --- pdf abspeichern --- //

//xs2pdf(9,'../Bilder/pos_pos.pdf');
//xs2pdf(10,'../Bilder/pos_win.pdf');
//xs2pdf(11,'../Bilder/pos_gesch.pdf');
//xs2pdf(12,'../Bilder/pos_ref.pdf');
//xs2pdf(13,'../Bilder/pos_pos_ref.pdf');
























//scf(10);
//clf(10);
//
//
//S2 = s2(stoe_anfang:stoe_ende);
//
//plot2d(T2,S2)
//xtitle('Referenzwinkel','Zeit [s]','[rad/s]');
////legend('m


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
//xtitle('Störsprungantwort','Zeit [s]','Winkelgeschwindigkeit [rad/s]');
//legend('gemessen','simuliert',1);







