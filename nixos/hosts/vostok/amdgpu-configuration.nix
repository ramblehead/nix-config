{pkgs, ...}: {
  boot.kernelModules = ["amdgpu"];

  # Enable GPU support at initrd stage
  hardware.amdgpu.initrd.enable = true;

  systemd.tmpfiles.rules = let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages_5; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];

  # # This is necesery because many programs hard-code the path to hip.
  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  # ];

  # As of ROCm 4.5, AMD has disabled OpenCL on Polaris based cards. So this is
  # needed if you have a 500 series card.
  environment.variables.ROC_ENABLE_PRE_VEGA = "1";

  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
    # setLdLibraryPath = true;

    extraPackages = with pkgs; [
      rocmPackages_5.clr.icd
      rocmPackages_5.clr
      rocmPackages_5.rocm-runtime
      rocmPackages_5.rocm-core

      rocmPackages_5.rocblas
      rocmPackages_5.hipblas

      # ocl-icd
    ];
  };

  environment.systemPackages = with pkgs; [
    clinfo
    radeontop
    opencl-info
    rocmPackages_5.rocminfo
  ];
}
