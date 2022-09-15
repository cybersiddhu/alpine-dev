{ lib, buildGo118Module, fetchFromGitHub }:

  {
	golines = buildGo118Module rec {
	  pname = "golines";
	  version = "0.11.0";

	  src = fetchFromGitHub {
	    owner = "segmentio";
	    repo = pname;
	    rev = "v${version}";
	    sha256= "sha256-2K9KAg8iSubiTbujyFGN3yggrL+EDyeUCs9OOta/19A=";
	  };

	  vendorSha256 = "sha256-rxYuzn4ezAxaeDhxd8qdOzt+CKYIh03A9zKNdzILq18=";

	  meta = with lib; {
	    description = "A golang formatter that fixes long lines";
	    homepage = "https://github.com/segmentio/golines";
	    license = licenses.mit;
	    maintainers = with maintainers; [ cybersiddhu ];
	  };
	};

	goimports = buildGo118Module rec {
	  pname = "goimports";
	  version = "0.1.12";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256= "sha256-OUMLnAtaS54+0Zun4oU7YAFZ5mVHkPpytiWpinjNG5c=";
	  };

	  vendorSha256 = "sha256-XpC3F6BimOja8Jv/MbbLaAdqPKipDY5gFZ8c+W2XoEM=";

	  subPackages = [ "cmd/goimports" ];

	  meta = with lib; {
	    description =  "Command goimports updates your Go import lines";
	    homepage = "https://github.com/golang/tools";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	gorename = buildGo118Module rec {
	  pname = "gorename";
	  version = "0.1.12";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256= "sha256-OUMLnAtaS54+0Zun4oU7YAFZ5mVHkPpytiWpinjNG5c=";
	  };

	  vendorSha256 = "sha256-XpC3F6BimOja8Jv/MbbLaAdqPKipDY5gFZ8c+W2XoEM=";

	  subPackages = [ "cmd/gorename" ];
	  doCheck = false;

	  meta = with lib; {
	    description = "The gorename command performs precise type-safe renaming of identifiers in Go source code";
	    homepage = "https://github.com/golang/tools";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	gomodifytags = buildGo118Module rec {
	  pname = "gomodifytags";
	  version = "1.16.0";

	  src = fetchFromGitHub {
	    owner = "fatih";
	    repo = "gomodifytags";
	    rev = "v${version}";
	    sha256= "sha256-prr34frdKUrPkotN2C31E9Ivxq+6sAF2icnq3WqyE/o=";
	  };

	  vendorSha256 = "sha256-8efqJfu+gtoFbhdlDZfb8NsXV9hBDI2pvAQNH18VVhU=";

	  meta = with lib; {
	    description = "Go tool to modify/update field tags in structs";
	    homepage = "https://github.com/fatih/gomodifytags";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	gotests = buildGo118Module rec {
	  pname = "gotests";
	  version = "1.6.0";

	  src = fetchFromGitHub {
	    owner = "cweill";
	    repo = pname;
	    rev = "v${version}";
	    sha256= "sha256-6IzUpAsFUgF2FwiC17OfDn1M+8WYFQPpRyXbkpHIztw="; 
	  };

	  vendorSha256 = "sha256-WMeHZN3s+8pIYEVaSLjI3Bz+rPTWHr1AkZ8lydjBwCw=";
	  doCheck = false;

	  meta = with lib; {
	    description = "Golang commandline tool that generates table driven tests"; 
	    homepage = "https://github.com/cweill/gotests";
	    license = licenses.asl20;
	    maintainers = with maintainers; [ cybersiddhu ];
	  };
	};

	goguru = buildGo118Module rec {
	  pname = "goguru";
	  version = "0.1.12";

	  src = fetchFromGitHub {
	    owner = "golang";
	    repo = "tools";
	    rev = "v${version}";
	    sha256= "sha256-OUMLnAtaS54+0Zun4oU7YAFZ5mVHkPpytiWpinjNG5c=";
	  };

	  vendorSha256 = "sha256-XpC3F6BimOja8Jv/MbbLaAdqPKipDY5gFZ8c+W2XoEM=";
	  doCheck = false;

	  subPackages = [ "cmd/guru" ];

	  meta = with lib; {
	    description =  "a tool for answering questions about Go source code"; 
	    homepage = "https://github.com/golang/tools";
	    license = licenses.bsd3;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};

	goiferr = buildGo118Module rec {
	   pname = "iferr-unstable";
	   version = "1.1.0";

	   src = fetchFromGitHub {
	     owner = "xyproto";
	     repo = "iferr";
	     rev = "v${version}";
	     sha256 = "sha256-BJnLDcbcxN/PaY3HRr+tVpiJTIahWrrn/wHUMyoPWgE=";
	   };

	   vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";
	   doCheck = false;

	   meta = with lib; {
	     description = ''Generate "if err != nil {" block'';
	     homepage = "https://github.com/xyproto/iferr";
	     license = licenses.mit;
	     maintainers = with maintainers; [ cybersiddhu ];
	  };
        };

	golangci-lint-langserver = buildGo118Module rec {
	  pname = "golangci-lint-langserver";
	  version = "0.0.7";

	  src = fetchFromGitHub {
	    owner = "nametake";
	    repo = "golangci-lint-langserver";
	    rev = "v${version}";
	    sha256 = "sha256-VsS0IV8G9ctJVDHpU9WN58PGIAwDkH0UH5v/ZEtbXDE=";
	  };

	  vendorSha256 = "sha256-tAcl6P+cgqFX1eMYdS8vnfdNyb+1QNWwWdJsQU6Fpgg=";

	  meta = with lib; {
	    description = "golangci-lint language server"; 
	    homepage = "https://github.com/nametake/golangci-lint-langserver";
	    license = licenses.mit;
	    maintainers = with maintainers; [ cybersiddhu ];
	};
     };
}
