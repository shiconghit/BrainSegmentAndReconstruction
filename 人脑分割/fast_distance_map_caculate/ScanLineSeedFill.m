function [edgePt allSeqEdgePt]= ScanLineSeedFill(srcImg)
    PI = 3.1415927;
    [hei,wid]=size(srcImg);
    dImage = double(srcImg);
    DX = zeros(hei,wid);
    DY = zeros(hei,wid);
    DA = zeros(hei,wid); % ÌÝ¶È·ùÖµ¾ØÕó
    for i=2:hei
        for j=2:wid
            DX(i,j) = dImage(i,j)-dImage(i,j-1);
            DY(i,j) = dImage(i,j)-dImage(i-1,j);
            DA(i,j) = sqrt(DX(i,j)*DX(i,j)+DY(i,j)*DY(i,j));
        end
    end

    % get pos of all the input startPt
    hold on;
    allstartPts = [];
    but = 1;
    iterTime = 0;
    while but == 1
        [xi,yi,but] = ginput(1);
        plot(xi,yi,'r.')
        iterTime = iterTime+1;
        allstartPts = [allstartPts; [xi yi]];
    end
    allSeqEdgePt = [];
    % iteration for handle each startPt and save the edge pt info in a
    % total array
    DGate = 30; % set the thres of the gradient
    for ii = 1:iterTime
        bFindFirst = 0;
        rgGGate = 0; 
        startPt = allstartPts(ii,:);
        for i=startPt(2)+1:hei
            for j=startPt(1)+1:wid            
                if DA(i,j)>DGate % if the gradient up the threshold
                    % cacu the average gray value of pixels in 3*3 adjacent
                    % region as the threshold of the edge gray value
                    rgGGate = CacuMedianGray(dImage,i,j,hei,wid);
                    bFindFirst = 1;
                    break;
                end
            end
            if bFindFirst == 1
                break;
            end
        end

        newImage = zeros(hei,wid);
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
%         figure,imshow(newImage);

        color = 2;% the value mark the region
        rgVal = newImage(startPt(2)+1,startPt(1)+1);
        seed = startPt+1;
        seedNum = 1;    
        while(seedNum~=0)
            [curx cury seed] = popArray(seed);
            if cury<2||cury>hei-1
                break;
            end
            newImage(cury,curx) = color;
            x0 = curx+1;
            while x0<=wid&&newImage(cury,x0)==rgVal
                newImage(cury,x0) = color;
                x0 = x0+1;
            end
            xr = x0 - 1;
            x0 = curx - 1;
            while x0>=1&&newImage(cury,x0)==rgVal
                newImage(cury,x0) = color;
                x0 = x0-1;
            end
            xl = x0+1;
            % the lower scanline
            x0 = xl;
            cury = cury+1;
            while(x0<=xr)
                flag = 0;
                while (newImage(cury,x0)==rgVal)&&(newImage(cury,x0)~=color)&&(x0<xr)
                    if flag==0
                        flag = 1;
                    end
                    x0 = x0+1;
                end
                if flag==1
                    if x0==xr&&newImage(cury,x0)==rgVal&&newImage(cury,x0)~=color
                        seed = pushArray(seed,x0,cury);
                    else
                        seed = pushArray(seed,x0-1,cury);
                    end
                    flag = 0;
                end
                xnextspan = x0;
                while x0<=xr&&newImage(cury,x0)~=rgVal||newImage(cury,x0)==color
                    x0 = x0+1;
                end
                if xnextspan==x0
                    x0 = x0+1;
                end
            end

            % the upper scanline
            x0 = xl;
            cury = cury-2;
            while(x0<=xr)
                flag = 0;
                while (newImage(cury,x0)==rgVal)&&(newImage(cury,x0)~=color)&&(x0<xr)
                    if flag==0
                        flag = 1;
                    end
                    x0 = x0+1;
                end
                if flag==1
                    if x0==xr&&newImage(cury,x0)==rgVal&&newImage(cury,x0)~=color
                        seed = pushArray(seed,x0,cury);
                    else
                        seed = pushArray(seed,x0-1,cury);
                    end
                    flag = 0;
                end
                xnextspan = x0;
                while x0<=xr&&newImage(cury,x0)~=rgVal||newImage(cury,x0)==color
                    x0 = x0+1;
                end
                if xnextspan==x0
                    x0 = x0+1;
                end
            end

            % update the length of seed array, if it is zero, exit the while
            [seedNum,col] = size(seed);
        end

        edgeImg = zeros(hei,wid);
        edgePt = [];
        for i=1:hei
            for j=1:wid
                bflag = IsRgPt(j-1,i-1,newImage,1);
                if bflag == 0 && newImage(i,j)==2
                    edgePt = [edgePt; [j-1 i-1]];
                    edgeImg(i,j) = 1;
                end
            end
        end

%         maxVal = max(max(newImage));
%         sNewImage = newImage./maxVal;
%         figure;
%         imshow(sNewImage);
%         axis([0 wid-1 0 hei-1]);
%         axis ij;
%         hold on;
%         plot(edgePt(:,1), edgePt(:,2), 'g.');    
%         hold off;

        for i = 1:hei
            for j = 1:wid
                if edgeImg(i,j)~=1
                    continue;
                end
                firstPX = j-1;
                firstPY = i-1;
            end
        end
        % array for store the edge pixels
        seqEdgePt = [firstPX firstPY];
        P0 = seqEdgePt;
        edgeImg(P0(2)+1,P0(1)+1) = 2;
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
            if edgeImg(tmpy+1,tmpx+1)==1
                P1 = [tmpx tmpy];
                curPt = P1;
                seqEdgePt = [seqEdgePt;P1];
                edgeImg(curPt(2)+1,curPt(1)+1) = 2;
                break;
            end
            dir = mod(dir+7,8);
        end    

        times = 0;
        dirType = 0;
        while (1)
            [deltaI,deltaJ] = DirToIndex8(dir);        
            tmpx = curPt(1)+deltaJ;
            tmpy = curPt(2)+deltaI;
            flag = IsRgPt(tmpx,tmpy,edgeImg,0);      
            if edgeImg(tmpy+1,tmpx+1)==1&&flag==0
                prePt = curPt;
                curPt = [tmpx tmpy];
                seqEdgePt = [seqEdgePt;curPt];
                edgeImg(curPt(2)+1,curPt(1)+1) = 2;
                dirType = 0;
            else
                dir = mod(dir+7,8);
                dirType = dirType+1;
            end
            if dirType>=8
                break;
            end    
            if tmpx==P1(1)&&tmpy==P1(2)&&prePt(1)==P0(1)&&prePt(2)==P0(2)
                break;
            end 
        end
        
        % store seqEdgePt generated in every iteration
        allSeqEdgePt = [allSeqEdgePt; seqEdgePt];
    end % end of for ii=1:
    hold off;
    
    figure;
    imshow(srcImg);
    hold on;
    plot(allSeqEdgePt(:,1)+1, allSeqEdgePt(:,2)+1, 'm.')
    hold off;