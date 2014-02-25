function [disMapR disMapC disMap] = ParallelComputeDisMap(srcImg,edgePt)
    % phase 1
    [imgHei,imgWid] = size(srcImg);
    % initialize the disMap matrix as infinity matrix
    disMap = zeros(imgHei,imgWid);
    % set the edge pixels as 0
    [mrow,mcol] = size(edgePt);
    if mcol~=2
        error('edgePt matrix size invalidate!');
        return;
    end
    for row=1:mrow
        disMap(edgePt(row,2)+1,edgePt(row,1)+1) = 1;
    end
    
%     disMap = [ 1   0	0	0	0	0	0	0;
%                     0	1	0	0	0	0	1	0;
%                     0	0	1	0	0	1	0	0;
%                     0	0	0	0	0	0	0	0;
%                     0	0	0	1	0	0	0	0;
%                     0	0	0	0	0	1	0	0;
%                     0	0	0	0	0	0	0	0;
%                     0	0	0	1	0	0	0	0 ];
%     imgWid = 8;
%     imgHei = 8;    
    bijL = zeros(1,imgWid);
    bijR = zeros(1,imgWid);
    Lij = zeros(1,imgWid);
    Rij = zeros(1,imgWid);
    Vij = zeros(imgHei,imgWid);
    for row=1:imgHei
        % cacu bij
        for col=1:imgWid
            if disMap(row,col)==1
                bijL(1,col) = col;
                bijR(1,col) = col;
            else
                bijL(1,col) = -Inf;
                bijR(1,col) = Inf;
            end
        end
        % cacu Lij
        Lij(1,1) = bijL(1,1);
        for col=2:imgWid
            Lij(1,col) = max(Lij(1,col-1),bijL(1,col));
        end        
        % cacu Rij
        Rij(1,imgWid) = bijR(1,imgWid);
        for col=imgWid-1:-1:1
            Rij(1,col) = min(bijR(1,col),Rij(1,col+1));
        end
        % cacu Vij
        for col=1:imgWid
            if abs(Rij(1,col))==Inf && abs(Lij(1,col))==Inf
                Vij(row,col) = Inf;
            elseif abs(col-Lij(1,col))<=abs(col-Rij(1,col))
                Vij(row,col) = Lij(1,col);
            else
                Vij(row,col) = Rij(1,col);
            end
        end
    end
    
    % phase 2
    disMapR = zeros(imgHei,imgWid);
    disMapC = zeros(imgHei,imgWid);
    
    % cacu the (Zv(k), Wv(k))
    for i=1:imgHei
        curRow = i;
        for j=1:imgWid
            if i==1
                istart = 1;
            else
                istart = disMapR(i-1, j);
            end
            minDis = Inf;
            minRow = i;
            for h=istart:imgHei
                dis = (curRow-h)*(curRow-h)+(j-Vij(h, j))*(j-Vij(h, j));
                if dis<=minDis
                    minDis = dis;
                    minRow = h;
                end
            end
            disMapR(curRow, j) = minRow;
            disMapC(curRow, j) = Vij(minRow, j);
        end
    end
    
    disMap = zeros(imgHei,imgWid);
    for i=1:imgHei
        for j=1:imgWid
            dx = disMapR(i,j) - i;
            dy = disMapC(i,j) - j;
            disMap(i,j) = sqrt(dx*dx+dy*dy);
        end
    end
    
    maxVal = max(max(disMap));
    s = disMap./maxVal;
    figure,imshow(s);
    return;
            
                
        
        
        
        
    