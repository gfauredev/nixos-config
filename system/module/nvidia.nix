{ lib, ... }:
{
  hardware.graphics.enable = lib.mkForce true;

  # Apparently needed for Wayland too, and even with open driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia.open = true;

  # hardware.nvidia = {
  #   modesetting.enable = true; # TEST relevance
  #   powerManagement = {
  #     enable = true; # Experimental, disable for stability
  #     finegrained = true; # Experimental, disable for stability
  #   };
  #   open = false; # We like openness
  #   nvidiaSettings = false; # Nvidia settings GUI
  #   nvidiaPersistenced = true; # Allow GPU to stay awake headless
  #   gps.enable = false; # GPU System Processor
  #   forceFullCompositionPipeline = true; # May solve bugs TEST relevance
  #   prime = {
  #     allowExternalGpu = true;
  #     offload = {
  #       enable = true;
  #       enableOffloadCmd = true;
  #     };
  #     sync.enable = true;
  #     intelBusId = "PCI:0:2:0";
  #     nvidiaBusId = "PCI:127:0:0";
  #   };
  #   package =
  #     config.boot.kernelPackages.nvidiaPackages.production; # .stable; # .beta;
  # };

  # hardware.graphics.extraPackages = with pkgs; [
  #   vaapiVdpau # Nvidia TEST relevance
  #   libvdpau-va-gl # Nvidia TEST relevance
  # ];
}
