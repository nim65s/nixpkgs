{
  cmake,
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinygltf";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "syoyo";
    repo = "tinygltf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-s3RlaDlCkNgbe2sl4TjYKkNLMWqEAGHGWNEV8Z3TH7Y=";
  };

  patches = [
    # CMake: allow opt-out of installing vendored headers
    (fetchpatch {
      url = "https://github.com/syoyo/tinygltf/pull/504/commits/21485496b15f944c93ae9085efc3fcea0f84fdce.patch";
      hash = "sha256-iFD4Ac4WofG0lGCxuU+iXshvd4QjmzHx3ZlQxzyp+IY=";
    })
    # CMake: fix export install dir
    (fetchpatch {
      url = "https://github.com/syoyo/tinygltf/pull/503/commits/8bec43169904a713b1ff9db1e9186a072bca741a.patch";
      hash = "sha256-hORzdWqyV8bCTgWw2na/aiDKLlSi++X9eMng2TTjmYI=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeBool "TINYGTLF_INSTALL_VENDOR" false)
  ];

  meta = with lib; {
    description = "Header only C++11 tiny glTF 2.0 library";
    homepage = "https://github.com/syoyo/tinygltf";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
    platforms = platforms.unix;
  };
})
