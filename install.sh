#!/bin/sh
 
# A script to install debian jessie on a KVM guest

# Domain is necessary in order to avoid debian installer to
# require manual domain entry during the install.
DOMAIN=`/bin/hostname -d` # Use domain of the host system
#DOMAIN="dp-net.com" # Alternatively, hardcode domain
# NB: See postinst.sh for ability to override domain received from
# DHCP during the install.

#DIST_URL="http://ftp.de.debian.org/debian/dists/stretch/main/installer-amd64/"
DIST_URL="https://d-i.debian.org/daily-images/amd64/"
LINUX_VARIANT="debian9"
# NB: Also see preseed.cfg for debian mirror hostname.

if [ $# -lt 1 ]
then
	echo "Usage: $0 <guest-name> [mac-address]"
	exit 1
fi

MAC="RANDOM"
if [ $# -eq 2 ]
then
	MAC=$2
fi

# Fetch SSH key from github.
wget https://github.com/pin.keys -O postinst/authorized_keys

# Create tarball with some stuff we would like to install into the system.
tar cvfz postinst.tar.gz postinst
 
virt-install \
--connect=qemu:///system \
--name=${1} \
--ram=1024 \
--vcpus=2 \
--disk size=16,path=/var/lib/libvirt/images/${1}.img,bus=virtio,cache=none \
--initrd-inject=preseed.cfg \
--initrd-inject=postinst.sh \
--initrd-inject=postinst.tar.gz \
--location ${DIST_URL} \
--os-type linux \
--os-variant ${LINUX_VARIANT} \
--virt-type=kvm \
--controller usb,model=none \
--graphics none \
--noautoconsole \
--network bridge=br0,mac=${MAC},model=virtio \
--extra-args="auto=true hostname="${1}" domain="${DOMAIN}" console=tty0 console=ttyS0,115200n8 serial"

rm postinst.tar.gz
