(require (prefix-in helix.static. "helix/static.scm"))
(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in wakatime. "cogs/wakatime.scm"))
(require (prefix-in helix.conf. "helix/configuration.scm"))

(helix.theme "catppuccin_macchiato")
(helix.set-option "line-number" "relative")
(helix.set-option "cursorline" "true")

(wakatime.run-wakatime)
