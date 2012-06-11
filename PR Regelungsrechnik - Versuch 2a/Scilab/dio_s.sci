function [R,S] = dio_s(B,A,Ac,I)
// Löser für die Diophantische Gleichung
// Löst: R*A+B*S=Ac (I=0) oder
//       R*A*s+B*S=Ac (I=1)
//
// Ohne Integrator I=0; degree Acl: 2*degree A -1 
// Mit  Integrator I=1; degree Acl: 2*degree A  
// Der resultierende Regler hat gleichen Zähler und Nennergrad!!!

R=[];
S=[];

ieee(2);

arg_poly=varn(A);

//check if integral action
if I==1
  PolAA=A*s;
  n=2*degree(A);
  ns=degree(A);
  nr=degree(A)-1;
else
  PolAA=A;
  n=2*degree(A)-1;
  ns=degree(A)-1;
  nr=degree(A)-1;
end

if degree(Ac)~=n
  disp('Falsche Ordnung für Acl!');
  return
end

na = degree(A);//degree of A
nb = degree(B);//degree of B

AA=coeff(PolAA);
BB=coeff(B);

//make A and B to order n by adding zeros at begin
AA = [zeros(1,max(max(na,nb)-na,0)) AA($:-1:1)];
BB = [zeros(1,max(max(na,nb)-nb,0)) BB($:-1:1)];

//build phi
phi = zeros(n+1,n+1);
for i = 1:nr+1,
  phi(i:i+length(AA)-1,i) = AA';
end;
for i = 1:ns+1,
  phi(i:i+length(BB)-1,nr+1+i) = BB';
end;

Phi=phi(1:n+1,1:n+1);

Acvec=coeff(Ac);
Acvec=Acvec($:-1:1)';

//solve the equation 
SOL = Phi\Acvec;
R = (SOL(1:nr+1))';
S = (SOL(nr+2:$))';

R=poly(R($:-1:1),arg_poly,'c')
if I==1,
  R=R*poly(0,arg_poly);
end
  
S=poly(S($:-1:1),arg_poly,'c');

endfunction