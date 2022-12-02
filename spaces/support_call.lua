table.insert(Config.spaces, {
  text = "Support Call",
  subText = "Interactive support call with customer",
  image = hs.image.imageFromAppBundle(ZendeskApp),
  funcs = 'support_call',
  togglProj = Config.projects.support,
  togglDesc = "Support Call",
  -- launch = {'planning'},
  -- blacklist = {'distraction', 'communication'},
  -- layouts = {
  --   {"Obsidian", nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0.6667, 0, .3334, 1), 0, 0},
  --   {ZendeskApp, nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0, 0, .3334, 1), 0, 0}
  -- }
})

Config.funcs.support_call = {
  setup = function()
    hs.application.launchOrFocusByBundleID(RingCentral)
    hs.urlevent.openURL("obsidian://open?vault=Berant&daily=true")
    hs.urlevent.openURL("obsidian://advanced-uri?vault=Berant&newpane=false&commandid=quickadd%253Achoice%253A30ca40e1-962a-4891-8052-5c379996c151")
  end,
  teardown = function()
    hs.application(RingCentral):kill()
  end
}