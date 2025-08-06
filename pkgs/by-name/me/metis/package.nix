{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "metis";
  version = "5.1.0";

  src = fetchurl {
    url = "http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-${version}.tar.gz";
    sha256 = "1cjxgh41r8k6j029yxs8msp3z6lcnpm16g5pvckk35kc7zhfpykn";
  };

  # Fix for CMake v4
  # ref. https://github.com/KarypisLab/METIS/commit/350931887dfc00c2e3cb7551c5abf30e0297126a
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  cmakeFlags = [
    "-DGKLIB_PATH=../GKlib"
    # remove once updated past https://github.com/KarypisLab/METIS/commit/521a2c360dc21ace5c4feb6dc0b7992433e3cb0f
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];
  nativeBuildInputs = [
    unzip
    cmake
  ];

  meta = {
    description = "Serial graph partitioning and fill-reducing matrix ordering";
    homepage = "http://glaros.dtc.umn.edu/gkhome/metis/metis/overview";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
}
