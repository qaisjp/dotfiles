--[[

Depends on http://www.hammerspoon.org/Spoons/URLDispatcher.html

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


local function catchZoom(fallbackProfile)
    local fallback = sendToProfile({"", fallbackProfile})[3]
    local fn = function(url)
        local joinCode = tonumber(string.match(url, "company.zoom.us/j/(%d+)"))
        joinCode = joinCode or tonumber(string.match(url, "company.zoom.us/integration/(%d+)"))
        if joinCode then
            local url = "zoommtg://company.zoom.us/join?action=join&confno=" .. joinCode
            hs.urlevent.openURL(url)
        else
            fallback(url)
        end
    end
    return {"company.zoom.us", nil, fn}
end

spoon.URLDispatcher.url_patterns = {
    catchZoom("Default"), -- Open Zoom links (e.g. from Slack or other apps)
    sendToProfile{"work.com", "Default"}, -- Anything on work domain
    sendToProfile{"groups.google.com", "Default"}, -- Google Groups

    -- Everything else is personal
    sendToProfile{".*", "Profile 2"},
}

spoon.URLDispatcher:start()
