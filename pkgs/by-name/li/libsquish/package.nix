{
  lib,
  stdenv,

  fetchsvn,

  # nativeBuildInputs
  cmake,

  withStatic ? stdenv.hostPlatform.isStatic,
}:
stdenv.mkDerivation {
  pname = "libsquish";
  version = "1.15-unstable-2024-11-23";

  src = fetchsvn {
    url = "https://svn.code.sf.net/p/libsquish/code/trunk";
    rev = "111";
    hash = "sha256-LMIpTIvFkGbBs3Ns2oVuIz3ulk/9DG0KMn8wNSJctEk=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!withStatic))
    (lib.cmakeBool "BUILD_SQUISH_EXTRA" true)
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./squishtest

    runHook postCheck
  '';

  meta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.linux;
  };
}
