{
  lib,

  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  libsForQt5,

  # buildInputs
  corto,
  glew,
  vcg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vclab-nexus"; # nexus is already taken
  version = "2025.05";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "nexus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lC3nKQJwkixwGzPP/oS0J+WIFgYqky6NaXu9bX28+3I=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/nim65s/nexus/commit/e742f16.patch";
      hash = "sha256-zoJuLp11DNpacIWTSCQst0NDGM9rJ2xeLLX2NaSLm7I=";
    })
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    corto
    glew
    libsForQt5.qtbase
    vcg
  ];

  meta = {
    description = "Library for creation and visualization of a batched multiresolution mesh";
    homepage = "https://github.com/cnr-isti-vclab/nexus";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "nxsview";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
