function [newx newy newseed] = popArray(seed)
    [row,col] = size(seed);
    if row==0
        newx = NaN;
        newy = NaN;
        newseed = [];
        return;
    end
    if row==1
        newx = seed(1);
        newy = seed(2);
        newseed = [];
        return;
    end
    newx = seed(1,1);
    newy = seed(1,2);
    newseed = seed(2:row,:);