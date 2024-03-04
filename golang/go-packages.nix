{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

  {

	gopls = buildGoModule rec {
	  pname = "gopls";
	  version = "0.14.2";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "gopls/v${version}";
	    sha256 = "sha256-hcicI5ka6m0W2Sj8IaxNsLfIc97eR8SKKp81mJvM2GM=";
	  };

	  modRoot = "gopls";
	  vendorHash = "sha256-jjUTRLRySRy3sfUDfg7cXRiDHk1GWHijgEA5XjS+9Xo=";

	  doCheck = false;

	  # Only build gopls, and not the integration tests or documentation generator.
	  subPackages = [ "." ];

	  meta = with lib; {
	    description = "Official language server for the Go language";
	    homepage = "https://github.com/golang/tools/tree/master/gopls";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ mic92 SuperSandro2000 zimbatm ];
	  };
	};

	golines = buildGoModule rec {
	  pname = "golines";
	  version = "0.12.2";

	  src = fetchFromGitHub {
	    owner = "segmentio";
	    repo = pname;
	    rev = "v${version}";
	    sha256 = "sha256-D0gI9BA0vgM1DBqwolNTfPsTCWuOGrcu5gAVFEdyVGg=";
	  };

	  vendorHash = "sha256-jI3/m1UdZMKrS3H9jPhcVAUCjc1G/ejzHi9SCTy24ak=";

	  meta = with lib; {
	    description = "A golang formatter that fixes long lines";
	    homepage = "https://github.com/segmentio/golines";
	    license = licenses.mit;
	    maintainers = with maintainers; [ cybersiddhu ];
	  };
	};

	godoc = buildGoModule rec {
	  pname = "godoc";
	  version = "0.1.12";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256= "sha256-OUMLnAtaS54+0Zun4oU7YAFZ5mVHkPpytiWpinjNG5c=";
	  };

	  vendorHash = "sha256-XpC3F6BimOja8Jv/MbbLaAdqPKipDY5gFZ8c+W2XoEM=";
	  doCheck = false;

	  subPackages = [ "cmd/godoc" ];

	  meta = with lib; {
	    description = "Godoc extracts and generates documentation for Go programs";
	    homepage = "https://pkg.go.dev/golang.org/x/tools/cmd/godoc";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	goimports = buildGoModule rec {
	  pname = "goimports";
	  version = "0.10.0";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256 = "sha256-ZhzmMn03mPKQ7XzHT9X3V7SSkAnzBYDcXwTCgmVyP3g=";
	  };

	  vendorHash = "sha256-01Y7v+ITIx1uzASLDuB/WKmXUijAdjvXQvn30u3BH/Y=";

	  subPackages = [ "cmd/goimports" ];

	  meta = with lib; {
	    description =  "Command goimports updates your Go import lines";
	    homepage = "https://github.com/golang/tools";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	gorename = buildGoModule rec {
	  pname = "gorename";
	  version = "0.1.12";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256= "sha256-OUMLnAtaS54+0Zun4oU7YAFZ5mVHkPpytiWpinjNG5c=";
	  };

	  vendorHash = "sha256-XpC3F6BimOja8Jv/MbbLaAdqPKipDY5gFZ8c+W2XoEM=";

	  subPackages = [ "cmd/gorename" ];
	  doCheck = false;

	  meta = with lib; {
	    description = "The gorename command performs precise type-safe renaming of identifiers in Go source code";
	    homepage = "https://github.com/golang/tools";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	gomodifytags = buildGoModule rec {
	  pname = "gomodifytags";
	  version = "1.16.0";

	  src = fetchFromGitHub {
	    owner = "fatih";
	    repo = "gomodifytags";
	    rev = "v${version}";
	    sha256= "sha256-prr34frdKUrPkotN2C31E9Ivxq+6sAF2icnq3WqyE/o=";
	  };

	  vendorHash = "sha256-8efqJfu+gtoFbhdlDZfb8NsXV9hBDI2pvAQNH18VVhU=";

	  meta = with lib; {
	    description = "Go tool to modify/update field tags in structs";
	    homepage = "https://github.com/fatih/gomodifytags";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	gotests = buildGoModule rec {
	  pname = "gotests";
	  version = "1.6.0";

	  src = fetchFromGitHub {
	    owner = "cweill";
	    repo = pname;
	    rev = "v${version}";
	    sha256= "sha256-6IzUpAsFUgF2FwiC17OfDn1M+8WYFQPpRyXbkpHIztw="; 
	  };

	  vendorHash = "sha256-WMeHZN3s+8pIYEVaSLjI3Bz+rPTWHr1AkZ8lydjBwCw=";
	  doCheck = false;

	  meta = with lib; {
	    description = "Golang commandline tool that generates table driven tests"; 
	    homepage = "https://github.com/cweill/gotests";
	    license = licenses.asl20;
	    maintainers = with maintainers; [ cybersiddhu ];
	  };
	};

	goguru = buildGoModule rec {
	  pname = "goguru";
	  version = "0.1.12";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256= "sha256-OUMLnAtaS54+0Zun4oU7YAFZ5mVHkPpytiWpinjNG5c=";
	  };

	  vendorHash = "sha256-XpC3F6BimOja8Jv/MbbLaAdqPKipDY5gFZ8c+W2XoEM=";
	  doCheck = false;

	  subPackages = [ "cmd/guru" ];

	  meta = with lib; {
	    description =  "a tool for answering questions about Go source code"; 
	    homepage = "https://github.com/golang/tools";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	goiferr = buildGoModule rec {
	   pname = "iferr-unstable";
	   version = "1.1.0";

	   src = fetchFromGitHub {
	     owner = "xyproto";
	     repo = "iferr";
	     rev = "v${version}";
	     sha256 = "sha256-BJnLDcbcxN/PaY3HRr+tVpiJTIahWrrn/wHUMyoPWgE=";
	   };

	   vendorHash = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
	   doCheck = false;

	   meta = with lib; {
	     description = ''Generate "if err != nil {" block'';
	     homepage = "https://github.com/xyproto/iferr";
	     license = licenses.mit;
	     maintainers = with maintainers; [ cybersiddhu ];
	  };
        };

	golangci-lint-langserver = buildGoModule rec {
	  pname = "golangci-lint-langserver";
	  version = "0.0.7";

	  src = fetchFromGitHub {
	    owner = "nametake";
	    repo = "golangci-lint-langserver";
	    rev = "v${version}";
	    sha256 = "sha256-VsS0IV8G9ctJVDHpU9WN58PGIAwDkH0UH5v/ZEtbXDE=";
	  };

	  vendorHash = "sha256-tAcl6P+cgqFX1eMYdS8vnfdNyb+1QNWwWdJsQU6Fpgg=";

	  meta = with lib; {
	    description = "golangci-lint language server"; 
	    homepage = "https://github.com/nametake/golangci-lint-langserver";
	    license = licenses.mit;
	    maintainers = with maintainers; [ cybersiddhu ];
	};
     };
     steampipe = buildGoModule rec {
	  pname = "steampipe";
	  version = "0.15.4";

	  src = fetchFromGitHub {
	    owner = "turbot";
	    repo = "steampipe";
	    rev = "v${version}";
	    sha256 = "sha256-QBmXWsAJepjQqfAaE8K2wA7Qi6HEDzqUECZkEPWAYQY=";
	  };

	  vendorHash = "sha256-/d1wdJw9DGOvFpQYzNJF9xuy36xF/ZKxxlOs1EFtR14=";
	  proxyVendor = true;

	  nativeBuildInputs = [ installShellFiles ];

	  ldflags = [
	    "-s"
	    "-w"
	  ];

	  postInstall = ''
	    INSTALL_DIR=$(mktemp -d)
	    installShellCompletion --cmd steampipe \
	      --bash <($out/bin/steampipe --install-dir $INSTALL_DIR completion bash) \
	      --fish <($out/bin/steampipe --install-dir $INSTALL_DIR completion fish) \
	      --zsh <($out/bin/steampipe --install-dir $INSTALL_DIR completion zsh)
	  '';

	  meta = with lib; {
	    homepage = "https://steampipe.io/";
	    description = "select * from cloud;";
	    license = licenses.agpl3;
	    maintainers = with maintainers; [ hardselius ];
	  };
	};
}
