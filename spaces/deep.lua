table.insert(Config.spaces, {
  text = "Deep",
  subText = "Work deeply on focused work",
  image = hs.image.imageFromAppBundle('com.microsoft.VSCode'),
  togglProj = Config.projects.deep,
  blacklist = {'distraction'},
  intentRequired = true,
  funcs = 'deep',
  layouts = {
    {"Obsidian", nil, hs.screen'Acer':name(), hs.geometry.rect(0.6667, 0, .3334, 1), 0, 0},
    {"Slack", nil, hs.screen'Built%-in':name(), hs.layout.right50, 0, 0},
    {ZendeskApp, nil, hs.screen'Acer':name(), hs.geometry.rect(0, 0, .3334, 1), 0, 0}
  }
})

Config.funcs.deep = {
  setup = function()
    hs.application.launchOrFocusByBundleID(VSCode)
    hs.application.launchOrFocusByBundleID(obsidian)
    hs.application.launchOrFocusByBundleID(Freedom)
    -- hs.shortcuts.run("Deep Focus")
  end,
  teardown = function()
    -- hs.urlevent.openURL("things:///show?id=today")
    -- hs.shortcuts.run("Leave Deep Focus")
  end
}