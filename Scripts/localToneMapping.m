function toneMapImage = localToneMapping(HDR, lpFilter_, s)
%Scale the range of the HDR into [0, 1]
lpFilter = lpFilter_;
%disp( min(HDR(:)));
%disp(max(HDR(:)));

%Normalize HDR image to [0, 1]
HDR = log2(HDR + 1e-6);
HDR_normalized = (HDR - min(HDR(:)))/ (max(HDR(:)) - min(HDR(:)));
%disp(min(HDR_normalized(:)));
%disp(max(HDR_normalized(:)));
% figure;
% imshow(HDR_normalized);

%Convert to CIELAB color space
HDR_Lab = rgb2lab(HDR_normalized);
L = HDR_Lab(:,:,1);
%a = HDR_Lab(:,:,2);
%b = HDR_Lab(:,:,3);
%disp(min(a(:)));
%disp(max(a(:)));
L = log2(L + 1e-6);
% figure;
% imshow(L,[]);

%Create lowpass version of luminance channel (Y)
L_range = max(L(:)) - min(L(:));
degreeOfSmoothing = 100 * L_range;

if strcmp(lpFilter,'bilatiral')
    L_lp = imbilatfilt(L, degreeOfSmoothing);

else %Gaussian filter
    L_lp = imgaussfilt(L, 50);
    min(L(:))
    max(L(:))
end

figure;
imshow(L_lp,[]);


%Create highpass version of luminance channel (Y)
L_hp = L - L_lp;

figure;
imshow(L_hp,[]);

%Scale lowpassed image
L_lp_scaled = s * L_lp;

%Combine filtered images and then the channels
L_new = L_hp + L_lp_scaled;

L_new = (L_new - min(L_new(:)))/ (max(L_new(:)) - min(L_new(:))) * 100;

%Combine all Lab channels with the new L
HDR_Lab(:,:,1) = L_new;

disp(min(L_new(:)));
disp(max(L_new(:)));

toneMapImage = im2uint8(lab2rgb(HDR_Lab));

end


