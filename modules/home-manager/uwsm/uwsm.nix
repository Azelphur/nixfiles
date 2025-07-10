{ config, pkgs, ... }:

{
  home.file = {
    ".config/uwsm/env".source = ./env;
  };  
}
