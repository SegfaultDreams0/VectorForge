# State Estimation Notes

A nonlinear state-space model can be written as:

`x[k] = f(x[k-1], u[k]) + w[k]`

`z[k] = h(x[k]) + v[k]`

where process noise and measurement noise represent different uncertainty sources.

Design questions:
- Which states are observable from available measurements?
- How are process and measurement noise selected?
- Are covariance matrices symmetric and positive semidefinite?
- How are outliers detected?
- What happens when the model is poorly tuned?

Validation idea: generate deterministic synthetic motion, add controlled noise, and compare estimates against known ground truth.
