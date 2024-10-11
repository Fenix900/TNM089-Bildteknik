function pixelPos = getPixelPos2(images, imageAmount, sampleAmount)
    % Definiera målvärden
    target = linspace(756, 0, imageAmount); 
    pixelPos = NaN(sampleAmount * imageAmount, 2);
    posInd = 1;

    % Använd array för att kolla unika positioner
    usedPositions = false(size(images, 1), size(images, 2));

    for i = 1:imageAmount
        % Beräkna summan av bilderna över färgkanalerna
        img_sum = sum(images(:,:,:,i), 3);
        [row, col] = size(img_sum);
        
        % Samla pixeldata
        pixelData = zeros(row * col, 3); 
        ind = 1;
        
        % Iterera genom alla pixlar
        for r = 1:row
            for c = 1:col
                % Hämta pixelvärdet i position (r,c)
                pixelValue = img_sum(r, c); 
                
                % Spara pixeldata
                pixelData(ind, :) = [r, c, abs(pixelValue - target(i))]; % [rad, kol, avstånd]
                ind = ind + 1;
            end
        end

        % Ta bort oönskade rader
        pixelData = pixelData(1:ind-1, :); 

        % Sortera pixelData efter avstånd (tredje kolumn)
        [~, sortedIndices] = sort(pixelData(:, 3));
        
        % Hämta unika positioner
        count = 0; % Räkna antalet sparade positioner
        for j = 1:size(sortedIndices, 1)
            if count >= sampleAmount
                break; % Om vi har fått tillräckligt med positioner, avbryt loopen
            end
            
            % Hämta sorterade positioner
            rowPos = pixelData(sortedIndices(j), 1);
            colPos = pixelData(sortedIndices(j), 2);

            % Kontrollera om positionen redan används
            if ~usedPositions(rowPos, colPos)
                % Spara positionen i pixelPos
                pixelPos(posInd, :) = [rowPos, colPos]; 
                posInd = posInd + 1;
                count = count + 1;   

                % Markera positionen som använd
                usedPositions(rowPos, colPos) = true;
            end
        end
    end

    % Ta bort NaN-rader i pixelPos (om det finns färre än sampleAmount positioner)
    pixelPos(all(isnan(pixelPos), 2), :) = [];
end
