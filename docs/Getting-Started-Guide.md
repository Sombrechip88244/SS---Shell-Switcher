# Getting Started Guide:
Welcome to the Shell Switcher Getting Started Guide! This document will help you set up and configure Shell Switcher quickly and easily. Follow the steps below to get started.

## Install
### Dependencies
- Brew
- Git
- Bash, zsh or sh

#### Brew:
You can install Brew using this command
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
#### Git:
git should be pre-installed but if not:
##### Debian/Ubuntu
```
sudo apt install git
```
##### Fedora
```
yum install git (up to Fedora 21)
```
```
dnf install git (Fedora 22 and later) 
```
##### Gentoo
```
emerge --ask --verbose dev-vcs/git
```
##### Arch
```
pacman -S git
```
##### Open suse
```
zypper install git
```
##### Mageia
```
urpmi git
```
##### Nix/Nix OS
```
nix-env -i git
```
##### FreeBSD
```
pkg install git
```
##### Solaris 9/10/11 (OpenCSW)
```
pkgutil -i git
```
##### Solaris 11 Express, OpenIndiana
```
pkg install developer/versioning/git
```
##### OpenBSD
```
pkg_add git
```
##### Alpine
```
apk add git
```
##### Red Hat Enterprise Linux, Oracle Linux, CentOS, Scientific Linux, et al.
RHEL and derivatives typically ship older versions of git. You can [download a tarball](https://www.kernel.org/pub/software/scm/git/) and build from source, or use a 3rd-party repository such as the [IUS Community Project](https://ius.io/) to obtain a more recent version of git.
##### Slitaz
```
tazpkg get-install git
```