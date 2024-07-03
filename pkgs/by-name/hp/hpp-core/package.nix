{
  fetchFromGitHub,
  lib,
  cmake,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-core";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-core";
    rev = "v${version}";
    hash = "sha256-GzlQ4kfiMUf9qVP5t+/qoQZbBIOe1JPdmL7+86dJVaQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [
    python3Packages.hpp-constraints
    python3Packages.proxsuite
  ];

  doCheck = true;

  meta = {
    description = "The core algorithms of the Humanoid Path Planner framework";
    homepage = "https://github.com/humanoid-path-planner/hpp-core";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
