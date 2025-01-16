
-- hs.loadSpoon("ReloadConfiguration")
-- spoon.ReloadConfiguration:start()

-- Install Hammerspoon IPC
hs.ipc.cliInstall("/opt/homebrew")

-- require "status-menubar"
require "app-toggle"

inspect = require 'inspect'

-- saved = hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
--     local app = window:application()
--     print('windowFocused: ' .. window:title(), inspect{
--         title = window:title(),
--         appTitle = app:title(),
--         appPath = app:path(),
--         appName = app:name(),
--     }, 'done')
-- end)
-- saved2 = hs.window.filter.default:subscribe(hs.window.filter.windowCreated, function(window, appName)
--     local app = window:application()
--     print('windowCreated: ' .. window:title(), inspect{
--         title = window:title(),
--         appTitle = app:title(),
--         appPath = app:path(),
--         appName = app:name(),
--     }, 'done')
-- end)
-- saved3 = hs.window.filter.default:subscribe(hs.window.filter.windowVisible, function(window, appName)
--     local app = window:application()
--     print('windowVisible: ' .. window:title(), inspect{
--         title = window:title(),
--         appTitle = app:title(),
--         appPath = app:path(),
--         appName = app:name(),
--     }, 'done')
-- end)


hs.loadSpoon("URLDispatcher")
local function sendToProfile(match, profile)
    local fn = function(url)
        print("Accessing URL", url)
        local start = os.clock()
        local t = hs.task.new(
            "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
            nil,
            function() return false end,
            {"--profile-directory=" .. profile, url}
        )
        print("Task creation in", os.clock() - start)
        start = os.clock()
        t:start()
        print("Task start in", os.clock() - start)
    end
    return {match, nil, fn}
end

local function catchZoom(fallbackProfile)
    local fallback = sendToProfile("", fallbackProfile)[3]
    local fn = function(url)
        local joinCode = tonumber(string.match(url, "stripe.zoom.us/j/(%d+)"))
        joinCode = joinCode or tonumber(string.match(url, "stripe.zoom.us/integration/(%d+)"))

        if joinCode then
            local uri = "zoommtg://stripe.zoom.us/join?action=join&confno=" .. joinCode

            local pwd = string.match(url, "?pwd=([a-zA-Z0-9]+)")
            if pwd then
                uri = uri .. "&pwd=" .. pwd
            end

            hs.urlevent.openURL(uri)
        else
            fallback(url)
        end
    end
    return {"zoom.us", nil, fn}
end

spoon.URLDispatcher.url_patterns = {
    catchZoom("Default"), -- Open Zoom links (e.g. from Slack or other apps)
    sendToProfile("https?://go/", "Default"), -- Go links
    sendToProfile(".stripe.", "Default"), -- Likely to be something on our VPN
    sendToProfile("stripe.com", "Default"), -- stripe.com website
    sendToProfile("slack.com", "Default"), -- Our Slack workspaces
    sendToProfile("paper.dropbox.com", "Default"), -- Paper
    sendToProfile("greenhouse.io", "Default"), -- Greenhouse
    sendToProfile("not%-a%-startup.pagerduty.com", "Default"), -- Pagerduty
    sendToProfile("video.ibm.com", "Default"), -- Friday Fireside / ATH / etc
    sendToProfile("whimsical.com", "Default"), -- Whimsical
    sendToProfile("streamshark.io", "Default"), -- Friday Fireside / ATH / etc
    sendToProfile("ask-stripe.force.com", "Default"), -- People Support
    sendToProfile("google.zoom", "Default"), -- Zoom SSO goes to Default Profile
    sendToProfile("tuple.app", "Default"), -- Tuple
    sendToProfile("amazonaws.com", "Default"), -- AWS
    sendToProfile("adobe", "Default"), -- AWS

    -- Google stuff
    sendToProfile("calendar.google.com", "Default"),
    sendToProfile("groups.google.com", "Default"),
    sendToProfile("drive.google.com", "Default"),
    sendToProfile("docs.google.com", "Default"),
    sendToProfile("forms.gle", "Default"),
    sendToProfile("accounts.google.com", "Default"),
    sendToProfile("google.com/calendar", "Default"),

    -- Everything else is personal
    sendToProfile(".*", "Profile 2"),
}

spoon.URLDispatcher:start()

