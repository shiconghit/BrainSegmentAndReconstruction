function f = sdf2circle3(nrow,ncol, ic,jc,r)
%   computes the signed distance to a circle
%   input     nrow: number of rows
%             ncol: number of columns
%             (ic,jc): center of the circle
%             r: radius of the circle
%   output    f: signed distance to the circle
[X,Y] = meshgrid(1:ncol, 1:nrow);
f = sqrt((X-jc*3/2).^2+(Y-ic/2).^2)-r;