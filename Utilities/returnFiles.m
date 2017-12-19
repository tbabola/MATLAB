function files = returnFiles(listing)
    [m,n] = size(listing);
    for i = 1:m
        files{i} = [listing(i).folder '\' listing(i).name];
    end
end
