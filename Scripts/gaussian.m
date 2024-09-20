function w = gaussian(z)
    Zmin = 0;
    Zmax = 255;
    
    sigma = (Zmax - Zmin) / 6;  % Standardavvikelse (kan justeras)
    mu = 0.5 * (Zmin + Zmax);   % Medelvärde, centrerat vid mitten av Zmin och Zmax
    
    % Beräkna Gaussisk viktfunktion
    w = exp(-0.5 * ((z - mu) / sigma).^2);
end

