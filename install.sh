#!/bin/bash
# Installs "phone calls on the PC" for the current user. No sudo needed.
# Safe to run again. To remove everything, run ./uninstall.sh
set -e
cd "$(dirname "$0")"

echo "Checking what is needed..."
missing=""
python3 -c "import dbus" 2>/dev/null || missing="$missing python-dbus"
python3 -c "import tkinter" 2>/dev/null || missing="$missing tk"
python3 -c "import gi" 2>/dev/null || missing="$missing python-gobject"
command -v notify-send >/dev/null || missing="$missing libnotify"
command -v wireplumber >/dev/null || missing="$missing wireplumber pipewire-audio"
if [ -n "$missing" ]; then
    echo "Please install these first, then run this again:"
    echo "    sudo pacman -S$missing"
    exit 1
fi
version=$(pipewire --version | grep -o '[0-9]\+\.[0-9]\+' | head -1)
if [ "$(printf '%s\n' 1.4 "$version" | sort -V | head -1)" != "1.4" ]; then
    echo "PipeWire $version is too old (1.4 or newer is needed). Update the system first."
    exit 1
fi

mkdir -p ~/.local/bin ~/.local/share/applications ~/.config/wireplumber/wireplumber.conf.d
cp -f phone ~/.local/bin/phone
chmod +x ~/.local/bin/phone
cp -f 50-phone-calls.conf ~/.config/wireplumber/wireplumber.conf.d/50-phone-calls.conf

cat > ~/.local/share/applications/phone-dial.desktop <<DESKTOP
[Desktop Entry]
Type=Application
Name=Phone
Comment=Call a number through the Bluetooth-connected phone
Exec=$HOME/.local/bin/phone ask %u
Icon=call-start
Categories=Network;Telephony;
MimeType=x-scheme-handler/tel;
Actions=Answer;Hangup;

[Desktop Action Answer]
Name=Answer call
Icon=call-start
Exec=$HOME/.local/bin/phone answer

[Desktop Action Hangup]
Name=Hang up
Icon=call-stop
Exec=$HOME/.local/bin/phone hangup
DESKTOP

# Start hidden at login, so the window pops up when the phone rings.
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/phone-watch.desktop <<DESKTOP
[Desktop Entry]
Type=Application
Name=Phone (wait for calls)
Comment=Pops up the Phone window when the Bluetooth-connected phone rings
Exec=$HOME/.local/bin/phone watch
Icon=call-start
DESKTOP

if [ ! -f ~/.config/phone-contacts.txt ]; then
    printf '# One contact per line:  name = number\n# Example:\n# mum = 0412 345 678\n' > ~/.config/phone-contacts.txt
fi

update-desktop-database ~/.local/share/applications 2>/dev/null || true
xdg-mime default phone-dial.desktop x-scheme-handler/tel 2>/dev/null || true

echo
echo "Installed. Two things left:"
echo "  1. Restart the audio service (sound cuts out for a second or two):"
echo "         systemctl --user restart wireplumber"
echo "  2. Pair your phone over Bluetooth - see README.txt"
