{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh";
    rev = version;
    hash = "sha256-1FxX9On8clJrNWnjWblubxcZNAn3id5hkHqp33SQeDc=";
  };

  # fix hardcoded /usr in plugin finder
  postPatch = ''
    substituteInPlace commons/zenoh-util/src/lib_search_dirs.rs --replace-fail \
      'LibSearchDir::Path("/usr/lib".to_string()),' \
      'LibSearchDir::Path("${placeholder "out"}/lib".to_string()),'
  '';

  cargoHash = "sha256-jtRb1ACSntAgFKRdxJ9rOXoXBGAzPTLW7V652XdFliU=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  checkFlags = [
    "--skip=test_liveliness_subscriber_double_router_history_middle"
    "--skip=zenoh_matching_status_remote"
    "--skip=qos_pubsub"
    "--skip=gossip"
    "--skip=zenoh_session_multicast"
    "--skip=transport_multicast_compression_udp_only"
    "--skip=transport_multicast_udp_only"
    "--skip=test_liveliness_issue_1470"
    "--skip=test_liveliness_subget_router_middle"
    "--skip=openclose_tcp_only_connect_with_interface_restriction"
    "--skip=openclose_tcp_only_listen_with_interface_restriction"
    "--skip=openclose_udp_only_connect_with_interface_restriction"
    "--skip=openclose_udp_only_listen_with_interface_restriction"
  ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
    ];

  meta = {
    description = "Zero Overhead Network Protocol";
    long_description = ''
      Zenoh unifies data in motion, data in-use, data at rest and computations.
            It carefully blends traditional pub/sub with geo-distributed storages, queries and computations,
            while retaining a level of time and space efficiency that is well beyond any of the mainstream stacks.
    '';
    homepage = "https://github.com/eclipse-zenoh/zenoh";
    changelog = "https://github.com/eclipse-zenoh/zenoh/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      apsl20
      epl20
    ];
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "zenoh";
  };
}
