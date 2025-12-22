{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zenoh-c,
}:

stdenv.mkDerivation rec {
  pname = "zenoh-cpp";
  version = "1.4.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-cpp";
    tag = version;
    hash = "sha256-rznvif87UZbYzZB4yHG4R850qm6Z3beJ1NSG4wrf58M=";
  };

  patches = [
    # ref. https://github.com/eclipse-zenoh/zenoh-cpp/pull/702
    ./fix-abs-path.patch
  ];

  cmakeFlags = [
    "-DZENOHCXX_ZENOHC=ON"
    "-DZENOHCXX_ZENOHPICO=OFF"
  ];

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    zenoh-c
  ];

  meta = {
    description = "C++ API for zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-cpp";
    license = with lib.licenses; [
      asl20
      epl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
  };
}
