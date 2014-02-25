function Delta_h = Delta(phi, epsilon)
%   Delta(phi, epsilon) compute the smooth Dirac function
Delta_h=(epsilon/pi)./(epsilon^2+ phi.^2);