function edgePt = EdgeDetectionUseThres(srcImg)
    dImage = double(srcImg);
    dImage = medfilt2(dImage);
    threshold = IterSelThres(dImage, 0);
    PI = 3.1415927;
    [hei,wid]=size(srcImg);
    
    newImage = zeros(hei,wid);
    % create the two-value image matrix
    for i=1:hei
        for j=1:wid
            if dImage(i,j)>threshold
                newImage(i,j)=1;
            else
                newImage(i,j)=0;
            end
        end
    end         
    % median filter the two-value image ,to eliminate the noisy and small
    % islands
    newImage = medfilt2(newImage);
    
    startPt = floor(ginput(1));
    
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
    dirUsed = 0;
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
            dirUsed = 0;
        else
            dir = mod(dir+7,8);
            dirUsed = dirUsed + 1;
        end
        if dirUsed>=8
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