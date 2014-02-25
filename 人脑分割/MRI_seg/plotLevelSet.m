function [c,h]=plotLevelSet(u,zLevel, style)
%   plotLevelSet(u,zLevel, style) plot the level contour of function u at
%   the zLevel.
[c,h] = contour(u,[zLevel zLevel],style); 