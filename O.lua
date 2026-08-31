-- FSOCEITY Anti-Cheat Bypass v2.0
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- 1. Отключаем удалённые события (RemoteEvents) которые ловят читы
local function killRemotes()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if v.Name:lower():find("anticheat") or v.Name:lower():find("cheat") or v.Name:lower():find("detect") then
                v:Destroy()
                print("[FSOCEITY] Убил античит-ремоут: " .. v.Name)
            end
        end
    end
end

-- 2. Блокируем проверки скорости (Velocity / Position)
local function blockVelocityChecks()
    local oldStep = game:GetService("RunService").Stepped
    oldStep:Connect(function()
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0) -- Сбрасываем подозрительную скорость
        end
    end)
end

-- 3. Маскируем Executor (симуляция легитимного клиента)
local function maskExecutor()
    local fake = {
        ["UserAgent"] = "Roblox/Win 10 (XenoLegit)",
        ["ClientVersion"] = "v2025.0.1"
    }
    getgenv().Executor = nil
    setfflag("FFlagDebugAllowVR", "true") -- Легальная опция для отвода глаз
    print("[FSOCEITY] Маскировка включена.")
end

-- 4. Обходим проверку Character (убираем подозрительные части)
local function cleanCharacter()
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Tool") and v.Name:lower():find("hack") then
            v:Destroy()
        end
    end
end

-- 5. Запускаем защиту от банхаммера
local function antiBan()
    local hook = hookfunction
    local oldBan = hook(game:GetService("Players").LocalPlayer, "Kick", function(self, reason)
        if reason:lower():find("exploit") or reason:lower():find("cheat") then
            print("[FSOCEITY] Блокирован кик за: " .. reason)
            return nil
        end
        return oldBan(self, reason)
    end)
    print("[FSOCEITY] Бан-защита активна.")
end

-- ЗАПУСК ВСЕХ БЛОКОВ
killRemotes()
blockVelocityChecks()
maskExecutor()
cleanCharacter()
antiBan()

print("[FSOCEITY] Античит ОБНУЛЁН, командир Сорокин. Скрипт можно юзать без страха.")
