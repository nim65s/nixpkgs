{
  blasfeo,
  cmake,
  fetchFromGitHub,
  lib,
  osqp,
  qpoases,
  stdenv,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation rec {
  pname = "acados";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "acados";
    repo = "acados";
    rev = "v${version}";
    hash = "sha256-EyRE49yWpHzqnYqzJjthy0g6DIvLAh7lJNySlmIGO18=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blasfeo
    osqp
    qpoases
  ] ++ lib.optionals pythonSupport [ python3Packages.python ];

  # ARG: https://github.com/acados/acados/blob/master/external/CMakeLists.txt
  cmakeFlags = [
    (lib.cmakeBool "ACADOS_WITH_OPENMP" true)
    (lib.cmakeBool "ACADOS_UNIT_TESTS" true)
    (lib.cmakeBool "ACADOS_UNIT_QPOASES" true)
    (lib.cmakeBool "ACADOS_WITH_DAQP" false) # TODO: only packaged from PyPI without CMake interface for now
    (lib.cmakeBool "ACADOS_WITH_HPMPC" false) # TODO
    (lib.cmakeBool "ACADOS_WITH_QORE" false) # TODO
    (lib.cmakeBool "ACADOS_WITH_OOQP" false) # TODO
    (lib.cmakeBool "ACADOS_WITH_QPDUNES" false) # TODO
    (lib.cmakeBool "ACADOS_WITH_OSQP" true)
    (lib.cmakeBool "ACADOS_PYTHON" pythonSupport)
    "-DBLABSFEO_SRC_DIR=${blasfeo.src}"
  ];

  meta = with lib; {
    description = "Fast and embedded solvers for nonlinear optimal control";
    homepage = "https://github.com/acados/acados";
    license = licenses.bsd2;
    maintainers = with maintainers; [ nim65s ];
  };
}
