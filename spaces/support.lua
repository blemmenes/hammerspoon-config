table.insert(Config.spaces, {
  text = "Support",
  subText = "Non-interactive support work for customer",
  image = hs.image.imageFromAppBundle(ZendeskApp),
  funcs = 'support',
  togglProj = Config.projects.support,
  togglDesc = "Support Work",
  -- launch = {'planning'},
  -- blacklist = {'distraction', 'communication'},
  layouts = {
    {"Obsidian", nil, hs.screen'Acer':name(), hs.geometry.rect(0.6667, 0, .3334, 1), 0, 0},
    {"Slack", nil, hs.screen'Acer':name(), hs.geometry.rect(0.3334, 0, 0.3334, 1), 0, 0},
    {ZendeskApp, nil, hs.screen'Acer':name(), hs.geometry.rect(0, 0, .3334, 1), 0, 0}
  }
})

Config.funcs.support = {
  setup = function()
    hs.application.launchOrFocusByBundleID(ZendeskApp)
    hs.application.launchOrFocusByBundleID(obsidian)
  end,
  teardown = function()
  end
}