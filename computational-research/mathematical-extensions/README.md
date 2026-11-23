# VectorForge Mathematical Extensions

This directory contains standalone mathematical modules written in standard Lua 5.4. They are separate from the Roblox Luau core and do not depend on Roblox services or engine datatypes.

## Modules

- `VectorAlgebra.lua` — arbitrary-dimensional vector operations, projections, orthogonalization, and triple products.
- `NumericalAnalysis.lua` — high-order finite differences, Richardson extrapolation, adaptive quadrature, root finding, and Runge–Kutta integration.
- `PhysicsMechanics.lua` — Newtonian gravity, two-body orbital quantities, drag, energy, and rigid-body angular acceleration.
- `RoboticsKinematics.lua` — Denavit–Hartenberg transforms, forward kinematics, geometric Jacobians, and damped least-squares position IK.
- `ScientificComputing.lua` — complex arithmetic, radix-2 FFT, spectral energy, and Newton–Cotes weight construction.

## Compatibility

The modules target standard Lua 5.4. `ScientificComputing.lua` uses Lua 5.4 integer division and bitwise operators. The modules are not intended to be inserted directly into Roblox Studio without porting the syntax and checking runtime compatibility.

## Usage

Place the files in a directory on the Lua module search path and require them by module name.

```lua
local vector = require("VectorAlgebra")
local numerical = require("NumericalAnalysis")
local physics = require("PhysicsMechanics")
local robotics = require("RoboticsKinematics")
local science = require("ScientificComputing")

local a = vector.new(3, 4, 0)
local length = vector.norm(a)

local root, converged = numerical.newton(
    function(x) return x * x - 2 end,
    function(x) return 2 * x end,
    1
)

local acceleration = physics.newtonian_acceleration(
    {7e6, 0, 0},
    5.972e24,
    6.67430e-11
)
```

All functions use radians for angles and SI units when physical quantities are supplied in SI units. Numerical routines expose tolerances or iteration limits where relevant; callers should choose them according to the scale and conditioning of their problem.
