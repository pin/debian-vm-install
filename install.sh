#!/bin/sh
 
# A script to install debian jessie on a KVM guest
 
if [ $# -ne 1 ]
then
	echo "Usage: $0 <guest-name>"
	exit 1
fi
 
virt-install \
--connect=qemu:///system \
--name=${1} \
--ram=1024 \
--vcpus=4 \
--disk size=4,path=/var/lib/libvirt/images/${1}.img,bus=virtio,cache=none \
--initrd-inject=preseed.cfg \
--initrd-inject=late.sh \
--location http://mirrors.cat.pdx.edu/debian/dists/jessie/main/installer-amd64/ \
--os-type=linux \
--virt-type=kvm \
--controller usb,model=none \
--graphics none \
--noautoconsole \
--network bridge=br0,mac=RANDOM,model=virtio \
--extra-args="auto=true hostname="${1}" domain=dp-net.com console=tty0 console=ttyS0,115200n8 serial"

