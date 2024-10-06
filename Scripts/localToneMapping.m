function toneMapImage = localToneMapping(HDR, lpFilter_, s)
%Scale the range of the HDR into [0, 1]
lpFilter = lpFilter_;
disp( min(HDR(:)));
disp(max(HDR(:)));

%Normalize HDR image to [0, 1], linearly
HDR_normalized = (HDR - min(HDR(:)))/ (max(HDR(:)) - min(HDR(:)));
% figure;
% imshow(HDR_normalized);

%Convert to YCbCr color space
HDR_normalized_YCbCr = rgb2YCbCr(HDR);
Y = HDR_normalized_YCbCr(:,:,1);
Cb = HDR_normalized_YCbCr(:,:,2);
Cr = HDR_normalized_YCbCr(:,:,3);
Y = log(Y - 1e-6);
% figure;
% imshow(Y,[]);

%Create lowpass version of luminance channel (Y)
Y_range = max(Y(:)) - min(Y(:));
degreeOfSmoothing = 100 * Y_range;

if strcmp(lpFilter,'bilatiral')
    Y_lp = imbilatfilt(Y, degreeOfSmoothing, 1.5);

else %Gaussian filter
    Y_lp = imgaussfilt(Y, 50);
end

figure;
imshow(Y_lp,[]);


%Create highpass version of luminance channel (Y)
Y_hp = Y - Y_lp;

figure;
imshow(Y_hp,[]);

%Scale lowpassed image
Y_lp_scaled = s * Y_lp;

%Combine filtered images and then the channels
Y_new = Y_hp + Y_lp_scaled;

R_new = Y_new + 1.403 * Cr;
G_new = Y_new - 0.344 * Cb - 0.714 * Cr;
B_new = Y_new + 1.770 * Cb;

toneMapImage = cat(3,R_new, G_new, B_new);
%HDR_normalized_YCbCr(:,:,1) = Y_new;

%toneMapImage = ycbcr2rgb(HDR_normalized_YCbCr);

end


