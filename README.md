# MicMute.spoon
---
A simple [Hammerspoon](https://www.hammerspoon.org/) [Spoon](https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md) to quickly mute/unmute your Mac's microphone

Features:
  - Toggle mic mute/unmute with a hotkey (optional)
  - Menubar icon for quick access (enabled by default): 🎙 when unmuted, 🎙 with a red stripe when muted
  - Optional on-screen alerts when muting/unmuting
  - Optional custom sounds for mute/unmute actions
  - Restore previous input volume when unmuting

## MicMute:configure
Configures the MicMute Spoon.

Parameters:
 * opts - A table of options:
   * `defaultVolume` (number) - Input volume to restore when unmuting (default: `50`)
   * `enableMenubar` (boolean) - Show menubar icon (default: `true`)
   * `hotkey` (table) - Hotkey to toggle mute/unmute (default: `nil`)
   * `enableAlert` (boolean) - Show alert when toggling (default: `false`)
   * `sounds` (table) - Table with 'mute' and/or 'unmute' sound file paths (default: `nil`)
   * `menuIconTemplate` (boolean) - Render the menubar icon as a template so macOS tints it to the menubar colour. The muted stripe becomes a gap in the silhouette (default: `false`)

Example:
  ```lua
  hs.loadSpoon("MicMute")
  spoon.MicMute:configure{
    defaultVolume = 50,
    enableMenubar = true,
    hotkey = {{"ctrl", "shift"}, "Q"},
    enableAlert = true,
    menuIconTemplate = false,
    sounds = {
      mute = "/System/Library/Sounds/Bottle.aiff",
      unmute = "/System/Library/Sounds/Pop.aiff"
    }
  }
  ```

Icons are drawn at runtime from emoji, so there are no image files to ship.
