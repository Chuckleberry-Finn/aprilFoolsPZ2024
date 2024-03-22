--local function test() if 1>"apple" then return true end end if getDebug() then Events.OnPlayerMove.Add(test) end

local osDate = os.date("*t")
if not osDate then return end
local eventOver = false
if osDate.month>=4 and osDate.day>=1 then eventOver = true end

local errorPopUps = -100
local errorPopUpsXY = {}

---What you can't see can't hurt you.
local function fix()

    local playerData = getPlayer() and getPlayerData(getPlayer():getPlayerNum())
    if not playerData then return end

    ---@type UIElement
    local ui = playerData and playerData.fixifierUI

    local textHeight = getTextManager():getFontHeight(UIFont.DebugConsole)

    local w = 100
    local h = (textHeight * 2 + 4)

    local sW = getCore():getScreenWidth()
    local x = sW - w
    local sH = getCore():getScreenHeight()
    local y = sH - h

    if not ui then
        ---@type ISUIElement
        local newUI = ISPanel:new(x, y, w, h)
        newUI:initialise()
        newUI:addToUIManager()
        newUI.backgroundColor = {r=0, g=0, b=0, a=0}
        newUI.borderColor = {r=0, g=0, b=0, a=0}
        newUI:setX(x)
        newUI:setY(y)
        newUI:setWidth(w)
        newUI:setHeight(h)
        ui = newUI:getJavaObject()

        playerData.fixifierUI = ui
    else
        local errors = getLuaDebuggerErrors()
        if errors:size() > 0 then errorPopUps = errorPopUps + 1 end
    end

    if eventOver then
        local g = math.floor(errorPopUps/10)

        if #errorPopUpsXY < g then
            local bX, bY = ZombRand(0,sW-w), ZombRand(0,sH-h)
            table.insert(errorPopUpsXY, {bX, bY})
        end

        for _,box in pairs(errorPopUpsXY) do
            local bX, bY = box[1], box[2]
            getRenderer():renderi(nil, bX-w, bY-h, w, h, 0.8, 0.0, 0.0, 1.0, nil)
            getRenderer():renderi(nil, bX+1-w, bY+1-h, w-2, textHeight-1, 0.0, 0.0, 0.0, 1.0, nil)
            getTextManager():DrawStringCentre(UIFont.DebugConsole, (bX)-(w/2), bY-h, "APRIL", 1.0, 0.0, 0.0, 1.0)
            getTextManager():DrawStringCentre(UIFont.DebugConsole, (bX)-(w/2), bY+textHeight-h, "FOOLS", 0.0, 0.0, 0.0, 1.0)
        end
    end

    if ui then ui:setStencilRect(x, y, w , h) end
end

Events.OnPostUIDraw.Add(fix)