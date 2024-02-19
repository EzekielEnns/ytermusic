{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
    
  outputs = { self, nixpkgs }: 
    let 

        supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
        nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
        forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      defaultPackage = forAllSystems (system: 
      let pkgs = nixpkgsFor.${system}; 
      in  
          pkgs.rustPlatform.buildRustPackage rec {
            buildInputs = with pkgs; [
                alsa-lib
                dbus
            ];
            nativeBuildInputs = with pkgs; [ pkg-config ];
            dbus = pkgs.dbus;
            pname = "ytermusic";
            version = "0.1";
            src = ./.;
            cargoLock = {
               lockFile = ./Cargo.lock;
               allowBuiltinFetchGit = true;
            };
        
      });
  };
}
