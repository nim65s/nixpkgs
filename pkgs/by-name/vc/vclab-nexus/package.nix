{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "vclab-nexus";
  version = "2025.05";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "nexus";
    rev = "v${version}";
    hash = "sha256-lC3nKQJwkixwGzPP/oS0J+WIFgYqky6NaXu9bX28+3I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Nexus is a c++/javascript library for creation and visualization of a batched multiresolution mesh";
    homepage = "https://github.com/cnr-isti-vclab/nexus";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "vclab-nexus";
    platforms = lib.platforms.all;
  };
}
