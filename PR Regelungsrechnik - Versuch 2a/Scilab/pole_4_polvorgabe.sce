// Fehlermeldung bei neudefinition vermeiden
funcprot(0);

function polvorgabe=globalPlot(tr,D)

    s = poly(0,'s');
    
//    tr = 4; //[S]
//    D = 0.97;
    
    
    w0 = (1/tr) * exp( D/sqrt(1-D^2) * acos(D) );
    
    RP = roots((s^2 + 2*D*w0*s + w0^2));
    rRP = real(RP(1));    
    
    
    add = 0.01; // unterschied der zusätzlichen Polstellen
    
    a1 = rRP*6;
    a2 = a1 - add;
    a3 = a2 - add;
    a4 = a3 - add;
    a5 = a4 - add;
    a6 = a5 - add;
    
    C_1 = w0^2 / (  (s^2 + 2*D*w0*s + w0^2) );
    C =  (a1*a2*a3*a4*a5*a6) * C_1 /( (s-a1) * (s-a2) * (s-a3)* (s-a4) * (s-a5) * (s-a6) ); // anstatt der kompensation vorne kann man auch das hier schreiben: ((1/-a1)*s+1)
    
    polvorgabe = [RP; a1; a2; a3; a4; a5; a6];
    
    t=[0:0.01:15];
    
    STEP_C_1 = csim('step',t,C_1)
    STEP_C = csim('step',t,C)
    
    scf(111); clf(111)
    plot2d(t,STEP_C_1)
    plot2d(t,STEP_C,2)
    xgrid;


endfunction