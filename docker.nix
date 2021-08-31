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
  ocamlKernel = jupyter.kernels.ocamlWith {
      name = "ocaml";
      packages = p: with p; [];
  };


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