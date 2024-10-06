function YCbCr = rgb2YCbCr(RGB) %(8-bit)

%Initialize YCbCr image
[rows, cols, channel] = size(RGB);
YCbCr = zeros(rows, cols, channel);

%Extract RGB channels
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

% Calculate Y, Cb, Cr
Y = 0.299 * R + 0.587 * G + 0.114 * B;
Cb = 0.564 * (B - Y);
Cr = 0.713 * (R - Y);

%Combine channels
YCbCr(:,:,1) = Y;
YCbCr(:,:,2) = Cb;
YCbCr(:,:,3) = Cr;
end

