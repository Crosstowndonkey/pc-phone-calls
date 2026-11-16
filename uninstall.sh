#!/bin/bash
# Removes everything install.sh added (your contacts file is kept).
rm -f ~/.local/bin/phone
rm -f ~/.local/share/applications/phone-dial.desktop
rm -f ~/.config/autostart/phone-watch.desktop
rm -f ~/.config/phone-settings.json
if [ -f ~/.config/pipewire/filter-chain.conf.d/phone-clean-mic.conf ]; then
    rm -f ~/.config/pipewire/filter-chain.conf.d/phone-clean-mic.conf
    # Stop the filter service if the clean mic was the only thing using it.
    if [ -z "$(ls -A ~/.config/pipewire/filter-chain.conf.d 2>/dev/null)" ]; then
        systemctl --user disable --now filter-chain.service >/dev/null 2>&1 || true
    else
        systemctl --user restart filter-chain.service || true
    fi
fi
rm -f ~/.config/wireplumber/wireplumber.conf.d/50-phone-calls.conf
update-desktop-database ~/.local/share/applications 2>/dev/null || true
echo "Removed. Restart the audio service to finish:  systemctl --user restart wireplumber"
echo "Your contacts are still in ~/.config/phone-contacts.txt"
