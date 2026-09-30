# Both machines: Nix, CLI tools, shells, and fonts.
# Home Manager lives in ./home. Languages and IDEs live in ./programming.
{
  imports = [
    ./nix.nix
    ./packages.nix
    ./shells.nix
    ./fonts.nix
  ];
}
