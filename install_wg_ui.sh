#!/bin/sh

echo 'Loesche alte Wireguard UI Instanz'
rm /opt/wireguard-ui/wireguard-ui

echo 'Stoppe Wireguard UI Service'
systemctl stop wireguard-ui

echo 'Lade neue Wireguard UI Version von github'
mkdir /opt/wireguard-ui
    arch=$(uname -m)
    if [[ $arch == x86_64* ]]; then
        wget https://github.com/ngoduykhanh/wireguard-ui/releases/download/v0.4.0/wireguard-ui-v0.4.0-linux-amd64.tar.gz -O /opt/wireguard-ui/install.tar.gz
        elif [[ $arch == i*86 ]]; then
        wget https://github.com/ngoduykhanh/wireguard-ui/releases/download/v0.4.0/wireguard-ui-v0.4.0-linux-386.tar.gz -O /opt/wireguard-ui/install.tar.gz
        elif  [[ $arch == arm* ]]; then
        wget https://github.com/ngoduykhanh/wireguard-ui/releases/download/v0.4.0/wireguard-ui-v0.4.0-linux-arm.tar.gz -O /opt/wireguard-ui/install.tar.gz
    fi
echo 'Neue Wireguard UI Version von github geladen'

echo 'Lade diverse helper scritps'
wget https://raw.githubusercontent.com/MajorTomDE/wireguard/main/misc/wgui.path -O /etc/systemd/system/wgui.path
wget https://raw.githubusercontent.com/MajorTomDE/wireguard/main/misc/wgui.service -O /etc/systemd/system/wgui.service
wget https://raw.githubusercontent.com/MajorTomDE/wireguard/main/misc/wireguard-ui.service -O /etc/systemd/system/wireguard-ui.service
echo 'Helper Scripts geladen'

echo 'Entpacke Wireguard'
cd /opt/wireguard-ui
tar -xf install.tar.gz
rm install.tar.gz

echo 'Initialisiere Daemon'
systemctl daemon-reload
echo 'Starte wgui service'
systemctl enable wgui.{path,service}
systemctl start wgui.{path,service}
echo 'Starte wireguard-ui service'
systemctl enable wireguard-ui
systemctl start wireguard-ui

if systemctl is-active --quiet wireguard-ui ; then
   echo 'Installation OK'
else
   echo 'Fehler'
fi
