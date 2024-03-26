table.insert(Config.spaces, {
  text = "Garden",
  subText = "Planning/gardening PKI",
  image = hs.image.imageFromAppBundle(obsidian),
  funcs = 'garden',
  togglProj = Config.projects.gardening,
  -- togglDesc = "Support Call",
  launch = {'planning'},
  blacklist = {'distraction' },
  layouts = {
    {"Obsidian", nil, hs.screen'Acer':name(), hs.layout.right50, 0, 0},
    {"Slack", nil, hs.screen'Built%-in':name(), hs.layout.right50, 0, 0}
  }
})

Config.funcs.garden = {
  setup = function()
    hs.application.launchOrFocusByBundleID(Freedom)
    hs.urlevent.openURL("obsidian://open?vault=Berant&daily=true")
  end,
  teardown = function()
  end
}