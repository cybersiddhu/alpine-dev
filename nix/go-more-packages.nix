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

	k0sctl = buildGoModule rec {
	  pname = "k0sctl";
	  version = "0.15.0";

	  src = fetchFromGitHub {
	    owner = "k0sproject";
	    repo = pname;
	    rev = "v${version}";
	    sha256 = "sha256-i/XgEPuYNxn10eOXfF+X33oLlkO9r6daeygZcSdcicQ=";
	  };

	  vendorSha256 = "sha256-RTC2AEDzSafvJT/vuPjzs25PhuzBiPb32an/a/wpY04=";

	  ldflags = [
	    "-s"
	    "-w"
	    "-X github.com/k0sproject/k0sctl/version.Environment=production"
	    "-X github.com/k0sproject/k0sctl/version.Version=${version}"
	  ];

  	  nativeBuildInputs = [ installShellFiles ];

	  postInstall = ''
	    for shell in bash zsh fish; do
	      installShellCompletion --cmd ${pname} \
		--$shell <($out/bin/${pname} completion --shell $shell)
	    done
	  '';

	  meta = with lib; {
	    description = "A bootstrapping and management tool for k0s clusters.";
	    homepage = "https://k0sproject.io/";
	    license = licenses.asl20;
	    maintainers = with maintainers; [ nickcao ];
	  };
	};

	clusterctl = buildGoModule rec {
  	  pname = "clusterctl";
  	  version = "1.4.2";

	  src = fetchFromGitHub {
	    owner = "kubernetes-sigs";
	    repo = "cluster-api";
	    rev = "v${version}";
	    sha256 = "sha256-NvCQs6YzQ2zNLQiYgFK/q2c74g/+YkzQIQJWEINOYIE=";
	  };

	  vendorSha256 = "sha256-ZJFpzBeC048RZ6YfjXQPyohCO1WagxXvBBacifkfkjE=";

	  subPackages = [ "cmd/clusterctl" ];

	  nativeBuildInputs = [ installShellFiles ];

	  ldflags = let t = "sigs.k8s.io/cluster-api/version"; in [
	    "-X ${t}.gitMajor=${lib.versions.major version}"
	    "-X ${t}.gitMinor=${lib.versions.minor version}"
	    "-X ${t}.gitVersion=v${version}"
	  ];

	  postInstall = ''
	    export HOME=$TMPDIR

	    installShellCompletion --cmd clusterctl \
	      --bash <($out/bin/clusterctl completion bash) \
	      --zsh <($out/bin/clusterctl completion zsh)
	  '';

	  meta = with lib; {
	    description = "Kubernetes cluster API tool";
	    homepage = "https://cluster-api.sigs.k8s.io/";
	    license = licenses.asl20;
	    maintainers = with maintainers; [ zowoq ];
	  };
	};
}
