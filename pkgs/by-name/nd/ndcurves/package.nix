{
  fetchFromGitHub,
  lib,
  cmake,
  jrl-cmakemodules,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "ndcurves";
  version = "1.4.1";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "ndcurves";
    rev = "v${version}";
    hash = "sha256-XJ3VSSGKSJ+x3jc4408PGHTYg3nC7o/EeFnbKBELefs=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    jrl-cmakemodules
    python3Packages.eigenpy
    python3Packages.pinocchio
  ];

  cmakeFlags = [ "-DCURVES_WITH_PINOCCHIO_SUPPORT=ON" ];

  doCheck = true;

  pythonImportsCheck = [ "ndcurves" ];

  meta = {
    description = "Environments and robot descriptions for HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-environments";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
