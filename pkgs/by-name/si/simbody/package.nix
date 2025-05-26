{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,

  # nativeBuildInputs
  cmake,
  doxygen,

  # buildInputs
  blas,
  freeglut,
  lapack,
  xorg,
}:

assert blas.isILP64 == lapack.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "simbody";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "simbody";
    repo = "simbody";
    tag = "Simbody-${finalAttrs.version}";
    hash = "sha256-SS4Rhe7G2Fc0Gj/9jeyU9gVTTjtRfFT9nhnBDDF4NjM=";
  };

  patches = [
    ./fix-fmt-constexpr.patch
  ];

  postPatch = ''
    substituteInPlace cmake/pkgconfig/simbody.pc.in --replace-fail "$""{prefix}/" ""
  '';

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [
    blas
    freeglut
    lapack
    xorg.libXi
    xorg.libXmu
  ];

  doCheck = true;

  cmakeFlags = [
    # timing failure
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;TestCustomConstraints")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance C++ multibody dynamics/physics library for simulating articulated biomechanical and mechanical systems like vehicles, robots, and the human skeleton";
    homepage = "https://github.com/simbody/simbody";
    changelog = "https://github.com/simbody/simbody/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "simbody";
    platforms = lib.platforms.all;
  };
})
