#! /bin/sh

# Check if script is being run as admin
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo" 
   exit 1
fi

# Open the user account settings
unity-control-center user-accounts

# Manage sources
cat src/sources.list > /etc/apt/sources.list

# Update Software
apt -y update
apt -y upgrade

# Lightdm
cat src/lightdm.conf > /etc/lightdm/lightdm.conf

# Enable the firewall
ufw enable

# Password management
apt install libpam-cracklib
sudo sed -i '/^PASS_MAX_DAYS/ c\PASS_MAX_DAYS   15' /etc/login.defs
sudo sed -i '/^PASS_MIN_DAYS/ c\PASS_MIN_DAYS   6'  /etc/login.defs
sudo sed -i '/^PASS_WARN_AGE/ c\PASS_WARN_AGE   7' /etc/login.defs
sed -i '1 s/^/password requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\n/' /etc/pam.d/common-password

# Media Files
for suffix in mp3 wav wma aac mp4 mov avi gif jpg png bmp img exe msi bat
do
  sudo find /home -name *.$suffix -type f -delete
done

# Disable su
passwd -l root

# Delete Software
apt -y purge hydra*
apt -y purge john*
apt -y purge nikto*
apt -y purge netcat*
apt -y purge zenmap*
apt -y purge nmap*
apt -y purge medusa*
