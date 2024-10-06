function result = globalToneMapping(HDR, onRGB, scaleMethod, saturation)
epsilon = 1e-6; %Small number

if onRGB
    if strcmp(scaleMethod,"linear")
        result = (HDR - min(HDR(:)))/ (max(HDR(:)) - min(HDR(:))); %Linear scale
    else
        %Check if image has zeros
        hasZeros = any(HDR(:) == 0); 

        if hasZeros %If HDR has zeros, it can not preform log. (It will lead to -inf)
            HDR_log = log2(HDR + epsilon);
        else
            HDR_log = log2(HDR);
        end
        result = (HDR_log - min(HDR_log(:)))/ (max(HDR_log(:)) - min(HDR_log(:))); 
        result = im2uint8(result);
    end
else %On luminance channel
    %Log2 for scale
    RGB_hdr = HDR;%log2(HDR + epsilon);
    RGB_hdr = (RGB_hdr - min(RGB_hdr(:)))/ (max(RGB_hdr(:)) - min(RGB_hdr(:)));%mat2gray(RGB_log2);

    %Convert to CIELAB
    Lab = rgb2lab(RGB_hdr);
    L = Lab(:,:,1); %./100;

    %Scale lum-channel
    L_new = log2(L + epsilon);
    L_new = (L_new - min(L_new(:)))/ (max(L_new(:)) - min(L_new(:))) * 100;
    
    %Combine all Lab channels with the new L
    Lab(:,:,1) = L_new;
    Lab(:,:,2) = Lab(:,:,2) * saturation;
    Lab(:,:,3) = Lab(:,:,3) * saturation;

    result = im2uint8(lab2rgb(Lab));
end

end

