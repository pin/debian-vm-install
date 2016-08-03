# Debian Jessie unattended install using Preseed

Script installs libvirt/KVM/qemu-based Debian Jessie virtual machine and does some custom post-install configuration.
It uses `virt-install`.
It can be used as an example or as a base for your own script.

For best results before first use at least:
 * Update domain name in `install.sh` and scattered in `late.sh`.
 * Update user / login name in `preseed.cfg`, update login name in `late.sh`
 * Update SSH public key in postinst or enable password setup in `preseed.cfg`

It is works best in setup with bridged network interface on KVM-based linux host. Bridge setup example:
```
$ cat /etc/network/interfaces
auto lo
iface lo inet loopback

auto eth0
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
