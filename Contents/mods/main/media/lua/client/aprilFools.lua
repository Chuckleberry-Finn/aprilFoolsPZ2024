---What you can't see can't hurt you.
local function fix()
    local managerUI = UIManager.getUI()
    local ui = managerUI:get(managerUI:size()-1)
    local textHeight = getTextManager():getFontHeight(UIFont.DebugConsole)
    local w = 100
    local h = (textHeight * 2 + 4)
    local sW = getCore():getScreenWidth()
    local x = sW - w
    local sH = getCore():getScreenHeight()
    local y = sH - h
    ui:setStencilRect(x, y, w , h)
end
Events.OnPostUIDraw.Add(fix)