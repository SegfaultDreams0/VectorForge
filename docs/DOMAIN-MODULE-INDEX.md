# Scientific domain module API index

This index is generated from the current topic ModuleScripts. It records public methods exposed by each module. It is not a correctness certificate; analytic and runtime tests remain pending.

## `tensor-calculus`

- `tensor-calculus/analysis/AntisymmetricTensor.lua` — `Project`, `IsAntisymmetric`
- `tensor-calculus/analysis/CovariantDerivative.lua` — `ContravariantVector`, `CovariantCovector`
- `tensor-calculus/analysis/EinsteinContraction.lua` — `ContractRank2`, `ContractRank4`
- `tensor-calculus/analysis/ExteriorDerivative.lua` — `OneForm2D`, `OneForm3D`
- `tensor-calculus/analysis/RicciTensor.lua` — `ContractRiemann`
- `tensor-calculus/analysis/TensorNorm.lua` — `Frobenius`, `FrobeniusSquared`, `EntryPNorm`
- `tensor-calculus/models/ContravariantTransform.lua` — `Rank2`
- `tensor-calculus/models/HodgeDual.lua` — `OneForm2D`
- `tensor-calculus/models/MetricTensor.lua` — `Validate`, `RaiseIndex`, `LowerIndex`, `VolumeDensity`, `InnerProduct`, `Inverse`, `Diagnostics`
- `tensor-calculus/models/ScalarCurvature.lua` — `Contract`
- `tensor-calculus/models/TensorEigen.lua` — `Symmetric`
- `tensor-calculus/models/TensorProduct.lua` — `Outer`
- `tensor-calculus/models/TensorStorage.lua` — `new`, `Get`, `Set`
- `tensor-calculus/solvers/ChristoffelSymbols.lua` — `FromMetric`, `Contracted`, `MetricCompatibilityResidual`
- `tensor-calculus/solvers/LeviCivitaSymbol.lua` — `Value`
- `tensor-calculus/solvers/RiemannCurvature.lua` — `FromConnection`, `LowerFirstIndex`, `FirstBianchiResidual`, `KretschmannScalar`
- `tensor-calculus/solvers/SymmetricTensor.lua` — `Project`, `IsSymmetric`
- `tensor-calculus/solvers/TensorDecomposition.lua` — `SVD`
- `tensor-calculus/solvers/TensorIndexing.lua` — `ToLinear`, `ToMulti`, `Contractible`
- `tensor-calculus/solvers/TensorTrace.lua` — `Mixed`

## `thermodynamics`

- `thermodynamics/analysis/BraytonCycle.lua` — `Efficiency`, `TemperatureAfterCompression`, `Analyze`, `OptimumPressureRatio`
- `thermodynamics/analysis/CombustionBalance.lua` — `Hydrocarbon`
- `thermodynamics/analysis/GibbsFreeEnergy.lua` — `Change`, `Spontaneous`
- `thermodynamics/analysis/PengRobinsonEOS.lua` — `Pressure`, `DimensionlessParameters`, `CubicCoefficients`
- `thermodynamics/analysis/PhaseEquilibrium.lua` — `RaoultPressure`
- `thermodynamics/analysis/ThermalConduction.lua` — `FourierRate`, `ThermalResistance`
- `thermodynamics/models/CarnotCycle.lua` — `Efficiency`
- `thermodynamics/models/ChemicalPotential.lua` — `FromActivity`
- `thermodynamics/models/ClausiusClapeyron.lua` — `PressureAtTemperature`, `Slope`
- `thermodynamics/models/ConvectionCorrelation.lua` — `DittusBoelter`
- `thermodynamics/models/EnthalpyModel.lua` — `Sensible`, `WithLatent`
- `thermodynamics/models/HelmholtzFreeEnergy.lua` — `FromInternalEnergy`
- `thermodynamics/models/IdealGasEOS.lua` — `Pressure`, `Density`
- `thermodynamics/solvers/EntropyModel.lua` — `IdealGasChange`
- `thermodynamics/solvers/HeatCapacityModel.lua` — `FromCalorimetry`, `Polynomial`
- `thermodynamics/solvers/MixtureProperties.lua` — `MoleWeighted`, `MolecularMass`
- `thermodynamics/solvers/RadiationExchange.lua` — `NetPower`
- `thermodynamics/solvers/RankineCycle.lua` — `ThermalEfficiency`
- `thermodynamics/solvers/RefrigerationCycle.lua` — `COP`, `CarnotCOP`
- `thermodynamics/solvers/VanDerWaalsEOS.lua` — `Pressure`, `CriticalPoint`, `Derivatives`, `CompressibilityFactor`

## `quantum-mechanics`

- `quantum-mechanics/analysis/BlochSphereState.lua` — `FromSpinor`
- `quantum-mechanics/analysis/HamiltonianOperator.lua` — `Apply`, `Energy`
- `quantum-mechanics/analysis/QuantumFourierTransform.lua` — `Forward`
- `quantum-mechanics/analysis/QuantumHarmonicOscillator.lua` — `EnergyLevel`, `WavefunctionScale`
- `quantum-mechanics/analysis/VonNeumannEvolution.lua` — `Derivative`
- `quantum-mechanics/analysis/WavePacketEvolution.lua` — `FreePhase`
- `quantum-mechanics/models/CrankNicolsonQuantum.lua` — `Step`
- `quantum-mechanics/models/ExpectationValues.lua` — `RealOperator`
- `quantum-mechanics/models/FiniteWellPotential.lua` — `Value`
- `quantum-mechanics/models/HermitianMatrix.lua` — `IsHermitian`
- `quantum-mechanics/models/PauliMatrices.lua` — `All`
- `quantum-mechanics/models/Schrodinger1D.lua` — `Hamiltonian`, `FiniteDifferenceHamiltonian`, `NormalizeSampledState`
- `quantum-mechanics/models/VariationalEigenSolver.lua` — `RayleighQuotient`, `Normalize`
- `quantum-mechanics/solvers/BarrierTunneling.lua` — `Transmission`, `LogTransmission`, `Reflection`
- `quantum-mechanics/solvers/DensityMatrix.lua` — `PureState`, `Purity`, `HermiticityResidual`, `EntropyFromEigenvalues`
- `quantum-mechanics/solvers/EigenstateSolver.lua` — `RealSymmetric`
- `quantum-mechanics/solvers/Schrodinger2D.lua` — `ApplyLaplacian`
- `quantum-mechanics/solvers/SpinPrecession.lua` — `BlochDerivative`
- `quantum-mechanics/solvers/UncertaintyRelations.lua` — `HeisenbergLowerBound`, `MinimumMomentumSpread`
- `quantum-mechanics/solvers/WKBApproximation.lua` — `Transmission`, `LocalWaveNumber`

## `fluid-dynamics`

- `fluid-dynamics/analysis/LatticeBoltzmann.lua` — `D2Q9Equilibrium`, `BGKCollision`, `MacroscopicMoments`, `ViscosityFromRelaxationTime`, `EquilibriumMoments`
- `fluid-dynamics/analysis/MultiphaseFlow.lua` — `ShanChenForce`
- `fluid-dynamics/analysis/PressureProjection.lua` — `Divergence`, `Project`, `SolvePressureJacobi`
- `fluid-dynamics/analysis/ReynoldsAveragedFlow.lua` — `EddyViscosity`, `TurbulentKineticEnergy`
- `fluid-dynamics/analysis/RiemannSolver.lua` — `HLL`
- `fluid-dynamics/analysis/ShallowWater.lua` — `Flux`, `WaveSpeed`
- `fluid-dynamics/models/AdvectionDiffusion.lua` — `Step1D`
- `fluid-dynamics/models/BoundaryLayer.lua` — `BlasiusThickness`, `SkinFriction`
- `fluid-dynamics/models/FreeSurfaceTracking.lua` — `VolumeFractionUpdate`
- `fluid-dynamics/models/IncompressibleFlow.lua` — `ContinuityResidual`, `CourantNumber`
- `fluid-dynamics/models/LargeEddySimulation.lua` — `SmagorinskyViscosity`
- `fluid-dynamics/models/NavierStokes2D.lua` — `VorticityRHS`, `VorticityTransportStep`, `MaximumDivergence`
- `fluid-dynamics/models/SmoothedParticleHydro.lua` — `Poly6Kernel`, `SpikyGradient`
- `fluid-dynamics/solvers/CavitationModel.lua` — `RayleighPlessetAcceleration`
- `fluid-dynamics/solvers/CompressibleFlow.lua` — `NormalShockDownstreamMach`, `TotalPressureRatio`
- `fluid-dynamics/solvers/FiniteVolumeFlux.lua` — `Rusanov`
- `fluid-dynamics/solvers/HydrostaticBalance.lua` — `PressureAtDepth`
- `fluid-dynamics/solvers/NavierStokes3D.lua` — `Divergence`
- `fluid-dynamics/solvers/TurbulenceClosure.lua` — `KOmegaEddyViscosity`
- `fluid-dynamics/solvers/VorticityTransport.lua` — `Stretching`, `BaroclinicTerm`

## `electromagnetics`

- `electromagnetics/analysis/BiotSavartField.lua` — `StraightSegmentCurrent`
- `electromagnetics/analysis/ElectricPotential.lua` — `PointCharges`
- `electromagnetics/analysis/FDTD3D.lua` — `UpdateEx`
- `electromagnetics/analysis/LorentzForce.lua` — `Compute`
- `electromagnetics/analysis/MaxwellCurlEquations.lua` — `Faraday`, `Ampere`
- `electromagnetics/analysis/PoyntingVector.lua` — `Compute`, `Magnitude`
- `electromagnetics/models/AmpereLaw.lua` — `EnclosedCurrent`
- `electromagnetics/models/CoulombField.lua` — `PointCharge`
- `electromagnetics/models/DielectricBoundary.lua` — `NormalDisplacement`, `NormalIncidenceReflection`
- `electromagnetics/models/FDTD1D.lua` — `StepElectric`, `StepMagnetic`, `CourantNumber`, `EnergyElectricMagnetic`
- `electromagnetics/models/PoissonElectrostatics.lua` — `Solve1D`, `ElectricField1D`, `Residual1D`
- `electromagnetics/models/SkinDepth.lua` — `Compute`
- `electromagnetics/models/WaveguideModes.lua` — `RectangularCutoff`
- `electromagnetics/solvers/AntennaArrayFactor.lua` — `Linear`
- `electromagnetics/solvers/DipoleRadiation.lua` — `FarFieldElectric`
- `electromagnetics/solvers/FDTD2D.lua` — `UpdateHz`
- `electromagnetics/solvers/FaradayInduction.lua` — `EMF`
- `electromagnetics/solvers/GaussLawSolver.lua` — `EnclosedCharge`, `SphericalField`
- `electromagnetics/solvers/LaplaceElectrostatics.lua` — `Jacobi2D`
- `electromagnetics/solvers/MagneticMaterial.lua` — `FieldFromFluxDensity`, `Magnetization`

## `finite-element-methods`

- `finite-element-methods/analysis/BeamElement3D.lua` — `LocalStiffness`
- `finite-element-methods/analysis/GaussianQuadrature.lua` — `Rule1D`, `Integrate1D`, `IntegrateInterval`, `ConvergenceEstimate`
- `finite-element-methods/analysis/ModalFEM.lua` — `Solve`
- `finite-element-methods/analysis/NeumannBoundary.lua` — `LinearEdgeLoad`
- `finite-element-methods/analysis/TetrahedralElement3D.lua` — `Geometry`
- `finite-element-methods/analysis/ThermalElement.lua` — `BarStiffness`, `BarCapacity`
- `finite-element-methods/models/BarElement1D.lua` — `Stiffness`, `AxialStress`, `ConsistentMass`, `Interpolate`, `StrainDisplacement`
- `finite-element-methods/models/ElasticityPlaneStress.lua` — `Constitutive`
- `finite-element-methods/models/GlobalAssembly.lua` — `Assemble`
- `finite-element-methods/models/HexahedralElement3D.lua` — `ShapeFunction`, `NaturalDerivatives`
- `finite-element-methods/models/NonlinearFEM.lua` — `NewtonSolve`
- `finite-element-methods/models/SparseStiffness.lua` — `FromTriplets`
- `finite-element-methods/models/TriangularElement2D.lua` — `CST`
- `finite-element-methods/solvers/AdaptiveMeshRefinement.lua` — `Mark`
- `finite-element-methods/solvers/BeamElement2D.lua` — `Stiffness`
- `finite-element-methods/solvers/DirichletBoundary.lua` — `Apply`
- `finite-element-methods/solvers/ElasticityPlaneStrain.lua` — `Constitutive`
- `finite-element-methods/solvers/MassMatrix.lua` — `ConsistentBar`
- `finite-element-methods/solvers/QuadrilateralElement2D.lua` — `BilinearShape`, `NaturalDerivatives`
- `finite-element-methods/solvers/ShapeFunctions.lua` — `Lagrange1D`

## `orbital-mechanics`

- `orbital-mechanics/analysis/AtmosphericDrag.lua` — `Acceleration`
- `orbital-mechanics/analysis/BiEllipticTransfer.lua` — `DeltaV`
- `orbital-mechanics/analysis/ClohessyWiltshire.lua` — `Propagate`
- `orbital-mechanics/analysis/ElementsToState.lua` — `Convert`
- `orbital-mechanics/analysis/GaussVariational.lua` — `ElementRates`
- `orbital-mechanics/analysis/UniversalVariables.lua` — `Propagate`
- `orbital-mechanics/models/GroundTrack.lua` — `Longitude`, `Latitude`
- `orbital-mechanics/models/J2Perturbation.lua` — `Acceleration`
- `orbital-mechanics/models/KeplerEquation.lua` — `Solve`, `TrueAnomaly`, `Period`, `MeanMotion`
- `orbital-mechanics/models/LambertSolver.lua` — `ZeroRevolution`
- `orbital-mechanics/models/OrbitalElements.lua` — `FromState`
- `orbital-mechanics/models/RestrictedThreeBody.lua` — `Acceleration`
- `orbital-mechanics/models/SolarRadiationPressure.lua` — `Acceleration`
- `orbital-mechanics/solvers/CowellIntegrator.lua` — `Propagate`
- `orbital-mechanics/solvers/HillFrame.lua` — `Basis`, `Project`
- `orbital-mechanics/solvers/HohmannTransfer.lua` — `DeltaV`
- `orbital-mechanics/solvers/LagrangePoints.lua` — `Collinear`
- `orbital-mechanics/solvers/StateToElements.lua` — `Convert`
- `orbital-mechanics/solvers/ThirdBodyPerturbation.lua` — `Acceleration`
- `orbital-mechanics/solvers/TwoBodyPropagator.lua` — `Acceleration`, `SpecificEnergy`, `SpecificAngularMomentum`, `CircularPeriod`

## `control-systems`

- `control-systems/analysis/AdaptiveControl.lua` — `MITUpdate`
- `control-systems/analysis/ControllabilityMatrix.lua` — `Build`
- `control-systems/analysis/DiscreteRiccati.lua` — `Solve`
- `control-systems/analysis/KalmanObserver.lua` — `Update`
- `control-systems/analysis/PIDController.lua` — `Step`, `StepFiltered`
- `control-systems/analysis/TrajectoryTracking.lua` — `PD`
- `control-systems/models/ActuatorDynamics.lua` — `FirstOrder`, `RateLimited`
- `control-systems/models/ExtendedKalmanObserver.lua` — `Correct`
- `control-systems/models/LQRController.lua` — `Design`, `Control`
- `control-systems/models/LinearStateSpace.lua` — `Derivative`, `Output`, `DiscretizeScalar`, `Step`
- `control-systems/models/LyapunovStability.lua` — `DiscreteSolution`, `Residual`, `CertifyDiscrete`
- `control-systems/models/ObservabilityMatrix.lua` — `Build`
- `control-systems/models/RobustHInfinity.lua` — `SISOFrequencyPeak`
- `control-systems/solvers/GainScheduling.lua` — `Interpolate`
- `control-systems/solvers/ModelPredictiveControl.lua` — `ScalarPlan`
- `control-systems/solvers/NonlinearStateSpace.lua` — `Evaluate`
- `control-systems/solvers/PolePlacement.lua` — `Ackermann`
- `control-systems/solvers/SensorFusion.lua` — `InformationFuse`
- `control-systems/solvers/SlidingModeControl.lua` — `Control`
- `control-systems/solvers/UnscentedKalmanObserver.lua` — `Create`

## `signal-processing`

- `signal-processing/analysis/AdaptiveLMS.lua` — `Update`
- `signal-processing/analysis/FIRFilter.lua` — `Apply`
- `signal-processing/analysis/InverseFFT.lua` — `Direct`
- `signal-processing/analysis/Resampler.lua` — `Linear`
- `signal-processing/analysis/WaveletPacket.lua` — `HaarLevel`, `Decompose`
- `signal-processing/analysis/WindowFunctions.lua` — `Hann`, `Blackman`
- `signal-processing/models/CepstralAnalysis.lua` — `RealCepstrum`
- `signal-processing/models/Convolution1D.lua` — `Full`
- `signal-processing/models/DFT.lua` — `Compute`, `FrequencyBins`, `MagnitudePhase`
- `signal-processing/models/HilbertTransform.lua` — `AnalyticSignal`
- `signal-processing/models/IIRFilter.lua` — `Biquad`
- `signal-processing/models/PolyphaseFilter.lua` — `Split`
- `signal-processing/models/SpectralDensity.lua` — `Periodogram`
- `signal-processing/solvers/ButterworthDesign.lua` — `SecondOrderLowPass`
- `signal-processing/solvers/Convolution2D.lua` — `Valid`
- `signal-processing/solvers/FFT.lua` — `Radix2`, `InverseRadix2`, `SingleSidedAmplitude`
- `signal-processing/solvers/MatchedFilter.lua` — `Correlate`
- `signal-processing/solvers/PhaseUnwrap.lua` — `Unwrap`
- `signal-processing/solvers/STFT.lua` — `Analyze`
- `signal-processing/solvers/WaveletHaar.lua` — `Transform`

## `stochastic-processes`

- `stochastic-processes/analysis/HiddenMarkovModel.lua` — `Forward`
- `stochastic-processes/analysis/MilsteinIntegrator.lua` — `Step`
- `stochastic-processes/analysis/OrnsteinUhlenbeck.lua` — `ExactStep`, `TransitionMoments`
- `stochastic-processes/analysis/ParticleFilter.lua` — `SystematicResample`
- `stochastic-processes/analysis/ReliabilityIndex.lua` — `FromFailureProbability`
- `stochastic-processes/analysis/SobolSequence.lua` — `VanDerCorput`, `OneDimensional`
- `stochastic-processes/models/BootstrapEstimator.lua` — `Mean`, `Resample`
- `stochastic-processes/models/BrownianMotion.lua` — `Increment`, `Path`, `QuadraticVariation`, `BridgeMean`
- `stochastic-processes/models/EnsembleKalman.lua` — `Analysis`
- `stochastic-processes/models/FokkerPlanck1D.lua` — `Step`
- `stochastic-processes/models/MonteCarloSampler.lua` — `Uniform`, `Estimate`
- `stochastic-processes/models/PoissonProcess.lua` — `ArrivalTimes`
- `stochastic-processes/models/RandomField1D.lua` — `ExponentialCovariance`
- `stochastic-processes/solvers/CovarianceEstimator.lua` — `Sample`
- `stochastic-processes/solvers/FirstPassageTime.lua` — `FromPath`
- `stochastic-processes/solvers/GaussianProcess.lua` — `Predict`
- `stochastic-processes/solvers/GeometricBrownianMotion.lua` — `ExactStep`
- `stochastic-processes/solvers/LatinHypercube.lua` — `Sample`
- `stochastic-processes/solvers/MarkovChain.lua` — `Step`
- `stochastic-processes/solvers/StochasticRK.lua` — `HeunStep`

## `continuum-mechanics`

- `continuum-mechanics/analysis/ElasticWaveSpeed.lua` — `Longitudinal`, `Shear`
- `continuum-mechanics/analysis/FirstPiolaKirchhoff.lua` — `FromCauchy`
- `continuum-mechanics/analysis/GreenLagrangeStrain.lua` — `Compute`
- `continuum-mechanics/analysis/MaxwellViscoelastic.lua` — `ExactStressUpdate`
- `continuum-mechanics/analysis/NeoHookeanMaterial.lua` — `CauchyStress`, `Energy`, `FirstPiola`, `ModifiedFirstInvariant`
- `continuum-mechanics/analysis/YieldVonMises.lua` — `EquivalentStress`, `IsYielded`, `TrescaEquivalent`, `YieldMargin`
- `continuum-mechanics/models/DamageEvolution.lua` — `EquivalentStrainUpdate`
- `continuum-mechanics/models/DeformationGradient.lua` — `FromDisplacementGradient`
- `continuum-mechanics/models/InfinitesimalStrain.lua` — `FromDisplacementGradient`
- `continuum-mechanics/models/MooneyRivlinMaterial.lua` — `Energy`
- `continuum-mechanics/models/PlasticReturnMapping.lua` — `J2RadialReturn`
- `continuum-mechanics/models/SecondPiolaKirchhoff.lua` — `FromFirstPiola`
- `continuum-mechanics/models/StressInvariants.lua` — `Compute`
- `continuum-mechanics/solvers/CauchyStress.lua` — `FromFirstPiola`
- `continuum-mechanics/solvers/FiniteStrainUpdate.lua` — `ComposeIncrement`
- `continuum-mechanics/solvers/HookeConstitutive.lua` — `IsotropicStress`
- `continuum-mechanics/solvers/HyperelasticEnergy.lua` — `NeoHookean`
- `continuum-mechanics/solvers/PrincipalStress.lua` — `Eigenvalues`
- `continuum-mechanics/solvers/StrainTensor.lua` — `RightCauchyGreen`, `GreenLagrange`
- `continuum-mechanics/solvers/ViscoelasticKelvinVoigt.lua` — `Stress`

## `differential-equations`

- `differential-equations/analysis/AdamsBashforth.lua` — `Step2`, `Step3`
- `differential-equations/analysis/CrankNicolson.lua` — `LinearStep`
- `differential-equations/analysis/PoissonEquation.lua` — `Solve1D`
- `differential-equations/analysis/RK4Integrator.lua` — `Step`, `IntegrateFixedSteps`, `StepDoubling`, `IntegrateWithHistory`
- `differential-equations/analysis/SpectralCollocation.lua` — `ChebyshevDifferentiation`
- `differential-equations/analysis/VerletIntegrator.lua` — `Step`
- `differential-equations/models/AdamsMoulton.lua` — `Corrector`, `ImplicitTrapezoid`
- `differential-equations/models/EulerIntegrator.lua` — `Step`
- `differential-equations/models/FiniteDifferenceBVP.lua` — `SecondOrder`
- `differential-equations/models/HeatEquation.lua` — `ExplicitStep`
- `differential-equations/models/RK45Integrator.lua` — `DormandPrinceStep`
- `differential-equations/models/ReactionDiffusion.lua` — `GrayScottStep`
- `differential-equations/models/SymplecticEuler.lua` — `Step`
- `differential-equations/solvers/BDFSolver.lua` — `ImplicitEulerStep`, `BDF2`
- `differential-equations/solvers/DormandPrince.lua` — `AdaptiveStep`, `IntegrateAdaptive`
- `differential-equations/solvers/ImplicitEuler.lua` — `Step`
- `differential-equations/solvers/MidpointIntegrator.lua` — `ExplicitStep`
- `differential-equations/solvers/ShootingMethod.lua` — `FindInitialSlope`
- `differential-equations/solvers/StiffSystemSolver.lua` — `RosenbrockEuler`
- `differential-equations/solvers/WaveEquation.lua` — `Leapfrog`

## `optimization-methods`

- `optimization-methods/analysis/BFGSOptimizer.lua` — `Minimize`
- `optimization-methods/analysis/ConjugateGradient.lua` — `PolakRibiere`
- `optimization-methods/analysis/DifferentialEvolution.lua` — `Minimize`
- `optimization-methods/analysis/GaussNewton.lua` — `Solve`
- `optimization-methods/analysis/InteriorPoint.lua` — `LogBarrier`, `DecreaseBarrier`
- `optimization-methods/analysis/NesterovAccelerated.lua` — `Step`
- `optimization-methods/models/AdamOptimizer.lua` — `Step`
- `optimization-methods/models/GradientDescent.lua` — `Minimize`
- `optimization-methods/models/LBFGSOptimizer.lua` — `TwoLoop`
- `optimization-methods/models/LevenbergMarquardt.lua` — `Solve`
- `optimization-methods/models/ParticleSwarm.lua` — `Update`
- `optimization-methods/models/ProjectedGradient.lua` — `BoxStep`
- `optimization-methods/models/SimplexSearch.lua` — `NelderMeadStep`
- `optimization-methods/solvers/AugmentedLagrangian.lua` — `Objective`, `UpdateMultipliers`
- `optimization-methods/solvers/GeneticOptimizer.lua` — `Tournament`, `UniformCrossover`
- `optimization-methods/solvers/MomentumDescent.lua` — `Step`
- `optimization-methods/solvers/NewtonOptimizer.lua` — `Step`
- `optimization-methods/solvers/RMSPropOptimizer.lua` — `Step`
- `optimization-methods/solvers/SimulatedAnnealing.lua` — `Accept`, `Cool`
- `optimization-methods/solvers/TrustRegion.lua` — `CauchyStep`, `UpdateRadius`, `ReductionRatio`, `AcceptTrial`

## `rigid-body-physics`

- `rigid-body-physics/analysis/ConstraintSolver.lua` — `ProjectedGaussSeidel`
- `rigid-body-physics/analysis/ContactConstraint.lua` — `BaumgarteImpulse`
- `rigid-body-physics/analysis/EulerRigidBody.lua` — `AngularAcceleration`, `EnergyAndMomentum`, `AngularAccelerationWithTorque`
- `rigid-body-physics/analysis/GyroscopicCoupling.lua` — `Torque`
- `rigid-body-physics/analysis/InverseKinematics.lua` — `PlanarTwoLink`
- `rigid-body-physics/analysis/RotationMatrix.lua` — `FromQuaternion`
- `rigid-body-physics/models/ArticulatedBody.lua` — `PlanarForwardKinematics`
- `rigid-body-physics/models/FrictionCone.lua` — `Project`
- `rigid-body-physics/models/InertiaTensor.lua` — `PointMasses`
- `rigid-body-physics/models/MassProperties.lua` — `CenterOfMass`
- `rigid-body-physics/models/NewtonEuler6DOF.lua` — `Derivative`
- `rigid-body-physics/models/QuaternionKinematics.lua` — `IntegrateOrientation`
- `rigid-body-physics/models/RigidBodyIntegrator.lua` — `SemiImplicit`
- `rigid-body-physics/solvers/AngularMomentum.lua` — `Compute`, `Magnitude`
- `rigid-body-physics/solvers/CenterOfMass.lua` — `FromBodies`
- `rigid-body-physics/solvers/CollisionResponse.lua` — `NormalImpulse`
- `rigid-body-physics/solvers/EulerAngleKinematics.lua` — `BodyRatesToEulerRates`
- `rigid-body-physics/solvers/ForwardKinematics.lua` — `SerialDH`
- `rigid-body-physics/solvers/ImpulseResolution.lua` — `OneDimensional`
- `rigid-body-physics/solvers/SequentialImpulse.lua` — `SolveRows`

## `computational-geometry`

- `computational-geometry/analysis/AABBTree.lua` — `Build`, `QueryPoint`
- `computational-geometry/analysis/ConvexHull3D.lua` — `BruteForceFaces`
- `computational-geometry/analysis/CurvatureEstimator.lua` — `ThreePoint2D`, `FromDerivatives`
- `computational-geometry/analysis/MeshSmoothing.lua` — `Laplacian`
- `computational-geometry/analysis/NURBSCurve.lua` — `Basis`, `Evaluate`, `WeightSum`, `RationalBasis`
- `computational-geometry/analysis/TriangleIntersection.lua` — `RayMollerTrumbore`
- `computational-geometry/models/BezierCurve.lua` — `Evaluate`, `DerivativeControlPoints`
- `computational-geometry/models/CatmullRomSpline.lua` — `Evaluate`
- `computational-geometry/models/ClosestPointOnCurve.lua` — `GoldenSection`
- `computational-geometry/models/DelaunayTriangulation.lua` — `Triangulate`
- `computational-geometry/models/GeodesicDistance.lua` — `Dijkstra`
- `computational-geometry/models/OBBTree.lua` — `Intersects`
- `computational-geometry/models/TorsionEstimator.lua` — `FromDerivatives`
- `computational-geometry/solvers/ArcLengthParameterization.lua` — `IntegrateSpeed`, `BuildTable`, `ParameterAtLength`, `CurvatureStep`
- `computational-geometry/solvers/BSplineCurve.lua` — `Evaluate`
- `computational-geometry/solvers/ConvexHull2D.lua` — `MonotoneChain`
- `computational-geometry/solvers/RayIntersection.lua` — `RaySegment2D`
- `computational-geometry/solvers/SignedDistanceField.lua` — `Polygon`
- `computational-geometry/solvers/SurfaceParameterization.lua` — `Barycentric3D`, `MapTriangle`
- `computational-geometry/solvers/VoronoiDiagram.lua` — `NearestSite`, `ClipCell`
