local inspect = require('inspect')

function shouldIntercept()
    return (#hs.screen.allScreens()) > 1
end

function toggleBundle(bundle)
    local front = hs.application.frontmostApplication()
    -- print(inspect(front:bundleID()))
    if front:bundleID() == bundle then
        front:hide()
    else
        hs.application.launchOrFocusByBundleID(bundle)
    end
end

function toggleChromeOrVscode()
    local front = hs.application.frontmostApplication()
    -- if front:name() == "Code" then
    if front:name() == "Cursor" then
        hs.application.launchOrFocus("Google Chrome.app")
    else
        -- hs.application.launchOrFocus("Visual Studio Code.app")
	hs.application.launchOrFocus("Cursor.app")
    end
end
