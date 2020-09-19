#! /bin/sh

echo "removing ~/.config/kdeglobals permision to SDDM"

setfacl -x u:sddm:r ~/.config/kdeglobals

if test -f ~/.config/autostart-scripts/kyzen-sddm-autostart.sh; then
    echo "disabling script autostart"
    rm ~/.config/autostart-scripts/kyzen-sddm-autostart.sh
fi

if test -f ~/.config/plasma-workspace/shutdown/kyzen-sddm-autostart.sh; then
    echo "disabling script logout "
    rm ~/.config/plasma-workspace/shutdown/kyzen-sddm-autostart.sh
fi

if test -f ~/.config/kyzen-usr-bg-config; then
    echo "Removing ~/.config/kyzen-usr-bg-config"
    rm ~/.config/kyzen-usr-bg-config
fi

if pgrep -x "kyzen-sddm-autostart.sh" > /dev/null; then
    echo "killing existing script instances"
    sudo pkill kyzen-sddm-autostart.sh
fi

echo "Sucessfully disabled!"