{
  stdenv,
  fetchFromGitHub,
  lib,
  boost,
  cmake,
  doxygen,
  gepetto-viewer-unwrapped,
  omniorb,
  pkg-config,
  python3Packages,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gepetto-viewer-corba";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer-corba";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/bpAs4ca/+QjWEGuHhuDT8Ts2Ggg+DZWETZfjho6E0w=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "ARGUMENTS $" "ARGUMENTS -p${python3Packages.omniorbpy}/${python3Packages.python.sitePackages} $" \
      --replace-fail '$'{CMAKE_SOURCE_DIR}/cmake '$'{JRL_CMAKE_MODULES}
  '';

  buildInputs = [
    boost
    omniorb
    libsForQt5.qtbase
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  propagatedBuildInputs = [
    gepetto-viewer-unwrapped
    python3Packages.boost
    python3Packages.omniorbpy
  ];

  doCheck = true;

  meta = {
    homepage = "https://github.com/gepetto/gepetto-viewer-corba";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
  };
})
