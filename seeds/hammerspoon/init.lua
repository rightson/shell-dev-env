-- Hammerspoon 視窗管理 - 極簡版

-- hs.window.animationDuration = 0 -- 關閉動畫

-- 視窗移動函數
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
-- 1/3 視窗分割
-- ==========================================

-- Ctrl + Option + 1: 左側 1/3
hs.hotkey.bind({"ctrl", "alt"}, "1", function()
    hs.alert.show("左側 1/3")
    moveWindow(0, 0, 1/3, 1)
end)

-- Ctrl + Option + 2: 中間 1/3
hs.hotkey.bind({"ctrl", "alt"}, "2", function()
    hs.alert.show("中間 1/3")
    moveWindow(1/3, 0, 1/3, 1)
end)

-- Ctrl + Option + 3: 右側 1/3
hs.hotkey.bind({"ctrl", "alt"}, "3", function()
    hs.alert.show("右側 1/3")
    moveWindow(2/3, 0, 1/3, 1)
end)

-- ==========================================
-- 2/3 視窗分割
-- ==========================================

-- Ctrl + Shift + Option + 1: 左側 2/3
hs.hotkey.bind({"ctrl", "shift", "alt"}, "1", function()
    hs.alert.show("左側 2/3")
    moveWindow(0, 0, 2/3, 1)
end)

-- Ctrl + Shift + Option + 2: 中間 2/3
hs.hotkey.bind({"ctrl", "shift", "alt"}, "2", function()
    hs.alert.show("中間 2/3")
    moveWindow(1/6, 0, 2/3, 1)
end)

-- Ctrl + Shift + Option + 3: 右側 2/3
hs.hotkey.bind({"ctrl", "shift", "alt"}, "3", function()
    hs.alert.show("右側 2/3")
    moveWindow(1/3, 0, 2/3, 1)
end)

-- Ctrl + Option + Cmd + M: 移動視窗到下一個顯示器
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "N", function()
    hs.alert.show("移動視窗到下一個顯示器")
    local win = hs.window.focusedWindow()
    if win then
        win:moveToScreen(win:screen():next())
    end
end)

-- Ctrl + Option + Cmd + M: 移動視窗到下一個顯示器並最大化
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "M", function()
    hs.alert.show("移動視窗到下一個顯示器並最大化")
    local win = hs.window.focusedWindow()
    if win then
        -- 移動到下一個顯示器
        local nextScreen = win:screen():next()
        win:moveToScreen(nextScreen)
        
        -- 最大化
        local screenFrame = nextScreen:frame()
        win:setFrame(screenFrame)
    end
end)

-- Ctrl + Option + Left: 左半邊
hs.hotkey.bind({"ctrl", "alt"}, "Left", function()
    hs.alert.show("左半邊")
    moveWindow(0, 0, 0.5, 1)
end)

-- Ctrl + Option + Right: 右半邊
hs.hotkey.bind({"ctrl", "alt"}, "Right", function()
    hs.alert.show("右半邊")
    moveWindow(0.5, 0, 0.5, 1)
end)

-- Ctrl + Option + C: 置中（70% 大小）
hs.hotkey.bind({"ctrl", "alt"}, "C", function()
    hs.alert.show("置中（70% 大小）")
    moveWindow(0.15, 0.15, 0.7, 0.7)
end)

-- ==========================================
-- 字典查詢與翻譯
-- ==========================================

-- Option + D: 打開字典並查詢剪貼簿內容
hs.hotkey.bind({"alt"}, "D", function()
    local clipboardContent = hs.pasteboard.getContents()
    if clipboardContent and clipboardContent ~= "" then
        hs.alert.show("查詢: " .. clipboardContent)
        -- 使用 URL scheme 打開字典 app 並搜尋
        hs.urlevent.openURL("dict://" .. hs.http.encodeForQuery(clipboardContent))
    else
        hs.alert.show("剪貼簿是空的")
    end
end)

-- Ctrl + Option + G: 打開 Google 翻譯並翻譯剪貼簿內容
hs.hotkey.bind({"ctrl", "alt"}, "G", function()
    local clipboardContent = hs.pasteboard.getContents()
    if clipboardContent and clipboardContent ~= "" then
        hs.alert.show("翻譯: " .. clipboardContent)
        -- 打開 Google 翻譯（自動偵測語言）
        local url = "https://translate.google.com/?sl=auto&tl=en&text=" .. hs.http.encodeForQuery(clipboardContent)
        hs.urlevent.openURL(url)
    else
        hs.alert.show("剪貼簿是空的")
    end
end)

-- ==========================================
-- 啟動提示
-- ==========================================
hs.alert.show("✓ 視窗管理已載入")