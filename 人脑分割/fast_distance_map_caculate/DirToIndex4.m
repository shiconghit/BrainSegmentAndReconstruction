function [di dj]=DirToIndex4(dir)
    switch dir
        case 0
            index = [0 1];
        case 1
            index = [-1 0];
        case 2
            index = [0 -1];
        case 3
            index = [1 0];
        otherwise
            error('para error!')
            return;
    end
    di = index(1);
    dj = index(2);
            
     