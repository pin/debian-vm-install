# Debian Bookworm unattended VM guest installer

Simple script that uses **virt-install** and configures Debian installer
for unattended installation and custom configuration using **preseed**
config in order to create freshly installed Debian KVM guest.

```
Usage: ./install.sh <GUEST_NAME> [MAC_ADDRESS]

  GUEST_NAME    used as guest hostname, name of the VM and image file name
  MAC_ADDRESS   allows to use specific MAC on the network, this is helpful
                when DHCP server expects your guest to have predefined MAC
```

Guest OS is minimal no-GUI Debian installation configured with serial console
for ability to `virsh console <GUEST_NAME>`, and OpenSSH server with your SSH
key or/and password pre-configured.

It is easy to change the script to add any extra packages and
configuration files during unattended installation. The main point of
sharing this script is to provide an example of unattended Debian VM
creation or a base for your own script.

Prerequisites
-------------
```
apt-get install wget virtinst libvirt-daemon-system qemu-system-x86 qemu-utils
```

Things to check before the first use
------------------------------------
 * Set your login name and full name in `preseed.cfg`, update your GitHub name
   in `install.sh` in order to install your SSH key for authentication by guest.
   If you want to use different SSH key, not the one from GitHub, just put
   `authorized_keys` to `preseed` directory and remove `wget` command that
   fetches key from GitHub.
   Update your login name in `postinst.sh`, where SSH key is installed.
 * It's worth considering to enable password authentication in `preseed.cfg`
   at least during first run so you could `virsh console <GUEST_NAME>` in case
   network connection in guest does not come up with DHCP or IP of the guest
   is unclear.
 * Check RAM size and disk size for the guest in arguments to `virst-install` in
   `install.sh` and modify them as needed.
 * Add `apt-get install -y <your_favorite>` or whatever you want to `postinst.sh`
   and any configuration files you want to add to the guest into `postinst`
   directory.

Network configuration
---------------------
Script works with bridged network, guests use DHCP and show up in local network.
In case you want something else, replace `br0` in arguments to virt-install
in `install.sh`.

Before setting bridged network up:
```
apt-get install brigde-utils
```

Example of network configuration in `/etc/network/interfaces`:
```
auto lo
iface lo inet loopback

auto br0
iface br0 inet dhcp
        bridge_hw eth0
        bridge_ports eth0
        bridge_stp off
        bridge_fd 1
        bridge_maxage 12
```

More Info
---------
* https://www.debian.org/releases/stable/example-preseed.txt
