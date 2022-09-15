with (import <nixpkgs> {});
with builtins;
let
	luaConfigSrc = stdenv.mkDerivation {
		name = "lua-config";
		src = fetchFromGitHub {
			owner = "cybersiddhu";
			repo = "alpine-dev";	
			rev = "92dfcbbc9fbebfd54bb6646ddddb4c0038ad98dc";
			sha256="/cb8vZkiqkm3VpR/yRlx3AusroiYeW+IuogqbPLi6bo=";
		};
		phases = ["installPhase"];
		installPhase = ''
			mkdir -p $out
			cp -a $src/* $out/
		'';

	};
  	nodePkgs = import ./nodedeps.nix {};
  	inputs = with nodePkgs; [
		typescript
		typescript-language-server
		graphql-language-service-cli
		dockerfile-language-server-nodejs
		vscode-langservers-extracted
  	];
	vimPackerSrc = stdenv.mkDerivation {
		name = "vim-packer";
		src = fetchFromGitHub {
			owner = "wbthomason";
			repo = "packer.nvim";	
			rev = "7f62848f3a92eac61ae61def5f59ddb5e2cc6823";
			sha256 = "A2c3DotYb355gDi2NeLGh4O/SOrIB2pV4tvecETl+ek=";
		};
		buildInputs = [ neovim inputs ]; 
		phases = ["installPhase"];
		installPhase = ''
  			export XDG_CONFIG_HOME=$out
  			export XDG_DATA_HOME=$out
			mkdir -p $out/nvim/site/pack/packer/start/packer.nvim
			cp -a $src/* $out/nvim/site/pack/packer/start/packer.nvim/
			cp ${luaConfigSrc}/js/init.lua $out/nvim/
			cp -a ${luaConfigSrc}/js/lua $out/nvim/
			export HOME=$(mktemp -d)
			nvim --headless -c "autocmd User PackerComplete quitall" -c "PackerSync" 
		'';
	};
in
mkShell {
  buildInputs = [ neovim bat vimPackerSrc ];
  shellHook = ''
  	export VIMRUNTIME=${vimPackerSrc}
  '';
}
