table.insert(Config.spaces, {
  text = "Research",
  subText = "Researching some topic",
  image = hs.image.imageFromAppBundle(braveBrowser),
  -- funcs = 'garden',
  togglProj = Config.projects.research,
  -- togglDesc = "Support Call",
  -- launch = {'planning'},
  intentRequired = true,
  blacklist = {'distraction' },
  -- layouts = {
  --   {"Obsidian", nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0.6667, 0, .3334, 1), 0, 0},
  --   {ZendeskApp, nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0, 0, .3334, 1), 0, 0}
  -- }
})

-- Config.funcs.garden = {
--   setup = function()
--     hs.application.launchOrFocusByBundleID(Freedom)
--     hs.urlevent.openURL("obsidian://open?vault=Berant&daily=true")
--   end,
--   teardown = function()
--   end
-- }