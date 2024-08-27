{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  boost,
  libxml2,
  minizip,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collada-dom";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "collada-dom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DYdqrwRIrVq0BQqZB0vtZzADteJGVaJtFC5kC/cD250=";
  };

  postInstall = ''
    chmod +w -R $out
    ln -s $out/include/*/* $out/include
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libxml2
    minizip
    readline
  ];

  meta = with lib; {
    description = "Lightweight version of collada-dom, with only the parser.";
    homepage = "https://github.com/gepetto/collada-dom";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.all;
  };
})
