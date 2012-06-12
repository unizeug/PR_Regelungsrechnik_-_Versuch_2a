function block=scicos_model_Einfachpendel(block,flag)
//Parameter
//l_1 = 0.323;      // Länge [m]
s_1 = 0.459;     // Schwerpunkt [m]
m_1 = 0.3475;    // Masse [Kg]
hT_s1 = 1.160;     // Schwingungsperiode [s]
J_s1 = 3.4e-2;   // Massenträgheit [ms²]
c_1 = 0.007;       // Reibkonstante
g=9.81;

if flag==0 //\dot x update
  x = block.x;
  u = block.inptr(1);   // Eingang: Geschwindigkeit des Wagens
  block.xd(1) = u;
  block.xd(2) = x(3)-u*((m_1*s_1*cos(x(2)))/(J_s1+m_1*s_1^2));
  block.xd(3) = -(1/(J_s1+m_1*s_1^2))*(-c_1*m_1*s_1*cos(x(2))*u/(J_s1+m_1*s_1^2)+c_1*x(3)+m_1*g*s_1*sin(x(2)));
elseif flag==1 //outputs
  block.outptr(1) = block.x(1);
  block.outptr(2) = block.x(2)-%pi;
  block.outptr(3) = block.x(3);
end
endfunction
