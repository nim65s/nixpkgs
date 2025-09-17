{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  libsForQt5,

  # buildInputs
  vcg,
}:

stdenv.mkDerivation rec {
  pname = "vclab-nexus";
  version = "2025.05";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "nexus";
    rev = "v${version}";
    hash = "sha256-lC3nKQJwkixwGzPP/oS0J+WIFgYqky6NaXu9bX28+3I=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
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
}
