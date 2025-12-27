{ config, inputs, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    # Standard .config/directory
    configs = {
      alacritty = "alacritty";
      picom = "picom";
    };
in

{
  home.username = "ray";
  home.homeDirectory = "/home/ray";
  home.stateVersion = "25.11";

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  # Iterate over xdg configs and map them accordingly
  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;

#  xdg.configFile = builtins.listToAttrs ( map(path: {
#    name = path;
#    value = {
#    source = create_symlink "${dotfiles}/${path}";
#    recursive = true;
#    };
#  }) configs);

  home.packages = with pkgs; [
    alacritty
    picom
  ];
}
