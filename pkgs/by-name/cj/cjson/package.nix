{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cjson";
  version = "1.7.18";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${version}";
    sha256 = "sha256-UgUWc/+Zie2QNijxKK5GFe4Ypk97EidG8nTiiHhn5Ys=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (stdenv.cc.isClang && !stdenv.hostPlatform.isDarwin) (
    lib.cmakeBool "ENABLE_CUSTOM_COMPILER_FLAGS" false
  );

  postPatch = ''
    # cJSON actually uses C99 standard, not C89
    # https://github.com/DaveGamble/cJSON/issues/275
    substituteInPlace CMakeLists.txt --replace -std=c89 -std=c99

    # Fix for CMake v4
    # ref. https://github.com/DaveGamble/cJSON/pull/949
    substituteInPlace CMakeLists.txt --replace \
      "cmake_minimum_required(VERSION 3.0)" \
      "cmake_minimum_required(VERSION 3.0...4.0)"
  '';

  meta = with lib; {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
