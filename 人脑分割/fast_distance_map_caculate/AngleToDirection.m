function [deltai,deltaj]=AngleToDirection(dx,dy)
    PI = 3.1415927;
    if abs(dx)<1e-6
        deltaj = 0;
        deltai = sign(dy);
        return;
    end            
    absAngle = atan(abs(dy/dx));
    if absAngle<=PI/8
        deltai = 0;
        deltaj = sign(dx);
        return;
    end
    if absAngle>=PI*3/8
        deltaj = 0;
        deltai = sign(dy);
        return;
    end
    deltaj = sign(dx);
    deltai = sign(dy);
    return;