{
  fetchFromGitHub,
  lib,
  cmake,
  jrl-cmakemodules,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-environments";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-environments";
    rev = "v${version}";
    hash = "sha256-ajfsBa57ORnkhtLgolKT+GQNQJ7IQWwDGsadidrm9sY=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    jrl-cmakemodules
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.pinocchio
    python3Packages.example-robot-data
  ];

  doCheck = true;

  # TODO: this requires hpp-corbaserver, which depends on hpp-environments…
  #pythonImportsCheck = [ "hpp.environments" ];

  meta = {
    description = "Environments and robot descriptions for HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-environments";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
