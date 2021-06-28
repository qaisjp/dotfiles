--[[
Copy and paste this URL into each Chrome profile: `chrome://version/#:~:text=Profile%20Path`

Under “Profile Path”, look for your profile name:

- `/Users/qaisjp/Library/Application Support/Google/Chrome/Default` <- "Default"
- `/Users/qaisjp/Library/Application Support/Google/Chrome/Profile 2` <- "Profile 2"

These two names are the names you will use in the configuration.
]]

hs.loadSpoon("URLDispatcher")

local sendToProfile = function(t)
    local fn = function(url)
        local t = hs.task.new(
            "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
            nil,
            function() return false end,
            {"--profile-directory=" .. t[2], url}
        )
        t:start()
    end
    return {t[1], nil, fn}
end

spoon.URLDispatcher.url_patterns = {
    sendToProfile{"work.com", "Default"}, -- Anything on work domain
    sendToProfile{"groups.google.com", "Default"}, -- Google Groups

    -- Everything else is personal
    sendToProfile{".*", "Profile 2"},
}

spoon.URLDispatcher:start()
