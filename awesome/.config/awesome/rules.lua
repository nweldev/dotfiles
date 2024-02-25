local beautiful = require("beautiful")
local clientkeys = require("keyboard.client")
local clientbuttons = require("buttons.client")

return {
  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
      size_hints_honor = false
    }
  },
  -- Titlebars
  {
    rule_any = {type = {"dialog", "normal"}},
    properties = {titlebars_enabled = true}
  },
  {
    rule = {class = "Gimp", role = "gimp-image-window"},
    properties = {maximized = true}
  },
  -- map clients to tag
  {
    rule_any = {class = {"firefox", "Google-chrome"} },
    except_any = { { role = "pop-up" }},
    properties = { tag = "🔍"}
  },
  {
    rule = {class = "Code"},
    properties = { tag = "{}"}
  },
  {
    rule_any = {class = {"ghostwriter"} },
    properties = { tag = "{}"}
  },
  {
    rule_any = {class = {"Terminator", "Hyper"} },
    properties = { tag = "💻"}
  },
  {
    rule_any = {class = { "Slack", "Signal"} },
    properties = { tag = "💬"}
  },
  {
    rule_any = {class = { "Zotero"} },
    properties = { tag = "📺"}
  },
  -- Web Apps
  {
    rule_any = {class="Google-chrome", instance = { "www.netflix.com__browse"} },
    properties = { tag = "📺"}
  },
  {
    rule_any = {class="Google-chrome", instance = { "www.primevideo.com"} },
    properties = { tag = "📺"}
  },
  {
    -- Disney+ (install specific, see desktop/.local/share/applications)
    rule_any = {class="Google-chrome", instance = { "crx_agimnkijcaahngcdmfeangaknmldooml" } },
    properties = { tag = "📺"}
  },
  -- floating clients
  {
    rule = {class = "firefox", role = "PictureInPicture"},
    properties = {
      floating = true,
      placement = awful.placement.bottom_left,
      titlebars_enabled = true,
      tags = awful.screen.focused().tags
    }
  }
}
