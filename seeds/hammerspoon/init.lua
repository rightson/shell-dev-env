-- Hammerspoon Window Management - Minimalist Version

-- hs.window.animationDuration = 0 -- Disable animation

-- Window movement function
local function moveWindow(x, y, w, h)
    local win = hs.window.focusedWindow()
    if not win then return end

    local screen = hs.screen.mainScreen():frame()
    win:setFrame({
        x = screen.x + (screen.w * x),
        y = screen.y + (screen.h * y),
        w = screen.w * w,
        h = screen.h * h
    })
end

-- ==========================================
-- 1/3 Window Split
-- ==========================================

-- Ctrl + Option + 1: Left 1/3
 hs.hotkey.bind({"ctrl", "alt"}, "1", function()
    hs.alert.show("Left 1/3")
    moveWindow(0, 0, 1/3, 1)
end)

-- Ctrl + Option + 2: Middle 1/3
 hs.hotkey.bind({"ctrl", "alt"}, "2", function()
    hs.alert.show("Middle 1/3")
    moveWindow(1/3, 0, 1/3, 1)
end)

-- Ctrl + Option + 3: Right 1/3
hs.hotkey.bind({"ctrl", "alt"}, "3", function()
    hs.alert.show("Right 1/3")
    moveWindow(2/3, 0, 1/3, 1)
end)

-- ==========================================
-- 2/3 Window Split
-- ==========================================

-- Ctrl + Shift + Option + 1: Left 2/3
hs.hotkey.bind({"ctrl", "shift", "alt"}, "1", function()
    hs.alert.show("Left 2/3")
    moveWindow(0, 0, 2/3, 1)
end)

-- Ctrl + Shift + Option + 2: Middle 2/3
hs.hotkey.bind({"ctrl", "shift", "alt"}, "2", function()
    hs.alert.show("Middle 2/3")
    moveWindow(1/6, 0, 2/3, 1)
end)

-- Ctrl + Shift + Option + 3: Right 2/3
hs.hotkey.bind({"ctrl", "shift", "alt"}, "3", function()
    hs.alert.show("Right 2/3")
    moveWindow(1/3, 0, 2/3, 1)
end)

-- Ctrl + Option + Cmd + N: Move window to next display
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "N", function()
    hs.alert.show("Move window to next display")
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():next())
    end
end)

-- Ctrl + Option + Cmd + M: Move window to next display and maximize
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "M", function()
    hs.alert.show("Move window to next display and maximize")
    local win = hs.window.focusedWindow()
    if win then
        -- Move to next display
        local nextScreen = win:screen():next()
        win:moveToScreen(nextScreen)

        -- Maximize
        local screenFrame = nextScreen:frame()
        win:setFrame(screenFrame)
    end
end)

-- Ctrl + Option + Left: Left half
hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
    hs.alert.show("Left half")
    moveWindow(0, 0, 0.5, 1)
end)

-- Ctrl + Option + Right: Right half
hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
    hs.alert.show("Right half")
    moveWindow(0.5, 0, 0.5, 1)
end)

-- Ctrl + Option + C: Center (70% size)
hs.hotkey.bind({"ctrl", "alt"}, "C", function()
    hs.alert.show("Center (70% size)")
    moveWindow(0.15, 0.15, 0.7, 0.7)
end)

-- ==========================================
-- Dictionary Lookup & Translation
-- ==========================================

-- Ctrl + Option + D: Open dictionary and lookup clipboard content
hs.hotkey.bind({"ctrl", "alt"}, "D", function()
    local clipboardContent = hs.pasteboard.getContents()
    if clipboardContent and clipboardContent ~= "" then
        hs.alert.show("Lookup: " .. clipboardContent)
        -- Use URL scheme to open Dictionary app and search
        hs.urlevent.openURL("dict://" .. hs.http.encodeForQuery(clipboardContent))
    else
        hs.alert.show("Clipboard is empty")
    end
end)

-- Ctrl + Option + G: Open Google Translate and translate clipboard content
hs.hotkey.bind({"ctrl", "alt"}, "G", function()
    local clipboardContent = hs.pasteboard.getContents()
    if clipboardContent and clipboardContent ~= "" then
        hs.alert.show("Translate: " .. clipboardContent)
        -- Open Google Translate (auto-detect language)
        local url = "https://translate.google.com/?sl=en&tl=zh-TW&text=" .. hs.http.encodeForQuery(clipboardContent)
        hs.urlevent.openURL(url)
    else
        hs.alert.show("Clipboard is empty")
    end
end)

-- ==========================================
-- Startup Notification
-- ==========================================
hs.alert.show("✓ Window management loaded")
