-- orbital-mechanics implementation for LagrangePoints
-- Units: SI (m, s, kg); central-body dynamics use Newtonian point-mass gravity, with perturbations included only in the named methods.

local Module = {}
function Module.Collinear(muRatio,point)
    assert(muRatio>0 and muRatio<0.5,"mass ratio must be in (0,0.5)"); assert(point==1 or point==2 or point==3,"point must be L1, L2, or L3")
    local x=if point==1 then 1-muRatio-(muRatio/3)^(1/3) elseif point==2 then 1-muRatio+(muRatio/3)^(1/3) else -1-(5*muRatio/12)
    for _=1,80 do
        local r1=math.abs(x+muRatio); local r2=math.abs(x-1+muRatio)
        local f=x-(1-muRatio)*(x+muRatio)/r1^3-muRatio*(x-1+muRatio)/r2^3
        local df=1-(1-muRatio)*(1/r1^3-3*(x+muRatio)^2/r1^5)-muRatio*(1/r2^3-3*(x-1+muRatio)^2/r2^5)
        local step=f/df; x-=step; if math.abs(step)<1e-13 then return x end
    end
    error("collinear Lagrange point iteration failed")
end

return Module
