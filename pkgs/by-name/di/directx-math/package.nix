{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "directx-math";
  version = "2024.10";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectXMath";
    rev = "oct2024";
    hash = "sha256-kwW8p0GAIn0GbHt8/P5w91nlbZC6NAAYkRf1opLNPyE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "all inline SIMD C++ linear algebra library for use in games and graphics apps";
    homepage = "https://github.com/microsoft/DirectXMath";
    changelog = "https://github.com/microsoft/DirectXMath/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
