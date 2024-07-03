{
  fetchFromGitHub,
  lib,
  cddlib,
  clp,
  cmake,
  glpk,
  python3Packages,
  qpoases,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-bezier-com-traj";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-bezier-com-traj";
    rev = "v${version}";
    hash = "sha256-o+bLMrVQNW117ZGhmOpi9jAh/TY8vvbbzlzVDSgkGo0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    cddlib
    clp
    glpk
    python3Packages.hpp-centroidal-dynamics
    python3Packages.ndcurves
    qpoases
  ];

  cmakeFlags = [ "-DUSE_GLPK=ON" ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_bezier_com_traj" ];

  meta = {
    description = "Multi contact trajectory generation for the COM using Bezier curves";
    homepage = "https://github.com/humanoid-path-planner/hpp-bezier-com-traj";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
