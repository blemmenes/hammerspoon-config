-- Variables and setup
macbook_monitor = "Built-in Retina Display"
main_monitor = "Acer XR382CQK"
hs.logger.defaultLogLevel="info"
meh       = {"shift","alt","ctrl"}
hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
hs.application.enableSpotlightForNameSearches(true)
Install=spoon.SpoonInstall
hs.hotkey.bindSpec({ hyper, "y" }, hs.toggleConsole)
hs.loadSpoon('Headspace')
hs.loadSpoon('Hyper')


-- Secrets for toggl/headspace integration
local secrets = require('secrets')
      secrets.start('.secrets.json')

Config = {}
Config.applications = require('configApplications')

-- Helper functions
function appID(app)
  return hs.application.infoForBundlePath(app)['CFBundleIdentifier']
end

function usbAttachedDevicesLookUp(name)
  return hs.fnutils.find(hs.usb.attachedDevices(), function(device)
    return device.productName == name
  end)
end

function stopApp(name)
  app = hs.application.get(name)
  if app and app:isRunning() then
    app:kill()
  end
end

function forceKillProcess(name)
  hs.execute("pkill " .. name)
end

function startApp(name)
  hs.application.open(name)
end

-- function to dump a table for debuging
function dump(o)
  if type(o) == 'table' then
     local s = '{ '
     for k,v in pairs(o) do
        if type(k) ~= 'number' then k = '"'..k..'"' end
        s = s .. '['..k..'] = ' .. dump(v) .. ','
     end
     return s .. '} '
  else
     return tostring(o)
  end
end

ZendeskApp = appID('/Users/blemmenes/Applications/WebCatalog Apps/Zendesk.app')
obsidian = appID('/Applications/Obsidian.app')
RingCentral = appID('/Applications/RingCentral.app')
Freedom = appID('/Applications/Freedom.app')
VSCode = appID('/Applications/Visual Studio Code.app')
braveBrowser = appID('/Applications/Brave Browser.app')


-- Hyper.spoon
App   = hs.application
Hyper = spoon.Hyper

Hyper:bindHotKeys({hyperKey = {{}, 'F19'}})

hs.fnutils.each(Config.applications, function(appConfig)
  if appConfig.hyperKey then
    Hyper:bind({}, appConfig.hyperKey, function() hs.application.launchOrFocusByBundleID(appConfig.bundleID) end)
  end
  if appConfig.localBindings then
    hs.fnutils.each(appConfig.localBindings, function(key)
      Hyper:bindPassThrough(key, appConfig.bundleID)
    end)
  end
end)

-- configure spaces for headspace
Config.spaces = {}
Config.funcs = {}
Config.projects = hs.settings.get("secrets").toggl.projects

require('spaces/support')
require('spaces/support_call')
require('spaces/research')
require('spaces/garden')
require('spaces/deep')
require('spaces/meeting')
require('spaces/play')
require('spaces/shutdown')

-- Headspace.spoon
spoon.Headspace:start()
               :loadConfig(Config)
               :setTogglKey(hs.settings.get('secrets').toggl.key)

Hyper:bind({}, 'l', nil, spoon.Headspace.choose)


-- Autmatic reload when hammerspoon config changes
function reloadConfig(files)
  doReload = false
  for _,file in pairs(files) do
      if file:sub(-4) == ".lua" then
          doReload = true
      end
  end
  if doReload then
      hs.reload()
  end
end
Install:andUse("FadeLogo",
               {
                 config = {
                   default_run = 1.0,
                 },
                 start = true
               }
)




-- Automatic eject on sleep
Install:andUse("EjectMenu", {
  config = {
    eject_on_lid_close = false,
    eject_on_sleep = true,
    show_in_menubar = true,
    notify = true,
  },
  hotkeys = { ejectAll = { hyper, "=" } },
  start = true,
})

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- Browser stuff
chromeBrowser = appID('/Applications/Google Chrome.app')
workBraveProfile = "/Users/blemmenes/Library/Application Support/BraveSoftware/Brave-Browser/Profile 1"
personalBraveProfile = "/Users/blemmenes/Library/Application Support/BraveSoftware/Brave-Browser/Default"
workApp = appID('/Users/blemmenes/Applications/WebCatalog Apps/Work.app')


Install:andUse("URLDispatcher",
               {
                 config = {
                   url_patterns = {
                    --  { "https?://jira%.work%.com",      JiraApp },
                     { "https://softiron.zendesk.com",      ZendeskApp },
                    --  { "https?://app.*%.opsgenie%.com", OpsGenieApp },
                     { "msteams:",                      "com.microsoft.teams" },
                     { "https?://.*%.softiron%.com",        workApp }
                   },
                   url_redir_decoders = {
                     -- Send MS Teams URLs directly to the app
                     { "MS Teams URLs",
                       "(https://teams.microsoft.com.*)", "msteams:%1", true },
                     -- Preview incorrectly encodes the anchor
                     -- character in URLs as %23, we fix it
                     { "Fix broken Preview anchor URLs",
                       "%%23", "#", false, "Preview" },
                   },
                   default_handler = braveBrowser
                 },
                 start = true,
                 -- Enable debug logging if you get unexpected behavior
                 -- loglevel = 'debug'
               }
)


Install:andUse("BingDaily",
               {
                 config = {
                    runAt = '"07:00"',
                    uhd_resolution = true }
                 })


-- Caffene toggle in menubar
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
    if state then
        caffeine:setTitle("AWAKE")
    else
        caffeine:setTitle("SLEEPY")
    end
end

function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end


-- SmartThings light automation
local scenes = hs.settings.get("secrets").smartthings.scenes
local headers = {["Authorization"] = hs.settings.get('secrets').smartthings.auth}

sleepWatcher = hs.caffeinate.watcher.new(function (eventType)
  if (usbAttachedDevicesLookUp("ErgoDox EZ")) then -- Check if docked
    if (eventType == hs.caffeinate.watcher.screensDidWake) then
      if hs.timer.localTime() < hs.timer.seconds("21:00") then -- if before 9PM turn on all lights
        hs.http.asyncPost("https://api.smartthings.com/v1/scenes/" .. scenes.office_on .. "/execute",
          nil,
          headers,
          function(http_number, body, headers)
          end)
      else -- if after 9PM turn on just desk lights
        hs.http.asyncPost("https://api.smartthings.com/v1/scenes/" .. scenes.office_late .. "/execute",
        nil,
        headers,
        function(http_number, body, headers)
        end)
      end
    elseif (eventType == hs.caffeinate.watcher.screensDidSleep) then
      hs.http.asyncPost("https://api.smartthings.com/v1/scenes/" .. scenes.office_off .. "/execute",
        nil,
        headers,
        function(http_number, body, headers)
        end)
    end
  end
end)
sleepWatcher:start()


-- Wifi automation
Install:andUse("WiFiTransitions",
               {
                 config = {
                   actions = {
                     -- { -- Test action just to see the SSID transitions
                     --    fn = function(_, _, prev_ssid, new_ssid)
                     --       hs.notify.show("SSID change",
                     --          string.format("From '%s' to '%s'",
                     --          prev_ssid, new_ssid), "")
                     --    end
                     -- },
                     { -- Stop data heavy apps when joining hotspot network
                       to = "Pixel_2217",
                       fn = {
                             hs.fnutils.partial(stopApp, "IPFS Desktop"),
                       }
                     },
                     { -- Start data heavy apps when leaving hotspot network
                       from = "Pixel_2217",
                       fn = {
                             hs.fnutils.partial(startApp, "IPFS Desktop"),
                       }
                     },
                   }
                 },
                 start = true,
               }
)


-- Bring all finder windows to the foreground
function finderWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end
finderWatcher = hs.application.watcher.new(finderWatcher)
finderWatcher:start()

-- keyboard shortcuts
Install:andUse("KSheet", {
  hotkeys = {
    toggle = { hyper, "k" }
  }
})


-- Seems to be not looking up correctly
Install:andUse("BrewInfo",
               {
                 config = {
                   brew_info_style = {
                    --  textFont = "Inconsolata",
                     textSize = 14,
                     radius = 10 }
                 },
                 hotkeys = {
                   -- brew info
                   show_brew_info = {hyper, "b"},
                   open_brew_url = {meh, "b"},
                 },
                 loglevel = 'debug'
               }
)



-- AutoLayout.spoon testing
hs.loadSpoon('AutoLayout')
local autolayout = spoon.AutoLayout

local layouts = {}
-- build a table of layouts for AutoLayout from Config
hs.fnutils.map(Config.applications, function(app_config)
  local bundleID = app_config['bundleID']
  if app_config.layouts then
    hs.fnutils.map(app_config.layouts, function(rule)
      local title_pattern, screen, layout = rule[1], rule[2], rule[3]
      table.insert(layouts,
        {
          hs.application.get(bundleID),                  -- application name
          title_pattern,                                 -- window title
          -- function() autolayout.whichScreen(screen) end, -- screen
          autolayout.whichScreen(screen), -- screen
          layout,                                        -- layout
          nil,
          nil
        }
      )
    end)
  end
end)

autolayout
:setDefault(layouts)
:start()

Hyper:bind({}, 'return', nil, autolayout.autoLayout)



-- TESTING
-- watchables                  = require('watchables')
-- -- start/stop modules
-- local modules               = { watchables }

-- hs.fnutils.each(modules, function(module)
--   if module then module.start() end
-- end)

-- -- stop modules on shutdown
-- hs.shutdownCallback = function()
--   hs.fnutils.each(modules, function(module)
--     if module then module.stop() end
--   end)
-- end





-- PaperWM = hs.loadSpoon("PaperWM")
-- PaperWM:bindHotkeys({
--     -- switch to a new focused window in tiled grid
--     focus_left  = { meh, "left"},
--     focus_right = { meh, "right"},
--     focus_up    = { meh, "up"},
--     focus_down  = { meh, "down"},

--     -- move windows around in tiled grid
--     swap_left  = { hyper , "left"},
--     swap_right = { hyper , "right"},
--     swap_up    = { hyper , "up"},
--     swap_down  = { hyper , "down"},

--     -- position and resize focused window
--     center_window = { meh, "c"},
--     full_width    = { meh, "f"},
--     cycle_width   = { meh, "r"},
--     cycle_height  = { hyper , "r"},

--     -- move focused window into / out of a column
--     slurp_in = { meh, "i"},
--     barf_out = { meh, "o"},

--     -- switch to a new Mission Control space
--     switch_space_1 = { meh, "1"},
--     switch_space_2 = { meh, "2"},
--     switch_space_3 = { meh, "3"},
--     switch_space_4 = { meh, "4"},
--     switch_space_5 = { meh, "5"},
--     switch_space_6 = { meh, "6"},
--     switch_space_7 = { meh, "7"},
--     switch_space_8 = { meh, "8"},
--     switch_space_9 = { meh, "9"},

--     -- move focused window to a new space and tile
--     move_window_1 = { hyper , "1"},
--     move_window_2 = { hyper , "2"},
--     move_window_3 = { hyper , "3"},
--     move_window_4 = { hyper , "4"},
--     move_window_5 = { hyper , "5"},
--     move_window_6 = { hyper , "6"},
--     move_window_7 = { hyper , "7"},
--     move_window_8 = { hyper , "8"},
--     move_window_9 = { hyper , "9"}
-- })
-- PaperWM:start()