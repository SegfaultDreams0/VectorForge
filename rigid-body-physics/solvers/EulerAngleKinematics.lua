-- rigid-body-physics implementation for EulerAngleKinematics
-- Units: SI (kg, m, s, N, N m); spatial vectors are numeric arrays and rotational state conventions are stated by the method.

local Module = {}
function Module.BodyRatesToEulerRates(angles,bodyRates)
    local phi,theta=angles[1],angles[2]; local p,q,r=bodyRates[1],bodyRates[2],bodyRates[3]
    local cosine=math.cos(theta); assert(math.abs(cosine)>1e-8,"Euler pitch singularity")
    return {p+math.sin(phi)*math.tan(theta)*q+math.cos(phi)*math.tan(theta)*r,math.cos(phi)*q-math.sin(phi)*r,(math.sin(phi)*q+math.cos(phi)*r)/cosine}
end

return Module
