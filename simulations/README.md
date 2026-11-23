# Simulations

## Overview

The `simulations/` directory contains numerical models that advance a system through time. These scripts are intended for controlled experimentation with classical mechanics and dynamical systems in Roblox Luau.

The simulations are separate from `src/VectorForge/`. They are demonstrations and reusable starting points, not replacements for Roblox physics or a validated general-purpose physics engine.

## Contents

| Module | Description |
|---|---|
| `TwoBodyOrbit.lua` | Integrates the relative motion of two point masses under Newtonian gravity using a fourth-order Runge–Kutta method |
| `DampedOscillator.lua` | Simulates a one-dimensional mass–spring–damper system using RK4 |

## Usage

Place the modules somewhere accessible to the script that will run the experiment, then require the selected ModuleScript.

```lua
local TwoBodyOrbit = require(path.to.TwoBodyOrbit)

local state = {
    position = Vector3.new(7.0e6, 0, 0),
    velocity = Vector3.new(0, 7.5e3, 0),
}

local nextState = TwoBodyOrbit.step(state, {
    gravitationalParameter = 3.986004418e14,
    timeStep = 1,
})
```

The orbit module uses SI units:
- Position: metres
- Velocity: metres per second
- Gravitational parameter: cubic metres per second squared
- Time step: seconds

The oscillator uses:
- Displacement: metres
- Velocity: metres per second
- Mass: kilograms
- Spring stiffness: newtons per metre
- Damping: newton-seconds per metre
- Time: seconds

## Numerical method

Both modules use classical fourth-order Runge–Kutta integration. RK4 is an explicit fixed-step method. Accuracy depends on the chosen time step and the behavior of the modeled system. A smaller step is not automatically sufficient to guarantee stability or physical fidelity.

## Assumptions and limitations

- `TwoBodyOrbit` models relative two-body motion with a fixed gravitational parameter. It does not model perturbations, atmospheric drag, collisions, or relativistic effects.
- The orbit model rejects a zero-distance state because the point-mass gravitational acceleration is singular there.
- `DampedOscillator` models a linear spring and linear viscous damping.
- These modules do not create Roblox parts or update a scene. Use `visualizations/` for display utilities.
- Validate step size, initial conditions, and accumulated numerical error for each experiment.

## Design notes

The modules expose small `step` functions so callers control the simulation clock, stopping conditions, and data recording. They do not create background loops or depend on `RunService`.

## Status

Experimental. The implementations are educational numerical tools and have not been comprehensively validated against an independent simulation package.
