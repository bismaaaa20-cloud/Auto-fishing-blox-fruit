-- ====================================================================
-- BAGIAN 1: INISIALISASI PUSTAKA GUI & VARIABEL UTAMA
-- ====================================================================

_G.OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
_G.VirtualInputManager = game:GetService("VirtualInputManager")
_G.UserInputService = game:GetService("UserInputService")
_G.Players = game:GetService("Players")
_G.LocalPlayer = _G.Players.LocalPlayer
_G.PlayerGui = _G.LocalPlayer:WaitForChild("PlayerGui")

-- Sinkronisasi Awal Parameter Makro
_G.StartAutofish = false
_G.SelectedBait = "Basic Bait"
_G.SelectedRod = "Fishing Rod"
_G.CastDelay = 1.5
_G.ReelDelay = 0.4
_G.AutoBuyBait = false

print("[BAGIAN 1 Selesai] Variabel dan pustaka berhasil disiapkan!")
-- ====================================================================
-- BAGIAN 2: MEMBUAT KOTAK OVERLAY INTERAKTIF (MOBILE DRAG & RESIZE)
-- ====================================================================

if _G.PlayerGui:FindFirstChild("MacroOverlayMobile") then
    _G.PlayerGui.MacroOverlayMobile:Destroy()
end

_G.OverlayGui = Instance.new("ScreenGui")
_G.OverlayGui.Name = "MacroOverlayMobile"
_G.OverlayGui.ResetOnSpawn = false
_G.OverlayGui.Parent = _G.PlayerGui

local function BuatKotakDinamis(nama, warna, posAwal, ukuranAwal)
    local FrameUtama = Instance.new("Frame")
    FrameUtama.Name = nama
    FrameUtama.Size = ukuranAwal
    FrameUtama.Position = posAwal
    FrameUtama.BackgroundColor3 = warna
    FrameUtama.BackgroundTransparency = 0.6
    FrameUtama.BorderSizePixel = 2
    FrameUtama.BorderColor3 = Color3.fromRGB(255, 255, 255)
    FrameUtama.Active = true
    FrameUtama.Parent = _G.OverlayGui

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, -18)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = warna
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.Text = nama
    Label.Parent = FrameUtama

    local ResizeHandle = Instance.new("ImageButton")
    ResizeHandle.Name = "ResizeHandle"
    ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
    ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
    ResizeHandle.BackgroundTransparency = 0.3
    ResizeHandle.Parent = FrameUtama

    local dragging, dragInput, dragStart, startPos
    FrameUtama.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = FrameUtama.Position
        end
    end)

    local resizing, resizeStart, startSize
    ResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            resizeStart = input.Position
            startSize = FrameUtama.Size
        end
    end)

    _G.UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            FrameUtama.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif resizing and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - resizeStart
            FrameUtama.Size = UDim2.new(0, math.max(30, startSize.X.Offset + delta.X), 0, math.max(20, startSize.Y.Offset + delta.Y))
        end
    end)
    
    _G.UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            resizing = false
        end
    end)
end

BuatKotakDinamis("Indicator Area (Green)", Color3.fromRGB(0, 255, 0), UDim2.new(0.45, 0, 0.35, 0), UDim2.new(0, 80, 0, 80))
BuatKotakDinamis("Fish Area (Red)", Color3.fromRGB(255, 0, 0), UDim2.new(0.30, 0, 0.70, 0), UDim2.new(0, 340, 0, 40))

_G.KotakHijau = _G.OverlayGui:FindFirstChild("Indicator Area (Green)")
_G.KotakMerah = _G.OverlayGui:FindFirstChild("Fish Area (Red)")

print("[BAGIAN 2 Selesai] Kotak visual Hijau & Merah berhasil muncul di layar!")
-- ====================================================================
-- BAGIAN 3: MEMBUAT WINDOW PANEL MENU (TAMPILAN ARAPBOT REPLIKA)
-- ====================================================================

local Window = _G.OrionLib:MakeWindow({Name = "ArapBot Mobile Remake (Pro v8)", HidePremium = true, SaveConfig = false, IntroText = "Memuat Fitur Makro..."})

local ControlsTab = Window:MakeTab({Name = "Controls", Icon = "rbxassetid://4483362458", PremiumOnly = false})

ControlsTab:AddToggle({
	Name = "Start Autofish", Default = false,
	Callback = function(Value) _G.StartAutofish = Value end    
})

ControlsTab:AddToggle({
	Name = "Change Area (Show/Hide Visual)", Default = true,
	Callback = function(Value)
		if _G.KotakHijau and _G.KotakMerah then
			_G.KotakHijau.Visible = Value
			_G.KotakMerah.Visible = Value
		end
	end    
})

ControlsTab:AddDropdown({
	Name = "Selected Bait", Default = "Basic Bait", Options = {"Basic Bait", "Rare Bait", "Legendary Bait"},
	Callback = function(Value) _G.SelectedBait = Value end
})

ControlsTab:AddDropdown({
	Name = "Selected Rod", Default = "Fishing Rod", Options = {"Fishing Rod", "Advanced Rod", "Rare Rod", "Legendary Rod"},
	Callback = function(Value) _G.SelectedRod = Value end
})

local SettingsTab = Window:MakeTab({Name = "Cast & Reel Settings", Icon = "rbxassetid://4483362458", PremiumOnly = false})

SettingsTab:AddSlider({
	Name = "Cast Delay", Min = 0.5, Max = 5, Default = 1.5, Increment = 0.1, ValueName = "detik",
	Callback = function(Value) _G.CastDelay = Value end    
})

SettingsTab:AddSlider({
	Name = "Reel Delay", Min = 0.1, Max = 3, Default = 0.4, Increment = 0.1, ValueName = "detik",
	Callback = function(Value) _G.ReelDelay = Value end    
})

SettingsTab:AddToggle({
	Name = "Auto Buy Bait", Default = false,
	Callback = function(Value) _G.AutoBuyBait = Value end    
})

print("[BAGIAN 3 Selesai] Menu panel kontrol berhasil dimuat!")
-- ====================================================================
-- BAGIAN 4: LOGIKA UTAMA MESIN OTOMATIS (CORE ENGINE & LOGIC 5s)
-- ====================================================================

local function SimulasiKetuk()
    local x = workspace.CurrentCamera.ViewportSize.X / 2
    local y = workspace.CurrentCamera.ViewportSize.Y / 2
    _G.VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    _G.VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-- Sistem Proteksi Anti-Kick Server Roblox 20 Menit
_G.LocalPlayer.Idled:Connect(function()
    _G.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait(0.2)
    _G.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)

local function DeteksiSunken()
    local guiPeti = _G.PlayerGui:FindFirstChild("SunkenChestGui") or _G.PlayerGui:FindFirstChild("ChestMinigame")
    if guiPeti and guiPeti.Enabled then return true end
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("sunken") or obj.Name:lower():find("chest") then
            if obj:IsA("BasePart") and (_G.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude < 45 then
                return true
            end
        end
    end
    return false
end

-- Memulai Perulangan Mesin Pintar
task.spawn(function()
    while true do
        if _G.StartAutofish then
            -- Auto Equip Alat Pancing
            local rod = _G.LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod) or _G.LocalPlayer.Character:FindFirstChild(_G.SelectedRod)
            if rod and rod.Parent == _G.LocalPlayer.Backpack then
                _G.LocalPlayer.Character.Humanoid:EquipTool(rod)
            end

            -- Pembelian Umpan Otomatis Toko
            if _G.AutoBuyBait then
                local baitCount = _G.PlayerGui:FindFirstChild("FishingGui") and _G.PlayerGui.FishingGui:FindFirstChild("BaitCount")
                if baitCount and tonumber(baitCount.Text) == 0 then
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingRemote") or game:GetService("ReplicatedStorage"):FindFirstChild("BuyBait")
                    if remote then remote:FireServer(_G.SelectedBait, 5) end
                end
            end

            -- Eksekusi Utama: Logika Prioritas Sunken Chest
            if DeteksiSunken() then
                print("[MAKRO] Sunken Chest langsung aktif! Mengklaim Peti Karun...")
                SimulasiKetuk()
                task.wait(1.2)
            else
                local hitungWaktu = 0
                local petiDitemukanMendadak = false
                
                while hitungWaktu < 5 do
                    task.wait(0.1)
                    hitungWaktu = hitungWaktu + 0.1
                    
                    if DeteksiSunken() then
                        petiDitemukanMendadak = true
                        break
                    end
                    if _G.KotakHijau then _G.KotakHijau.BorderColor3 = Color3.fromRGB(255, 165, 0) end -- Mode Menghindari Ikan
                end

                -- Hasil Evaluasi Setelah 5 Detik Berakhir
                if petiDitemukanMendadak or DeteksiSunken() then
                    print("[PRIORITAS] Peti terdeteksi di akhir timer! Langsung mengeklik peti.")
                    SimulasiKetuk()
                else
                    if _G.KotakHijau then _G.KotakHijau.BorderColor3 = Color3.fromRGB(255, 255, 255) end
                    local gameUI = _G.PlayerGui:FindFirstChild("FishingGui") or _G.PlayerGui:FindFirstChild("FishingMinigame")
                    
                    if gameUI and gameUI.Enabled then
                        if _G.KotakHijau and _G.KotakMerah then
                            local khPos = _G.KotakHijau.AbsolutePosition
                            local kmPos = _G.KotakMerah.AbsolutePosition
                            
                            -- Deteksi Tabrakan Hitbox Kotak Hijau & Merah di Layar HP
                            if khPos.X < (kmPos.X + _G.KotakMerah.AbsoluteSize.X) and (khPos.X + _G.KotakHijau.AbsoluteSize.X) > kmPos.X then
                                task.wait(_G.ReelDelay)
                                SimulasiKetuk()
                            end
                        end
                    else
                        SimulasiKetuk() -- Melempar Umpan (Cast)
                        task.wait(_G.CastDelay)
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

_G.OrionLib:Init()
print("[BAGIAN 4 Selesai] Sistem Otomatisasi Makro Berhasil Dijalankan Keseluruhan!")
