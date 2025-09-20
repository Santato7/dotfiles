local config = import("micro/config")
local shell = import("micro/shell")

function init()
    -- true means overwrite any existing binding to Ctrl-r
    -- this will modify the bindings.json file
    config.TryBindKey("Alt-R", "lua:initlua.ruby_run", true)
end

function ruby_run(bp)
    local buf = bp.Buf
    if buf:FileType() == "ruby" then
        -- the true means run in the foreground
        -- the false means send output to stdout (instead of returning it)
        shell.RunInteractiveShell("ruby " .. buf.Path, true, false)
    end
end
