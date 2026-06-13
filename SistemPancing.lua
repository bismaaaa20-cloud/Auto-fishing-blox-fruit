if not getgenv().SystemLoaded then
    getgenv().SystemLoaded = true
    getgenv().AutoFishingState = false
    getgenv().FishingMode = "Perfect" 
    getgenv().TargetType = "Chest"      
    getgenv().AutoOpenAllChests = true
    getgenv().AntiAfkEnabled = true
    getgenv().FpsBoostEnabled = false
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if getgenv().FpsBoostEnabled then
            RunService:Set3dRenderingEnabled(false)
            setfpscap(15) 
        else
            RunService:Set3dRenderingEnabled(true)
            setfpscap(60)
        end
    end)
end)

task.spawn(function()
    LocalPlayer.Idled:Connect(function(waktuDiam)
        if getgenv().AntiAfkEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end
    end)
end)

local function kelolaAlatPancing()
    local character = LocalPlayer.Character
    if not character then return nil end
    local rod = nil
    for _, item in pairs(character:GetChildren()) do
        if item:IsA("Tool") and (string.find(string.lower(item.Name), "rod") or string.find(string.lower(item.Name), "pancing")) then
            rod = item; break
        end
    end
    if not rod then
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and (string.find(string.lower(item.Name), "rod") or string.find(string.lower(item.Name), "pancing")) then
                LocalPlayer.Character.Humanoid:EquipTool(item)
                rod = item; task.wait(0.3); break
            end
        end
    end
    if rod and (rod:GetAttribute("Cast") == false or not rod:FindFirstChild("Bobber")) then
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        task.wait(2)
    end
    return rod
end

local function prosesBukaSemuaPeti()
    local character = LocalPlayer.Character
    if not character or not getgenv().AutoOpenAllChests then return end
    local targetPeti = nil
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and string.find(string.lower(item.Name), "chest") then
            targetPeti = item; break
        end
    end
    if targetPeti then
        for _, item in pairs(character:GetChildren()) do
            if item:IsA("Tool") then item.Parent = LocalPlayer.Backpack end
        end
        task.wait(0.2)
        LocalPlayer.Character.Humanoid:EquipTool(targetPeti)
        task.wait(0.4)
        for i = 1, 12 do
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.04)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            task.wait(0.08)
        end
        task.wait(1.5)
    end
end

task.spawn(function()
    local isHolding = false
    while true do
        task.wait(0.005)
        if getgenv().AutoFishingState then
            prosesBukaSemuaPeti()
            local rod = kelolaAlatPancing()
            if rod then
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local fishingGui = playerGui and (playerGui:FindFirstChild("FishingGui") or playerGui:FindFirstChild("FishingGame"))
                
                if fishingGui and fishingGui.Enabled then
                    if getgenv().FishingMode == "Perfect" then
                        local zonaHijau = fishingGui:FindFirstChild("GreenZone") or fishingGui:FindFirstChild("BarGreen")
                        local ikonIkan = fishingGui:FindFirstChild("FishBlue") or fishingGui:FindFirstChild("Fish")
                        local ikonPeti = fishingGui:FindFirstChild("ChestYellow") or fishingGui:FindFirstChild("Chest") or fishingGui:FindFirstChild("SunkenChest")
                        
                        if zonaHijau then
                            local lebarHijau = zonaHijau.AbsoluteSize.X
                            local pusatHijau = zonaHijau.AbsolutePosition.X + (lebarHijau / 2)
                            
                            if getgenv().TargetType == "Chest" then
                                if ikonIkan and not ikonPeti then
                                    local posisiIkan = ikonIkan.AbsolutePosition.X + (ikonIkan.AbsoluteSize.X / 2)
                                    if posisiIkan > pusatHijau then
                                        if isHolding then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1); isHolding = false end
                                    else
                                        if not isHolding then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1); isHolding = true end
                                    end
                                elseif ikonPeti then
                                    local posisiPeti = ikonPeti.AbsolutePosition.X + (ikonPeti.AbsoluteSize.X / 2)
                                    local batasToleransi = lebarHijau * 0.2
                                    if posisiPeti > pusatHijau + batasToleransi then
                                        if not isHolding then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1); isHolding = true end
                                    elseif posisiPeti < pusatHijau - batasToleransi then
                                        if isHolding then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1); isHolding = false end
                                    end
                                end
                            end
                            local progressBar = fishingGui:FindFirstChild("ProgressBar") or fishingGui:FindFirstChild("Bar")
                            if progressBar and progressBar.Size.X.Scale >= 0.97 then
                                if isHolding then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1); isHolding = false; task.wait(1) end
                            end
                        end
                    elseif getgenv().FishingMode == "Instant" then
                        if rod:GetAttribute("Bite") == true or fishingGui:GetAttribute("CanReel") == true then
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                            task.wait(0.05)
                            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                            task.wait(1)
                        end
                    end
                else
                    if isHolding then VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1); isHolding = false end
                    local catchNotification = playerGui:FindFirstChild("CatchNotification") or playerGui:FindFirstChild("AppraiseFrame") or playerGui:FindFirstChild("RewardGui")
                    if catchNotification and (catchNotification.Enabled or (catchNotification:FindFirstChild("Frame") and catchNotification.Frame.Visible)) then
                        for i = 1, 3 do
                            VirtualInputManager:SendMouseButtonEvent(100, 100, 0, true, game, 1); task.wait(0.02)
                            VirtualInputManager:SendMouseButtonEvent(100, 100, 0, false, game, 1); task.wait(0.05)
                        end
                    end
                    local mainGui = playerGui:FindFirstChild("Main") or playerGui:FindFirstChild("HUD")
                    if mainGui and mainGui:FindFirstChild("FishingPower") and mainGui.FishingPower:GetAttribute("Full") == true then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game); task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Z, false, game); task.wait(1)
                    end
                end
            end
        end
    end
end)
