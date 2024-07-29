{
  cmake,
  example-robot-data,
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-manipulation-urdf";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-urdf";
    rev = "v${version}";
    hash = "sha256-Qthm+u6YW9e/5i2UrXDBMwecGWVNY9FuDMw3K4BHgIk=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs = [ python3Packages.hpp-manipulation ];
  doCheck = true;

  preCheck = ''
    export ROS_PACKAGE_PATH=${example-robot-data}/share
  '';

  meta = {
    description = "Implementation of a parser for hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
