function result = globalToneMapping(HDR, onRGB, scaleMethod, saturation, useReinhard, a, s, L_white) 
epsilon = 1e-6; % Small number

if onRGB
    if strcmp(scaleMethod, "linear")
        % Linear scaling
        result = (HDR - min(HDR(:))) / (max(HDR(:)) - min(HDR(:))); 
        
    elseif strcmp(scaleMethod, "log")
        % Logarithmic scaling
        hasZeros = any(HDR(:) == 0);
        if hasZeros
            HDR_log = log2(HDR + epsilon);
        else
            HDR_log = log2(HDR);
        end
        result = (HDR_log - min(HDR_log(:))) / (max(HDR_log(:)) - min(HDR_log(:))); 
        result = im2uint8(result);
        
    end
else
    if useReinhard
        disp('reinhard');
        HDR_log = log2(HDR + epsilon);
        HDR_log = (HDR_log - min(HDR_log(:))) / (max(HDR_log(:)) - min(HDR_log(:)));

        R_in = HDR_log(:,:,1);
        G_in = HDR_log(:,:,2);
        B_in = HDR_log(:,:,3);
        %[R_row, R_col] = size(R_in); 

        
        Lw = (0.27 * R_in) + (0.67 * G_in) + (0.06 * B_in); % Beräkna luminans
        N = numel(Lw); % Total antal pixlar
        Lw_avg = exp((1/N) * sum(log(epsilon + Lw), 'all')); % Beräkna log-genomsnittlig luminans
        disp(Lw_avg);

        L = (a / Lw_avg) * Lw; % Skalad luminans
        
        %Beräkna Ld metod 1
        %Ld = L ./ (1 + L); % Tonmappad luminans

        %Beräkna Ld metod 2

        Ld = (L .* (1 + (L / L_white.^2))) ./ (1 + L); % Tonmappad luminans

        % Färgkanaljustering
        R_out = (R_in ./ (L + epsilon)).^s .* Ld;
        G_out = (G_in ./ (L + epsilon)).^s .* Ld;
        B_out = (B_in ./ (L + epsilon)).^s .* Ld;

        C_out = cat(3, R_out, G_out, B_out); % Kombinera RGB-kanaler
        result = im2uint8(C_out); % Skala tillbaka till 8-bitars format

    else
        % Luminance channel scaling with log2 on L-channel
        RGB_hdr = (HDR - min(HDR(:))) / (max(HDR(:)) - min(HDR(:)));

        % Convert to CIELAB
        Lab = rgb2lab(RGB_hdr);
        L = Lab(:,:,1);
        a = Lab(:,:,2);
        b = Lab(:,:,3);

        % Scale luminance channel
        L_new = log2(L + epsilon);
        L_new = (L_new - min(L_new(:))) / (max(L_new(:)) - min(L_new(:))) * 100;

        % Combine all Lab channels
        Lab(:,:,1) = L_new;

        % Scale a and b channels

        Lab(:,:,2) = Lab(:,:,2) * saturation;
        Lab(:,:,3) = Lab(:,:,3) * saturation;
        disp(min(min(Lab(:,:,2))));
        disp(max(max(Lab(:,:,2))));

        result = im2uint8(lab2rgb(Lab));
    end
end

end