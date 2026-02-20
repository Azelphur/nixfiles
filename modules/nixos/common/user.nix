{ lib, ... }:

{
  options.my.user = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "Primary username";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    email = lib.mkOption {
      type = lib.types.str;
      default = "";
    };
    
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Authorized SSH public keys";
    };
  };
}
