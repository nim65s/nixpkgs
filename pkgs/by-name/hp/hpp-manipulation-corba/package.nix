{
  cmake,
  fetchFromGitHub,
  lib,
  pkg-config,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-manipulation-corba";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-corba";
    rev = "v${version}";
    hash = "sha256-QTD+aXURL+dCG3ZbFH4Q2X6TQhOP8sq11xkWtKCM5EU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  propagatedBuildInputs = [
    python3Packages.hpp-corbaserver
    python3Packages.hpp-manipulation-urdf
    python3Packages.omniorbpy
  ];

  enableParallelBuilding = false;

  doCheck = true;

  meta = {
    description = "Corba server for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-corba";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
