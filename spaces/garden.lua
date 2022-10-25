table.insert(Config.spaces, {
  text = "Garden",
  subText = "Planning/gardening PKI",
  image = hs.image.imageFromAppBundle(obsidian),
  funcs = 'garden',
  togglProj = Config.projects.gardening,
  -- togglDesc = "Support Call",
  launch = {'planning'},
  blacklist = {'distraction' },
  -- layouts = {
  --   {"Obsidian", nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0.6667, 0, .3334, 1), 0, 0},
  --   {ZendeskApp, nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0, 0, .3334, 1), 0, 0}
  -- }
})

Config.funcs.garden = {
  setup = function()
    hs.application.launchOrFocusByBundleID(Freedom)
    hs.urlevent.openURL("obsidian://open?vault=Berant&daily=true")
  end,
  teardown = function()
  end
}