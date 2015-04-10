#!/bin/sh

# Setup console, remove timeout on boot.
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0"/g; s/TIMEOUT=5/TIMEOUT=0/g' /etc/default/grub
update-grub

# Members of `sudo` group are not asked for password.
sed -i 's/%sudo\tALL=(ALL:ALL) ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers

# Empty message of the day.
echo -n > /etc/motd

# Install SSH key for root.
mkdir -m700 /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6Up5b2jDreGMmMbkLtbskCdFTIrEtJLvpzCg95p2wHaEpEEu4VqvibL216Wbyeg/b9+fOnLyRV2eNZZC3gaq7IZak3STsdbZg8K7I/1ECSO3sMeACLwvNUlZLXEBP16IOIJQ3DmxWHIK4+0ndX8W2f8hrPYBVVW5Rbr5vbR27stlXwBI2ZerCxRmfhjuKz5VGvc40nUCHCe0ZrqOJumFnX8EDiu9sbutJKiMVObjpD0ENld8rm/sHiuQi2ds2uKsZOMSbtrefzfnIUf+s2/2AgUA8OsR2SMwi2xfl1iYo8SzYQCdGn12KUG5ODoowEjws9X4kbDYa5H+q9gfNFwrscrVPqqazc8NqgERXMdpuzpPhmy4EmVy+HtVwYkfDJ+k/N1Z9Tea0tm8TY952oRE4wBQnd0Wuk2ywi0UjBaZggwMteZGtVIn0saBjeej68SHD1Iex6crVQkfvNbZM+0evcCs0FqPsTLEykc4RcOUQx9V2yJLXmsIStHkZ5goE4nBtxkIGUMtP23lU0+GeLuZGO43wf3kPfKBNvNK4FdkZrxn6Vfas3IshF/x1amc6XkXY2rMqoCIyiUjvulWTcOlwNTbVQDXqBpeYCbjGwUihUU7yZl3ybLPNSjseBbxjgCo7lMdhe71WATH22lsL0Z7gpXjU8xUErJe4nBS9klVxow==" > /root/.ssh/authorized_keys

# Remove some not essential packages.
DEBIAN_FRONTEND=noninteractive apt-get purge -y nano gcc-4.8-base ispell laptop-detect tasksel

