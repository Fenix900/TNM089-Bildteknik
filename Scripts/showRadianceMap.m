function showRadianceMap(red, green, blue)
%Normalize channels
normImRed = (red -  min(red(:))) / (max(red(:)) - min(red(:)));
normImGreen = (green -  min(green(:))) / (max(green(:)) - min(green(:)));
normImBlue = (blue -  min(blue(:))) / (max(blue(:)) - min(blue(:)));

%Normalized HDR
normalizedHDR = cat(3, normImRed, normImGreen, normImBlue);

%Gråskala
grayHDR = rgb2gray(normalizedHDR);
min(grayHDR(:))
max(grayHDR(:))

%Color map
colorMap = [linspace(0, 0, 128)', linspace(0, 1, 128)', linspace(1, 0, 128)';
    linspace(0, 1, 128)', linspace(1, 0, 128)', linspace(0, 0, 128)'];


figure;
imshow(grayHDR);
colormap(colorMap); 
end

