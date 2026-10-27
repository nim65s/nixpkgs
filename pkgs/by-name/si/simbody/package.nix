{
  lib,
  stdenv,
  fetchFromGitHub,
  breakpointHook,
  vim,

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
  # 3.8 is too old for opensim 4.6:
  # https://github.com/opensim-org/opensim-core/issues/4369
  # and opensim versions before that are not compatible with C++20
  version = "3.8-unstable-2026-10-26";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "simbody";
    repo = "simbody";
    # tag = "Simbody-${finalAttrs.version}";
    rev = "47082210cba91565d3df5321a84190f8f5127905";
    hash = "sha256-Ki4JzjmdkwQPCRz8Z1ADAGAqlppR63zoq+609rQgm+Y=";
  };

  postPatch = ''
    substituteInPlace cmake/pkgconfig/simbody.pc.in --replace-fail "$""{prefix}/" ""
  '';

  nativeBuildInputs = [
    breakpointHook
    vim
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
    # https://github.com/simbody/simbody/issues/877
    "TestCableSpan"
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
