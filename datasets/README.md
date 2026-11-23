# Datasets

## Overview

The `datasets/` directory stores small, version-controlled data tables used by examples, simulations, tests, and visual demonstrations.

The modules in this directory provide input data only. They do not perform numerical integration, mutate Roblox instances, or download external datasets.

## Contents

| Module | Description |
|---|---|
| `PhysicalConstants.lua` | Selected physical constants in SI units |
| `SolarSystem.lua` | Approximate heliocentric orbital reference values for selected planets |
| `MotionSamples.lua` | A deterministic sample sequence of timestamped 2D position observations |

## Data conventions

- Physical quantities use SI units unless a field explicitly states otherwise.
- Orbital distances are mean semi-major axes, not instantaneous positions.
- Orbital periods are expressed in seconds.
- Planetary masses and orbital values are rounded reference values and should not be treated as precision ephemerides.
- The motion sample set is synthetic and intended for examples or filter experiments; it is not measured sensor data.

## Usage

```lua
local constants = require(path.to.PhysicalConstants)
local planets = require(path.to.SolarSystem)
local samples = require(path.to.MotionSamples)

local earthMu = constants.gravitationalConstant * planets.Earth.mass
local firstObservation = samples[1]
```

## Data integrity

Keep units, provenance, precision, and assumptions documented when adding new entries. Avoid mixing measured, synthetic, and approximate values without labeling them clearly.

## Status

The included values are compact reference data for educational and experimental use. They are not a substitute for authoritative scientific databases or mission-grade ephemerides.
