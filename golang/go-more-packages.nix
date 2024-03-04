{ lib, buildGoModule, fetchFromGitHub, stdenv , installShellFiles }:

{
	terraform-ls = buildGoModule rec {
	  pname = "terraform-ls";
	  version = "0.30.1";

	  src = fetchFromGitHub {
	    owner = "hashicorp";
	    repo = pname;
	    rev = "v${version}";
	    sha256 = "sha256-enPnj4/p83hQkVv821MGyGipgEmVo12IZzy/3y8UprQ=";
	  };
	  vendorSha256 = "sha256-U3zslBDVz5nvhNgcn5L84hSUolf7XFCuh7zMZxyW/gQ=";

	  ldflags = [ "-s" "-w" "-X main.version=v${version}" "-X main.prerelease=" ];

	  # There's a mixture of tests that use networking and several that fail on aarch64
	  doCheck = false;

	  doInstallCheck = true;
	  installCheckPhase = ''
	    runHook preInstallCheck
	    $out/bin/terraform-ls --help
	    $out/bin/terraform-ls version | grep "v${version}"
	    runHook postInstallCheck
	  '';

	  meta = with lib; {
	    description = "Terraform Language Server (official)";
	    homepage = "https://github.com/hashicorp/terraform-ls";
	    changelog = "https://github.com/hashicorp/terraform-ls/blob/v${version}/CHANGELOG.md";
	    license = licenses.mpl20;
	    maintainers = with maintainers; [ mbaillie jk ];
	  };
	};

	aiac = buildGoModule rec {
	  pname = "aiac";
	  version = "2.2.0";

	  src = fetchFromGitHub {
	    owner = "fatih";
	    repo = "gofireflyio";
	    rev = "v${version}";
	    sha256 = "sha256-Ju2LoCDY4lQaiJ3OSkt01SaOqVLrDGiTAwxxRnbnz/0=";
	  };

	  vendorSha256 = "sha256-UaC3Ez/i+kPQGOJYtCRtaD2pn3kVZPTaoCcNG7LiFbY=";

	  meta = with lib; {
	    description = "Artificial Intelligence Infrastructure-as-Code Generator";
	    homepage = "https://github.com/gofireflyio/aiac"; 
	    license = licenses.asl20;
	    maintainers = with maintainers; [ cybersiddhu ]; 
	  };
	};


	oapi-codegen = buildGoModule rec {
  	   pname = "oapi-codegen";
           version = "1.13.2";

	  src = fetchFromGitHub {
	    owner = "deepmap";
	    repo = pname;
	    rev = "refs/tags/v${version}";
	    sha256 = "11cxw7pjvmh2bbzv9wpjf2f3mj649b1zk0232wiw46h9s4ihfnb1";
	  };

	  vendorHash = "sha256-AV9rNKqfDMbelu2Bfo5EZ8HlZPjCupBdxsM1Y6Sy9QM=";

	  # Tests use network
	  doCheck = false;

	  meta = with lib; {
	    description = "Go client and server OpenAPI 3 generator";
	    homepage = "https://github.com/deepmap/oapi-codegen";
	    changelog = "https://github.com/deepmap/oapi-codegen/releases/tag/v${version}";
	    license = licenses.asl20;
	    maintainers = with maintainers; [ j4m3s ];
	  };
	};

	dagger = buildGoModule rec {
		  pname = "dagger";
		  version = "0.10.0";

		  src = fetchFromGitHub {
		    owner = "dagger";
		    repo = "dagger";
		    rev = "v${version}";
		    sha256 = "sha256-pvuxgGgPvbkfZdbsJ34jJMcjUpIxDT/KLdTHrLFMqxk=";
		  };

		  vendorHash = "sha256-VhOZpjFKCrIT4VlyTfw8RGfLULtOCzmGKg3Cjy67r8Y=";

	  	  doCheck = false;
	  	  subPackages = [ "cmd/dagger" ];
		  meta = with lib; {
		    description = "Application Delivery as Code that Runs Anywhere";
		    homepage = "https://github.com/dagger/dagger"; 
		    license = licenses.asl20;
		    maintainers = with maintainers; [ cybersiddhu ]; 
		  };
	};

}
