{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  mim-solvers,

  # nativeBuildInputs
  python,

  # propagatedBuildInputs
  osqp,
  proxsuite,
  scipy,

  # nativeCheckInputs
  pytest,
}:
toPythonModule (
  mim-solvers.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" true)
    ];

    # this is used by CMake at configure/build time
    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = super.propagatedBuildInputs ++ [
      mim-solvers
      osqp
      proxsuite
      scipy
    ];

    nativeCheckInputs = [
      pythonImportsCheckHook
      pytest
    ];

    pythonImportsCheck = [
      "mim_solvers"
    ];
  })
)
