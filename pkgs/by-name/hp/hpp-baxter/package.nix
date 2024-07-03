{
  fetchFromGitHub,
  lib,
  cmake,
  jrl-cmakemodules,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-baxter";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-baxter";
    rev = "v${version}";
    hash = "sha256-hhb/ZxjU5OO6mV1vlcOY02gObArchqq+jaI5pZsgMO0=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    jrl-cmakemodules
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.example-robot-data
    python3Packages.pinocchio
  ];

  doCheck = true;

  meta = {
    description = "Wrappers for Baxter robot in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-baxter";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
