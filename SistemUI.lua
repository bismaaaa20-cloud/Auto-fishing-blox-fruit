-- [[ Blox Fruits MOBILE FIXED - MINI PANEL GUI ]] --

-- Bersihkan sisa GUI lama agar tidak menumpuk di layar
if game:GetService("CoreGui"):FindFirstChild("MiniFishingGUI") then
    game:GetService("CoreGui").MiniFishingGUI:Destroy()
end

-- Variabel Status Fitur (Default: MATI)
_G.AutoFishing = false
_G.InstantChest = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ToggleUIBtn = Instance.new("TextButton") -- Tombol Buka/Tutup
local TitleLabel = Instance.new("TextLabel")
local FishBtn = Instance.new("TextButton")      -- Tombol Auto Fish
local ChestBtn = Instance.new("TextButton")     -- Tombol Auto Chest
local UICorner_Main = Instance.new("UICorner")
local UICorner_Toggle = Instance.new("UICorner")
local UICorner_Fish = Instance.new("UICorner")
local UICorner_Chest = Instance.new("UICorner")

ScreenGui.Name = "MiniFishingGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. TOMBOL BUKA / TUTUP (Diletakkan terpisah di area kosong agar mudah diklik)
ToggleUIBtn.Name = "ToggleUIBtn"
ToggleUIBtn.Parent = ScreenGui
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Warna Biru
ToggleUIBtn.Position = UDim2.new(0.1, 0, 0.4, 0) -- Posisi kiri layar
ToggleUIBtn.Size = UDim2.new(0, 70, 0, 30)       -- Ukuran sangat kecil
ToggleUIBtn.Font = Enum.Font.SourceSansBold
ToggleUIBtn.Text = "MENU"
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleUIBtn.TextSize = 14
UICorner_Toggle.Parent = ToggleUIBtn

-- 2. PANEL UTAMA KECIL (Bisa disembunyikan / dibuka tutup)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.1, 0, 0.46, 0) -- Berada di bawah tombol MENU
MainFrame.Size = UDim2.new(0, 160, 0, 110)      -- Panel dibuat sangat ringkas
MainFrame.Visible = true -- Default: Terbuka di awal
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser jika menutupi pandangan
UICorner_Main.Parent = MainFrame

-- Judul Menu Kecil
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0, 25)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "FISHING MENU"
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextSize = 12

-- 3. TOMBOL FITUR 1: AUTO FISH
FishBtn.Name = "FishBtn"
FishBtn.Parent = MainFrame
FishBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah (OFF)
FishBtn.Position = UDim2.new(0.05, 0, 0.28, 0)
FishBtn.Size = UDim2.new(0.9, 0, 0, 30)
FishBtn.Font = Enum.Font.SourceSansBold
FishBtn.Text = "AUTO FISH: OFF"
FishBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FishBtn.TextSize = 12
UICorner_Fish.Parent = FishBtn

-- 4. TOMBOL FITUR 2: AUTO CHEST
ChestBtn.Name = "ChestBtn"
ChestBtn.Parent = MainFrame
ChestBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah (OFF)
ChestBtn.Position = UDim2.new(0.05, 0, 0.62, 0)
ChestBtn.Size = UDim2.new(0.9, 0, 0, 30)
ChestBtn.Font = Enum.Font.SourceSansBold
ChestBtn.Text = "AUTO CHEST: OFF"
ChestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ChestBtn.TextSize = 12
UICorner_Chest.Parent = ChestBtn


-- =========================================================
-- LOGIKA INTERAKSI UI (BUKA-TUTUP & ON/OFF)
-- =========================================================

-- Fungsi Buka Tutup Panel Utama (Minimize)
ToggleUIBtn.MouseButton1Down:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        ToggleUIBtn.Text = "TUTUP"
        ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    else
        ToggleUIBtn.Text = "BUKA"
        ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Berubah redup saat ditutup
    end
end)

-- Tombol On/Off Auto Fish
FishBtn.MouseButton1Down:Connect(function()
    _G.AutoFishing = not _G.AutoFishing
    if _G.AutoFishing then
        FishBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- Hijau (ON)
        FishBtn.Text = "AUTO FISH: ON"
    else
        FishBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah (OFF)
        FishBtn.Text = "AUTO FISH: OFF"
    end
end)

-- Tombol On/Off Auto Chest
ChestBtn.MouseButton1Down:Connect(function()
    _G.InstantChest = not _G.InstantChest
    if _G.InstantChest then
        ChestBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50) -- Hijau (ON)
        ChestBtn.Text = "AUTO CHEST: ON"
    else
        ChestBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50) -- Merah (OFF)
        ChestBtn.Text = "AUTO CHEST: OFF"
    end
end)


-- =========================================================
-- JALUR BACKEND PROSES GAME (BERJALAN DI LATAR BELAKANG)
-- =========================================================
local Players = game:Service("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:Service("Workspace")
local VirtualInputManager = game:Service("VirtualInputManager")

-- Loop Auto Fishing
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFishing then
            pcall(function()
                local character = LocalPlayer.Character
                local tool = character and character:FindFirstChildWhichIsA("Tool")
                
                if tool and (string.find(string.lower(tool.Name), "rod") or string.find(string.lower(tool.Name), "fishing")) then
                    tool:Activate()
                    task.wait(0.3)
                    
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local fishGui = playerGui and (playerGui:FindFirstChild("FishingGui") or playerGui:FindFirstChild("Fishing"))
                    if fishGui then
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                    end
                end
            end)
        end
    end
end)

-- Loop Auto Chest Instan
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.InstantChest then
            pcall(function()
                for _, object in pairs(Workspace:GetChildren()) do
                    if not _G.InstantChest then break end
                    if object:IsA("Model") and (string.find(object.name, "Chest") or string.find(object.name, "Sunken")) then
                        local targetPart = object:FindFirstChildWhichIsA("Part") or object:FindFirstChild("TouchInterest")
                        if targetPart then
                            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if root then
                                root.CFrame = targetPart.CFrame
                                task.wait(0.15)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Sistem Anti-AFK
local VirtualUser = game:Service("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

print("Mini GUI Berhasil Dimuat!")
