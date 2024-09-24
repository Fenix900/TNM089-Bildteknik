function  radianceMap = createRadianceMap(images, g, w, B)
[row, col, imageAmount] = size(images);
radianceMap = zeros(row, col);

for i = 1:col
    for k = 1:row
        for j = 1:imageAmount
            pixel = images(k,i,j) + 1;
            
            randianceMap(k,i) = (w(pixel) * (g(pixel) - B(j))) / w(pixel);
            
        end
    end
end

end

