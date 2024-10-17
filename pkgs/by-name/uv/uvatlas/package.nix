{
  cmake,
  directx-headers,
  directx-math,
  eigen,
  fetchFromGitHub,
  lib,
  salh,
  spectra,
  stdenv,
}:
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
    substituteInPlace CMakeLists.txt --replace-fail \
      "target_include_directories(\$""{PROJECT_NAME} PUBLIC" \
      "target_include_directories(\$""{PROJECT_NAME} PUBLIC ${salh}/include"
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
