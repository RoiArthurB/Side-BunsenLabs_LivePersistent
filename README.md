# Create a Live BunsenLabs USB Drive With Persistent Storage

[![Language](http://img.shields.io/badge/language-UnixShell-brightgreen.svg)](https://en.wikipedia.org/wiki/Unix_shell)
![GitHub](https://img.shields.io/github/license/RoiArthurB/Side-BunsenLabs_LivePersistent.svg)

![Maintenance](https://img.shields.io/maintenance/yes/2019.svg)

Shell script which install the latest [BunsenLabs](https://www.bunsenlabs.org) on a USB Key with [persistence](https://www.pendrivelinux.com/what-is-persistent-linux/).

### MY needs for that USB key ?

* Boot on any computer
* Boot in a minute
* Fit on a 4Go USB key
* VERY stable (not daily use)
* With GUI
* Create with debug software available (gparted, ..)
* Very wide packages availables (APT or AUR)
* Could install the OS if needed

### Why BunsenLabs ?

* :heavy_check_mark: Boot on any computer
* :heavy_check_mark: Boot in a minute **+** :heavy_check_mark: Boot in 1Go RAM
* :heavy_check_mark: Fit on a 4Go USB key ( ~ 1Go / 1Go20 for the system partition)
* :heavy_check_mark: VERY stable => _[Based on **Debian stable**](https://wiki.debian.org/Derivatives/Census/BunsenLabs)_
* :heavy_check_mark: With GUI => _[OpenBox](http://openbox.org/wiki/Main_Page)_
* :heavy_check_mark: Create with debug software available (gparted, ..)
* :heavy_check_mark: Very wide packages availables => _Debian apt-get_
* :heavy_check_mark: Could install the OS if needed -> Persistence doesn't removed the ability to use the key as an install key

## Getting Started

### Distribution

That script only work for [arch based distros](https://wiki.archlinux.org/index.php/Arch-based_distributions) and [debian based distros](https://en.wikipedia.org/wiki/List_of_Linux_distributions#Debian-based)


### Installing

While running of the script, packages (listed in the _Built With_ part) will automatically installed if needed.

- For **Arch based distro** : The Package manager _pacman_ and _[yay](https://aur.archlinux.org/packages/yay/)_ will be used

- For **Debian based distro** : The Package manager _apt-get_ will be used

## Running the script

Simply, open a terminal and execute the script with root privileges

```
cd /path/to/the/script
sudo sh ./bl-livePersistent.sh
```

At the beginning of the execution, you'll be prompt to choose your disk. Simply write the disk name (not the partition)

```
Disk /dev/sda: 298.1 GiB, 320072933376 bytes, 625142448 sectors
Disk /dev/sdb: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
Disk /dev/sdd: 3.8 GiB, 4051697664 bytes, 7913472 sectors
Tell me what disk should be transform please

>> sdc
```

The script will also ask you to choose the architecture you prefer. Simply write the associated number

```
What version of bl-Helium-4 do you want?
1 = amd64
2 = i386
3 = i386, no PAE

>> 1
```

## Built With
* Unix basic commands (fdisk, mkfs, wget, ...)
* [mbr](https://en.wikipedia.org/wiki/Master_boot_record)
* [syslinux](https://en.wikipedia.org/wiki/SYSLINUX)
* [p7zip](https://www.7-zip.org/)

## Authors

* **Arthur Brugiere** - [RoiArthurB](https://github.com/RoiArthurB)

## Special thanks

I want to thank the [BunsenLabs forum](https://forums.bunsenlabs.org/) which helps me a lot to create that script.
<!--- https://forums.bunsenlabs.org/viewtopic.php?pid=6974#p6974 --->

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details
