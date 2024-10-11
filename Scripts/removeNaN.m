function result = removeNaN(image)
    [row, col] = size(image);
    nan_exists = false;

    % Kolla om det finns NaN
    for r = 1:row
        for c = 1:col
            if isnan(image(r, c))
                nan_exists = true;
                break;
            end
        end
        if nan_exists
            break;
        end
    end

    if nan_exists % Om NaN finns, byt ut mot en grannes värde
        for r = 1:row
            for c = 1:col
                if isnan(image(r, c))
                    % Samla grannar som inte är NaN
                    neighbors = [];
                    if r > 1 && ~isnan(image(r-1, c)) % Granne ovanför
                        neighbors = [neighbors, image(r-1, c)];
                    end
                    if r < row && ~isnan(image(r+1, c)) % Granne nedanför
                        neighbors = [neighbors, image(r+1, c)];
                    end
                    if c > 1 && ~isnan(image(r, c-1)) % Granne till vänster
                        neighbors = [neighbors, image(r, c-1)];
                    end
                    if c < col && ~isnan(image(r, c+1)) % Granne till höger
                        neighbors = [neighbors, image(r, c+1)];
                    end

                    % Om det finns några giltiga grannar, välj en (t.ex. medelvärde)
                    if ~isempty(neighbors)
                        image(r, c) = mean(neighbors); % Du kan välja en annan metod här om du vill
                    end
                end
            end
        end
        result = image; % Returnera den modifierade bilden
    else
        result = image; % Om inga NaN-värden finns, returnera originalbilden
    end
end