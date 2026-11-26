-- Shared domain helpers; standard linear algebra is delegated to VectorForge Core
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VectorForge = ReplicatedStorage:WaitForChild("VectorForge")
local LA = require(VectorForge:WaitForChild("SpectralLinearAlgebra"))
local N = {}
function N.Positive(value,label)
    assert(type(value)=="number" and value==value and value>0 and value<math.huge,(label or "value").." must be positive and finite")
    return value
end
function N.Nonnegative(value,label)
    assert(type(value)=="number" and value==value and value>=0 and value<math.huge,(label or "value").." must be nonnegative and finite")
    return value
end
function N.Add(a,b)
    assert(#a==#b,"array dimensions mismatch")
    if type(a[1])=="number" then local out=table.create(#a); for i=1,#a do out[i]=a[i]+b[i] end; return out end
    return LA.Add(a,b)
end
function N.Subtract(a,b)
    assert(#a==#b,"array dimensions mismatch")
    if type(a[1])=="number" then local out=table.create(#a); for i=1,#a do out[i]=a[i]-b[i] end; return out end
    return LA.Subtract(a,b)
end
function N.Scale(a,s)
    if type(a[1])=="number" then local out=table.create(#a); for i=1,#a do out[i]=a[i]*s end; return out end
    return LA.Scale(a,s)
end
function N.Cross3(a,b)
    assert(#a==3 and #b==3,"cross product requires 3-vectors")
    return {a[2]*b[3]-a[3]*b[2],a[3]*b[1]-a[1]*b[3],a[1]*b[2]-a[2]*b[1]}
end
function N.Det3(a)
    assert(#a==3 and #a[1]==3 and #a[2]==3 and #a[3]==3,"expected 3x3 matrix")
    return a[1][1]*(a[2][2]*a[3][3]-a[2][3]*a[3][2])-a[1][2]*(a[2][1]*a[3][3]-a[2][3]*a[3][1])+a[1][3]*(a[2][1]*a[3][2]-a[2][2]*a[3][1])
end
function N.Factorial(n)
    assert(n>=0 and n%1==0 and n<=170,"factorial argument out of range")
    local value=1; for i=2,n do value*=i end; return value
end
function N.Binomial(n,k)
    assert(n>=0 and k>=0 and k<=n and n%1==0 and k%1==0,"invalid binomial arguments")
    return N.Factorial(n)/(N.Factorial(k)*N.Factorial(n-k))
end
function N.ComplexAdd(a,b) return {Re=a.Re+b.Re,Im=a.Im+b.Im} end
function N.ComplexMul(a,b) return {Re=a.Re*b.Re-a.Im*b.Im,Im=a.Re*b.Im+a.Im*b.Re} end
function N.ComplexScale(a,s) return {Re=a.Re*s,Im=a.Im*s} end
function N.ComplexExp(theta) return {Re=math.cos(theta),Im=math.sin(theta)} end
function N.ComplexAbs2(a) return a.Re*a.Re+a.Im*a.Im end
function N.RK4(f,x,t,h)
    local k1=f(x,t); local k2=f(N.Add(x,N.Scale(k1,h/2)),t+h/2)
    local k3=f(N.Add(x,N.Scale(k2,h/2)),t+h/2); local k4=f(N.Add(x,N.Scale(k3,h)),t+h)
    local weighted=N.Add(N.Add(k1,N.Scale(k2,2)),N.Add(N.Scale(k3,2),k4))
    return N.Add(x,N.Scale(weighted,h/6))
end
function N.StumpffC(z)
    if math.abs(z)<1e-7 then return 0.5-z/24+z*z/720-z*z*z/40320 end
    if z>0 then local q=math.sqrt(z); return (1-math.cos(q))/z end
    local q=math.sqrt(-z); return (math.cosh(q)-1)/(-z)
end
function N.StumpffS(z)
    if math.abs(z)<1e-7 then return 1/6-z/120+z*z/5040-z*z*z/362880 end
    if z>0 then local q=math.sqrt(z); return (q-math.sin(q))/(q*q*q) end
    local q=math.sqrt(-z); return (math.sinh(q)-q)/(q*q*q)
end
function N.TensorLinearIndex(indices,shape)
    assert(#indices==#shape,"tensor index rank mismatch"); local linear,stride=1,1
    for axis=#shape,1,-1 do local index=indices[axis]; assert(index>=1 and index<=shape[axis] and index%1==0,"tensor index out of bounds"); linear+=(index-1)*stride; stride*=shape[axis] end
    return linear
end
function N.TensorMultiIndex(linear,shape)
    local total=1; for _,size in ipairs(shape) do N.Positive(size,"tensor dimension"); total*=size end
    assert(linear>=1 and linear<=total and linear%1==0,"linear index out of bounds")
    local rest=linear-1; local indices=table.create(#shape)
    for axis=#shape,1,-1 do indices[axis]=(rest%shape[axis])+1; rest=math.floor(rest/shape[axis]) end
    return indices
end
function N.TridiagonalSolve(lower,diagonal,upper,rhs)
    local n=#diagonal; assert(#rhs==n and #lower==n-1 and #upper==n-1,"tridiagonal dimensions mismatch")
    local c=table.clone(upper); local d=table.clone(rhs); local b=table.clone(diagonal)
    for i=2,n do local m=lower[i-1]/b[i-1]; b[i]-=m*c[i-1]; d[i]-=m*d[i-1] end
    local x=table.create(n); x[n]=d[n]/b[n]
    for i=n-1,1,-1 do x[i]=(d[i]-c[i]*x[i+1])/b[i] end
    return x
end
function N.ChebyshevGrid(n)
    assert(n>=2 and n%1==0,"Chebyshev order must be >= 2")
    local x=table.create(n+1); for j=0,n do x[j+1]=math.cos(math.pi*j/n) end; return x
end
function N.InverseNormalCDF(p)
    assert(p>0 and p<1,"probability must be strictly between zero and one")
    local a={-39.6968302866538,220.946098424521,-275.928510446969,138.357751867269,-30.6647980661472,2.50662827745924}
    local b={-54.4760987982241,161.585836858041,-155.698979859887,66.8013118877197,-13.2806815528857}
    local c={-0.00778489400243029,-0.322396458041136,-2.40075827716184,-2.54973253934373,4.37466414146497,2.93816398269878}
    local d={0.00778469570904146,0.32246712907004,2.445134137143,3.75440866190742}
    local plow=0.02425; local q,r
    if p<plow then q=math.sqrt(-2*math.log(p)); return (((((c[1]*q+c[2])*q+c[3])*q+c[4])*q+c[5])*q+c[6])/((((d[1]*q+d[2])*q+d[3])*q+d[4])*q+1) end
    if p>1-plow then q=math.sqrt(-2*math.log(1-p)); return -(((((c[1]*q+c[2])*q+c[3])*q+c[4])*q+c[5])*q+c[6])/((((d[1]*q+d[2])*q+d[3])*q+d[4])*q+1) end
    q=p-0.5; r=q*q
    return (((((a[1]*r+a[2])*r+a[3])*r+a[4])*r+a[5])*r+a[6])*q/(((((b[1]*r+b[2])*r+b[3])*r+b[4])*r+b[5])*r+1)
end


function N.FFTComplexRadix2(samples)
    local n=#samples
    assert(n>=1 and bit32.band(n,n-1)==0,"complex radix-2 FFT length must be a power of two")
    local out=table.create(n)
    for i=1,n do
        assert(type(samples[i].Re)=="number" and type(samples[i].Im)=="number","complex sample requires Re and Im")
        out[i]={Re=samples[i].Re,Im=samples[i].Im}
    end
    local j=0
    for i=0,n-2 do
        if i<j then out[i+1],out[j+1]=out[j+1],out[i+1] end
        local bit=math.floor(n/2)
        while bit32.band(j,bit)~=0 do j-=bit; bit=math.floor(bit/2) end
        j+=bit
    end
    local length=2
    while length<=n do
        local root=N.ComplexExp(-2*math.pi/length)
        for start=1,n,length do
            local w={Re=1,Im=0}
            for offset=0,length/2-1 do
                local even=out[start+offset]
                local odd=N.ComplexMul(w,out[start+offset+length/2])
                out[start+offset]=N.ComplexAdd(even,odd)
                out[start+offset+length/2]={Re=even.Re-odd.Re,Im=even.Im-odd.Im}
                w=N.ComplexMul(w,root)
            end
        end
        length*=2
    end
    return out
end

return N
