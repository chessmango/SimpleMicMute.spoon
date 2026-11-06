--- === MicMute ===
---
--- A simple Hammerspoon Spoon to quickly mute/unmute your Mac's microphone
---
--- Features:
---   - Toggle mic mute/unmute with a hotkey (optional)
---   - Menubar icon for quick access (enabled by default)
---   - Optional on-screen alerts when muting/unmuting
---   - Optional custom sounds for mute/unmute actions
---   - Restore previous input volume when unmuting

--- === MicMute:configure ===
--- Method
--- Configures the MicMute Spoon.
---
--- Parameters:
---  * opts - A table of options:
---    * defaultVolume (number) - Input volume to restore when unmuting (default: 50)
---    * enableMenubar (boolean) - Show menubar icon (default: true)
---    * hotkey (table) - Hotkey to toggle mute/unmute (default: nil)
---    * enableAlert (boolean) - Show alert when toggling (default: false)
---    * sounds (table) - Table with 'mute' and/or 'unmute' sound file paths (default: nil)
---    * menuIconTemplate (boolean) - Render the menubar icon as a template so macOS tints it to the menubar colour (default: false)
---
--- Example:
---   hs.loadSpoon("MicMute")
---   spoon.MicMute:configure{
---     defaultVolume = 50,
---     enableMenubar = true,
---     hotkey = {{"ctrl", "shift"}, "Q"},
---     enableAlert = true,
---     sounds = {
---       mute = "/System/Library/Sounds/Bottle.aiff",
---       unmute = "/System/Library/Sounds/Pop.aiff"
---     }
---   }

--- === MicMute:toggleMic ===
--- Method
--- Toggles the microphone between muted and unmuted states.

--- === MicMute:muteMic ===
--- Method
--- Mutes the microphone.

--- === MicMute:unmuteMic ===
--- Method
--- Unmutes the microphone and restores the previous input volume.

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "MicMute"
obj.version = "1.0"
obj.author = "laluowen"
obj.license = "MIT - https://opensource.org/licenses/MIT"
obj.homepage = "https://github.com/laluowen/MicMute.spoon"

-- Defaults
obj.defaultVolume = 50
obj.hotkey = nil
obj.enableMenubar = true
obj.lastInputVolume = obj.defaultVolume
obj.micMenu = nil
obj.enableAlert = false
obj.sounds = nil
obj.micIcons = nil
obj.menuIconTemplate = false

local function renderIcon(emoji, points, strike, template)
  local px = points * 2
  local canvas = hs.canvas.new({ x = 0, y = 0, w = px, h = px })
  canvas[1] = { type = "text", text = emoji, textSize = px * 0.78, frame = { x = 0, y = px * 0.05, w = px, h = px }, textAlignment = "center" }
  if strike then
    canvas[2] = {
      type = "segments",
      coordinates = { { x = px * 0.08, y = px * 0.08 }, { x = px * 0.92, y = px * 0.92 } },
      strokeColor = { red = 0.9, green = 0.1, blue = 0.1, alpha = 1 },
      strokeWidth = px * 0.14,
      action = "stroke",
    }
    if template then
      canvas[2].compositeRule = "destinationOut"
    end
  end
  local image = canvas:imageFromCanvas()
  canvas:delete()
  image:size({ w = points, h = points }, true)
  image:template(template)
  return image
end

function obj:updateMicMenu()
  if not obj.micMenu then return end
  local ok, current = hs.osascript.applescript('input volume of (get volume settings)')
  local muted = ok and tonumber(current) == 0
  obj.micMenu:setTitle(nil)
  obj.micMenu:setIcon(muted and obj.micIcons.muted or obj.micIcons.unmuted, obj.menuIconTemplate)
end

function obj:muteMic()
  local ok, current = hs.osascript.applescript('input volume of (get volume settings)')
  if ok then
    obj.lastInputVolume = tonumber(current)
  end
  hs.osascript.applescript('set volume input volume 0')
  if self.sounds and self.sounds.mute then
    hs.sound.getByFile(self.sounds.mute):play()
  end
  self:updateMicMenu()
  if self.enableAlert then
    hs.alert.show("📵 Mic Muted")
  end
end

function obj:unmuteMic()
  hs.osascript.applescript('set volume input volume ' .. tostring(obj.lastInputVolume))
  if self.sounds and self.sounds.unmute then
    hs.sound.getByFile(self.sounds.unmute):play()
  end
  self:updateMicMenu()
  if self.enableAlert then
    hs.alert.show("🎙 Mic Unmuted")
  end
end

function obj:toggleMic()
  local ok, current = hs.osascript.applescript('input volume of (get volume settings)')
  if ok and tonumber(current) > 0 then
    self:muteMic()
  else
    self:unmuteMic()
  end
end

function obj:bindHotkeys(mapping)
  if mapping and mapping.toggle then
    hs.hotkey.bind(mapping.toggle[1], mapping.toggle[2], function() self:toggleMic() end)
  end
  return self
end

function obj:start()
  self.micIcons = {
    unmuted = renderIcon("🎙", 18, false, self.menuIconTemplate),
    muted = renderIcon("🎙", 18, true, self.menuIconTemplate),
  }

  -- Menubar
  if self.enableMenubar then
    self.micMenu = hs.menubar.new()
    if self.micMenu then
      self.micMenu:setClickCallback(function() self:toggleMic() end)
      self:updateMicMenu()
    end
  end
  return self
end

function obj:init()
  -- For compatibility with SpoonInstall
end

function obj:configure(opts)
  if opts then
    if opts.defaultVolume then self.defaultVolume = opts.defaultVolume end
    if opts.enableMenubar ~= nil then self.enableMenubar = opts.enableMenubar end
    if opts.hotkey then self.hotkey = opts.hotkey end
    if opts.enableAlert ~= nil then self.enableAlert = opts.enableAlert end
    if opts.sounds then self.sounds = opts.sounds end
    if opts.menuIconTemplate ~= nil then self.menuIconTemplate = opts.menuIconTemplate end
  end
  self.lastInputVolume = self.defaultVolume

  self:start()
  if self.hotkey then
    self:bindHotkeys({ toggle = self.hotkey })
  end
  return self
end

return obj
