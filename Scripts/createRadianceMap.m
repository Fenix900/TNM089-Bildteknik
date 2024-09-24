function  radianceMap = createRadianceMap(images, g, w, B)
[row, col, imageAmount] = size(images);
radianceMap = zeros(row, col);

for i = 1:col
    for k = 1:row
        num = 0;
        den = 0;
        for j = 1:imageAmount
            pixel = images(k,i,j) + 1;

            num =  num + radianceMap(k,i) + (w(pixel) * (g(pixel) - B(j)));
            den = den + w(pixel);
            %radianceMap(k,i) = radianceMap(k,i) + ((w(pixel) * (g(pixel) - B(j))) / w(pixel));
            
        end
        radianceMap(k,i) = num / den;
    end
end

end

