function edgePt = EdgeDetection(srcImg)
    PI = 3.1415927;
    [hei,wid]=size(srcImg);
%     figure,imhist(image);
    dImage = double(srcImg);

    DX = zeros(hei,wid);
    DY = zeros(hei,wid);
    DA = zeros(hei,wid); % the gradient matrix of image
    for i=2:hei
        for j=2:wid
            DX(i,j) = dImage(i,j)-dImage(i,j-1);
            DY(i,j) = dImage(i,j)-dImage(i-1,j);
            DA(i,j) = sqrt(DX(i,j)*DX(i,j)+DY(i,j)*DY(i,j));
        end
    end

    DGate = 55.723; % set the thres of the gradient
    bFindFirst = 0;
    rgGGate = 0;    
    hold on;     
    startPt = floor(ginput(1));
    plot(startPt(1),startPt(2),'ro');
    for i=startPt(2)+1:hei
        for j=startPt(1)+1:wid            
            if DA(i,j)>DGate% if the gradient up the threshold
                % cacu the average gray value of pixels in 3*3 adjacent
                % region as the threshold of the edge gray value
                rgGGate = CacuMedianGray(dImage,i,j,hei,wid);
                plot(j,i,'r.');
                bFindFirst = 1;
                break;
            end
        end
        if bFindFirst == 1
            break;
        end
    end
    hold off;
   
    newImage = zeros(hei,wid);
    rgGGate = 30;
%     for i=1:hei
%         bSetMinJ = 0;
%         minj = 0;
%         maxj = 0;
%         for j=1:wid
%             if dImage(i,j)>rgGGate
%                 if bSetFP == 0
%                     firstPX = j-1;
%                     firstPY = i-1;
%                     bSetFP = 1;
%                 end
%                 if bSetMinJ==0
%                     minj = j;
%                     bSetMinJ=1;
%                 end
%                 maxj = j;
%             end
%         end
%         if minj~=0
%             newImage(i,minj:maxj)=ones(1,maxj-minj+1);
%         end
%     end        
    % create the two-value image matrix
    for i=1:hei
        for j=1:wid
            if dImage(i,j)>rgGGate
                newImage(i,j)=1;
            else
                newImage(i,j)=0;
            end
        end
    end         
    % median filter the two-value image ,to eliminate the noisy and small
    % islands
    newImage = medfilt2(newImage);
    
    % find the first pixel on the edge
    bSetFP = 0;
    firstPX = 0;
    firstPY = 0;
    for i=startPt(2)+1:hei
        for j=startPt(1)+1:wid
            if newImage(i,j)==1
                firstPX = j-1;
                firstPY = i-1;
                bSetFP = 1;
                break;
            end
        end
        if bSetFP==1
            break;
        end
    end  
    
    % array for store the edge pixels
    edgePt = [firstPX firstPY];
    P0 = edgePt;
    newImage(P0(2)+1,P0(1)+1) = 2;
    curPt = zeros(1,2);
    prePt = zeros(1,2);
    dir  = 0;
    curPt = P0;
    prePt = P0;
    bSetP1 = 0;
    P1 = zeros(1,2);
    % find P1 and first step dir
    while(1)      
        [deltaI,deltaJ] = DirToIndex8(dir);
        tmpx = curPt(1)+deltaJ;
        tmpy = curPt(2)+deltaI;
        if newImage(tmpy+1,tmpx+1)==1
            P1 = [tmpx tmpy];
            curPt = P1;
            edgePt = [edgePt;P1];
            newImage(curPt(2)+1,curPt(1)+1) = 2;
            break;
        end
        dir = mod(dir+7,8);
    end
    
%     figure;
%     imshow(newImage);
%     axis([1 wid 1 hei]);
%     axis ij;
%     hold on;
    times = 0;
    dirType = 0;
    while (1)
%         times = times+1;
%         if mod(times,100)==0
%             disp('100 times');
%         end
        [deltaI,deltaJ] = DirToIndex8(dir);        
        tmpx = curPt(1)+deltaJ;
        tmpy = curPt(2)+deltaI;
        flag = IsRgPt(tmpx,tmpy,newImage,0);      
        if newImage(tmpy+1,tmpx+1)==1&&flag==0
            prePt = curPt;
            curPt = [tmpx tmpy];
            edgePt = [edgePt;curPt];
%             plot(curPt(1)+1,curPt(2)+1,'g.');
            newImage(curPt(2)+1,curPt(1)+1) = 2;
            dirType = 0;
        else
            dir = mod(dir+7,8);
            dirType = dirType+1;
        end
        if dirType>=8
            break;
        end
        % when curPt==P1 and prePt==P0,alogrithm finished        
        if tmpx==P1(1)&&tmpy==P1(2)&&prePt(1)==P0(1)&&prePt(2)==P0(2)
            break;
        end 
    end   
%     hold off;  
%     disp('End');
    
    figure;
    imshow(newImage);
    axis([1 wid 1 hei]);
    axis ij;
    hold on;
    for i=1:hei
        for j=1:hei
            if newImage(i,j)==2
                plot(j,i,'g.');
            end
        end
    end
    hold off;      
%     for i=firstPY+1:hei
%         for j=firstPX:wid            
%             if DA(i,j)>DGate % 意味着是边界元素，记录下位置
%                 edgePt = [edgePt;[j-1,i-1]];
%                 plot(j-1,i-1,'r.');
%                 continue;
%             end
%             % 如果不是边界点，则计算3×3邻域灰度均值，与阈值判断，决定它是边界内
%             % 还是外的一点            
%             tagPt = [j-1,i-1];
%             times = 0;
%             while (DA(tagPt(2),tagPt(1))<=DGate)                   
%                 times = times+1;
%                 if times>8
%                     break;
%                 end
%                 medGray = CacuMedianGray(dImage,i,j,hei,wid);
%                 [deltai,deltaj] = AngleToDirection(DX(tagPt(2)+1,tagPt(1)+1),DY(tagPt(2)+1,tagPt(1)+1));                
%                 if medGray>rgGGate % 是区域内的一点
%                     % 根据其梯度的方向
%                     tagPt(2) = tagPt(2) + 1;
%                 else % 是区域外的一点
%                     tagPt(2) = tagPt(2) - 1;
%                 end
%             end
%             if times>8
%                 disp('failed to find adjacent pt!');
%                 return;
%             end
%             edgePt = [edgePt;tagPt];
%             plot(tagPt(1),tagPt(2),'r.');
%         end
%     end
%  
%     hold off;  