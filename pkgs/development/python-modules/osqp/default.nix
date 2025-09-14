{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  pybind11,
  setuptools-scm,
  scikit-build-core,

  # nativeBuildInputs
  cmake,
  ninja,

  # dependencies
  jinja2,
  joblib,
  numpy,
  scipy,

  # propagatedBuildInputs
  osqp,

  # nativeCheckInputs
  pytestCheckHook,
  torch,

  oldest-supported-numpy,
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "osqp-python";
    tag = "v${version}";
    hash = "sha256-i39tphtGO//MS5sqwn6qx5ORR/A8moi0O8ltGGmkv2w=";
  };

  # use our pkgs.osqp
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "FetchContent_MakeAvailable(osqp)" \
        "find_package(osqp REQUIRED CONFIG)" \
      --replace-fail \
        "pybind11_add_module($""{OSQP_EXT_MODULE_NAME} src/bindings.cpp)" \
        "pybind11_add_module($""{OSQP_EXT_MODULE_NAME} src/bindings.cpp)
         target_link_libraries($""{OSQP_EXT_MODULE_NAME} PUBLIC osqp::osqp)"
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    pybind11
    setuptools-scm
    scikit-build-core
  ];

  nativeBuildInputs = [
    cmake
    ninja
    numpy
    oldest-supported-numpy
  ];

  pythonRelaxDeps = [
    "scipy"
  ];

  dependencies = [
    jinja2
    joblib
    numpy
    scipy
  ];

  propagatedBuildInputs = [
    osqp
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  pythonImportsCheck = [ "osqp" ];

  disabledTests = [
    # Need an unfree license package - mkl
    "test_issue14"
  ];

  meta = {
    description = "Operator Splitting QP Solver";
    longDescription = ''
      Numerical optimization package for solving problems in the form
        minimize        0.5 x' P x + q' x
        subject to      l <= A x <= u

      where x in R^n is the optimization variable
    '';
    homepage = "https://osqp.org/";
    downloadPage = "https://github.com/oxfordcontrol/osqp-python/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drewrisinger ];
  };
}
