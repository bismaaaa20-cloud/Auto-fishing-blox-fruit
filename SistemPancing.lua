-- ====================================================================
-- BAGIAN 1: PENGATURAN DEFAULT & SERVICES (Y-AXIS FIX)
-- ====================================================================
if not getgenv().SystemLoaded then
    getgenv().SystemLoaded = true
    getgenv().AutoFishingState = false
    getgenv().FishingMode = "Perfect" 
    getgenv().TargetType = "Chest"      
    getgenv().AutoOpenAllChests = true
    getgenv().AntiAfkEnabled = true
    getgenv().FpsBoostEnabled = false
    getgenv().AutoSellEnabled = true 
    getgenv().SafeZoneTeleport = true 
    getgenv().AutoBuyBaitEnabled = true
    getgenv().SelectedBaitType = "Basic"
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- ====================================================================
-- BAGIAN 2: OPTIMASI PERANGKAT & ANTI-REPORT
-- ====================================================================
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
    LocalPlayer.Idled:Connect(function()
        if getgenv().AntiAfkEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end
    end)
end)

local function secureLocation()
    local character = LocalPlayer.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if hrp and getgenv().SafeZoneTeleport then
        if (hrp.Position - Vector3.new(0, 0, 0)).Magnitude < 150 then
            hrp.CFrame = CFrame.new(1420, -12, -3250)
            task.wait(0.5)
        end
    end
end
-- ====================================================================
-- BAGIAN 3: SISTEM TRANSAKSI TOKO (AUTO BUY & SELL)
-- ====================================================================
local function periksaDanBeliUmpan()
    if not getgenv().AutoBuyBaitEnabled then return end
    local dataFolder = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData") or LocalPlayer:FindFirstChild("leaderstats")
    local baitAmount = 0
    
    if dataFolder and dataFolder:FindFirstChild("Bait") then
        baitAmount = dataFolder.Bait.Value
    else
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local mainGui = playerGui and (playerGui:FindFirstChild("Main") or playerGui:FindFirstChild("HUD") or playerGui:FindFirstChild("FishingItemGui"))
        local baitLabel = mainGui and mainGui:FindFirstChild("BaitAmount", true) or mainGui:FindFirstChild("Amount", true)
        if baitLabel and baitLabel:IsA("TextLabel") then
            baitAmount = tonumber(string.match(baitLabel.Text, "%d+")) or 0
        end
    end
    
    if baitAmount <= 0 then
        local fishingRemote = ReplicatedStorage:FindFirstChild("FishingRemote", true) 
            or ReplicatedStorage:FindFirstChild("FishingEvent", true) 
            or ReplicatedStorage:FindFirstChild("FishingComm", true)
            
        if fishingRemote and fishingRemote:IsA("RemoteEvent") then
            fishingRemote:FireServer("BuyBait", getgenv().SelectedBaitType, 10)
            task.wait(1.5)
        end
    end
end

local function checkInventoryAndSell()
    if not getgenv().AutoSellEnabled then return end
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local inventoryGui = playerGui and (playerGui:FindFirstChild("Inventory") or playerGui:FindFirstChild("BagGui") or playerGui:FindFirstChild("FishingItemGui"))
    local isFull = false
    
    if inventoryGui and (string.find(string.lower(tostring(inventoryGui)), "full") or string.find(string.lower(tostring(inventoryGui)), "max")) then
        isFull = true
    end
    
    if isFull then
        local fishingRemote = ReplicatedStorage:FindFirstChild("FishingRemote", true) 
            or ReplicatedStorage:FindFirstChild("FishingEvent", true) 
            or ReplicatedStorage:FindFirstChild("FishingComm", true)
            
        if fishingRemote and fishingRemote:IsA("RemoteEvent") then
            fishingRemote:FireServer("SellFish")
            task.wait(0.5)
            fishingRemote:FireServer("SellAll")
            task.wait(1.5)
        end
    end
end
-- ====================================================================
-- BAGIAN 4: MANAJEMEN ALAT PANCING & BITE DETECTOR
-- ====================================================================
local function kelolaAlatPancing()
    secureLocation() 
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
                rod = item; task.wait(0.4); break
            end
        end
    end
    
    if rod and (rod:GetAttribute("Cast") == false or not rod:FindFirstChild("Bobber")) then
        checkInventoryAndSell() 
        periksaDanBeliUmpan() 
        
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.08)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        task.wait(2.2) 
        
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        while getgenv().AutoFishingState and (rod:GetAttribute("Cast") == true or rod:FindFirstChild("Bobber")) do
            local biteGui = playerGui:FindFirstChild("BiteGui") or playerGui:FindFirstChild("FishingGui") or playerGui:FindFirstChild("NotificationGui")
            if rod:GetAttribute("Bite") == true or (biteGui and (biteGui:GetAttribute("CanReel") == true or biteGui.Enabled == true)) then
                break
            end
            task.wait(0.05)
        end
        
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        task.wait(0.6)
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
-- ====================================================================
-- BAGIAN 5: CORE LOOP & VERTICAL LOCK (Y-AXIS ENGINE)
-- ====================================================================
task.spawn(function()
    while true do
        task.wait(0.005) 
        if getgenv().AutoFishingState then
            pcall(function()
                prosesBukaSemuaPeti()
                local rod = kelolaAlatPancing()
                if rod then
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local fishingGui = playerGui and (playerGui:FindFirstChild("FishingGui") or playerGui:FindFirstChild("FishingGame") or playerGui:FindFirstChild("FishingItemGui"))
                    
                    if fishingGui and fishingGui.Enabled then
                        if getgenv().FishingMode == "Perfect" then
                            local zonaHijau = nil
                            for _, child in pairs(fishingGui:GetChildren()) do
                                if child:IsA("Frame") and (string.find(string.lower(child.Name), "green") or string.find(string.lower(child.Name), "zone") or string.find(string.lower(child.Name), "bar")) then
                                    zonaHijau = child; break
                                end
                            end
                            if not zonaHijau then
                                zonaHijau = fishingGui:FindFirstChild("GreenZone") or fishingGui:FindFirstChild("BarGreen")
                            end
                            
                            local ikonIkan = fishingGui:FindFirstChild("FishBlue") or fishingGui:FindFirstChild("Fish") or fishingGui:FindFirstChild("FishIcon")
                            local ikonPeti = fishingGui:FindFirstChild("ChestYellow") or fishingGui:FindFirstChild("Chest") or fishingGui:FindFirstChild("SunkenChest")
                            
                            if zonaHijau then
                                local objekTarget = ikonIkan
                                if getgenv().TargetType == "Chest" and ikonPeti then
                                    objekTarget = ikonPeti
                                end
                                
                                -- KUNCI POSISI VERTIKAL (NAIK-TURUN HP SUMBU Y)
                                if objekTarget and objekTarget.Visible then
                                    local targetPos = objekTarget.Position
                                    zonaHijau.Position = UDim2.new(
                                        zonaHijau.Position.X.Scale, 
                                        zonaHijau.Position.X.Offset, 
                                        targetPos.Y.Scale, 
                                        targetPos.Y.Offset
                                    )
                                end
                                
                                local progressBar = fishingGui:FindFirstChild("ProgressBar") or fishingGui:FindFirstChild("Bar")
                                local perfectLabel = fishingGui:FindFirstChild("PerfectLabel") or fishingGui:FindFirstChild("Perfect")
                                
                                if (progressBar and progressBar.Size.X.Scale >= 0.93) or (perfectLabel and perfectLabel.Visible == true) then
                                    task.wait(0.05)
                                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                    task.wait(0.05)
                                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                    task.wait(1.5)
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
                        local catchNotification = playerGui:FindFirstChild("CatchNotification") or playerGui:FindFirstChild("AppraiseFrame") or playerGui:FindFirstChild("RewardGui")
                        if catchNotification and (catchNotification.Enabled or (catchNotification:FindFirstChild("Frame") and catchNotification.Frame.Visible)) then
                            for i = 1, 3 do
                                VirtualInputManager:SendMouseButtonEvent(400, 400, 0, true, game, 1); task.wait(0.04)
                                VirtualInputManager:SendMouseButtonEvent(400, 400, 0, false, game, 1); task.wait(0.08)
                            end
                        end
                    end
                end
            end)
        end
    end
end)
