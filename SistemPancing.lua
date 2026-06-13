-- ==========================================
-- BAGIAN 1: SETTING DEFAULT & SERVICES
-- ==========================================
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
-- ==========================================
-- BAGIAN 2: OPTIMIZATION & UTILITIES
-- ==========================================

-- Pengendali FPS Booster
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

-- Bypass Anti-AFK Kick Roblox
task.spawn(function()
    LocalPlayer.Idled:Connect(function()
        if getgenv().AntiAfkEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new(0, 0))
        end
    end)
end)

-- Teleport Pengaman (Anti-Report)
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
-- ==========================================
-- BAGIAN 3: BAIT & MERCHANT ECONOMY
-- ==========================================

-- Otomatis Beli Umpan Saat Habis
local function periksaDanBeliUmpan()
    if not getgenv().AutoBuyBaitEnabled then return end
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    local dataFolder = LocalPlayer:FindFirstChild("Data") or LocalPlayer:FindFirstChild("PlayerData")
    local baitAmount = 0
    
    if dataFolder and dataFolder:FindFirstChild("Bait") then
        baitAmount = dataFolder.Bait.Value
    elseif leaderstats and leaderstats:FindFirstChild("Bait") then
        baitAmount = leaderstats.Bait.Value
    else
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local mainGui = playerGui and (playerGui:FindFirstChild("Main") or playerGui:FindFirstChild("HUD"))
        local baitLabel = mainGui and mainGui:FindFirstChild("BaitAmount", true)
        if baitLabel and baitLabel:IsA("TextLabel") then
            baitAmount = tonumber(string.match(baitLabel.Text, "%d+")) or 0
        end
    end
    
    if baitAmount <= 0 then
        local buyBaitRemote = ReplicatedStorage:FindFirstChild("BuyBait", true) 
            or ReplicatedStorage:FindFirstChild("PurchaseBait", true) 
            or ReplicatedStorage:FindFirstChild("BaitRemote", true)
            
        if buyBaitRemote and buyBaitRemote:IsA("RemoteEvent") then
            buyBaitRemote:FireServer(getgenv().SelectedBaitType, 25)
            task.wait(1)
        elseif buyBaitRemote and buyBaitRemote:IsA("RemoteFunction") then
            buyBaitRemote:InvokeServer(getgenv().SelectedBaitType, 25)
            task.wait(1)
        end
    end
end

-- Otomatis Jual Ikan Saat Tas Penuh
local function checkInventoryAndSell()
    if not getgenv().AutoSellEnabled then return end
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local inventoryGui = playerGui and (playerGui:FindFirstChild("Inventory") or playerGui:FindFirstChild("BagGui"))
    
    if inventoryGui and string.find(string.lower(tostring(inventoryGui)), "full") then
        local sellRemote = ReplicatedStorage:FindFirstChild("SellFish", true) or ReplicatedStorage:FindFirstChild("MerchantRemote", true)
        if sellRemote and sellRemote:IsA("RemoteEvent") then
            sellRemote:FireServer("SellAll")
            task.wait(1)
        end
    end
end
-- ==========================================
-- BAGIAN 4: ROD MANAGEMENT & BITE DETECTOR
-- ==========================================
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

-- Otomatis Hancurkan/Buka Peti di Tas
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
-- ==========================================
-- BAGIAN 5: CORE LOOP & PERFECT BYPASS ENGINE
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.001)
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
                            local objekTarget = ikonIkan
                            if getgenv().TargetType == "Chest" and ikonPeti then
                                objekTarget = ikonPeti
                            end
                            
                            if objekTarget and objekTarget.Visible then
                                zonaHijau.Position = UDim2.new(objekTarget.Position.X.Scale, objekTarget.Position.X.Offset, zonaHijau.Position.Y.Scale, zonaHijau.Position.Y.Offset)
                            end
                            
                            local progressBar = fishingGui:FindFirstChild("ProgressBar") or fishingGui:FindFirstChild("Bar")
                            local perfectLabel = fishingGui:FindFirstChild("PerfectLabel") or fishingGui:FindFirstChild("Perfect")
                            
                            if (progressBar and progressBar.Size.X.Scale >= 0.93) or (perfectLabel and perfectLabel.Visible == true) then
                                task.wait(0.05)
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                                task.wait(0.05)
                                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                                task.wait(1.4)
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
        end
    end
end)
