table.insert(Config.spaces, {
  text = "Play",
  subText = "Take a break, read, relax... but not for long.",
  image = hs.image.imageFromAppBundle('com.valvesoftware.steam'),
  togglProj = Config.projects.play,
  funcs = 'play',
  layouts = {
    {"Slack", nil, hs.screen'Built%-in':name(), hs.layout.right50, 0, 0}
  }
})

Config.funcs.play = {
  setup = function()
    hs.application.find(Freedom):kill()
    hs.application.launchOrFocusByBundleID(Slack)
  end,
  teardown = function()
    hs.application.launchOrFocusByBundleID(Freedom)
  end
}