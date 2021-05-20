function [U] = voltage(X)
%function which realises the vectorised voltage according
%to the sampled experimental design of size 4xn (with n sampling points)
%X is the original input samples for the original model
%evaluation
%V is size of 1xn
%------Physical constants
R = 8.314; %Ideal gas constant (J/K/mol)
T = 298.15; %absolute temperature (K)
F = 96485; %Faraday constant (C/mol)

%-----Known Inputs
I = 0.4; %charging current (A)
b = 0.9; %fitted constant for the flow rate
A_e = 2.236*0.4e-4; %electrode area (m^2)
A_m = 5e-4; %membrane area (m^2)
a = 4e-5; %fitted constant for the electrolyte flow rate
Ep0 = 0.62; %thermodynamic potential of TEMPO (V)
En0 = -0.63; %thermodynamic potential of MV (V)
kp0 = 4.2e-5; %kinetic constant of TEMPO (m/s)
kn0 = 3.3e-5; %kinetic constant of MV (m/s)

Deltac = I/A_m./(F*a.*(X(4,:)./A_e).^b)/1000;
X(4,:) = 1- Deltac/1000;


U =  X(1,:).^5./(X(2,:).^2).*sqrt(X(3,:))*I + Ep0 - En0 + R*T/F* log( X(2,:).^3.*X(3,:).^3) +R*T/F/2 .*log((I+sqrt(I^2+4*F*kp0.*X(4,:)))/(2.*X(4,:)))+R*T/F/2 .*log((I+sqrt(I^2+4*F*kn0*X(4,:)))/(2.*X(4,:))) ;

end

