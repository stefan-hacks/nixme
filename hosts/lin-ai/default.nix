# ═══════════════════════════════════════════════════════════════════════════════
# HOSTS/LIN-AI/DEFAULT.NIX - AI/ML Workstation Configuration
# ═══════════════════════════════════════════════════════════════════════════════
#
# Specialized host for AI/ML development with GPU support.
#
# ═══════════════════════════════════════════════════════════════════════════════

{ config, pkgs, lib, inputs, vars, const, ... }:

{
  imports = [ ./hardware.nix ];
  
  networking.hostName = "lin-ai";
  system.stateVersion = "26.05";
  
  # ═══════════════════════════════════════════════════════════════════════════
  # GPU/CUDA CONFIGURATION
  # ═══════════════════════════════════════════════════════════════════════════
  services.xserver.videoDrivers = lib.mkForce [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      cudaPackages.cuda_nvml_dev
      cudaPackages.cuda_cudart
      linuxPackages.nvidia_x11
    ];
  };
  
  # ═══════════════════════════════════════════════════════════════════════════
  # AI/ML PACKAGES
  # ═══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Python ML stack
    python3
    python3Packages.pytorch
    python3Packages.tensorflow
    python3Packages.keras
    python3Packages.scikit-learn
    python3Packages.pandas
    python3Packages.numpy
    python3Packages.matplotlib
    python3Packages.seaborn
    python3Packages.jupyter
    python3Packages.ipython
    python3Packages.notebook
    
    # CUDA
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    
    # ML tools
    ollama
    lmstudio
    
    # Data tools
    apache-spark
    
    # Container for ML
    distrobox
    
    # Development
    gcc
    gnumake
    cmake
  ];
  
  # ═══════════════════════════════════════════════════════════════════════════
  # OLLAMA SERVICE
  # ═══════════════════════════════════════════════════════════════════════════
  services.ollama = {
    enable = true;
    acceleration = "cuda";
  };
}
