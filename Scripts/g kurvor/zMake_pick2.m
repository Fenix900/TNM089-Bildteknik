function [Z_red, Z_green, Z_blue] = zMake_pick2(images, imageAmount, sampleAmount, pixelSamples, paintRed)

    display("Pick local!");
    allRowPos = zeros(1, pixelSamples);
    allColPos = zeros(1, pixelSamples);
    
    for i = 1:imageAmount

        %Summera kanaler för att få ljusnivån [0, 765]
        rgbSum = sum(images(:,:,:,i),3);

        targets = linspace(max(max(rgbSum(:,:))), min(min(rgbSum(:,:))), imageAmount);
    
        if i~=1
            for k = 1:nnz(allRowPos)
                rgbSum(allRowPos(k), allColPos(k)) = rgbSum(allRowPos(k), allColPos(k)) + 2000;
            end
        end
        
        % Ta fram och sortera alla unika RGB-värden
        [uniqueEl, ~, ~] = unique(rgbSum);
    
        %Sortera vektorn beroende på avstånd till target (h(i))
        %Avståndet till target
        dist = abs(uniqueEl - targets(i));
    
        [~, sorted_ind] = sort(dist);
    
        sorted_unique_values = uniqueEl(sorted_ind);
    
        % Räkna förekomsten av varje unik RGB-värde
        % idx är lika stor som rgbSum. Varje el. i idx säger oss vart
        % motsvarande värde i rgbSum finns i s_u_v, DVS ett index i s_u_v.
        % Typ en innehållsförteckning till vart alla värden i rgbSum finns i
        % s_u_v
        [~, idx] = ismember(rgbSum, sorted_unique_values);
        
        % [numel(sorted_unique_values), 1] = length(s_u_v)x1-vektor
        % idx(:) = gör bara om matrisen idx till en vektor.
        elCount = accumarray(idx(:), 1, [numel(sorted_unique_values), 1]);
        
         % Se till så att det finns MINST samplesPerIm stycken samples
        cntr_sampPerIm = 0;
        cntr_span_rel = 1;
    
        for k = 1:length(elCount)
            cntr_sampPerIm = cntr_sampPerIm + elCount(k);
            if cntr_sampPerIm < sampleAmount
                cntr_span_rel = cntr_span_rel+1;
            else
                break
            end
        end
    
        % Hitta och spara samplesPerIm stycken positioner
        span_relevant = sorted_unique_values(1:cntr_span_rel); % Måste göra detta så att find funkar..
    
        [rowPos, colPos] = find(ismember(rgbSum, span_relevant));
    
        start_idx = (i-1)*sampleAmount + 1;
        end_idx = i*sampleAmount;
    
        allRowPos(start_idx:end_idx) = rowPos(1:sampleAmount);
        allColPos(start_idx:end_idx) = colPos(1:sampleAmount);
    end
    
    %Skapar Z(i,j) för alla tre kanaler    
    Z_red = zeros(pixelSamples ,imageAmount);
    Z_green = zeros(pixelSamples ,imageAmount);
    Z_blue = zeros(pixelSamples ,imageAmount);
    
    for j = 1:imageAmount
        for i =1:pixelSamples 
            Z_red(i,j) = images(allRowPos(i), allColPos(i), 1, j);
            Z_green(i,j) = images(allRowPos(i), allColPos(i), 2, j);
            Z_blue(i,j) = images(allRowPos(i), allColPos(i), 3, j);
        end
    end    

    if paintRed
        middleIm = uint8(imageAmount/2);
        for i = 1:length(allRowPos)
            images(allRowPos(i),allColPos(i),1,middleIm) = 255;
            images(allRowPos(i),allColPos(i),2,middleIm) = 0;
            images(allRowPos(i),allColPos(i),3,middleIm) = 0;
        end
        figure;
        imshow(images(:,:,:,middleIm))
    end
end