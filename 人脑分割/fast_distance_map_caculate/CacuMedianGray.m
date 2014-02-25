function medianGray = CacuMedianGray(ImageData,i,j,hei,wid)
    medianGray = 0;
    for a=-1:1
        for b=-1:1
            if (i+a)>=1&&(i+a)<=hei&&(j+b)>=1&&(j+b)<=wid
                medianGray = medianGray + ImageData(i+a,j+b);
            end
        end
    end
    medianGray = medianGray/9;