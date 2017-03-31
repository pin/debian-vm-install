#!/bin/sh

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

# Setup console, remove timeout on boot.
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0"/g; s/TIMEOUT=5/TIMEOUT=0/g' /etc/default/grub
update-grub

# Members of `sudo` group are not asked for password.
sed -i 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers

# Empty message of the day.
echo -n > /etc/motd

# Unpack postinst tarball.
tar -x -v -z -C/tmp -f /tmp/postinst.tar.gz

# Install SSH key for pin.
mkdir -m700 /home/pin/.ssh
cat /tmp/postinst/authorized_keys > /home/pin/.ssh/authorized_keys
chown -R pin:pin /home/pin/.ssh

# Install collectd and config.
#apt-get install -y collectd-core
#cp /tmp/postinst/collectd.conf /etc/collectd/

# Remove some non-essential packages.
DEBIAN_FRONTEND=noninteractive apt-get purge -y nano laptop-detect tasksel dictionaries-common emacsen-common iamerican ibritish ienglish-common ispell

# Set domain name in hosts file
#sed -i 's/127.0.1.1\t\([a-z]*\).*/127.0.1.1\t\1\.dp\-net\.com\t\1/' /etc/hosts

# Avoid using DHCP-server provided domain name.
#sed -i 's/#supersede.*/supersede domain-name "dp-net.com";/' /etc/dhcp/dhclient.conf

