--local function test() if 1>"apple" then return true end end if getDebug() then Events.OnPlayerMove.Add(test) end

local osDate = os.date("*t")
if not osDate then return end
local engageEvent = (osDate.month==4 and osDate.day>=1 and osDate.day<=7)

local errorPopUps = -100
local errorPopUpsXY = {}
local ernest = getTexture("media/textures/ernest.png")
local ernestW, ernestH, ernestX, ernestY = ernest:getWidth(), ernest:getHeight()

local debugTextH = getTextManager():getFontHeight(UIFont.DebugConsole)
local largeTextH = getTextManager():getFontHeight(UIFont.Large)

--engageEvent = true

local gagOver = false
local hoverOverFace = false

---@type UIElement
fixifierUI = nil

---What you can't see can't hurt you.
local function fix()

    local w = 106
    local h = ((debugTextH * 2) + 10)

    local sW = getCore():getScreenWidth()
    local x = sW - w
    local sH = getCore():getScreenHeight()
    local y = sH - h

    if not fixifierUI then
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
        newUI.ui = newUI:getJavaObject()
        newUI.ui:setConsumeMouseEvents(false)
        newUI:backMost()
        fixifierUI = newUI
    end

    if not fixifierUI then return end

    if not gagOver then
        local reader = getFileReader("aprilFools2024.txt", false)
        if reader then
            gagOver = true
            reader:close()
        end
    end

    if engageEvent and (not gagOver) then

        if #errorPopUpsXY>0 then
            local mx, my = getMouseX(), getMouseY()
            hoverOverFace = (ernestX and ernestY and mx >= ernestX and my >= ernestY and mx <= ernestX+ernestW and my <= ernestY+ernestH) or false
        end

        local g = math.max(0,math.min(math.floor(errorPopUps/10), 999))

        if hoverOverFace then
            for i=0, (#errorPopUpsXY/50) do
                errorPopUpsXY[#errorPopUpsXY] = nil
            end

            if #errorPopUpsXY <= 0 then
                local writer = getFileWriter("aprilFools2024.txt", true, false)
                writer:write("Fooled Ya! delete This file to re-enable the gag.")
                writer:close()
            end
        else
            errorPopUps = errorPopUps + 1 + g

            if #errorPopUpsXY < g then
                local bX, bY = ZombRand(0,sW), ZombRand(0,sH)
                table.insert(errorPopUpsXY, {bX, bY})
            end
        end

        for _,box in pairs(errorPopUpsXY) do
            local bX, bY = box[1], box[2]
            getRenderer():renderi(nil, bX-w, bY-h, w, h, 0.8, 0.0, 0.0, 1.0, nil)
            getRenderer():renderi(nil, bX+1-w, bY+1-h, w-2, debugTextH-1, 0.0, 0.0, 0.0, 1.0, nil)
            getTextManager():DrawStringCentre(UIFont.DebugConsole, (bX)-(w/2), bY-h, "APRIL", 1.0, 0.0, 0.0, 1.0)
            getTextManager():DrawStringCentre(UIFont.DebugConsole, (bX)-(w/2), bY+debugTextH-h, "FOOLS", 0.0, 0.0, 0.0, 1.0)
        end

        if g > 10 then
            local eX, eY = (sW/4)-(ernestW/2), (sH/2)-(ernestW/2)
            ernestX = eX
            ernestY = eY

            local msg = {"Well, would you look at that! Seems like all them errors we've been keepin' under wraps have sprung a leak!",
                         "But fear not, my friends, 'cause this Spiffo’s got just the solution. You see this face right here?",
                         "Well, I have some trusty ductape under my hat.",
                         " ",
                         "Just HOVER your mouse over my face, and we'll patch up them leaks quicker than quick!",
                         "So, let's roll up our sleeves and get to holdin', 'cause ain't no leak gonna dampen our spirits today!",
                         " ",
                         "Thanks for being a good sport, happy April-Fools, and remember there's no cure-alls in life.",
                         "Now, go tell all your friends to try this mod out!",
            }

            getRenderer():renderi(nil, 0, eY+(ernestH/5)-(largeTextH/2), sW, largeTextH*(#msg+1), 0.0, 0.0, 0.0, 0.8, nil)
            getRenderer():renderi(ernest, eX, eY+(ernestH/5), ernestW, ernestH, 1.0, 1.0, 1.0, 1.0, nil)

            for i,m in pairs(msg) do
                getTextManager():DrawString(UIFont.Large, eX+(ernestW*1.20), eY+(ernestH/5)+((largeTextH)*(i-1)), m, 1.0, 1.0, 1.0, 1.0)
            end

        end
    end

    fixifierUI.ui:setStencilRect(x, y, w , h)
    if (not isIngameState()) then fixifierUI.ui:clearStencilRect() end
end

Events.OnPostUIDraw.Add(fix)