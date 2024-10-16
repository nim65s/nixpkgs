{
  boost,
  fetchFromGitHub,
  lib,
  libjpeg,
  libpng,
  stdenv,
  zlib,
}:

stdenv.mkDerivation {
  pname = "poisson-recon";
  version = "18.35";

  src = fetchFromGitHub {
    owner = "mkazhdan";
    repo = "PoissonRecon";
    # That commit title is "Version 18.35", but there is no corresponding tag or github release
    rev = "387fa8acc7871133efbe1fe20083bd57899ef018";
    hash = "sha256-/a6o4YBKYu/4N5Y4SEcloq30hDEZAHcHd3Z/L+bdc4E=";
  };

  makeFlags = [ "-j2" ]; # more take too much RAM

  buildInputs = [
    boost
    libjpeg
    libpng
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 Bin/Linux/PoissonRecon* $out/bin
    install -Dm444 Src/*.h -t $out/include/poisson-recon
    install -Dm444 Src/*.inl -t $out/include/poisson-recon

    runHook postInstall
  '';

  meta = {
    description = "Poisson Surface Reconstruction";
    homepage = "https://github.com/mkazhdan/PoissonRecon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "PoissonRecon";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
