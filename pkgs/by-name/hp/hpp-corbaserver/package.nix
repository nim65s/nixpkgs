{
  cmake,
  fetchFromGitHub,
  hpp-template-corba,
  lib,
  pkg-config,
  psmisc,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-corbaserver";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-corbaserver";
    rev = "v${version}";
    hash = "sha256-qFcBT/YDTsrAzEE//JmCbk1TnVrnYcme1WCzkPaXwZ0=";
  };

  prePatch = ''
    substituteInPlace tests/hppcorbaserver.sh \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  propagatedBuildInputs = [
    python3Packages.hpp-core
    python3Packages.omniorbpy
    hpp-template-corba
  ];
  checkInputs = [ psmisc ];

  enableParallelBuilding = false;

  doCheck = true;

  pythonImportsCheck = [ "hpp.corbaserver" ];

  meta = {
    description = "Corba server for Humanoid Path Planner applications";
    homepage = "https://github.com/humanoid-path-planner/hpp-corbaserver";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
