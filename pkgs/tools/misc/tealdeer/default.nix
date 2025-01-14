{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, installShellFiles
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "tealdeer";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "dbrgn";
    repo = "tealdeer";
    rev = "v${version}";
    sha256 = "sha256-c7HYQtNT3e/GRyhS6sVGBw91cIusWmOqQ3i+Gglc/Ks=";
  };

  cargoSha256 = "sha256-CLCY4rKdYX3QZvk18Ty9B3kcC6hXsDTpAFG0S5xusEQ=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd tldr \
      --bash completion/bash_tealdeer \
      --fish completion/fish_tealdeer \
      --zsh completion/zsh_tealdeer
  '';

  # Disable tests that require Internet access:
  checkFlags = [
    "--skip test_autoupdate_cache"
    "--skip test_create_cache_directory_path"
    "--skip test_pager_flag_enable"
    "--skip test_quiet_cache"
    "--skip test_quiet_failures"
    "--skip test_quiet_old_cache"
    "--skip test_spaces_find_command"
    "--skip test_update_cache"
  ];

  meta = with lib; {
    description = "A very fast implementation of tldr in Rust";
    homepage = "https://github.com/dbrgn/tealdeer";
    maintainers = with maintainers; [ davidak ];
    license = with licenses; [ asl20 mit ];
    mainProgram = "tldr";
  };
}
