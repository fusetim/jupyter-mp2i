let 
  jupyter = import (builtins.fetchGit {
      url = https://github.com/tweag/jupyterWith;
  }) {};
  iPython = jupyter.kernels.iPythonWith {
    name = "python";
    packages = p: with p; [ numpy matplotlib ];
  };
  cKernel = jupyter.kernels.cKernelWith {
      name = "c";
      packages = pkgs: with pkgs; [libcue];
  };
  ocamlKernel = (import (builtins.fetchurl {
      url = https://gist.githubusercontent.com/fusetim/e59b17fc9bac31f2e43174fccd14d7e9/raw/278c713c0faedba35f7d120b87ffb41cca707eaa/default.nix;
  }) {
      name = "ocaml";
      packages = p: with p; [];
  });


  jupyterEnvironment = 
    jupyter.jupyterlabWith {
        kernels = [ ocamlKernel cKernel iPython ];
        extraPackages = p: [p.pandoc];
    };
in 
  jupyter.mkDockerImage {
      name = "jupyter-mp2i";
      jupyterlab = jupyterEnvironment;
  }