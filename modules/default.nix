{ inputs }:
let
  genModules =
    { type, modules }: builtins.map (module: "${inputs.self}/modules/${type}/${module}") modules;

  mkModules = moduleAttrList: builtins.concatMap (moduleAttr: genModules moduleAttr) moduleAttrList;
in
{
  mkSystem = hostname: nixpkgsVersion: modules: {
    ${hostname} = nixpkgsVersion.lib.nixosSystem {
      system = "x86_64-linux";
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
