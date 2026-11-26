-- state space definition
local M = {}
function M.new(A,B,C,D)
    assert(#A > 0 and #A == #B and #C > 0 and #C == #D, "state space dimensions mismatch")
    return {A=A,B=B,C=C,D=D,StateDimension=#A,OutputDimension=#C,InputDimension=#B[1]}
end
function M.Validate(model)
    assert(#model.A == model.StateDimension and #model.B == model.StateDimension, "invalid state matrices")
    return true
end
return M
