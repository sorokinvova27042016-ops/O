-- ============================================================
-- MM2 MEGA SCRIPT BY FSOCEITY (WALLHACK + СПИН + ВСЁ ВКЛЮЧЕНО)
-- ============================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- ========== ОБХОД АНТИЧИТА (МАКСИМУМ) ==========
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        if v.Name:lower():find("anticheat") or v.Name:lower():find("cheat") or 
           v.Name:lower():find("detect") or v.Name:lower():find("exploit") or 
           v.Name:lower():find("ban") or v.Name:lower():find("kick") or
           v.Name:lower():find("admin") or v.Name:lower():find("mod") then
            v:Destroy()
        end
    end
end

local oldKick = hookfunction(player, "Kick", function(self, reason)
    if reason and (reason:lower():find("cheat") or reason:lower():find("exploit") or reason:lower():find("ban")) then
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

-- ========== ОПРЕДЕЛЕНИЕ РОЛИ ==========
local function getPlayerRole(p)
    local role = "Невинный"
    if p:FindFirstChild("Role") then
        role = p.Role.Value
    elseif p:FindFirstChild("playerRole") then
        role = p.playerRole.Value
    elseif p:FindFirstChild("Murderer") then
        role = "Мардер"
    elseif p:FindFirstChild("Sheriff") then
        role = "Шериф"
    end
    return role
end

-- ========== WALLHACK (ЦВЕТА) ==========
spawn(function()
    while true do
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character then
                local highlight = p.Character:FindFirstChild("Highlight")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Parent = p.Character
                end
                local role = getPlayerRole(p)
                if role == "Мардер" or role == "Murderer" then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Шериф" or role == "Sheriff" then
                    highlight.FillColor = Color3.fromRGB(0, 100, 255)
                    highlight.OutlineColor = Color3.fromRGB(0, 100, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                end
                highlight.FillTransparency = 0.3
                highlight.OutlineTransparency = 0
            end
        end
        wait(0.3)
    end
end)

-- ========== СПИН (КРУТИЛКА) С ФИКСАЦИЕЙ КАМЕРЫ ==========
local spinActive = false
local spinSpeed = 10

local function startSpin()
    spinActive = true
    local camPos = cam.CFrame
    while spinActive do
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
        cam.CFrame = camPos  -- камера остаётся на месте
        wait(0.01)
    end
end

-- ========== ГУИ МЕНЮ (БОЛЬШОЕ) ==========
local sg = Instance.new("ScreenGui")
sg.Name = "FSOCEITY_MM2"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 480, 0, 780)
frame.Position = UDim2.new(0.5, -240, 0.5, -390)
frame.BackgroundColor3 = Color3.fromRGB(5, 5, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 200, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
title.Text = "FSOCEITY MM2 MEGA PRO"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function makeBtn(text, color, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local aimbotActive = false
local autoFarmActive = false
local invisActive = false

-- ========== КНОПКИ ==========
makeBtn("🎯 АИМБОТ (ШЕРИФ) ВКЛ/ВЫКЛ", Color3.fromRGB(100, 100, 200), 0.10, function()
    aimbotActive = not aimbotActive
    print("[FSOCEITY] Аимбот " .. (aimbotActive and "ВКЛ" or "ВЫКЛ"))
end)

makeBtn("💰 АВТО-ФАРМ КОИНОВ", Color3.fromRGB(255, 200, 0), 0.17, function()
    autoFarmActive = not autoFarmActive
    print("[FSOCEITY] Фарм " .. (autoFarmActive and "ВКЛ" or "ВЫКЛ"))
    if autoFarmActive then
        spawn(function()
            while autoFarmActive do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Part") and (v.Name:lower():find("coin") or v.Name:lower():find("money")) then
                        root.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                        wait(0.1)
                        if v:FindFirstChildWhichIsA("ClickDetector") then
                            fireclickdetector(v:FindFirstChildWhichIsA("ClickDetector"))
                        end
                    end
                end
                wait(0.5)
            end
        end)
    end
end)

makeBtn("👻 НЕВИДИМОСТЬ", Color3.fromRGB(150, 0, 200), 0.24, function()
    invisActive = not invisActive
    if invisActive then
        local ff = Instance.new("ForceField")
        ff.Parent = char
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.Transparency = 1 end
        end
        print("[FSOCEITY] НЕВИДИМ")
    else
        if char:FindFirstChild("ForceField") then char:FindFirstChild("ForceField"):Destroy() end
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("BasePart") then p.Transparency = 0 end
        end
        print("[FSOCEITY] ВИДИМ")
    end
end)

makeBtn("💀 УБИТЬ ВСЕХ (МАРДЕР)", Color3.fromRGB(180, 0, 0), 0.31, function()
    if getPlayerRole(player) == "Мардер" then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.Health = 0
            end
        end
        print("[FSOCEITY] ВСЕ УБИТЫ")
    else
        print("[FSOCEITY] ТЫ НЕ МАРДЕР")
    end
end)

makeBtn("🔫 УБИТЬ МАРДЕРА (ШЕРИФ)", Color3.fromRGB(0, 100, 255), 0.38, function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
            if getPlayerRole(p) == "Мардер" then
                p.Character.Humanoid.Health = 0
                print("[FSOCEITY] МАРДЕР УБИТ: " .. p.Name)
                break
            end
        end
    end
end)

makeBtn("⚡ ТЕЛЕПОРТ К МАРДЕРУ", Color3.fromRGB(0, 150, 150), 0.45, function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if getPlayerRole(p) == "Мардер" then
                root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                print("[FSOCEITY] ТЕЛЕПОРТ К " .. p.Name)
                break
            end
        end
    end
end)

makeBtn("🌀 КРУТИЛКА (СПИН) ВКЛ/ВЫКЛ", Color3.fromRGB(200, 100, 0), 0.52, function()
    if spinActive then
        spinActive = false
        print("[FSOCEITY] СПИН ВЫКЛ")
    else
        spawn(startSpin)
        print("[FSOCEITY] СПИН ВКЛ")
    end
end)

makeBtn("🐢 МЕДЛЕННЫЙ СПИН", Color3.fromRGB(100, 100, 100), 0.59, function()
    spinSpeed = 5
    print("[FSOCEITY] СПИН МЕДЛЕННЫЙ")
end)

makeBtn("🐇 БЫСТРЫЙ СПИН", Color3.fromRGB(255, 100, 0), 0.66, function()
    spinSpeed = 25
    print("[FSOCEITY] СПИН БЫСТРЫЙ")
end)

makeBtn("🔄 ВОСКРЕСИТЬ СЕБЯ", Color3.fromRGB(0, 200, 100), 0.73, function()
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 100
        char.Humanoid.BreakJointsOnDeath = false
        print("[FSOCEITY] ВОСКРЕС")
    end
end)

makeBtn("📦 ВСЕ ОРУЖИЯ", Color3.fromRGB(200, 200, 0), 0.80, function()
    for _, tool in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
        if tool:IsA("Tool") then
            local clone = tool:Clone()
            clone.Parent = player.Backpack
        end
    end
    print("[FSOCEITY] ВСЕ ОРУЖИЯ ВЫДАНЫ")
end)

makeBtn("❌ ЗАКРЫТЬ МЕНЮ", Color3.fromRGB(100, 0, 0), 0.88, function()
    sg:Destroy()
    print("[FSOCEITY] МЕНЮ ЗАКРЫТО")
end)

-- ========== АИМБОТ (СКВОЗЬ СТЕНЫ) ==========
game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotActive then
        local target = nil
        local dist = math.huge
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if getPlayerRole(p) == "Мардер" then
                    local hrp = p.Character.HumanoidRootPart
                    local d = (root.Position - hrp.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = hrp
                    end
                end
            end
        end
        if target then
            root.CFrame = CFrame.lookAt(root.Position, target.Position + Vector3.new(0, 2.5, 0))
            game:GetService("ReplicatedStorage").Events.Fire:FireServer()
        end
    end
end)

-- ========== СТАТУС ==========
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0.94, 0)
status.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
status.Text = "FSOCEITY ACTIVE | F1 - STOP"
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- ========== F1 ==========
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        spinActive = false
        autoFarmActive = false
        sg:Destroy()
        print("[FSOCEITY] СКРИПТ ОСТАНОВЛЕН")
    end
end)

print("[FSOCEITY] MM2 MEGA PRO ЗАГРУЖЕН! СПИН, АИМБОТ, WALLHACK, ВСЁ РАБОТАЕТ.")
