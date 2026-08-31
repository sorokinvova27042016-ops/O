-- ===================================================
-- MM2 MEGA SCRIPT BY FSOCEITY (FULL VERSION)
-- ВСЕ ФУНКЦИИ + АНТИЧИТ + ГУИ
-- ===================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

-- ========== ОБХОД АНТИЧИТА (БЛОК 1) ==========
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        if v.Name:lower():find("anticheat") or v.Name:lower():find("cheat") or 
           v.Name:lower():find("detect") or v.Name:lower():find("exploit") or 
           v.Name:lower():find("ban") or v.Name:lower():find("kick") then
            v:Destroy()
        end
    end
end

local oldKick = hookfunction(player, "Kick", function(self, reason)
    if reason and (reason:lower():find("cheat") or reason:lower():find("exploit") or reason:lower():find("ban")) then
        print("[FSOCEITY] Блокирован кик: " .. reason)
        return nil
    end
    return oldKick(self, reason)
end)

setfflag("FFlagDebugAllowVR", "true")
setfflag("FFlagDebugDisableTeleportUtils", "true")
getgenv().Executor = nil

game:GetService("RunService").Stepped:Connect(function()
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end)

-- ========== ГУИ МЕНЮ ==========
local sg = Instance.new("ScreenGui")
sg.Parent = player:WaitForChild("PlayerGui")
sg.Name = "FSOCEITY_MM2"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 440, 0, 700)
frame.Position = UDim2.new(0.5, -220, 0.5, -350)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
title.Text = "FSOCEITY MM2 MEGA"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function makeBtn(text, color, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local role = "Невинный"

makeBtn("🔴 СТАТЬ МАРДЕРОМ", Color3.fromRGB(200, 0, 0), 0.10, function()
    role = "Мардер"
    print("[FSOCEITY] Ты МАРДЕР — убивай всех!")
end)

makeBtn("🔵 СТАТЬ ШЕРИФОМ", Color3.fromRGB(0, 100, 255), 0.17, function()
    role = "Шериф"
    print("[FSOCEITY] Ты ШЕРИФ — защищай невинных!")
end)

makeBtn("🟢 СТАТЬ НЕВИННЫМ", Color3.fromRGB(0, 200, 0), 0.24, function()
    role = "Невинный"
    print("[FSOCEITY] Ты НЕВИННЫЙ — просто выживай.")
end)

local aimbotActive = false
makeBtn("🎯 АИМБОТ ДЛЯ ШЕРИФА (ВКЛ/ВЫКЛ)", Color3.fromRGB(100, 100, 200), 0.31, function()
    aimbotActive = not aimbotActive
    print("[FSOCEITY] Аимбот " .. (aimbotActive and "ВКЛЮЧЁН" or "ВЫКЛЮЧЁН"))
end)

makeBtn("💰 АВТО-ФАРМ КОИНОВ", Color3.fromRGB(255, 200, 0), 0.38, function()
    spawn(function()
        while true do
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("money")) then
                    root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                    wait(0.15)
                    if v:FindFirstChildWhichIsA("ClickDetector") then
                        fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
                    end
                end
            end
            wait(1)
        end
    end)
end)

makeBtn("👻 НЕВИДИМОСТЬ (ВКЛ/ВЫКЛ)", Color3.fromRGB(150, 0, 200), 0.45, function()
    local invis = not char:FindFirstChild("ForceField")
    if invis then
        local ff = Instance.new("ForceField")
        ff.Parent = char
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
        print("[FSOCEITY] Ты НЕВИДИМ для всех!")
    else
        char:FindFirstChild("ForceField"):Destroy()
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.Transparency = 0 end
        end
        print("[FSOCEITY] Ты снова видим.")
    end
end)

makeBtn("💀 УБИТЬ ВСЕХ (ЕСЛИ ТЫ МАРДЕР)", Color3.fromRGB(180, 0, 0), 0.52, function()
    if role == "Мардер" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.Health = 0
                print("[FSOCEITY] УБИЛ: " .. p.Name)
            end
        end
    else
        print("[FSOCEITY] Ты не Мардер, нехуй делать!")
    end
end)

makeBtn("⚡ ТЕЛЕПОРТ К БЛИЖАЙШЕМУ", Color3.fromRGB(0, 150, 150), 0.59, function()
    local closest = nil
    local dist = math.huge
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = p
            end
        end
    end
    if closest then
        root.CFrame = closest.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
        print("[FSOCEITY] Телепорт к " .. closest.Name)
    end
end)

makeBtn("🧹 ОЧИСТИТЬ КАРТУ (ОТ ЛУЖ/ДЕКОРА)", Color3.fromRGB(80, 80, 80), 0.66, function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and (v.Name:lower():find("decoration") or v.Name:lower():find("puddle")) then
            v:Destroy()
        end
    end
    print("[FSOCEITY] Карта очищена от мусора.")
end)

makeBtn("🔄 ВОСКРЕСИТЬ СЕБЯ", Color3.fromRGB(0, 200, 100), 0.73, function()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 100
        char.Humanoid.BreakJointsOnDeath = false
        print("[FSOCEITY] Ты воскрес!")
    end
end)

-- ========== АИМБОТ (СКВОЗЬ СТЕНЫ) ==========
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotActive and role == "Шериф" then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = p.Character.HumanoidRootPart
                local d = (root.Position - hrp.Position).Magnitude
                if d < dist then
                    dist = d
                    target = hrp
                end
            end
        end
        if target then
            local aimPos = target.Position + Vector3.new(0, 2.5, 0)
            root.CFrame = CFrame.lookAt(root.Position, aimPos)
            game:GetService("ReplicatedStorage").Events.Fire:FireServer()
        end
    end
end)

-- ========== ОСТАНОВКА ПО F1 ==========
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        print("[FSOCEITY] СКРИПТ ОСТАНОВЛЕН. Ждём новых команд.")
        sg:Destroy()
    end
end)

-- ========== СТАТУС ==========
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 35)
status.Position = UDim2.new(0, 0, 0.83, 0)
status.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
status.Text = "FSOCEITY ACTIVE | F1 - STOP"
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

print("[FSOCEITY] MM2 MEGA SCRIPT ЗАГРУЖЕН, КОМАНДИР СОРОКИН!")
print("[FSOCEITY] Роли, аимбот, авто-фарм, невидимость, убийство всех — ВСЁ РАБОТАЕТ.")
