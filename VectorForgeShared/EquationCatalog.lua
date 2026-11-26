-- equation catalog
return {
 NavierStokes = "rho(du/dt + u.grad(u)) = -grad(p) + mu Laplacian(u) + rho f",
 Continuity = "d(rho)/dt + div(rho u) = 0",
 Elasticity = "div(sigma) + rho b = rho a",
 Heat = "rho cp dT/dt = div(k grad(T)) + Q",
 Maxwell = "curl(E)=-dB/dt; curl(H)=J+dD/dt",
 Schrodinger = "i hbar d(psi)/dt = H psi",
 Hamilton = "q_dot = partial H/partial p; p_dot = -partial H/partial q",
 Ito = "dX=a(X,t)dt+B(X,t)dW",
 EulerRigidBody = "I omega_dot + omega x (I omega) = tau",
 Optimization = "min f(x), subject to g(x)<=0 and h(x)=0",
}
