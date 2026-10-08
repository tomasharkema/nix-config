{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.hass;
  dongleAddress = "192.168.9.165:6638";

  cpcPath = "/tmp/ttyCPC";
  ezspInterface = "/tmp/ttyZigbeeNCP";

  cpcConf = pkgs.writeText ''
    # Instance Name
    # Optional, defaults to "cpcd_0"
    # This string uniquely identifies the running cpcd instance.
    # An application must pass this value to cpc_init() to connect
    # to this particular instance.
    instance_name: cpcd_0

    # Bus type selection
    # Mandatory
    # Allowed values : UART or SPI
    bus_type: UART

    # SPI device file
    # Mandatory if spi chosen, ignored if uart chosen
    spi_device_file: /dev/spidev0.0

    # SPI RX IRQ gpio chip
    # Ignored when using the gpio sysfs interface
    spi_rx_irq_gpio_chip: gpiochip0

    # SPI RX IRQ gpio
    # RX interrupt gpio selection
    spi_rx_irq_gpio: 22

    # SPI bitrate.
    # Ignored if uart chosen.
    # See doc/spi_bitrate.md for a complete explanation
    spi_device_bitrate: 1000000

    # UART device file
    # Mandatory if uart chosen, ignored if spi chosen
    uart_device_file: ${cpcPath}

    # UART baud rate.
    # Optional if uart chosen, ignored if spi chosen. Defaults to 115200
    # Allowed values : standard UART baud rates listed in 'termios.h'
    uart_device_baud: 115200

    # UART flow control.
    # Optional if uart chosen, ignored if spi chosen. Defaults to 'true'
    # Allowed values are 'true' or 'false'
    uart_hardflow: false

    # BOOTLOADER Recovery Pins Enabled
    # Set to true to enter bootloader via wake and reset pins
    # If true, bootloader_wake_gpio and bootloader_reset_gpio must be configured
    bootloader_recovery_pins_enabled: false

    # BOOTLOADER WAKE gpio chip
    # Ignored when using the gpio sysfs interface
    bootloader_wake_gpio_chip: gpiochip0

    # BOOTLOADER WAKE gpio
    # Wakeup gpio used by the bootloader
    # Ensure bootloader_recovery_pins_enabled=true to use this pin
    bootloader_wake_gpio: 24

    # BOOTLOADER RESET gpio chip
    # Ignored when using the gpio sysfs interface
    bootloader_reset_gpio_chip: gpiochip0

    # BOOTLOADER RESET gpio
    # Reset pin
    # Ensure bootloader_recovery_pins_enabled=true to use this pin
    bootloader_reset_gpio: 23

    # Prints tracing information to stdout
    # Optional, defaults to 'false'
    # Allowed values are 'true' or 'false'
    stdout_trace: true

    # Prints tracing information to a file located under traces_folder
    # Optional, defaults to 'false'
    # Allowed values are 'true' or 'false'
    trace_to_file: false

    # Traces folder
    # Optional, defaults to '/dev/shm/cpcd-traces'
    # Folder mounted on a tmpfs is preferred
    traces_folder: /dev/shm/cpcd-traces

    # Enable frame trace
    # Optional, defaults to 'false'
    # Allowed values are 'true' or 'false'
    enable_frame_trace: false

    # Number of open file descriptors.
    # Optional, defaults to 2000
    # If the error 'Too many open files' occurs, this is the value to increase.
    rlimit_nofile: 2000

    # Disable the encryption over CPC endpoints
    # Optional, defaults false
    disable_encryption: true

    # Binding key file
    # Mandatory when security is used
    # Must have 32 alphanumeric characters as the first line, representing a 128 bit binding key
    # If ECDH encryption is used, this file will be created during the binding process
    binding_key_file: /etc/binding-key.key
  '';
in {
  options.apps.hass = {
    enable = lib.mkEnableOption "hass";
    folder = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/home-assistant";
    };
  };

  config = lib.mkIf cfg.enable {
    apps.docker.enable = true;

    services.tsnsrv.services = {
      hass = {
        toURL = "http://127.0.0.1:8123";
        upstreamHeaders = {
          Host = "hass.ling-lizard.ts.net";
        };
      };
    };

    # systemd = {
    #   services = {
    #     cpc-dongle = {
    #       script = ''
    #         ${pkgs.socat}/bin/socat -d pty,raw,echo=0,link=${cpcPath},ignoreeof "tcp:${dongleAddress}"
    #       '';
    #     };
    #     cpcd = {
    #       script = ''
    #         ${pkgs.custom.cpc-daemon}/bin/cpcd -c ${cpcConf}
    #       '';
    #       after = ["cpc-dongle.service"];
    #     };
    #     zigbeed = {
    #       script = ''
    #         zigbeed --radio-url "spinel+cpc://cpcd_0?iid=1&iid-list=0" --ezsp-interface ${ezspInterface}
    #       '';
    #       after = ["cpcd.service"];
    #     };
    #   };
    # };

    virtualisation = {
      oci-containers.containers = {
        home-assistant = {
          image = "ghcr.io/home-assistant/home-assistant:stable";

          autoStart = true;
          privileged = true;
          extraOptions = ["--network=host"];

          volumes = [
            "/run/dbus:/run/dbus:rw"
            "/etc/localtime:/etc/localtime:ro"
            "${cfg.folder}:/config"
          ];
        };
        matter = {
          image = "ghcr.io/matter-js/python-matter-server:stable";

          autoStart = true;
          privileged = true;
          extraOptions = ["--network=host"];

          volumes = [
            "/run/dbus:/run/dbus"
            "/etc/localtime:/etc/localtime"
            "${cfg.folder}/matter:/data"
          ];
        };
      };
    };
  };
}
