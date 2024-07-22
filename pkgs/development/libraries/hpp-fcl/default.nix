{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, boost
, eigen
, assimp
, jrl-cmakemodules
, octomap
, qhull
, pythonSupport ? false
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-fcl";
    #rev = "v${finalAttrs.version}";
    rev = "d914b542761e6c4ee3308dce105256b0cf986f67";
    hash = "sha256-u6nbTkYXqZXNsVSYHF2QiXmzrFFodv0Rcx77JNDbOyQ=";
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
    "-DCOAL_BACKWARD_COMPATIBILITY_WITH_HPP_FCL=ON"
    "-DCOAL_HAS_QHULL=ON"
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


  meta = with lib; {
    description = "Extension of the Flexible Collision Library";
    homepage = "https://github.com/humanoid-path-planner/hpp-fcl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
})
