clear all%释放参数
D=imread('788_6_5.bmp');
for i=6:1:57
    fname = sprintf('788_6_%d.bmp',i);
    x=fname;
    d= imread(x);
    D = cat(3,D,d);
end%用for循环读入所有的bmp信息，用cat函数进行三维数组排列
D = squeeze(D);
[x y z D] = reducevolume(D, [4 4 1]);%按4 4 1抽取，减少数据量
D = smooth3(D); % 对数据进行平滑处理
p = patch(isosurface(x,y,z,D, 5,'verbose'), ...
'FaceColor', 'yellow', 'EdgeColor', 'none'); %patch创建块对象
p2 = patch(isocaps(x,y,z,D, 5), 'FaceColor', 'interp', 'EdgeColor','none');
view(3); 
axis tight; 
daspect([1 1 .4])%X,Y,Z轴显示比例
colormap(gray(100))
camlight; lighting gouraud%定义光照等