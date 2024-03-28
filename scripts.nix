{ pkgs }:

pkgs.writeShellScriptBin "rebuild" ''
  pushd /etc/nixos
  echo "NixOS Rebuilding..."
  sudo nixos-rebuild switch --flake ./#default 
  gen=$(nixos-rebuild list-generations | grep current)
  git commit -am "$gen"
  popd
''