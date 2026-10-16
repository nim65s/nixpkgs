{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  doxygen,

  blas,
  lapack,
  freeglut,
  libglvnd,
  libGLU,
  libxmu,
  libxi,

  ctestCheckHook,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simbody";
  version = "3.8";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "simbody";
    repo = "simbody";
    tag = "Simbody-${finalAttrs.version}";
    hash = "sha256-SS4Rhe7G2Fc0Gj/9jeyU9gVTTjtRfFT9nhnBDDF4NjM=";
  };

  postPatch = ''
    substituteInPlace cmake/pkgconfig/simbody.pc.in --replace-fail "$""{prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    blas
    lapack
    freeglut
    libglvnd
    libGLU
    libxmu
    libxi
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = true;

  nativeCheckInputs = [
    ctestCheckHook
  ];

  disabledTests = [
    # ref https://github.com/simbody/simbody/issues/756
    "TestCustomConstraints"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance C++ multibody dynamics/physics library for simulating articulated biomechanical and mechanical systems like vehicles, robots, and the human skeleton";
    homepage = "https://github.com/simbody/simbody";
    changelog = "https://github.com/simbody/simbody/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
