{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cityhash";
  version = "1.1.1-unstable-2022-07-19";

  src = fetchFromGitHub {
    owner = "google";
    repo = "cityhash";
    rev = "f5dc54147fcce12cefd16548c8e760d68ac04226";
    hash = "sha256-DrjasTunNE+TIiQlel2vJPDp/Kc7tN7QxWgI0ln/emM=";
  };

  doCheck = true;

  meta = {
    description = "family of hash functions for strings";
    homepage = "https://github.com/google/cityhash";
    changelog = "https://github.com/google/cityhash/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "cityhash";
    platforms = lib.platforms.all;
  };
})
