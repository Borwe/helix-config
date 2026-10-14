(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in wakatime. "cogs/wakatime.scm"))

(helix.theme "catppuccin_latte")
(helix.set-option "line-number" "relative")
(helix.set-option "cursorline" "true")

(wakatime.run-wakatime)
