{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

with pkgs;
assert hostPlatform.isx86_64;

let
  vscodeExt = vscode-with-extensions.override {
    vscodeExtensions = with vscode-extensions;
      [ bbenoist.nix eamodio.gitlens ]
      ++ vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-ruby";
          publisher = "wingrunr21";
          version = "0.28.0";
          sha256 = "H3f1+c31x+lgCzhgTb0uLg9Bdn3pZyJGPPwfpCYrS70=";
        }
        {
          name = "ruby-debug";
          publisher = "castwide";
          version = "0.3.5";
          sha256 = "7OrBMOKR2eFlPiX8MZmus94WXYXc+aPryNdiOmtC5DY=";
        }
        {
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.31.0";
          sha256 = "McSWrOSYM3sMtZt48iStiUvfAXURGk16CHKfBHKj5Zk=";
        }
      ];
  };

  rubyEnv = ruby.withPackages (ps: with ps; [
    #------------#
    # additional #
    #------------#
    nokogiri
    pry
    rake
    rspec
    rest-client
    #------------#
    # pydevtools #
    #------------#
    rubocop
  ]);
  # gems = bundlerEnv {
  #   name = "gems-for-some-project";
  #   gemdir = ./.;
  # };

in
mkShell {
  buildInputs = [ rubyEnv ];
  nativeBuildInputs = [ bundix cacert emacs-nox git gnumake less more nixpkgs-fmt pandoc ] ++ lib.optionals (hostPlatform.isLinux) [ vscodeExt ]
    ++ [ rubyEnv ];
  shellHook = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';


}
