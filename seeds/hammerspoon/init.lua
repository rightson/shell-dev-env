-- Hammerspoon Window Management - Multi-Monitor Fixed

-- Window movement function
local function moveWindow(x, y, w, h)
    local win = hs.window.focusedWindow()
    if not win then return end

    -- Use the screen the window is CURRENTLY on, not the main screen
    local f = win:screen():frame()

    win:setFrame({
        x = f.x + (f.w * x),
        y = f.y + (f.h * y),
        w = f.w * w,
        h = f.h * h
    })
end

-- ==========================================
-- 1/3 Window Split
-- ==========================================

hs.hotkey.bind({"ctrl", "alt"}, "1", function()
    hs.alert.show("Left 1/3")
    moveWindow(0, 0, 1/3, 1)
end)

hs.hotkey.bind({"ctrl", "alt"}, "2", function()
    hs.alert.show("Middle 1/3")
    moveWindow(1/3, 0, 1/3, 1)
end)

hs.hotkey.bind({"ctrl", "alt"}, "3", function()
    hs.alert.show("Right 1/3")
    moveWindow(2/3, 0, 1/3, 1)
end)

-- ==========================================
-- 2/3 Window Split
-- ==========================================

hs.hotkey.bind({"ctrl", "shift", "alt"}, "1", function()
    hs.alert.show("Left 2/3")
    moveWindow(0, 0, 2/3, 1)
end)

hs.hotkey.bind({"ctrl", "shift", "alt"}, "2", function()
    hs.alert.show("Middle 2/3")
    moveWindow(1/6, 0, 2/3, 1)
end)

hs.hotkey.bind({"ctrl", "shift", "alt"}, "3", function()
    hs.alert.show("Right 2/3")
    moveWindow(1/3, 0, 2/3, 1)
end)

-- ==========================================
-- Display Movement (Next/Maximize)
-- ==========================================

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "N", function()
    local win = hs.window.focusedWindow()
    if win then
        hs.alert.show("Next Display")
        win:moveToScreen(win:screen():next(), false, true) -- Ensure it maintains aspect ratio
    end
end)

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "m", function()
    local win = hs.window.focusedWindow()
    if win then
        hs.alert.show("Next Display & Maximize")
        local nextScreen = win:screen():next()
        win:moveToScreen(nextScreen, false, true)
        win:maximize()
    end
end)

-- ==========================================
-- Standard Splits
-- ==========================================

hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
    hs.alert.show("Left Half")
    moveWindow(0, 0, 0.5, 1)
end)

hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
    hs.alert.show("Right Half")
    moveWindow(0.5, 0, 0.5, 1)
end)

hs.hotkey.bind({"ctrl", "alt"}, "C", function()
    hs.alert.show("Center (70%)")
    moveWindow(0.15, 0.15, 0.7, 0.7)
end)

-- Keep your Dictionary and Google Translate code as they are