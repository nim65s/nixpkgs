{
  cmake,
  directx-headers,
  directx-math,
  eigen,
  fetchFromGitHub,
  fetchurl,
  lib,
  spectra,
  stdenv,
}:

let
  # ref. https://github.com/microsoft/UVAtlas/blob/25ee5cd86a6d090e8fbc6c51765f52f824f0bb60/build/UVAtlas-GitHub-WSL-11.yml#L122
  sal_h = fetchurl {
    url = "https://raw.githubusercontent.com/dotnet/corert/master/src/Native/inc/unix/sal.h";
    hash = "sha256-u56nwdBc38EKF/6A2Hp80WDBBjx+X6CJzWQFwxxhChs=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "uv-atlas";
  version = "2024.09";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "UVAtlas";
    rev = "sep2024";
    hash = "sha256-q44PoSYf2l1PvoHnn+FYQdjTLNW/amAW2rhxJsjgdbQ=";
  };

  postPatch = ''
    cp ${sal_h} UVAtlas/inc/sal.h
  '';

  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    directx-headers
    directx-math
    eigen
    spectra
  ];

  cmakeFlags = [
    (lib.cmakeBool "UVATLAS_USE_OPENMP" true)
    (lib.cmakeBool "ENABLE_USE_EIGEN" true)
  ];

  meta = {
    description = "UVAtlas isochart texture atlas";
    homepage = "https://github.com/microsoft/UVAtlas/";
    changelog = "https://github.com/microsoft/UVAtlas/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
