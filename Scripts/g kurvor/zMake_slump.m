function [Z_red, Z_green, Z_blue] = zMake_slump(images, imageAmount, pixelSamples, row, col, paintRed)
    % Slumpa pixelpositioner
    display("Slump!");
    randX = randi([1, row], 1, pixelSamples);
    randY = randi([1, col], 1, pixelSamples);
    
    %Skapar Z(i,j) för alla tre kanaler
    Z_red = zeros(pixelSamples ,imageAmount);
    Z_green = zeros(pixelSamples ,imageAmount);
    Z_blue = zeros(pixelSamples ,imageAmount);
    
    for j = 1:imageAmount
        for i =1:pixelSamples 
            Z_red(i,j) = images(randX(i), randY(i), 1, j);
            Z_green(i,j) = images(randX(i), randY(i), 2, j);
            Z_blue(i,j) = images(randX(i), randY(i), 3, j);
        end
    end

    if paintRed
        middleIm = uint8(imageAmount/2);
        for i = 1:length(randX)
            images(randX(i),randY(i),1,middleIm) = 255;
            images(randX(i),randY(i),2,middleIm) = 0;
            images(randX(i),randY(i),3,middleIm) = 0;
        end
        figure;
        imshow(images(:,:,:,middleIm))
    end
end