#!/usr/bin/env bash

# Are you root?
if [[ $EUID -ne 0 ]]; then
   echo "[ERROR] Please run this script as root! Exiting." 1>&2
   exit -1
fi

# Determine if we are Ubuntu 14. For other operating system, do not 
# continue.  For older (or newer) versions of Ubuntu, display 
# warning but try anyways.
ver=$(lsb_release -d|awk -F"\t" '{print $2}')

# Ubuntu?
if [[ "$ver" == "Ubuntu"* ]]; then
    
    # Is it the supported one?
    if [[ "$ver" == "Ubuntu 14."* ]]; then
        echo "[+] Supported Ubuntu detected."
    else
        echo "[WARNING] It looks like you're using Ubuntu, but not the offically supported version."
        echo -n "Do you want to try the setup anyways? [y/N] "

        read response

        case $response in
            [yY][eE][sS]|[yY])
                ;;
            *)
                echo "Exiting."
                exit 0
                ;;
        esac
    fi

# Something else. Bail.
else
    echo "[ERROR] You're not using Ubuntu. You'll need to install dependencies manually. Sorry!"
    exit -2
fi

# Make sure everything is up to date.
echo "[+] Updating repos..."
apt-get -qqy update || exit -2

# General stuff
echo "[+] Installing software..."
apt-get -qqy install pptpd ppp python|| exit -3

echo "[+] Dependency installation complete. Have fun!"
