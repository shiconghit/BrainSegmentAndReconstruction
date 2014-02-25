function phi1 = m_levelset(U,s)
% three images are provided for test
t=s;    % example that CV model works well
[nrow,ncol] =size(U);
[y,x] = ginput(2); 
r = sqrt((y(2)-y(1))^2+(x(2)-x(1))^2);
phi1= sdf2circle(nrow,ncol,x(1),y(1),r);
% [y,x] = ginput(1);
% phi2= sdf2circle(nrow,ncol,x,y,r);
delta_t = 0.1;
lambda_1=1;lambda_2=1;
nu=0;h = 1;epsilon=1;
mu = 0.01*255*255;  % tune this parameter for different images
I=double(U);
hold on;
plotLevelSet(phi1,0,'r');
% plotLevelSet(phi2,0,'b');
numter =1;
for k=1:t,
    phi1=evolution_cv(I, phi1, mu, nu, lambda_1, lambda_2, delta_t, epsilon, numter); % update level set function
%     phi2=evolution_cv(I, phi2, mu, nu, lambda_1, lambda_2, delta_t, epsilon, numter);
    if mod(k,2)==0    %%%%%%  显示水平集变化过程
        pause(.3);
        imagesc(I,[0 255]);colormap(gray)
        hold on;
        plotLevelSet(phi1,0,'r');
%         plotLevelSet(phi2,0,'b');
    end    
end;

%%
Message = '水平集分割完毕';
msgbox(Message);