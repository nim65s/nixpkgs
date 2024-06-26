{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, boost
, eigen
, assimp
, octomap
, qhull
, pythonSupport ? false
, python3Packages
, jrl-cmakemodules
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "3.0.0-pre";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-fcl";
    rev = "4674799ce2f7dd8406f9e25f125a79c0e165bf1e";
    hash = "sha256-tQcMOfU9lk+tWTQwVscZG5uCCNAjH5aw6pGS34vXRx4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  propagatedBuildInputs = [
    assimp
    jrl-cmakemodules
    qhull
    octomap
  ] ++ lib.optionals (!pythonSupport) [
    boost
    eigen
  ] ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ];

  cmakeFlags = [
    "-DHPP_FCL_HAS_QHULL=ON"
    "-DINSTALL_DOCUMENTATION=ON"
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = lib.optionals (!pythonSupport) [
    "hppfcl"
  ];

  outputs = [ "dev" "out" "doc" ];
  postFixup = ''
    moveToOutput share/ament_index "$dev"
    moveToOutput share/${finalAttrs.pname} "$dev"
  '';


  meta = {
    description = "Extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
