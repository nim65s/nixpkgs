{
  lib,
  stdenv,
  fetchFromGitHub,
  catch2_3,
  cmake,
  jrl-cmakemodules,
  pythonSupport ? false,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odri-master-board-sdk";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "open-dynamic-robot-initiative";
    repo = "master-board";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-fXd1T7S1KgdQCXMidg4ZC+XijUoGZL8BUbtVyCxarMo=";
  };

  sourceRoot = "${finalAttrs.src.name}/sdk/master_board_sdk";

  buildInputs = [ catch2_3 ];
  nativeBuildInputs = [ cmake ];
  propagatedBuildInputs =
    [ jrl-cmakemodules ]
    ++ lib.optionals pythonSupport [
      python3Packages.python
      python3Packages.boost
    ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport) ];

  doCheck = true;

  meta = {
    description = "SDK of the Solo Quadruped Master Board";
    homepage = "https://github.com/open-dynamic-robot-initiative/master-board";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
