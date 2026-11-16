# Phone calls on the PC

Make and take calls from your mobile number using your PC's headset and
microphone. The PC acts like a car hands-free kit: the phone still makes the
call, the sound goes through the PC. Works over Bluetooth.

Made for Manjaro / Arch with KDE Plasma and PipeWire 1.4 or newer.
Tested with an iPhone 13. Samsung / Android phones use the same Bluetooth
hands-free standard and should work the same way, but that is untested.

## What it does

- A small **Phone** window: keypad, Call, Answer and Hang up.
- **Stays open during the call**, with a timer and who you're talking to.
- **Key tones** for "press 1 for accounts" phone menus.
- **Incoming calls** pop the window up, showing the caller's number, or their
  name if they're in your contacts file.
- **Hold, swap and conference calls:** put a call on hold, add a second call,
  switch between two, or join them together.
- **Call volume** slider.
- **Noise removal for your voice** (optional): fans, keyboard and background
  noise are cleaned off your microphone before the other person hears it.
- **System tray icon** that shows it's running and changes with the call state.
- Clicking a **phone-number link** on a web page fills the number in.
- Everything is also available as **terminal commands**.

## Install

1. Download or clone this folder, open a terminal in it and run:

   ```
   ./install.sh
   ```

   It needs no sudo. If something is missing it tells you what to install.

2. Restart the audio service (sound cuts out for a second or two):

   ```
   systemctl --user restart wireplumber
   ```

3. Turn Bluetooth on on the PC (system tray icon).

4. Pair the phone.

   - **Samsung:** open Settings > Connections > Bluetooth and leave that
     screen open. On the PC: System Settings > Bluetooth > Add New Device,
     pick the phone, confirm the code on both. Then on the phone tap the cog
     next to the PC's name and make sure "Calls" is switched on.
   - **iPhone:** the same, from Settings > Bluetooth (there is no Calls
     switch).

5. Check it worked:

   ```
   phone status
   ```

   It should say "Phone connected".

## Using it

### Making a call

Open **Phone** from the app menu, type a number or contact name (or click the
keypad) and press **Call**. The window stays open during the call:

- **Hang up** ends the call.
- The keypad and the number keys send key tones, for "press 1 for accounts"
  phone menus.
- Keypad clicks and number keys play the classic two-note phone tone for that
  key on the PC.
- The **Call volume** slider sets how loud the other person is (0 to 15). It
  is the phone's own call volume, so the phone's volume buttons move it too,
  and the phone remembers it for the next call.

Closing the window does not end the call.

### Hold, second calls and conference calls

The row of small buttons under Call and Hang up:

| Button | What it does |
| --- | --- |
| **Hold** / **Resume** | Puts the call on hold, or takes it off hold |
| **Add call** | Asks for a second number and rings it; the first call waits on hold |
| **Swap** | With one call active and one on hold, switches which one you're talking to |
| **Merge** | Joins the active call and the held call into one conference call |

- If someone rings while you're on a call, **Answer** puts your current call
  on hold and picks up the new one. **Hang up** turns the new one down and
  leaves you on your call.
- With one call active and one on hold, **Hang up** ends only the one you're
  talking to. Press **Resume** to go back to the other.
- In a conference, **Hang up** ends it for everyone.

Whether hold and conference work depends on your phone and your mobile
plan: the PC only asks the phone to do it.

### Clean up my voice (noise removal)

Optional. It adds a virtual microphone called **Phone clean mic**: your normal
microphone with background noise (fans, keyboard, traffic) and low rumble
removed. With **Clean up my voice** ticked in the Phone window, that is what
the other person hears. Untick it during a call to compare; the choice is
remembered.

To set it up:

```
sudo pacman -S noise-suppression-for-voice
./install.sh
```

- The noise removal is [RNNoise](https://github.com/werman/noise-suppression-for-voice),
  the same kind OBS offers.
- It uses your default microphone. Don't make "Phone clean mic" itself the
  default microphone.
- Other programs (Discord, OBS, a browser) can pick "Phone clean mic" as
  their microphone too.
- It only cleans; it doesn't make you louder. A phone line also carries less
  detail than a headset, so expect "clear", not "studio".
- To tune it, edit
  `~/.config/pipewire/filter-chain.conf.d/phone-clean-mic.conf` (the comments
  explain the numbers), then run `systemctl --user restart filter-chain`.
  If soft words get cut off, lower "VAD Threshold".
- Terminal: `phone clean on` / `phone clean off`.

### Incoming calls

Phone starts hidden when you log in and waits. When the phone rings, the
window pops up showing who is calling (the contact's name if the number is in
your contacts file), with **Answer** and **Hang up** (Hang up turns the call
down). A call you didn't pick up stays on the window as "Missed call".

### The tray icon

While Phone is running, its icon sits in the system tray (bottom right, next
to the clock; it may be under the little arrow). Click it to show or hide the
window. The icon changes when a call is ringing, during a call, and when no
phone is connected.

Closing the window only hides it. **Quit** at the bottom stops it until you
open Phone again or log in again. To stop it starting at login, delete
`~/.config/autostart/phone-watch.desktop`.

Right-clicking the app menu launcher also offers "Answer call" and "Hang up".

### Terminal

| Command | What it does |
| --- | --- |
| `phone` | Opens the window |
| `phone dial 0412345678` | Dials straight away (a contact name works too) |
| `phone answer` | Answers the ringing call |
| `phone hangup` | Ends all calls |
| `phone hold` | Puts the call on hold, or takes it off hold |
| `phone swap` | Switches between the active call and the held one |
| `phone merge` | Joins both calls into a conference call |
| `phone tones 1` | Presses keys during a call |
| `phone clean on` / `off` | Turns noise removal for your voice on or off |
| `phone watch` | Starts hidden and waits for calls |
| `phone status` | Shows the connected phone and any calls |

### Other things

- **Web pages:** clicking a phone-number link opens the Phone window with the
  number filled in. Nothing dials until you press Call.
- **Contacts:** add lines like `mum = 0412 345 678` to
  `~/.config/phone-contacts.txt`, then type "mum" instead of the number.
- **Calls started on the phone itself:** on the call screen tap the Bluetooth
  button (Samsung) or the audio button (iPhone) and pick the PC.

## If something is off

- **"No phone connected":** the phone isn't connected over Bluetooth.
- **No sound in a call:** while the call is up, open the volume widget in the
  tray. The phone shows as an extra playback and recording stream; point them
  at your headset and your microphone.
- **"Clean up my voice (not set up)":** the RNNoise plugin isn't installed or
  the filter isn't running. See "Clean up my voice" above; check with
  `systemctl --user status filter-chain`.
- **The other person is too quiet:** move the Call volume slider up, or press
  volume up on the phone during the call.
- **"Phone connected" never shows on a Samsung:** check the "Calls" switch
  from step 4, then turn the phone's Bluetooth off and on again.
- **Every call goes to the PC when you don't want it to:** on a Samsung,
  switch "Calls" off for the PC (step 4) or tap the Bluetooth button during
  the call. On an iPhone: Settings > Accessibility > Touch > Call Audio
  Routing.

## Remove

```
./uninstall.sh
```

Your contacts file is kept.

## What it installs

Everything goes inside your home folder:

| File | What it is |
| --- | --- |
| `~/.local/bin/phone` | The Phone program |
| `~/.local/share/applications/phone-dial.desktop` | The app menu entry |
| `~/.config/autostart/phone-watch.desktop` | Starts Phone hidden at login |
| `~/.config/wireplumber/wireplumber.conf.d/50-phone-calls.conf` | Turns on hands-free mode |
| `~/.config/phone-contacts.txt` | Your contacts (optional) |
| `~/.config/phone-settings.json` | The window's tick boxes (made when you first change one) |
| `~/.config/pipewire/filter-chain.conf.d/phone-clean-mic.conf` | The noise-removing microphone (only with the RNNoise plugin) |

## Licence

MIT - see [LICENSE](LICENSE).
