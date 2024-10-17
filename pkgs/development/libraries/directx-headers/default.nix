{ lib, stdenv, fetchFromGitHub, cmake }:
stdenv.mkDerivation (finalAttrs: {
  pname = "directx-headers";
  version = "1.614.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "DirectX-Headers";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CDmzKdV40EExLpOHPAUnytqG9x1+IGW4AZldfYs5YJk=";
  };

  nativeBuildInputs = [ cmake ];

  # tests require WSL2
  cmakeFlags = [ "-DBUILD_TESTING=OFF" ];

  meta = with lib; {
    description = "Official D3D12 headers from Microsoft";
    homepage = "https://github.com/microsoft/DirectX-Headers";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
    platforms = platforms.all;
  };
})
