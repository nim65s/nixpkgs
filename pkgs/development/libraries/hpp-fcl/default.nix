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
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-fcl";
  version = "3.0.0";

  src = fetchFromGitHub {
    #owner = "humanoid-path-planner";
    owner = "nim65s";
    repo = "hpp-fcl";
    #rev = "v${finalAttrs.version}";
    rev = "1b20de92";
    hash = "sha256-HqBAWN8tvuf/uMK0kBvW9By0K0vloAkH0QBkHB5DWgY=";
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
    zlib
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
