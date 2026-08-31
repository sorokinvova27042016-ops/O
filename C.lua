-- FSOCEITY Xeno 99 Nights - Full GUI Menu
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "FSOCEITY_MENU"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0.5, -175, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
title.Text = "FSOCEITY XENO FARM"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Кнопка "Найти алмазы"
local btnFind = Instance.new("TextButton")
btnFind.Size = UDim2.new(0.9, 0, 0, 40)
btnFind.Position = UDim2.new(0.05, 0, 0.15, 0)
btnFind.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btnFind.Text = "🔍 НАЙТИ АЛМАЗЫ"
btnFind.TextColor3 = Color3.fromRGB(255, 255, 255)
btnFind.Parent = frame
btnFind.MouseButton1Click:Connect(function()
    local gems = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and (v.Name:lower():find("diamond") or v.Name:lower():find("ore")) then
            table.insert(gems, v)
        end
    end
    print("[FSOCEITY] Найдено алмазов: " .. #gems)
    for _, g in pairs(gems) do
        root.CFrame = g.CFrame + Vector3.new(0, 3, 0)
        wait(0.2)
        if g:FindFirstChildWhichIsA("ClickDetector") then
            fireclickdetector(g:FindFirstChildWhichIsA("ClickDetector"))
        end
    end
end)

-- Кнопка "Телепорт к игрокам"
local btnTP = Instance.new("TextButton")
btnTP.Size = UDim2.new(0.9, 0, 0, 40)
btnTP.Position = UDim2.new(0.05, 0, 0.30, 0)
btnTP.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btnTP.Text = "🚀 ТЕЛЕПОРТ К ИГРОКАМ"
btnTP.TextColor3 = Color3.fromRGB(255, 255, 255)
btnTP.Parent = frame
btnTP.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            wait(0.5)
        end
    end
end)

-- Кнопка "Обход античита"
local btnAC = Instance.new("TextButton")
btnAC.Size = UDim2.new(0.9, 0, 0, 40)
btnAC.Position = UDim2.new(0.05, 0, 0.45, 0)
btnAC.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btnAC.Text = "🛡️ ОБХОД АНТИЧИТА"
btnAC.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAC.Parent = frame
btnAC.MouseButton1Click:Connect(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:lower():find("anticheat") or v.Name:lower():find("cheat")) then
            v:Destroy()
        end
    end
    print("[FSOCEITY] Античит обнулён.")
end)

-- Кнопка "Автофарм (цикл)"
local btnAuto = Instance.new("TextButton")
btnAuto.Size = UDim2.new(0.9, 0, 0, 40)
btnAuto.Position = UDim2.new(0.05, 0, 0.60, 0)
btnAuto.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
btnAuto.Text = "♻️ АВТОФАРМ (ВКЛ)"
btnAuto.TextColor3 = Color3.fromRGB(255, 255, 255)
btnAuto.Parent = frame

local autoRunning = false
btnAuto.MouseButton1Click:Connect(function()
    autoRunning = not autoRunning
    btnAuto.Text = autoRunning and "⏹️ АВТОФАРМ (ВЫКЛ)" or "♻️ АВТОФАРМ (ВКЛ)"
    while autoRunning do
        for _, p in pairs(game.Players:GetPlayers()) do
            if not autoRunning then break end
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                wait(0.5)
                for _, g in pairs(workspace:GetDescendants()) do
                    if not autoRunning then break end
                    if g:IsA("Part") and (g.Name:lower():find("diamond") or g.Name:lower():find("ore")) then
                        root.CFrame = g.CFrame + Vector3.new(0, 3, 0)
                        wait(0.2)
                        if g:FindFirstChildWhichIsA("ClickDetector") then
                            fireclickdetector(g:FindFirstChildWhichIsA("ClickDetector"))
                        end
                    end
                end
            end
        end
        wait(2)
    end
end)

-- Статус
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 0.80, 0)
status.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
status.Text = "FSOCEITY ACTIVE | F1 - STOP"
status.TextColor3 = Color3.fromRGB(150, 255, 150)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- Остановка всего по F1
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        autoRunning = false
        print("[FSOCEITY] Всё остановлено. Ждём команд.")
    end
end)

print("[FSOCEITY] Меню загружено, командир Сорокин. Жми кнопки, ебашь алмазы!")
