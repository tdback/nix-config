{ inputs }:
let
  mkModules = modules: builtins.map (module: "${inputs.self}/modules/${module}") modules;
in
{
  mkSystem = hostname: system: nixpkgsVersion: modules: rec {
    deploy.nodes.${hostname} = {
      inherit hostname;
      profiles.system = {
        user = "root";
        sshUser = "tdback";
        path = inputs.deploy-rs.lib.${system}.activate.nixos nixosConfigurations.${hostname};
      };
    };

    nixosConfigurations.${hostname} = nixpkgsVersion.lib.nixosSystem {
      inherit system;
      modules = (mkModules modules) ++ [
        "${inputs.self}/hosts/${hostname}"
        "${inputs.self}/modules/users"
        inputs.home-manager.nixosModules.home-manager
        inputs.agenix.nixosModules.default
      ];
      specialArgs = { inherit inputs; };
    };
  };

  mergeSets = inputs.nixpkgs.lib.lists.foldl' (
    x: y: inputs.nixpkgs.lib.attrsets.recursiveUpdate x y
  ) { };
}
