#! /bin/sh

# Check if script is being run as admin
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Open the user account settings
unity-control-center user-accounts

# Check if the lightdm config file exists
if [ ! -f /etc/lightdm/lightdm.conf ]; then
    touch /etc/lightdm/lightdm.conf
fi

if [[ -n /etc/lightdm/lightdm.conf ]]; then
    echo allow-guest=false > /etc/lightdm/lightdm.conf
fi

# Enable the firewall
ufw enable

# Password management
apt install libpam-cracklib
sudo gedit /etc/login.defs
