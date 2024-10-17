{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
  tbb_2021_11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oneDPL";
  version = "2022.6.0";

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "onedpl";
    rev = "oneDPL-${finalAttrs.version}-rc1";
    hash = "sha256-VdVdv+dpdhe10SB50AHiim5Glwjv0xCwxYoPetGXQi8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    tbb_2021_11
  ];

  meta = {
    description = "implementation of the oneAPI specification for the oneDPL component";
    homepage = "https://github.com/oneapi-src/onedpl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
