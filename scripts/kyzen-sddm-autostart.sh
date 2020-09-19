#! /bin/sh

echo "Copying current desktop setting to kyzen-usr-bg-config" 
cp ~/.config/plasma-org.kde.plasma.desktop-appletsrc ~/.config/kyzen-usr-bg-config
echo "giving ~/.config/kyzen-usr-bg-config permision to SDDM"
setfacl -m u:sddm:r ~/.config/kyzen-usr-bg-config