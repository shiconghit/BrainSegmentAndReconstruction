function thres = IterSelThres(srcImg, bShow)
    [imgHei,imgWid] = size(srcImg);
    dSrcImg = double(srcImg);
    % choose the four corner pixels of the image as the bk pixels
    % scale be the 1/20 of the hei and wid of the image
    crgHei = floor(imgHei/20);
    crgWid = floor(imgWid/20);
    if crgHei<=0 || crgWid<=0
        error('Image too small!');
        return;
    end    
    % collect the four corner pixels
    crgPixels = dSrcImg(1:crgHei,1:crgWid);%topleft
    crgPixels = [crgPixels;dSrcImg(1:crgHei,imgWid-crgWid+1:imgWid)];%topright
    crgPixels = [crgPixels;dSrcImg(imgHei-crgHei+1:imgHei,1:crgWid)];%bottomleft
    crgPixels = [crgPixels;dSrcImg(imgHei-crgHei+1:imgHei,imgWid-crgWid+1:imgWid)];%bottomright
    [crgHei,crgWid] = size(crgPixels);
    % cacu the aver gray value of these corner pixels
    sum = 0;
    for i=1:crgHei
        for j=1:crgWid
            sum = sum+crgPixels(i,j);
        end
    end
    iniT = floor(sum/(crgHei*crgWid));
    
    % as default,the gray value of bk pixels be small,and ob gray value be large
    curT =  iniT % the result threshold
    preT = -1 % the threshold of last iteration
    while abs(curT-preT)>1e-1
        % cacu the average gray value of bk and object under current threshold 
        bkGraySum = 0;
        obGraySum = 0;
        bkGrayNum = 0;
        obGrayNum = 0;
        for i=1:imgHei
            for j=1:imgWid
                if dSrcImg(i,j)<=curT
                    bkGraySum = bkGraySum+dSrcImg(i,j);
                    bkGrayNum = bkGrayNum +1;
                else                    
                    obGraySum = obGraySum+dSrcImg(i,j);
                    obGrayNum = obGrayNum +1;
                end
            end
        end
        if bkGrayNum==0 || obGrayNum==0
            break;
        end
        avrBkGray = bkGraySum/bkGrayNum;
        avrObGray = obGraySum/obGrayNum;
        % update the curT and preT
        preT = curT;
        curT = (avrBkGray+avrObGray)/2.0;
    end    
    thres = curT;
    
    if bShow == 0
        return;
    end
    % show the result image undre this threshold
    newImage = zeros(imgHei,imgWid);
    for i=1:imgHei
        for j=1:imgWid
            if dSrcImg(i,j)>curT
                newImage(i,j) = 1;
            end
        end
    end
    newImage = medfilt2(newImage);
    figure,imshow(newImage);
    