table.insert(Config.spaces, {
  text = "Play",
  subText = "Take a break, read, relax... but not for long.",
  image = hs.image.imageFromAppBundle('com.valvesoftware.steam'),
  togglProj = Config.projects.play,
  funcs = 'play'
})

Config.funcs.play = {
  setup = function()
    hs.application.find(Freedom):kill()
  end,
  teardown = function()
    hs.application.launchOrFocusByBundleID(Freedom)
  end
}