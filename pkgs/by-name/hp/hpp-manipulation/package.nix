{
  cmake,
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-manipulation";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation";
    rev = "v${version}";
    hash = "sha256-IAukCfmub9dn0OmwXib7WdUluGoacqJVbGADX/av3wg=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    python3Packages.hpp-core
    python3Packages.hpp-universal-robot
  ];

  doCheck = true;

  meta = {
    description = "Classes for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
