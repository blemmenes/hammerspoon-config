return {
  ['com.microsoft.outlook'] = {
    bundleID = 'com.microsoft.outlook',
    hyperKey = 'e',
    tags = {'communication', 'planning'},
    layouts = {
      {nil, 2, hs.layout.maximized}
    }
  },
  ['md.obsidian'] = {
    bundleID = 'md.obsidian',
    hyperKey = 'o',
    tags = {'research', 'notes', 'planning'},
    layouts = {
      {nil, 1, hs.geometry.rect(0.6667, 0, .3334, 1)} -- right third
    }
  },
  ['com.brave.Browser.app.cinhimbnkkaeohfgghhklpknlkffjgod'] = {
    bundleID = 'com.brave.Browser.app.cinhimbnkkaeohfgghhklpknlkffjgod',
    hyperKey = 'm',
    tags = {'personal'},
    layouts = {
      {nil, 2, hs.layout.right50}
    }
  },
  ['com.tinyspeck.slackmacgap'] = {
    bundleID = 'com.tinyspeck.slackmacgap',
    hyperKey = 's',
    tags = {'communication'},
    layouts = {
      -- {nil, , hs.layout.maximized}
      {nil, 1, hs.geometry.rect(0.3334, 0, 0.3334, 1)} -- middle third
    }
  },
  ['com.webcatalog.juli.zendesk'] = {
    bundleID = 'com.webcatalog.juli.zendesk',
    hyperKey = 'z',
    -- tags = {'research', 'notes'},
    layouts = {
      {nil, 1, hs.geometry.rect(0, 0, .3334, 1)} -- left third
    }
  },
  ['com.microsoft.VSCode'] = {
    bundleID = 'com.microsoft.VSCode',
    hyperKey = 'c',
    -- tags = {'research', 'notes'},
    layouts = {
      {nil, 1, hs.geometry.rect(0.3334, 0, 0.3334, 1)} -- middle third
    }
  },
  ['com.hnc.Discord'] = {
    bundleID = 'com.hnc.Discord',
    hyperKey = 'd',
    tags = {'communication', 'distraction', 'personal'},
    layouts = {
      {nil, 2, hs.layout.right50 
    }
  },
  ['tv.plex.desktop'] = {
    bundleID = 'tv.plex.desktop',
    hyperKey = 'd',
    tags = { 'distraction', 'personal'}
    }
  }
}