#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "giving ~/.config/kdeglobals permision to SDDM"

setfacl -m u:sddm:r ~/.config/kdeglobals 

echo "intializing background setting backup"

if ! test -d ~/.config/autostart-scripts; then
    echo "creating autostart scritp directory"
    mkdir ~/.config/autostart-scripts
fi

if test -f ~/.config/autostart-scripts/kyzen-sddm-autostart.sh; then
    echo "removing previous startup script"
    rm ~/.config/autostart-scripts/kyzen-sddm-autostart.sh
fi

if test -d ~/.config/plasma-workspace/shutdown; then

    if test -f ~/.config/plasma-workspace/shutdown/kyzen-sddm-autostart.sh; then
        echo "removing previous logout script "
        rm ~/.config/plasma-workspace/shutdown/kyzen-sddm-autostart.sh
    fi

    echo "enabling script on logout"
    ln -sf "$DIR"/kyzen-sddm-autostart.sh ~/.config/plasma-workspace/shutdown/kyzen-sddm-autostart.sh
fi

echo "enabling script autostart"
ln -sf "$DIR"/kyzen-sddm-autostart.sh ~/.config/autostart-scripts/kyzen-sddm-autostart.sh && echo "Done! script will start automatically upon next login"

echo "Running script for current session"
"$DIR"/kyzen-sddm-autostart.sh

echo "Sucessfully enabled!"