{
  lib,
  fetchFromGitHub,
  cmake,
  cddlib,
  clp,
  jrl-cmakemodules,
  python3Packages,
  qpoases,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-centroidal-dynamics";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-centroidal-dynamics";
    rev = "v${version}";
    hash = "sha256-z5JfncCDNHYhpGZ+CDiq/o/1g7bGbfiBrcEx0aIoD6w=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    cddlib
    clp
    qpoases
  ];
  propagatedBuildInputs = [
    jrl-cmakemodules
    python3Packages.boost
    python3Packages.eigenpy
  ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_WITH_CLP" true) ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_centroidal_dynamics" ];

  meta = {
    description = "Utility classes to check the (robust) equilibrium of a system in contact with the environment.";
    homepage = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
