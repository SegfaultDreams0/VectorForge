# Visualizations

## Overview

The `visualizations/` directory contains Roblox Luau utilities that turn numerical output into simple 3D scene elements.

These utilities are deliberately separate from the mathematical models. A simulation should calculate values; a visualization should display those values. This separation makes it easier to test numerical code without creating or depending on Roblox instances.

## Contents

| Module | Description |
|---|---|
| `TrajectoryRenderer.lua` | Draws a sampled sequence of `Vector3` positions as anchored line segments |
| `VectorFieldRenderer.lua` | Displays a set of vector samples as anchored direction indicators |

## Usage

### Trajectory renderer

```lua
local TrajectoryRenderer = require(path.to.TrajectoryRenderer)

local points = {
    Vector3.new(0, 5, 0),
    Vector3.new(5, 8, 0),
    Vector3.new(10, 5, 0),
}

local model = TrajectoryRenderer.draw(points, {
    parent = workspace,
    thickness = 0.15,
    color = Color3.fromRGB(70, 170, 255),
})
```

### Vector field renderer

```lua
local VectorFieldRenderer = require(path.to.VectorFieldRenderer)

local samples = {
    {
        position = Vector3.new(0, 5, 0),
        vector = Vector3.new(1, 0, 0),
    },
    {
        position = Vector3.new(5, 5, 0),
        vector = Vector3.new(0, 1, 0),
    },
}

local model = VectorFieldRenderer.draw(samples, {
    parent = workspace,
    scale = 2,
})
```

## Behavior

- Each renderer creates a `Model` and parents it to the supplied `parent`.
- Generated parts are anchored and non-collidable.
- `TrajectoryRenderer` skips zero-length segments.
- `VectorFieldRenderer` skips zero-length vectors.
- Call `model:Destroy()` when the visualization is no longer needed.

## Performance considerations

These modules create Roblox instances. Large datasets can produce many parts and increase rendering and replication costs. Keep visual samples bounded, prefer client-side display for non-authoritative debugging, and consider pooling or custom geometry for dense plots.

## Limitations

- The renderers are simple inspection tools, not high-performance plotting engines.
- They do not automatically scale, animate, or update when source data changes.
- The vector field renderer uses a shaft and a small endpoint marker rather than a mesh arrowhead.
- The caller is responsible for choosing a sensible world-space scale.

## Status

Experimental visualization helpers. Test them in Roblox Studio and profile them with representative sample counts before using them in a live experience.
