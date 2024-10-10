function [allRowPos,allColPos] = getPixelPos(images, imageAmount, sampleAmount)

targets = linspace(765, 0, imageAmount);
allRowPos = zeros(1, sampleAmount * imageAmount);
allColPos = zeros(1, sampleAmount * imageAmount);

for i = 1:imageAmount

    %Summera kanaler för att få ljusnivån [0, 765]
    rgbSum = sum(images(:,:,:,i),3);
    
    % Ta fram och sortera alla unika RGB-värden
    [uniqueEl, ~, ~] = unique(rgbSum);

    %Sortera vektorn beroende på avstånd till target (h(i))
    %Avståndet till target
    dist = abs(uniqueEl - targets(i));

    [~, sorted_ind] = sort(dist);

    sorted_unique_values = uniqueEl(sorted_ind);

    % Räkna förekomsten av varje unik RGB-värde
    [~, idx] = ismember(rgbSum, sorted_unique_values);
    
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
end

