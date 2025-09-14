{
  lib,
  buildPythonPackage,
  cmake,
  cvxopt,
  fetchFromGitHub,
  numpy,
  oldest-supported-numpy,
  pytestCheckHook,
  pythonOlder,
  qdldl,
  scipy,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "osqp";
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "osqp";
    repo = "osqp-python";
    tag = "v${version}";
    hash = "sha256-i39tphtGO//MS5sqwn6qx5ORR/A8moi0O8ltGGmkv2w=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    numpy
    oldest-supported-numpy
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "scipy"
  ];

  propagatedBuildInputs = [
    numpy
    qdldl
    scipy
  ];

  nativeCheckInputs = [
    cvxopt
    pytestCheckHook
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
