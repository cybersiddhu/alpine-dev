with (import <nixpkgs> {});
let 
  osdeps = [
  	curl
	git 
	htop 
	exa 
	fd
	zsh
	file 
	ripgrep
	starship
	neovim
	which
	nodejs-14_x
	yarn
	bat
  ];
  vimPlugs = with vimPlugins; [
  	nvim-lspconfig
	nvim-cmp
	cmp-nvim-lsp
	cmp-buffer
	cmp-calc
	cmp-spell
	cmp-path
	lspkind-nvim
	luasnip
	cmp_luasnip
	friendly-snippets
   ];	
  nodePkgs = import ./nodedeps.nix {};
  inputs = with nodePkgs; [
	typescript
	typescript-language-server
	graphql-language-service-cli
	dockerfile-language-server-nodejs
	vscode-langservers-extracted
  ] ++ osdeps ++ vimPlugs;

in
mkShell {
  buildInputs = [ inputs ];
}
