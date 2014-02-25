function [di dj]=DirToIndex8(dir)
    switch dir
        case 0
            index = [0 1];
        case 1
            index = [-1 1];
        case 2
            index = [-1 0];
        case 3
            index = [-1 -1];
        case 4
            index = [0 -1];
        case 5
            index = [1 -1];
        case 6
            index = [1 0];
        case 7
            index = [1 1];
        otherwise
            error('para error!')
            return;
    end
    di = index(1);
    dj = index(2);
            
     