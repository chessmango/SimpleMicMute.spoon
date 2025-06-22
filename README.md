# SimpleMicMute.spoon
---
A simple [Hammerspoon](https://www.hammerspoon.org/) [Spoon](https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md) to quickly mute/unmute your Mac's microphone

Features:
  - Toggle mic mute/unmute with a hotkey (optional)
  - Menubar icon for quick access (enabled by default)
  - Optional on-screen alerts when muting/unmuting
  - Optional custom sounds for mute/unmute actions
  - Restore previous input volume when unmuting

## SimpleMicMute:configure
Configures the SimpleMicMute Spoon.

Parameters:
 * opts - A table of options:
   * `defaultVolume` (number) - Input volume to restore when unmuting (default: `50`)
   * `enableMenubar` (boolean) - Show menubar icon (default: `true`)
   * `hotkey` (table) - Hotkey to toggle mute/unmute (default: `nil`)
   * `enableAlert` (boolean) - Show alert when toggling (default: `false`)
   * `sounds` (table) - Table with 'mute' and/or 'unmute' sound file paths (default: `nil`)

Example:
  ```lua
  hs.loadSpoon("SimpleMicMute")
  spoon.SimpleMicMute:configure{
    defaultVolume = 50,
    enableMenubar = true,
    hotkey = {{"ctrl", "shift"}, "Q"},
    enableAlert = true,
    sounds = {
      mute = "/System/Library/Sounds/Bottle.aiff",
      unmute = "/System/Library/Sounds/Pop.aiff"
    }
  }
  ```
