%脑部MRI图像的三维重建及动画显示
%brainavi．m 
clear%清除内存 
clc%清除屏幕 

Figwin=figure('Name' , '脑部三维重建及旋转动画演示 ','NumberTitle' , 'off' ,'Menubar','none' ); 
%产生标题为”脑部 维重建及旋转动画演示”的图形窗 
%口 
%%%1．读入脑部MRl图像%%%
%%%%%%load mri  %调入脑部MRI图像数据 
D=imread('788_6_9.bmp');
for i=10:1:30
    fname = sprintf('788_6_%d.bmp',i);
    x=fname;
    d= imread(x);
    D = cat(3,D,d);
end%用for循环读入所有的bmp信息，用cat函数进行三维数组排列

%D=squeeze(D); %将D从4维转换为3维 
Ds=smooth3(D);%采用高斯低通滤波器对D进行平 
%滑，得Ds 
%%%2．脑部三维重建与旋转动画显示%%% 
fv=isosurface(Ds,20); 
%脑部等值面抽取，阈值k=20，见公式(1)。fv是一个结构 
%数组，其中 
%fv．veaices为图形的顶点信息；fv．faces为图形的表面信 
%息 
fv2=isocaps(D,5);%脑部上盖的等值面抽取，闽值k=5 
yuan=fv.vertices; %令yuan为原脑部图形的顶点信息 
yuan2=fv2.vertices;%令yuan2为原脑部上盖图形的顶点 
%信息 
N=length(yuan);%N和N2分别为yuan和yuan2的 
%像素个数 
N2=length(yuan2); 
xg=sum(yuan(: ,1))/N;yg=sum(yuan(: ,2))/N; 
zg=sum(yuan(: ,3))/N;
xg2=sum(yuan2(: ,1))/N2;
yg2=sum(yuan2(: ,2))/N2; 
zg2=sum(yuan2(: ,3))/N2; 
%求yuan和yuan2的质心，见公式(2) 
T1=[1 0 0 0;0 1 0 0;0 0 1 0;-xg -yg -zg 1]; 
T3=[1 0 0 0;0 1 0 0;0 0 1 0;xg yg zg 1];
T12=[1 0 0 0;0 1 0 0;0 0 1 0;-xg2 -yg2 -zg2 1]; 
T32=[1 0 0 0;0 1 0 0;0 0 1 0;xg2 yg2 zg2 1]; 
%3D旋转矩阵中的T1和T3，见公式(2)、(4) 
M=24;  %动画画面的帧数，M=24 
close('all');
mov = avifile('E:\brainRotate.avi'); %创建脑部旋转动画文件 brainRotate.avi 
for j=1:M %以循环方式产生、显示与保存脑部旋转动画 
    xian=0; 
    xian2=0; 
    %xian和xian2的初始化。xian和xian2分别为yuan和 
    %yuan2每次旋转后的动画画面。 
    th=2*pi/M*j; %每次绕z轴旋转的角度m。 
    a=0;  %每次绕x轴旋转的角度a。 
    b=0; %每次绕Y轴旋转的角度b。 
    Rx=[1 0 0 0;0 cos(a) sin(a) 0;0 -sin(a) cos(a) 0;0 0 0 1]; 
    Ry=[cos(b) 0 -sin(b) 0;0 1 0 0;sin(b) 0 cos(b) 0; 0 0 0 1]; 
    Rz=[cos(th) sin(th) 0 0;-sin(th) cos(th) 0 0;0 0 1 0;0 0 0 1]; 
    T2=Rx*Ry*Rz;%3D旋转变换T2，见公式(3) 
    T=T1*T2*T3; %脑部图形及上盖绕自身质心旋转的变 
    %换矩阵T和TT，见公式(5) 
    TT=T12*T2 *T32; 
    xian=[yuan ones(N,1)] * T; %脑部图形及上盖的3D 
    %旋转变换，见公式(6) 
    xian2=[yuan2 ones(N2,1)] * T; 
    xian=xian(: ,1 :3);%脑部绕其质心在平行于z轴的方向 
    %旋转360度(共24帧) 
    xian2=xian2(: ,1:3); %脑部上盖绕其质心在平行于 
    %z轴的方向旋转360度(共24帧) 
    axis([50 250 50 250 0 60])
    daspect([1,1,0.4]);view(3) 
    patch( 'Vertices',xian, 'Faces',fv.faces, 'Facecolor',[1,0.75,0.65],'EdgeColor','none'); 
    hold on 
    patch( 'Vertices',xian2,'Faces' ,fv2.faces,'FaceColor' ,[1,0.75,0.65],'EdgeColor','none' ); 
    %分别对脑部及其上盖进行面绘制 维重建。顶点为已经 
    %过3D旋转的xian与xian2，而表面信息不变，仍然是 
    %fv．faces与fv2．faces，并设定图形表而颜色与边缘颜色。 
    hold on;
    lightangle(th,30);lighting phong;%利用phone模型进 
    %行灯光设置 
    xlabel( 'x' );ylabel('Y');zlabel('Z'); %显示X，Y，Z坐 
    %标轴 
    F=getframe(gcf); %产生一帧动画 
    mov=addframe(mov,F);
    %将动面帧F加入动画文件mov中 
    name=strcat( 'a' ,num2str(j)); 
    print( '-dtiff' ,name);
    %将动画的各帧图片存入名称为aj．tif的图像文件中(j= 
    %1-24) 
        if j~=M+1  %擦除上一帧的画面 
            delete(gca); 
        end 
end 
aviobjl=close(mov);  %显示完毕，关闭动㈣文件

