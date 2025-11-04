-- cl_init.lua

include("shared.lua")

surface.CreateFont("PriceText", {
    font = "Trebuchet18",
    size = 14,
    weight = 600,
    antialias = true
})

function ENT:Initialize()
    self.AutomaticFrameAdvance = true
end

function ENT:Draw()
    self:DrawModel()
end

-- Listen for the net message sent by the server
net.Receive("ShowConversionMessage", function()
    local shmeckles = net.ReadInt(32)
    local cashConverted = net.ReadInt(32)

    -- Format the message
    local formattedShmeckles = tostring(shmeckles)
    local formattedCash = DarkRP.formatMoney(cashConverted)

    -- Create the formatted chat message
    local tab = {Color(255, 165, 0, 255), "Trash Collector: ", Color(255, 255, 255), 
                 "You converted " .. formattedShmeckles .. " shmeckles into ", Color(0, 255, 0), formattedCash}
    chat.AddText(unpack(tab))
end)

net.Receive("collectoropenmenu", function()
    local collector = net.ReadEntity()
    local TrashSellPrice = net.ReadInt(24)
    local npcname = net.ReadString()
    local ply = net.ReadEntity()

    local FormattedTrashSellPrice = DarkRP.formatMoney(TrashSellPrice)
    local title = "Trash Collector"
    local subtitle = "Hey! How much trash did you collect today?"
    local shmeckles = ply:GetNWInt("Shmeckles", 0)

    -- Frame / Base
    local menuWidth = ScrW() * 0.25
    local menuHeight = ScrH() * 0.2
    local collectormenu = vgui.Create("DFrame")
    collectormenu:SetSize(menuWidth, menuHeight)
    collectormenu:Center()
    collectormenu:MakePopup()
    collectormenu:SetDraggable(true)
    collectormenu:ShowCloseButton(true)
    collectormenu:SetTitle("")

    -- Button Sizes for reference
    local buttonw, buttonh = collectormenu:GetWide() / 2, collectormenu:GetTall() / 8

    -- Timer Label (Top Left)
    local countdownLabel = vgui.Create("DLabel", collectormenu)
    countdownLabel:SetPos(10, 80)
    countdownLabel:SetText("Time Left: --")
    countdownLabel:SetFont("PriceText")
    countdownLabel:SetTextColor(Color(255, 255, 255))
    countdownLabel:SizeToContents()

    -- Conversion Rate Text (Top Left, below the timer)
    local conversionRateLabel = vgui.Create("DLabel", collectormenu)
    conversionRateLabel:SetPos(10, 110)
    conversionRateLabel:SetText("Shmeckle Conversion Rate: " .. FormattedTrashSellPrice)
    conversionRateLabel:SetFont("PriceText")
    conversionRateLabel:SetTextColor(Color(255, 255, 255))
    conversionRateLabel:SizeToContents()

    collectormenu.Paint = function(self, w, h)
        -- Background
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 200))
        -- Titles
        draw.SimpleText(title .. " - " .. npcname, "Trebuchet24", 5, 15, Color(255, 165, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        draw.SimpleText(subtitle, "PriceText", 5, 35, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    -- Paycheck Button (Center aligned, first button)
    local cashout = vgui.Create("DButton", collectormenu)
    cashout:SetSize(buttonw, buttonh)
    cashout:SetPos((collectormenu:GetWide() - buttonw) - 10, (collectormenu:GetTall() - buttonh * 4) - 10)
    cashout:SetText("")
    cashout.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 120))

        local b1col
        if self.hover then
            b1col = Color(50, 255, 50, 255)
        else
            b1col = Color(255, 255, 255, 255)
        end

        -- Get the amount of shmeckles from the player
        local shmeckles = ply:GetNWInt("shmeckles", 0)

        -- Calculate the total value of shmeckles after conversion
        local FormattedShmeckles = DarkRP.formatMoney(shmeckles * TrashSellPrice)

        draw.SimpleText("Convert all shmeckles into cash.", "PriceText", w / 2, h / 2, b1col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    cashout.DoClick = function(activator)
        -- Send the net message to the server
        net.Start("cashouttrash")
        net.WriteEntity(collector)
        net.SendToServer()
        timer.Remove("UpdateRateTimer_" .. collector:EntIndex())
        collectormenu:Remove()
    end

    cashout.OnCursorEntered = function(self)
        surface.PlaySound("buttons/lightswitch2.wav")
        self.hover = true
    end

    cashout.OnCursorExited = function(self)
        self.hover = false
    end

    -- Timer to update the conversion rate and countdown every few seconds
    local updateInterval = 30
    local lastUpdateTime = CurTime()
    local nextUpdateTime = lastUpdateTime + updateInterval

    local function updateRate()
        local timeLeft = math.ceil(nextUpdateTime - CurTime())
        if timeLeft <= 0 then
            -- Update the rate when the timer hits 0
            FormattedTrashSellPrice = DarkRP.formatMoney(collector:GetTrashSellPrice())
            conversionRateLabel:SetText("Shmeckle Conversion Rate: " .. FormattedTrashSellPrice)
            conversionRateLabel:SizeToContents()

            nextUpdateTime = CurTime() + updateInterval
        end

        -- Update the countdown label
        countdownLabel:SetText("Time Left: " .. timeLeft .. "s")
        countdownLabel:SizeToContents()
    end

    timer.Create("UpdateRateTimer_" .. collector:EntIndex(), 1, 0, updateRate)

    collectormenu.OnClose = function()
        timer.Remove("UpdateRateTimer_" .. collector:EntIndex())
    end
end)
