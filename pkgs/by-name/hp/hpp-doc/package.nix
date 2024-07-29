{
  cmake,
  doxygen,
  fetchFromGitHub,
  lib,
  libsForQt5,
  pkg-config,
  python3Packages,
  stdenv,
}:

python3Packages.buildPythonPackage rec {
  pname = "hpp-doc";
  version = "5.1.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-doc";
    rev = "v${version}";
    hash = "sha256-VvddV7/R+Rkw1l8zPrMpOisZrua1KKQPPtke1lUppvo=";
  };

  prePatch = ''
    substituteInPlace scripts/auto-install-hpp.sh \
      --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace scripts/install-tar-on-remote \
      --replace-fail /bin/bash ${stdenv.shell}
    substituteInPlace scripts/generate-tar-doc \
      --replace-fail /bin/sh ${stdenv.shell}
    substituteInPlace scripts/packageDep \
      --replace-fail /usr/bin/python ${python3Packages.python.interpreter}
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];
  buildInputs = [ libsForQt5.qtbase ];
  propagatedBuildInputs = [
    python3Packages.hpp-practicals
    python3Packages.hpp-tutorial
  ];

  meta = {
    description = "Documentation for project Humanoid Path Planner";
    homepage = "https://github.com/humanoid-path-planner/hpp-doc";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
