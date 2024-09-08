{
  fetchFromGitHub,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "typst-packages";
  version = "0-unstable-2024-09-08";

  src = fetchFromGitHub {
    owner = "typst";
    repo = "packages";
    rev = "9b0ffff0bb029f3c470c2f523a119c137671a756";
    hash = "sha256-5N9UmFJgBFcVZWJ8jyx5xHWiWou8a9KjwuhruQzJwG4=";
  };

  # We don't care about output.
  # only src matter.
  # This probably should not be a derivation, but I don't know how to make something else
  installPhase = ''
    touch $out
  '';
}
