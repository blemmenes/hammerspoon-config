table.insert(Config.spaces, {
  text = "Communication",
  subText = "Deddicated communication email/slack time",
  image = hs.image.imageFromAppBundle('com.tinyspeck.slackmacgap'),
  funcs = 'communication',
  togglProj = Config.projects.communication,
  -- togglDesc = "Communication",
  launch = {'communication'},
})

Config.funcs.communication = {
  setup = function()
    hs.application.launchOrFocusByBundleID('com.tinyspeck.slackmacgap')
    hs.application.launchOrFocusByBundleID('com.microsoft.Outlook')
  end,
  teardown = function()
  end
}