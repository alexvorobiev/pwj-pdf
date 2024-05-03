{
  description = "PWJ lessons in one pdf";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      # Systems supported
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      # Helper to provide system-specific attributes
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {
      packages = forAllSystems ({ pkgs }: {
        default = pkgs.writeShellApplication {
          name = "pwj";
          runtimeInputs = [
            (pkgs.python3Packages.callPackage ./pystitcher {})
            pkgs.zsh
          ];

          text = ''
            zsh <<EOF
            for i in /mnt/c/Users/alexa/Downloads/Piano/pwj/**/*.pdf(om); do
              echo "- [\$(basename -s .pdf \$i | tr '-' ' ' | sed -e 's/^\(.\)/\U\1/' | sed -e 's/Lesson [Ss]heet //')](\$i)";
            done | grep -v pwj.pdf > pwj.md
            EOF

            pystitcher pwj.md pwj.pdf
          '';
        };
      });
    };
}
