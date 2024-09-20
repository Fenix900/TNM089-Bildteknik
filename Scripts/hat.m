function w = hat(z)
Zmin = 0;
Zmax = 255;
medelvardet = 0.5*(Zmin + Zmax);

w = zeros(size(z)); 

% Hantera pixelvärden mindre än eller lika med medelvärdet
w(z <= medelvardet) = z(z <= medelvardet) - Zmin;
    
% Hantera pixelvärden större än medelvärdet
w(z > medelvardet) = Zmax - z(z > medelvardet);
end

