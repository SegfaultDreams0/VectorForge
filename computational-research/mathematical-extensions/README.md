# VectorForge Mathematical Extensions

This directory contains standalone mathematical modules written in standard Lua 5.4. They are separate from the Roblox Luau core and do not depend on Roblox services or engine datatypes.

## Compatibility

The modules target standard Lua 5.4. `ScientificComputing.lua` uses Lua 5.4 integer division and bitwise operators. The modules are not intended to be inserted directly into Roblox Studio without porting the syntax and checking runtime compatibility.


All functions use radians for angles and SI units when physical quantities are supplied in SI units. Numerical routines expose tolerances or iteration limits where relevant; callers should choose them according to the scale and conditioning of their problem.
