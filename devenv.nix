{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  languages.elixir.enable = true;
  languages.elixir.package = pkgs.elixir_1_17;
}
