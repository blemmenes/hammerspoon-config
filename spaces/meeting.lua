table.insert(Config.spaces, {
  text = "Meeting",
  subText = "Meeting, internal or exeternal non-support",
  image = hs.image.imageFromAppBundle(RingCentral),
  funcs = 'meeting',
  togglProj = Config.projects.meetings,
  togglDesc = "Meeting"
  -- launch = {'planning'},
  -- blacklist = {'distraction', 'communication'},
--   layouts = {
--     {"Obsidian", nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0.6667, 0, .3334, 1), 0, 0},
--     -- {ZendeskApp, nil, hs.screen.primaryScreen():name(), hs.geometry.rect(0, 0, .3334, 1), 0, 0}
--   }
})

Config.funcs.meeting = {
  setup = function()
    hs.application.launchOrFocusByBundleID(RingCentral)
    hs.urlevent.openURL("obsidian://open?vault=Berant&daily=true")
    hs.urlevent.openURL("obsidian://advanced-uri?vault=Berant&commandid=quickadd%253Achoice%253A13f6baf9-74a8-4be8-9de4-db9e3112afe8")
  end,
  teardown = function()
    hs.application(RingCentral):kill()
  end
}