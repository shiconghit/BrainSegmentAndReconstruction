function bFlag=IsRgPt(ptx,pty,srcImg,gray)
    [hei,wid] = size(srcImg);
    if ptx<=0 || ptx>=wid-1 || pty<=0 || pty>=hei-1
        bFlag = 0;
        return;
    end
    
    tg = srcImg(pty,ptx+1);
    rg = srcImg(pty+1,ptx+2);
    bg = srcImg(pty+2,ptx+1);
    lg = srcImg(pty+1,ptx);
    
    if tg==gray||rg==gray||bg==gray||lg==gray
        bFlag = 0;
    else
        bFlag = 1;
    end

                    