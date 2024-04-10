# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

let
	rebuild = import ./scripts.nix { inherit pkgs; };
in
{
	imports =
	[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		inputs.home-manager.nixosModules.default
	];

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/New_York";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
	LC_ADDRESS = "en_US.UTF-8";
	LC_IDENTIFICATION = "en_US.UTF-8";
	LC_MEASUREMENT = "en_US.UTF-8";
	LC_MONETARY = "en_US.UTF-8";
	LC_NAME = "en_US.UTF-8";
	LC_NUMERIC = "en_US.UTF-8";
	LC_PAPER = "en_US.UTF-8";
	LC_TELEPHONE = "en_US.UTF-8";
	LC_TIME = "en_US.UTF-8";
	};

	virtualisation.libvirtd.enable = true;
	programs.virt-manager.enable = true;

	# # Enable the X11 windowing system.
	services.xserver.enable = true;

	# # Enable the GNOME Desktop Environment.
	services.xserver.displayManager.gdm.enable = true;
	# services.xserver.desktopManager.gnome.enable = true;

	# Configure keymap in X11
	services.xserver.xkb = {
	layout = "us";
	variant = "";
	};

	# Enable CUPS to print documents.
	services.printing.enable = true;


	programs.hyprland = {
	enable = true;
	package = inputs.hyprland.packages.${pkgs.system}.hyprland;
	};

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

	# Enable sound with pipewire.
	security.rtkit.enable = true;
	hardware.pulseaudio.enable = false;
	services.pipewire = {
	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
	};

	programs.steam = {
  	enable = true;
  	remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
	};

	hardware.bluetooth.enable = true; # enables support for Bluetooth
	services.blueman.enable = true; # Blueman GUI 
	
	# Enable touchpad support (enabled default in most desktopManager).
	services.xserver.libinput.enable = true;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	security.sudo.wheelNeedsPassword = false;
	
	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.adithya = {
	isNormalUser = true;
	description = "Adithya";
	extraGroups = [ "networkmanager" "wheel" "libvirtd" ]
	++ ["lp" "scanner"];
	packages = with pkgs; [
		firefox
		google-chrome
		vscode
		git
	];
	};

	environment.systemPackages = with pkgs; [
	rebuild
	vim 
	wget
	neovim
	neofetch

	discord
	waybar
	rebuild
	# Hyprland
	dunst
	libnotify
	swww
	kitty
	rofi-wayland
	lxqt.lxqt-policykit
	networkmanagerapplet
	grim
	clipman
	logiops
	pamixer
	eza
	sutils
	signal-desktop
	];

	nix.settings.experimental-features = ["nix-command" "flakes"];


	fonts.packages = with pkgs; [
		noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    twemoji-color-font
    fira-code
    fira-code-symbols	
		(nerdfonts.override { fonts = ["JetBrainsMono"];})
	];
	fonts.fontconfig = {
      enable = true;
			defaultFonts = {
      serif = ["JetBrainsMono" ];
      sansSerif = [ "JetBrainsMono" ];
      monospace = [ "JetBrainsMono" ];
    	};
	};


	home-manager = {
		# also pass inputs to home-manager modules
		extraSpecialArgs = {inherit inputs;};
		users = {
		"adithya" = import ./home.nix;
		};
	};

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#   enable = true;
	#   enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?

	nix.settings = {
		substituters = ["https://hyprland.cachix.org"];
		trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
		};

}
