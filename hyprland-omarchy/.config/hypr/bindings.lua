-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- Typora instead of Omarchy's default Omawrite on Super+Shift+W.
hl.unbind("SUPER + SHIFT + W")
o.bind("SUPER + SHIFT + W", "Typora", o.launch("typora --enable-wayland-ime"))

-- Attach to (or create) a dedicated "Work" tmux session instead of Omarchy's
-- default tmux terminal.
hl.unbind("SUPER + ALT + RETURN")
o.bind(
  "SUPER + ALT + RETURN",
  "Tmux",
  o.launch('xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"')
)
