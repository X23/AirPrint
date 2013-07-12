#!/bin/bash
apt-get update
echo "y" | apt-get upgrade
echo "y" | apt-get install cups avahi-daemon python-cups cups-pdf hpijs-ppds
usermod -a -G lpadmin $1
cupsctl --remote-admin
ifconfig  | grep 'inet addr:'
echo " head over to the web interface at either of the ip address on port 631 (http://ipaddress:631) above to set up your printer on the web interface"
read -p "Once completed press any key to continue... " -n1 -s
mkdir airprint
wget https://dl.dropbox.com/s/clb5hwjy98jvcrc/airprint-renew.sh
chmod +x airprint-renew.sh
wget https://raw.github.com/tjfontaine/airprint-generate/master/airprint-generate.py
sh -c "echo 'image/urf urf string(0,UNIRAST<00>)' > /usr/share/cups/mime/airprint.types"
sh -c "echo 'image/urf application/pdf 100 pdftoraster' > /usr/share/cups/mime/airprint.convs"
service cups restart
python airprint-generate.py
cp *.service /etc/avahi/services
service avahi-daemon restart
echo "Great news! the process has now finished and airprint should now be available to you"
echo "If you add or remove printers you will need to run the airprint-renew script"
