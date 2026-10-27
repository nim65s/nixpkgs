{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  doxygen,
  swig,

  python3Packages,

  gtest,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ezc3d";
  version = "1.7.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "pyomeca";
    repo = "ezc3d";
    tag = "Release_${finalAttrs.version}";
    hash = "sha256-icsDU3U963Z91FMQp4VhClLL8/KoOo33IWriK0O0oVM=";
  };

  postPatch = ''
    substituteInPlace test/CMakeLists.txt \
      --replace-fail \
        "add_subdirectory(" \
        "find_package(GTest REQUIRED)
        message(DEBUG" \
      --replace-fail \
        "gtest_main" \
        "GTest::gtest_main"

    sed -i "1i #include <algorithm>" test/common_utils.h
  '';

  nativeBuildInputs = [
    cmake
    doxygen
    python3Packages.python
    swig
  ];

  buildInputs = [
    python3Packages.numpy
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOC" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BINDER_PYTHON3" true)
    (lib.cmakeFeature "GTEST_INCLUDE_DIR" "${lib.getInclude gtest}/include")
    (lib.cmakeFeature "PYTHON_INSTALL_PREFIX" "${python3Packages.python.sitePackages}/ezc3d")
  ];

  doCheck = true;

  checkInputs = [
    gtest
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy to use C3D reader/writer for C++, Python and Matlab";
    homepage = "https://github.com/pyomeca/ezc3d";
    changelog = "https://github.com/pyomeca/ezc3d/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "ezc3d";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
