-- ============================================================
-- XENO 99 NIGHTS MEGA SCRIPT BY FSOCEITY (С ГАРАНТИРОВАННЫМ МЕНЮ)
-- ============================================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- ========== ОБХОД АНТИЧИТА ==========
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

-- ========== ГАРАНТИРОВАННОЕ МЕНЮ (С ЗАЩИТОЙ ОТ УДАЛЕНИЯ) ==========
local function createGUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "FSOCEITY_XENO"
    sg.ResetOnSpawn = false
    sg.Parent = player:WaitForChild("PlayerGui")

    -- Если GUI удалили — пересоздаём через 0.5 сек
    player:WaitForChild("PlayerGui").ChildRemoved:Connect(function(child)
        if child.Name == "FSOCEITY_XENO" then
            wait(0.5)
            createGUI()
        end
    end)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 450, 0, 700)
    frame.Position = UDim2.new(0.5, -225, 0.5, -350)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 255, 200)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    title.Text = "FSOCEITY XENO MEGA"
    title.TextColor3 = Color3.fromRGB(0, 255, 200)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local function makeBtn(text, color, posY, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 42)
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
    local spinActive = false
    local spinSpeed = 15

    -- ========== ФУНКЦИЯ СПИНА ==========
    local function startSpin()
        spinActive = true
        local camPos = cam.CFrame
        while spinActive do
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            cam.CFrame = camPos
            wait(0.01)
        end
    end

    -- ========== КНОПКИ ==========
    makeBtn("💎 ФАРМ АЛМАЗОВ (АВТО)", Color3.fromRGB(0, 200, 255), 0.10, function()
        autoFarmActive = not autoFarmActive
        print("[FSOCEITY] Фарм " .. (autoFarmActive and "ВКЛ" or "ВЫКЛ"))
        if autoFarmActive then
            spawn(function()
                while autoFarmActive do
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Part") and (v.Name:lower():find("diamond") or v.Name:lower():find("ore") or v.Name:lower():find("gem")) then
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
        end
    end)

    makeBtn("🎯 АИМБОТ (НА ИГРОКОВ)", Color3.fromRGB(100, 100, 200), 0.18, function()
        aimbotActive = not aimbotActive
        print("[FSOCEITY] Аимбот " .. (aimbotActive and "ВКЛ" or "ВЫКЛ"))
    end)

    makeBtn("🌀 СПИН (КРУТИЛКА) ВКЛ/ВЫКЛ", Color3.fromRGB(200, 100, 0), 0.26, function()
        if spinActive then
            spinActive = false
            print("[FSOCEITY] СПИН ВЫКЛ")
        else
            spawn(startSpin)
            print("[FSOCEITY] СПИН ВКЛ")
        end
    end)

    makeBtn("🐢 МЕДЛЕННЫЙ СПИН", Color3.fromRGB(100, 100, 100), 0.34, function()
        spinSpeed = 5
        print("[FSOCEITY] СПИН МЕДЛЕННЫЙ")
    end)

    makeBtn("🐇 БЫСТРЫЙ СПИН", Color3.fromRGB(255, 100, 0), 0.42, function()
        spinSpeed = 30
        print("[FSOCEITY] СПИН БЫСТРЫЙ")
    end)

    makeBtn("👻 НЕВИДИМОСТЬ", Color3.fromRGB(150, 0, 200), 0.50, function()
        local invis = not char:FindFirstChild("ForceField")
        if invis then
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

    makeBtn("⚡ ТЕЛЕПОРТ К ИГРОКАМ", Color3.fromRGB(0, 150, 150), 0.58, function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                wait(0.3)
            end
        end
        print("[FSOCEITY] ТЕЛЕПОРТ КО ВСЕМ")
    end)

    makeBtn("💀 УБИТЬ ВСЕХ", Color3.fromRGB(180, 0, 0), 0.66, function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.Health = 0
            end
        end
        print("[FSOCEITY] ВСЕ УБИТЫ")
    end)

    makeBtn("🔄 ВОСКРЕСИТЬ СЕБЯ", Color3.fromRGB(0, 200, 100), 0.74, function()
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 100
            char.Humanoid.BreakJointsOnDeath = false
            print("[FSOCEITY] ВОСКРЕС")
        end
    end)

    makeBtn("📦 ВСЕ ОРУЖИЯ", Color3.fromRGB(200, 200, 0), 0.82, function()
        for _, tool in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if tool:IsA("Tool") then
                local clone = tool:Clone()
                clone.Parent = player.Backpack
            end
        end
        print("[FSOCEITY] ВСЕ ОРУЖИЯ ВЫДАНЫ")
    end)

    makeBtn("❌ ЗАКРЫТЬ МЕНЮ", Color3.fromRGB(100, 0, 0), 0.90, function()
        sg:Destroy()
        print("[FSOCEITY] МЕНЮ ЗАКРЫТО")
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

    -- ========== АИМБОТ ==========
    game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotActive then
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
                root.CFrame = CFrame.lookAt(root.Position, target.Position + Vector3.new(0, 2.5, 0))
                -- Авто-атака (если есть RemoteEvent)
                local attack = game:GetService("ReplicatedStorage"):FindFirstChild("Attack")
                if attack then attack:FireServer() end
            end
        end
    end)

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

    print("[FSOCEITY] XENO MEGA GUI ЗАГРУЖЕН!")
end

-- ========== ЗАПУСК ==========
createGUI()
