function  wh = addsam(wh)

%---------------------------------------------------------
   wh = [wh(:,1), wh, wh(:,end)]; wh = [wh(1,:); wh; wh(end,:)];

