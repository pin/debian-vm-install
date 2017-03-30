# Debian Stretch unattended VM guest installer

Simple script that uses virt-install and configures Debian installer
for unattended installation and custom configuration using Preseed
config in order to create freshly installed Debian KVM guest.

```
Usage: ./install.sh <GUEST_NAME> [MAC_ADDRESS]"

  GUEST_NAME    used as guest hostname, name of the VM and image file name
  MAC_ADDRESS   allows to use specific MAC on the network, this is helpful
                when DHCP server expects your guest to have predefined MAC
```

Prerequisites
-------------
 * virt-install: `apt-get install virtinst`
 * KVM/qemu: `apt-get install qemu-kvm libvirt-daemon # something else?`

Things to check before first use
--------------------------------
 * Set your login name, full name in `preseed.cfg`, update your GitHub name
   in `install.sh` in order to provide right SSH key for authentication in guest.
   If you want to use different SSH key, put `authorized_keys` to `preseed`
   directory and remove `wget` fetching keyt from GitHub.
   Update your login name in `postinst.sh`, where SSH key is installed.
 * Worth considering to enable password authentication in `preseed.cfg` at least
   during first run so you could `virsh console <GUEST_NAME>` in case network
   is not comes up with DHCP or IP of the guest is unclear.
 * Check RAM size and disk size for the guest in arguments to `virst-install` in
   `install.sh`.
 * Add `apt-get install <your_favorite>` or whatever you want to `postinst.sh`
   and any configuration files you want to add to the guest into `postinst`
   directory.

Network configuration
---------------------
Script works best with bridged network, when guests are able to use DHCP
server. In case you want something else, replace `br0` in arguments to
virt-install in `install.sh`.

Example of network configuration in `/etc/network/interfaces`:
```
auto lo
iface lo inet loopback

auto eth0 # replace eth0 with your actual interface name
iface eth0 inet manual

auto br0
iface br0 inet dhcp
        bridge_ports eth0
        bridge_stp off
        bridge_fd 0
        bridge_maxwait 0
```

More Info
---------
* https://www.debian.org/releases/stable/example-preseed.txt
