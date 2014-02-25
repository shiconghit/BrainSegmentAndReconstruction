% main function of Shape registration
figure
srcImg=imread('C:\\Users\\shicong\\Desktop\\hai\\imgdata\\788_6_22.bmp','bmp');
%srcImg=imread('Brain1_dst_256256.bmp','bmp');
figure,imshow(srcImg);
hSrcImg = gcf
[hei, wid]=size(srcImg);

%create the menu for figure SrcImg 
f = uimenu(hSrcImg, 'Label','MouseInterAct');
uimenu(f,'Label','EdgeDetect','Callback','edgePtM = EdgeDetection(srcImg);');
uimenu(f,'Label','EgDtUseThres','Callback','edgePtM = EdgeDetectionUseThres(srcImg);');
uimenu(f,'Label','SeedFill','Callback','[edgePtM seqEdgePtM]= ScanLineSeedFill(srcImg);');
uimenu(f,'Label','PrlCmpuDisMap','Callback','[dismapy dismapx dismap] = ParallelComputeDisMap(srcImg,edgePtM);');

