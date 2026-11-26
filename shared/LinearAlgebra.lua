-- linear algebra
local LA = {}
function LA.Copy(A)
    local B = table.create(#A)
    for i,row in ipairs(A) do B[i] = table.clone(row) end
    return B
end
function LA.Transpose(A)
    local m,n = #A,#A[1]
    local T = table.create(n)
    for j=1,n do T[j]=table.create(m) end
    for i=1,m do for j=1,n do T[j][i]=A[i][j] end end
    return T
end
function LA.Multiply(A,B)
    assert(#A[1] == #B, "matrix dimensions do not conform")
    local C = table.create(#A)
    for i=1,#A do
        C[i]=table.create(#B[1],0)
        for k=1,#B do for j=1,#B[1] do C[i][j] += A[i][k]*B[k][j] end end
    end
    return C
end
function LA.Identity(n)
    local I=table.create(n)
    for i=1,n do I[i]=table.create(n,0); I[i][i]=1 end
    return I
end
function LA.Norm2(x)
    local s=0
    for i=1,#x do s += x[i]*x[i] end
    return math.sqrt(s)
end
return LA
