%%
%读取图像
clc;close all;
index = 25;%12-20效果较好，之后的还需调整阈值和优化
fileName = sprintf('imgdata\\788_6_%d.bmp', index);
imgData = imread(fileName);
imgData = medfilt2(imgData,[3,3]);
%figure,imshow(imgData);
%二值化
level = graythresh(imgData);
imgbw = im2bw(imgData,level);
%figure('name','imgbw'),imshow(imgbw);
%开闭运算，填充孔洞
SE1=strel('square',5);
imgbw_erode=imerode(imgbw,SE1); %erode
%figure('name','imgbw_erode'),imshow(imgbw_erode);
%imgbw_dilated = imdilate(imgbw_erode,SE1);
%figure('name','imgbw_erode'),imshow(imgbw_dilated);
%%
%种子生长法去除外层
I = imgData;
figure,imshow(I),title('原始图像')
I=double(I)/255;
[M,N]=size(I);
%种子点的选取
%x1=156;y1=109;%x1=116;y1=123;
x1 = ceil(M/2);
y1 = ceil(N/2);
seed1=I(x1,y1);             %将生长起始点灰度值存入seed中
Y=zeros(M,N);             %作一个全零与原图像等大的图像矩阵Y，作为输出图像矩阵
Y(x1,y1)=I(x1,y1);          %将Y中与所取点相对应位置的点设置为与原图像相同的灰度

sum1=seed1;               %储存符合区域生长条件的点的灰度值的和
suit1=1;                   %储存符合区域生长条件的点的个数
count1=1;                 %记录每次判断一点周围八点符合条件的新点的数目
threshold1=20/255;         %判断域值
while count1>0
 s1=0;                    %记录判断一点周围八点时，符合条件的新点的灰度值之和
 count1=0;
 for i1=1:M
   for j1=1:N
     if Y(i1,j1)~=0
      if (i1-1)>0 && (i1+1)<(M+1) && (j1-1)>1 && (j1+1)<(N+1)
 %判断此点是否为图像边界上的点
       for u=-1:1                                %判断点周围八点是否合和域值条件
        for v=-1:1                               %u,v为偏移量
          if  Y(i1+u,j1+v)==0 && abs(I(i1+u,j1+v)-seed1)<=threshold1    
%判断是否未存在于输出矩阵Y，并且为符合域值条件的点
             Y(i1+u,j1+v)=I(i1+u,j1+v);            %符合以上两条件即将其在Y中与之位置对应的点设置为白场
             count1=count1+1;                    %此次循环新点数增1
             s1=s1+I(i1+u,j1+v);                   %此点的灰度之加入s中
          end
        end  
       end
      end
     end
   end
 end
suit1=suit1+count1;                         %将n加入符合点数计数器中
sum1=sum1+s1;                           %将s加入符合点的灰度值总合中
seed1=sum1/suit1;                          %计算新的灰度平均值
end
figure,imshow(Y)
[B,L] = bwboundaries(Y, 'noholes');
figure,imshow(Y); hold on;
boundary = B{1};
plot(boundary(:,2), boundary(:,1), 'r','LineWidth',2);
BW = roipoly(I,boundary(:,2), boundary(:,1));
roi = immultiply(BW,imgData);
%figure, imshow(roi);
%%
%模糊c均值聚类
cluster_n = 4;%类的数目
[center, u, obj_fcn] = fcm(double(roi(:)), cluster_n);
[m,n] = size(roi);

ppp = sort(center,'descend');
for i = 1:cluster_n
    CIndex(i) = find(center == ppp(i));
end
l = m*n;
for k = 1:l
    cluster = find(u(:,k) == max(u(:,k)),1);
    order = find(CIndex == cluster,1); 
    imgData(mod(k-1,n)+1,fix((k-1)/n+1)) =  255-(order-1)*255/(cluster_n-1);
end
figure('name','fuzzy c-means clustering'),imshow(imgData);
break