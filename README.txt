PHONE CALLS ON THE PC
=====================

Make and take calls from your mobile number using your PC's headset and
microphone. The PC acts like a car hands-free kit: the phone still makes the
call, the sound goes through the PC. Works over Bluetooth.

Made for Manjaro / Arch with KDE Plasma and PipeWire 1.4 or newer.
Tested with an iPhone 13. Samsung / Android phones use the same Bluetooth
hands-free standard and should work the same way, but that is untested.

INSTALL
-------
1. Unpack the folder, open a terminal in it and run:
       ./install.sh
   It needs no sudo. If something is missing it tells you what to install.
2. Restart the audio service (sound cuts out for a second or two):
       systemctl --user restart wireplumber
3. Turn Bluetooth on on the PC (system tray icon).
4. Pair the phone.
   Samsung: open Settings > Connections > Bluetooth and leave that screen
   open. On the PC: System Settings > Bluetooth > Add New Device, pick the
   phone, confirm the code on both. Then on the phone tap the cog next to
   the PC's name and make sure "Calls" is switched on.
   iPhone: the same, from Settings > Bluetooth (there is no Calls switch).
5. Check it worked:
       phone status
   should say "Phone connected".

USING IT
--------
- App menu: open "Phone", type a number or contact name (or click the
  keypad), press Call. The window stays open during the call:
    * Hang up ends the call.
    * The keypad and the number keys send key tones, for "press 1 for
      accounts" phone menus.
    * Keypad clicks and number keys play the classic two-note phone
      tone for that key on the PC.
    * The Call volume slider sets how loud the other person is (0 to 15).
      It is the phone's own call volume, so the phone's volume buttons
      move it too, and the phone remembers it for the next call.
  Closing the window does not end the call.
- Incoming calls: Phone starts hidden when you log in and waits. When the
  phone rings, the window pops up showing who is calling (the contact's
  name if the number is in your contacts file), with Answer and Hang up
  (Hang up turns the call down). A call you didn't pick up stays on the
  window as "Missed call".
  While Phone is running, its icon sits in the system tray (bottom
  right, next to the clock; it may be under the little arrow). Click it
  to show or hide the window. The icon changes when a call is ringing,
  during a call, and when no phone is connected.
  Closing the window only hides it. "Quit" at the bottom stops it until
  you open Phone again or log in again. To stop it starting at login,
  delete ~/.config/autostart/phone-watch.desktop
  Right-click the launcher for "Answer call" and "Hang up".
- Terminal:
       phone                    (opens the window)
       phone dial 0412345678
       phone answer
       phone hangup
       phone tones 1            (press keys during a call)
       phone watch              (start hidden, wait for calls)
       phone status
- Web pages: clicking a phone-number link opens the Phone window with the
  number filled in. Nothing dials until you press Call.
- Contacts: add lines like   mum = 0412 345 678
  to ~/.config/phone-contacts.txt, then type "mum" instead of the number.
- Calls started on the phone itself: on the call screen tap the Bluetooth
  button (Samsung) or the audio button (iPhone) and pick the PC.

IF SOMETHING IS OFF
-------------------
- "No phone connected": the phone isn't connected over Bluetooth.
- No sound in a call: while the call is up, open the volume widget in the
  tray. The phone shows as an extra playback and recording stream; point
  them at your headset and your microphone.
- "Phone connected" never shows on a Samsung: check the "Calls" switch
  from step 4, then turn the phone's Bluetooth off and on again.
- Every call goes to the PC when you don't want it to: on a Samsung, switch
  "Calls" off for the PC (step 4) or tap the Bluetooth button during the
  call. On an iPhone: Settings > Accessibility > Touch > Call Audio Routing.

REMOVE
------
       ./uninstall.sh

WHAT IT INSTALLS (all inside your home folder)
----------------------------------------------
~/.local/bin/phone                                   the dialler script
~/.local/share/applications/phone-dial.desktop       the menu entry
~/.config/wireplumber/wireplumber.conf.d/50-phone-calls.conf
                                                     turns on hands-free mode
~/.config/phone-contacts.txt                         your contacts (optional)
