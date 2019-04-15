#!/bin/sh

# Go root
######################
if ! [ $(id -u) = 0 ]; then
	echo "I am not root!"
	exit 1
else
	# Debug
	one=1
	two=2
fi

######################
#	INSTALL NEEDED
######################

# Arch / Manjaro
if [ -f /etc/arch-release ];then

	pacman -S syslinux p7zip mtools --noconfirm --needed

	if [ ! -f /sbin/install-mbr ];then

		# Check if yay installed
		if [ ! type "yay" > /dev/null ];then
			echo "This script use yay to install AUR package"
			echo "You can install yay, or install the mbr package from AUR before rerun this script"
			exit 1
		fi

		gpg --receive-keys 8C004C2F93481F6B

		# run yay command with user su
		su $SUDO_USER -c "yay -S mbr --noconfirm --needed"
	fi
else
	# Debian / Ubuntu
	if [ -f /etc/debian_version ];then
		apt-get update
		apt-get install --no-install-recommends -y mbr syslinux p7zip
	else
		echo "This script doesn't support your distro, sorry my friend :/"
		echo "I've only prepare it for pacman/yay and apt-get !"
		exit 1
	fi
fi

######################
#	PREPARE STUFF
######################

# Get device
echo $'\n============================\n'

# List all disks
fdisk -l | grep '^Disk /'

echo Tell me what disk should be transform please \(ex input waited : sdc\)
read devVar
echo $'\n'Working on \/dev\/$devVar$'\n'

# move to perso workspace
if [ ! -d /tmp/toto1233 ];then
	mkdir /tmp/toto1233
fi
cd /tmp/toto1233

# Download iso
if [ ! -f ./CurrentRelease.txt ];then
	wget https://ddl.bunsenlabs.org/ddl/CurrentRelease.txt
fi
blVersion=$(head -n 1 ./CurrentRelease.txt)

echo $'\n============================\n'
echo What version of $blVersion do you want?
echo 1 = amd64
echo 2 = i386
echo 3 = i386, no PAE
read archiIndex

case "$archiIndex" in
"1") 
    archi=amd64
    ;;
"2")
    archi=i386
    ;;
"3")
    archi=i386-cd
    ;;
*)
    archi=amd64
    ;;
esac

echo $'\n'Downloading $blVersion-$archi.iso$'\n'

if [ ! -f ./$blVersion-$archi.iso ];then
	wget https://ddl.bunsenlabs.org/ddl/$blVersion-$archi.iso
	chmod 777 ./$blVersion-$archi.iso 
fi

######################
#	FORMAT DISK
######################
echo ========================================
echo Format USB :

# umount to work on it

umount /dev/$devVar*

isoSize=$(stat -c%s "./$blVersion-$archi.iso")
# Move to Mo
isoSize=${isoSize::-3}
echo $isoSize
# Add 10% of the iso size to the boot partition
isoSize=$(($isoSize*110/100)) 

# Debug for fdisk accurate value
isoSize=$(($isoSize*2)) 

echo $isoSize
# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/$devVar
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +$isoSize # 100 MB boot parttion
  t # change type partition
  b # change to WIN95 fat32
  a # set "boot" flag on partition
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  w # write the partition table
  y # valid proceed
  q # and we're done
EOF

echo ========================================
echo Format partitions :

# Format partition
mkfs.vfat /dev/$devVar$one
# Format second partition with label
mkfs.ext4 /dev/$devVar$two -L 'persistence' -F

######################
#	Set Up the Master Boot Record
######################
echo ========================================
echo Set up the master boot record :

# install MBR to the first sector
/sbin/install-mbr /dev/$devVar

syslinux -i /dev/$devVar$one

# Extract the ISO to the First Partition
echo ========================================
echo Extraction the ISO :

if [ ! -d /tmp/toto1233/mnt ];then
	mkdir mnt
fi
mount /dev/$devVar$one mnt
cd mnt
7z x /tmp/toto1233/$blVersion-$archi.iso	

######################
#	Set Up  Persistence
######################
echo ========================================
echo Set up persistence :

mv isolinux syslinux
mv syslinux/isolinux.cfg syslinux/syslinux.cfg
mv syslinux/isolinux.bin syslinux/syslinux.bin
sed -i 's/\(append boot=.*\)$/\1 persistence/' syslinux/live.cfg
#EOF

# End w/ first partition
cd ../
umount ./mnt

# Create the persistence.conf file in the second partition
mount /dev/$devVar$two ./mnt
cd mnt
touch persistence.conf
echo / union | tee persistence.conf

# Final command
syslinux -i /dev/$devVar$one -d /syslinux

######################
#	Cleaning
######################
echo ========================================
echo Cleaning :

cd /tmp
umount ./mnt
rm -fr /tmp/toto1233

######################
#	End
######################
echo ========================================
echo "That's it! :)"
echo "Reboot to your USB drive and choose a Live session. You'll see messages about your drives not mounting to /live/persistence, that's normal."
echo "The first time you'll boot, you'll see a brief cron job running, that's the persistence being configured. You should be automatically logged into the session. "
echo "If you want to log out, the username is _user_ and the password is _live_. "
echo $'\n'
echo Enjoy your USB Key :D
