{
  fetchFromGitHub,
  lib,
  cmake,
  hpp-util,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-pinocchio";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-pinocchio";
    rev = "v${version}";
    hash = "sha256-OIsz2L4Dg1J5jMKGi4VHjRdstS7kvFJzfjnHVtFe9DE=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    python3Packages.example-robot-data
    python3Packages.hpp-environments
    python3Packages.pinocchio
    hpp-util
  ];

  doCheck = true;

  meta = {
    description = "Wrapping of Pinocchio library into HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-pinocchio";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
