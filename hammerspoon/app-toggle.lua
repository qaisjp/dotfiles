local inspect = require('inspect')

groups = {}

function shouldIntercept()
    return (#hs.screen.allScreens()) > 1
end

function toggleBundle(bundle, group)
    -- Create the group if it doesn't exist
    if not groups[group] then
        groups[group] = {}
    end

    -- Add the bundle to the group
    if not groups[group][bundle] then
        groups[group][bundle] = true
    end

    local front = hs.application.frontmostApplication()
    -- print(inspect(front:bundleID()))
    if front:bundleID() == bundle then
        front:hide()
    else
        hs.application.launchOrFocusByBundleID(bundle)

        -- hide all the other bundles in the group
        for other, _ in pairs(groups[group]) do
            if other ~= bundle then
                local app = hs.application.get(other)
                if app then
                    app:hide()
                end
            end
        end
    end
end

lastWindow = nil
function toggleBundleFocusOnly(bundle)
    local front = hs.application.frontmostApplication()
    -- print(inspect(front:bundleID()))
    if front:bundleID() == bundle then
        if lastWindow then
            lastWindow:focus()
        end
    else
        lastWindow = hs.window.focusedWindow()
        hs.application.launchOrFocusByBundleID(bundle)
    end
end

function toggleChromeOrVscode()
    -- hide all bundles from the floating group
    for bundle, _ in pairs(groups['floating'] or {}) do
        local app = hs.application.get(bundle)
        if app then
            app:hide()
        end
    end


    local front = hs.application.frontmostApplication()
    -- if front:name() == "Code" then
    if front:name() == "Cursor" then
        hs.application.launchOrFocus("Google Chrome.app")
    else
        -- hs.application.launchOrFocus("Visual Studio Code.app")
	hs.application.launchOrFocus("Cursor.app")
    end
end
