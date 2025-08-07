{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "jrl-cmakemodules";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "nim65s";
    repo = "jrl-cmakemodules";
    rev = "c580d022070db426db24eacd6181690286186647";
    hash = "sha256-tF5HyUW2Vmwvyx7zrfvfwFgMe1V1G0mkEfgwMHkh+90=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.all;
  };
}
