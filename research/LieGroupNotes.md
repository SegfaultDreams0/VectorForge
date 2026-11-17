# Lie Group Notes

SO(3) contains 3x3 orthogonal matrices with determinant +1: `R^T R = I` and `det(R) = 1`.

Unit quaternions represent orientations using four scalar components constrained by unit norm. Implementations should document component order, multiplication convention, normalization policy, and coordinate-frame convention.

SE(3) combines rotation and translation in a homogeneous transform: `T = [ R  t ; 0  1 ]`.

Questions:
- Which quaternion convention does each implementation use?
- Are exponential and logarithmic maps stable near zero rotation?
- How are near-pi rotations handled?
- Are conversions tested against Roblox CFrame reference cases?
