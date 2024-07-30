{
  cmake,
  example-robot-data,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf/pull/63/commits/f79aa07339e7ad57a9752c8c3742caa39ac5131f.patch";
      hash = "sha256-qBeg/PJryCmYn1iQB2Zx9x9CUshsemIP/Ls2VRBQf/4=";
    })
  ];

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
