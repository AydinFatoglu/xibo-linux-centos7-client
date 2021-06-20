#!/bin/bash
clear
cat << "EOF"

 /$$   /$$ /$$$$$$ /$$$$$$$   /$$$$$$        /$$$$$$$  /$$                                                /$$$$$$   /$$$$$$ 
| $$  / $$|_  $$_/| $$__  $$ /$$__  $$      | $$__  $$| $$                                               /$$__  $$ /$$__  $$
|  $$/ $$/  | $$  | $$  \ $$| $$  \ $$      | $$  \ $$| $$  /$$$$$$  /$$   /$$  /$$$$$$   /$$$$$$       | $$  \ $$| $$  \__/
 \  $$$$/   | $$  | $$$$$$$ | $$  | $$      | $$$$$$$/| $$ |____  $$| $$  | $$ /$$__  $$ /$$__  $$      | $$  | $$|  $$$$$$ 
  >$$  $$   | $$  | $$__  $$| $$  | $$      | $$____/ | $$  /$$$$$$$| $$  | $$| $$$$$$$$| $$  \__/      | $$  | $$ \____  $$
 /$$/\  $$  | $$  | $$  \ $$| $$  | $$      | $$      | $$ /$$__  $$| $$  | $$| $$_____/| $$            | $$  | $$ /$$  \ $$
| $$  \ $$ /$$$$$$| $$$$$$$/|  $$$$$$/      | $$      | $$|  $$$$$$$|  $$$$$$$|  $$$$$$$| $$            |  $$$$$$/|  $$$$$$/
|__/  |__/|______/|_______/  \______/       |__/      |__/ \_______/ \____  $$ \_______/|__/             \______/  \______/ 
                                                                     /$$  | $$                                              
                                                                    |  $$$$$$/                                              
                                                                     \______/                                               

EOF
echo "This is the one and only fully automated install bash script for Centos 7 x64 platform!"
echo ""
echo ""
xibouser="USER INPUT"
read -p "YOU MUST ENTER A NEW USERNAME FOR THIS SIGNAGE DISPLAY: " xibouser
id -u $xibouser &>/dev/null || useradd $xibouser
echo "YOU MUST ENTER A NEW PASSWORD (twice) FOR USER [$xibouser]"
passwd $xibouser

host="USER INPUT"
read -p "YOU MUST ENTER A NEW HOSTNAME: " host
hostnamectl set-hostname $host.local

echo "Createing User : [$xibouser]"
echo "Setting Hostname as : [$host.local]"

echo "Downloading and Installing GUI [X Window System / xorg / GDM / Openbox]"
echo "Downloading and Installing GUI [X Window System]"
yum groupinstall "X Window System" -y > /dev/null 2>&1
echo "Downloading and Installing GUI [xorg]"
yum install xorg* -y > /dev/null 2>&1
echo "Downloading and Installing GUI [GDM]"
yum install epel-release -y > /dev/null 2>&1
yum install gdm -y > /dev/null 2>&1
echo "Downloading and Installing GUI [Openbox]"
yum install openbox -y > /dev/null 2>&1
yum install nano -y > /dev/null 2>&1

echo "Downloading and Installing Snap For Centos 7"

sudo yum install snapd -y > /dev/null 2>&1
sudo systemctl enable --now snapd.socket > /dev/null 2>&1
sudo ln -s /var/lib/snapd/snap /snap > /dev/null 2>&1

echo "Downloading and Installing Latest Stable Version Xibo Player From Snap"

sudo snap install xibo-player > /dev/null 2>&1
sleep 5
sudo snap install xibo-player > /dev/null 2>&1

echo "GUI is now enabled"

systemctl set-default graphical.target > /dev/null 2>&1

echo "Auto Login is configured for user $xibouser"

cd /etc/gdm/
sed -i "4i AutomaticLogin=$xibouser" custom.conf
sed -i "5i AutomaticLoginEnable=True" custom.conf

echo "Xibo Player Auto Start at logon configured"

mkdir /home/$xibouser/.config/
cd /home/$xibouser/.config/
mkdir openbox
cd openbox
echo "xibo-player" > autostart.sh
echo "Never Sleep configured"
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target > /dev/null 2>&1

# TO DO PART
#echo "Xibo Player Server configuration redy!"
#mkdir -p /home/$xibouser/snap/xibo-player/common
#cd /home/$xibouser/snap/xibo-player/common
#echo -e "<?xml version="1.0" encoding="utf-8"?><cmsAddress>http://signage.thyteknik.com</cmsAddress><key>HztF8r</key><localLibrary>&quot;/home/$xibouser/snap/xibo-player/common/resources&quot;</localLibrary><username/><password/><domain/><displayId></displayId>" > cmsSettings.xml

echo "ALL DONE!!!! - REBOOTING NOW..."
sleep 5
sudo reboot
