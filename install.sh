#!/bin/sh -e
 
# Create debian VM as a KVM guest using virt-install in fully
# automated way based on preseed.cfg

# Domain is necessary to avoid debian installer to
# require manual domain entry during the install.
DOMAIN=`/bin/hostname -d` # Use domain of the host system
#DOMAIN="dp-net.com" # Alternatively, hardcode domain
# NB: See postinst.sh for ability to override domain received from
# DHCP during the install.

DIST_URL="http://ftp.debian.org/debian/dists/bookworm/main/installer-amd64/"
LINUX_VARIANT="debiantesting"
# NB: Also see preseed.cfg for debian mirror hostname.

if [ $# -lt 1 ]
then
	cat <<- EOF
	Usage: $0 <GUEST_NAME> [MAC_ADDRESS]"

	  GUEST_NAME    used as guest hostname, name of the VM and image file name
	  MAC_ADDRESS   allows to use specific MAC on the network, this is helpful
	                when DHCP server expects your guest to have predefined MAC

	Examples:

	  $0 backend 52:54:00:bf:b3:86 # create guest named "backend" with given MAC

	  $0 wow # create guest named "wow" with random MAC
	EOF
	exit 1
fi

MAC="RANDOM"
if [ $# -eq 2 ]
then
	MAC=$2
fi

# Fetch SSH key from github.
wget -q https://github.com/pin.keys -O postinst/authorized_keys

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
--os-variant ${LINUX_VARIANT} \
--virt-type=kvm \
--controller usb,model=none \
--graphics none \
--noautoconsole \
--network bridge=br0,mac=${MAC},model=virtio \
--extra-args="auto=true hostname="${1}" domain="${DOMAIN}" console=tty0 console=ttyS0,115200n8 serial"

rm postinst.tar.gz
