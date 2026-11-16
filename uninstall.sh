#!/bin/bash
# Removes everything install.sh added (your contacts file is kept).
rm -f ~/.local/bin/phone
rm -f ~/.local/share/applications/phone-dial.desktop
rm -f ~/.config/autostart/phone-watch.desktop
rm -f ~/.config/wireplumber/wireplumber.conf.d/50-phone-calls.conf
update-desktop-database ~/.local/share/applications 2>/dev/null || true
echo "Removed. Restart the audio service to finish:  systemctl --user restart wireplumber"
echo "Your contacts are still in ~/.config/phone-contacts.txt"
