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

eventTap = hs.eventtap.new(
    {
        -- hs.eventtap.event.types.flagsChanged,
        -- hs.eventtap.event.types.keyDown,
        hs.eventtap.event.types.systemDefined
    },
    function(event)
        -- print("Eventtap")

        local key = event:systemKey()
        -- print()
        -- print("Keypress:")
        -- print("keycode", inspect(event:getKeyCode()))
        -- print("systemKey", inspect(key))
        -- print("mousecount", hs.mouse.count())
        if key.down and key.key == "BRIGHTNESS_DOWN" then
            if not shouldIntercept() then return false end
            -- print("flags", event:rawFlags())

            -- Don't do our thing if shift is held
            -- if event:getFlags().shift then
                -- return false
            -- end

            -- Don't do our thing if held down
            if key['repeat'] then
                return false -- Don't intercept
            end

            local front = hs.application.frontmostApplication()
            if front:name() == "iTerm2" then
                front:hide()
            else
                hs.application.launchOrFocus("iTerm.app")
            end

            -- print('property is', inspect({event:getProperty(hs.eventtap.event.properties.keyboardEventKeyboardType)}))
            -- must still return false, otherwise repeat doesn't work
            return true
        end


        if key.down and key.key == "BRIGHTNESS_UP" then
            if not shouldIntercept() then return false end
            -- print("flags", event:rawFlags())

            -- Don't do our thing if shift is held
            -- if event:getFlags().shift then
                -- return false
            -- end

            -- Don't do our thing if held down
            if key['repeat'] then
                return false -- Don't intercept
            end

            local front = hs.application.frontmostApplication()
            -- print("frontapp is", front)
            if front:name() == "Code" then
                hs.application.launchOrFocus("Google Chrome.app")
            else
                hs.application.launchOrFocus("Visual Studio Code.app")
            end

            -- print('property is', inspect({event:getProperty(hs.eventtap.event.properties.keyboardEventKeyboardType)}))
            -- must still return false, otherwise repeat doesn't work
            return true
        end

        -- Don't intercept
        return false
    end
):start()



eventTap2 = hs.eventtap.new(
    {
        -- hs.eventtap.event.types.flagsChanged,
        hs.eventtap.event.types.keyDown,
        -- hs.eventtap.event.types.systemDefined
    },
    function(event)
        -- print("Eventtap")

        local key = event:getUnicodeString()
        local keycode = event:getKeyCode()
        local flags = event:getFlags()
        local altDown = flags.alt
        local letter = hs.keycodes.map[keycode]
        -- print()
        -- print("Keypress:")
        -- print("keycode", inspect(keycode), hs.keycodes.map[keycode])
        -- print("flags", inspect(flags))
        -- print("mousecount", hs.mouse.count())
        if altDown and letter == "s" then
            -- if not shouldIntercept() then return false end
            -- print("flags", event:rawFlags())

            -- Don't do our thing if shift is held
            -- if event:getFlags().shift then
                -- return false
            -- end

            -- Don't do our thing if held down
            -- if key['repeat'] then
            --     return false -- Don't intercept
            -- end

            local slackID = "com.tinyspeck.slackmacgap"
            -- toggleBundle(slackID)
            -- if front:bundleID() == slackID then
            --     front:hide()
            -- else
            --     hs.application.launchOrFocusByBundleID(slackID)
            -- end

            -- print('property is', inspect({event:getProperty(hs.eventtap.event.properties.keyboardEventKeyboardType)}))
            -- must still return false, otherwise repeat doesn't work
            -- return true
        end



        -- Don't intercept
        return false
    end
):start()