{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "jrl-cmakemodules";
  version = "0-unstable-2024-07-27";

  src = fetchFromGitHub {
    owner = "jrl-umi3218";
    repo = "jrl-cmakemodules";
    rev = "7255b14540d102c98b2b9e0e65d01991d134d0e7";
    hash = "sha256-m2OlhoxaAWxLhPWFe4nzAJN59Gc1HQmhzg8NOv8VqIE";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "CMake utility toolbox";
    homepage = "https://github.com/jrl-umi3218/jrl-cmakemodules";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
