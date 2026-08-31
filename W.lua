-- ============================================================
-- УНИВЕРСАЛЬНЫЙ WALLHACK + AIMBOT + ESP (ЛЮБАЯ ИГРА)
-- FSOCEITY XENO ULTRA
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

-- ========== ГУИ МЕНЮ ==========
local function createGUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "FSOCEITY_UNIVERSAL"
    sg.ResetOnSpawn = false
    sg.Parent = player:WaitForChild("PlayerGui")

    player:WaitForChild("PlayerGui").ChildRemoved:Connect(function(child)
        if child.Name == "FSOCEITY_UNIVERSAL" then
            wait(0.5)
            createGUI()
        end
    end)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 650)
    frame.Position = UDim2.new(0.5, -210, 0.5, -325)
    frame.BackgroundColor3 = Color3.fromRGB(5, 5, 25)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(0, 255, 200)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = sg

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 70)
    title.Text = "FSOCEITY ULTRA WH"
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

    local wallhackActive = false
    local aimbotActive = false
    local espActive = false
    local spinActive = false
    local spinSpeed = 15
    local oneTapActive = false

    -- ========== WALLHACK ==========
    local function wallhack()
        while wallhackActive do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hl = p.Character:FindFirstChild("Highlight")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Parent = p.Character
                    end
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                    hl.FillTransparency = 0.2
                    hl.OutlineTransparency = 0
                end
            end
            wait(0.3)
        end
    end

    -- ========== ESP ==========
    local function esp()
        while espActive do
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    local pos, onScreen = cam:WorldToScreenPoint(hrp.Position + Vector3.new(0, 3, 0))
                    if onScreen then
                        local bill = Instance.new("BillboardGui")
                        bill.Size = UDim2.new(0, 200, 0, 50)
                        bill.Adornee = hrp
                        bill.AlwaysOnTop = true
                        bill.Parent = hrp

                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        local hp = p.Character:FindFirstChild("Humanoid")
                        local health = hp and hp.Health or "?"
                        label.Text = p.Name .. " | " .. health .. " HP | " .. math.floor((root.Position - hrp.Position).Magnitude) .. "m"
                        label.TextColor3 = Color3.fromRGB(255, 255, 255)
                        label.TextScaled = true
                        label.Font = Enum.Font.GothamBold
                        label.Parent = bill
                        wait(0.5)
                        bill:Destroy()
                    end
                end
            end
            wait(0.5)
        end
    end

    -- ========== СПИН ==========
    local function startSpin()
        spinActive = true
        local camPos = cam.CFrame
        while spinActive do
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            cam.CFrame = camPos
            wait(0.01)
        end
    end

    -- ========== ONE TAP KILL ==========
    local function oneTap()
        oneTapActive = not oneTapActive
        print("[FSOCEITY] ONE TAP " .. (oneTapActive and "ВКЛ" or "ВЫКЛ"))
        if oneTapActive then
            game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
                if processed then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 and oneTapActive then
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if dist < 30 then
                                p.Character.Humanoid.Health = 0
                                print("[FSOCEITY] ONE TAP: " .. p.Name)
                            end
                        end
                    end
                end
            end)
        end
    end

    -- ========== КНОПКИ ==========
    makeBtn("🔴 WALLHACK (ВКЛ/ВЫКЛ)", Color3.fromRGB(200, 0, 0), 0.10, function()
        wallhackActive = not wallhackActive
        print("[FSOCEITY] Wallhack " .. (wallhackActive and "ВКЛ" or "ВЫКЛ"))
        if wallhackActive then spawn(wallhack) end
    end)

    makeBtn("🎯 AIMBOT (ВКЛ/ВЫКЛ)", Color3.fromRGB(100, 100, 200), 0.18, function()
        aimbotActive = not aimbotActive
        print("[FSOCEITY] Aimbot " .. (aimbotActive and "ВКЛ" or "ВЫКЛ"))
    end)

    makeBtn("📋 ESP (ВКЛ/ВЫКЛ)", Color3.fromRGB(0, 200, 0), 0.26, function()
        espActive = not espActive
        print("[FSOCEITY] ESP " .. (espActive and "ВКЛ" or "ВЫКЛ"))
        if espActive then spawn(esp) end
    end)

    makeBtn("⚡ ONE TAP KILL (ВКЛ/ВЫКЛ)", Color3.fromRGB(255, 0, 100), 0.34, function()
        oneTap()
    end)

    makeBtn("🌀 СПИН (ВКЛ/ВЫКЛ)", Color3.fromRGB(200, 100, 0), 0.42, function()
        if spinActive then
            spinActive = false
            print("[FSOCEITY] Спин ВЫКЛ")
        else
            spawn(startSpin)
            print("[FSOCEITY] Спин ВКЛ")
        end
    end)

    makeBtn("🐢 МЕДЛЕННЫЙ СПИН", Color3.fromRGB(100, 100, 100), 0.50, function()
        spinSpeed = 5
        print("[FSOCEITY] Спин медленный")
    end)

    makeBtn("🐇 БЫСТРЫЙ СПИН", Color3.fromRGB(255, 100, 0), 0.58, function()
        spinSpeed = 30
        print("[FSOCEITY] Спин быстрый")
    end)

    makeBtn("👻 НЕВИДИМОСТЬ", Color3.fromRGB(150, 0, 200), 0.66, function()
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

    makeBtn("💀 УБИТЬ ВСЕХ", Color3.fromRGB(180, 0, 0), 0.74, function()
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.Health = 0
            end
        end
        print("[FSOCEITY] ВСЕ УБИТЫ")
    end)

    makeBtn("❌ ЗАКРЫТЬ МЕНЮ", Color3.fromRGB(100, 0, 0), 0.82, function()
        sg:Destroy()
        print("[FSOCEITY] МЕНЮ ЗАКРЫТО")
    end)

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
                local shoot = game:GetService("ReplicatedStorage"):FindFirstChild("Shoot") or 
                              game:GetService("ReplicatedStorage"):FindFirstChild("Fire") or
                              game:GetService("ReplicatedStorage"):FindFirstChild("Attack")
                if shoot then shoot:FireServer() end
            end
        end
    end)

    -- ========== СТАТУС ==========
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, 0, 0, 30)
    status.Position = UDim2.new(0, 0, 0.90, 0)
    status.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
    status.Text = "FSOCEITY ULTRA | F1 - STOP"
    status.TextColor3 = Color3.fromRGB(100, 255, 100)
    status.TextScaled = true
    status.Font = Enum.Font.Gotham
    status.Parent = frame

    -- ========== F1 ==========
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.F1 then
            spinActive = false
            wallhackActive = false
            espActive = false
            aimbotActive = false
            oneTapActive = false
            sg:Destroy()
            print("[FSOCEITY] СКРИПТ ОСТАНОВЛЕН")
        end
    end)

    print("[FSOCEITY] УНИВЕРСАЛЬНЫЙ WALLHACK ЗАГРУЖЕН!")
end

createGUI()
