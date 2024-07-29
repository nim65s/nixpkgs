{
  cmake,
  fetchFromGitHub,
  jrl-cmakemodules,
  lib,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-universal-robot";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-universal-robot";
    rev = "v${version}";
    hash = "sha256-Fyq7P+YZDGUKxOrif0id1WIeMKu5o/7FM+CRpBCPC2A=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    python3Packages.python
  ];
  propagatedBuildInputs = [
    jrl-cmakemodules
    python3Packages.example-robot-data
  ];

  doCheck = true;

  meta = {
    description = "Data specific to robots ur5 and ur10 for hpp-corbaserver";
    homepage = "https://github.com/humanoid-path-planner/hpp-universal-robot";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
