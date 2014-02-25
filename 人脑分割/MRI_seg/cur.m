function D = cur(q, hx, hy);
  
u=q;
eps=1e-8;
%eps=1;

q    = addsam(q);
qx   = (q(2:end,:) - q(1:end-1,:))/hx;
qy   = (q(:,2:end) - q(:,1:end-1))/hy;
tmp  = qx./sqrt(10+qx.^2 + eps);
qxx  = (tmp(2:end,:) - tmp(1:end-1,:))/hx;
tmp  = qy./sqrt(10+qy.^2 + eps);
qyy  = (tmp(:,2:end) - tmp(:,1:end-1))/hy;
D    = (qxx(:,2:end-1)  + qyy(2:end-1,:))*(hx*hy);
return;