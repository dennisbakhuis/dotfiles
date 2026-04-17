# Ensure ~/.local/bin is on PATH before other conf.d files run.
# Needed so command -v checks (e.g. for `claude`) in aliases.fish succeed
# on Linux, where the claude installer drops the binary in ~/.local/bin.
if test -d $HOME/.local/bin
    fish_add_path -g $HOME/.local/bin
end
