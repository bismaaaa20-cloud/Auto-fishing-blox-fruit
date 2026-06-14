-- ====================================================================
-- BAGIAN 1: INISIALISASI INTERNAL MURNI (RUN INI PERTAMA KALI)
-- ====================================================================

_G.VirtualInputManager = game:GetService("VirtualInputManager")
_G.UserInputService = game:GetService("UserInputService")
_G.Players = game:GetService("Players")
_G.LocalPlayer = _G.Players.LocalPlayer
_G.PlayerGui = _G.LocalPlayer:WaitForChild("PlayerGui")

-- Sinkronisasi Awal Parameter Utama Makro
_G.StartAutofish = false
_G.SelectedBait = "Basic Bait"
_G.SelectedRod = "Fishing Rod"
_G.CastDelay = 1.5
_G.ReelDelay = 0.4
_G.AutoBuyBait = false
_G.AutoSunkenTimer = true -- Bawaan pabrik menyala (ON)

print("[BAGIAN 1 SUKSES] Sistem dasar siap digunakan!")
-- ====================================================================
-- BAGIAN 2: FIX POSITION OVERLAY (DRAG & RESIZE MOBILE)
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

-- Koordinat letak diatur pas di area bawah (Y: 0.73 & 0.75) agar dekat bar pancingan asli
BuatKotakDinamis("Indicator Area (Green)", Color3.fromRGB(0, 255, 0), UDim2.new(0.48, 0, 0.73, 0), UDim2.new(0, 60, 0, 60))
BuatKotakDinamis("Fish Area (Red)", Color3.fromRGB(255, 0, 0), UDim2.new(0.35, 0, 0.75, 0), UDim2.new(0, 240, 0, 30))

_G.KotakHijau = _G.OverlayGui:FindFirstChild("Indicator Area (Green)")
_G.KotakMerah = _G.OverlayGui:FindFirstChild("Fish Area (Red)")

print("[BAGIAN 2 SUKSES] Kotak visual area bawah berhasil dimuat!")
-- ====================================================================
-- BAGIAN 3: INTERFACE MENU UTAMA (DENGAN SAKELAR AUTO SUNKEN)
-- ====================================================================

if _G.PlayerGui:FindFirstChild("ArapBotMenuMobile") then
    _G.PlayerGui.ArapBotMenuMobile:Destroy()
end

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "ArapBotMenuMobile"
MainGui.ResetOnSpawn = false
MainGui.Parent = _G.PlayerGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 220, 0, 305)
MenuFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MenuFrame.BorderSizePixel = 2
MenuFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Parent = MainGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.Text = " ArapBot Mobile Remake v10"
Title.Parent = MenuFrame

local function BuatToggle(text, yPos, defaultState, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.TextSize = 13
    Button.Font = Enum.Font.SourceSans
    
    local state = defaultState
    local function updateVisual()
        if state then
            Button.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            Button.Text = text .. " : ON"
        else
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Button.Text = text .. " : OFF"
        end
    end
    
    updateVisual()
    Button.MouseButton1Click:Connect(function()
        state = not state
        updateVisual()
        callback(state)
    end)
    Button.Parent = MenuFrame
end

local function BuatInputBox(text, yPos, defaultText, callback)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 0, 30)
    Label.Position = UDim2.new(0.05, 0, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Text = text
    Label.Parent = MenuFrame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.35, 0, 0, 25)
    Box.Position = UDim2.new(0.55, 0, 0, yPos)
    Box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Box.TextColor3 = Color3.fromRGB(0, 255, 0)
    Box.Text = tostring(defaultText)
    Box.ClearTextOnFocus = false
    Box.Parent = MenuFrame

    Box.FocusLost:Connect(function()
        local num = tonumber(Box.Text)
        if num then callback(num) end
    end)
end

-- TATA LETAK SAKELAR PANEL MENU
BuatToggle("Start Autofish", 45, false, function(v) _G.StartAutofish = v end)
BuatToggle("Change Area (Visual Box)", 90, true, function(v)
    if _G.KotakHijau and _G.KotakMerah then
        _G.KotakHijau.Visible = v
        _G.KotakMerah.Visible = v
    end
end)
BuatToggle("Auto Sunken (Timer 5s)", 135, true, function(v) _G.AutoSunkenTimer = v end)
BuatToggle("Auto Buy Bait", 180, false, function(v) _G.AutoBuyBait = v end)

BuatInputBox("Cast Delay (Sec):", 225, _G.CastDelay, function(v) _G.CastDelay = v end)
BuatInputBox("Reel Delay (Sec):", 260, _G.ReelDelay, function(v) _G.ReelDelay = v end)

print("[BAGIAN 3 SUKSES] Panel menu kontrol berhasil muncul!")
-- ====================================================================
-- BAGIAN 4: CORE AUTOMATION ENGINE (REAL-TIME DETECTION & RECAST SAFE)
-- ====================================================================

local function SimulasiKetuk()
    local x = workspace.CurrentCamera.ViewportSize.X / 2
    local y = workspace.CurrentCamera.ViewportSize.Y / 2
    _G.VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    _G.VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

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

local SudahMelempar = false
local WaktuLempar = 0

task.spawn(function()
    while true do
        if _G.StartAutofish then
            -- Auto Equip Alat Pancing
            local rod = _G.LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod) or _G.LocalPlayer.Character:FindFirstChild(_G.SelectedRod)
            if rod and rod.Parent == _G.LocalPlayer.Backpack then
                _G.LocalPlayer.Character.Humanoid:EquipTool(rod)
            end

            -- Beli Umpan Otomatis
            if _G.AutoBuyBait then
                local baitCount = _G.PlayerGui:FindFirstChild("FishingGui") and _G.PlayerGui.FishingGui:FindFirstChild("BaitCount")
                if baitCount and tonumber(baitCount.Text) == 0 then
                    local remote = game:GetService("ReplicatedStorage"):FindFirstChild("FishingRemote") or game:GetService("ReplicatedStorage"):FindFirstChild("BuyBait")
                    if remote then remote:FireServer(_G.SelectedBait, 5) end
                end
            end

            local gameUI = _G.PlayerGui:FindFirstChild("FishingGui") or _G.PlayerGui:FindFirstChild("FishingMinigame")
            local AdaPeti = DeteksiSunken()

            if AdaPeti then
                print("[MAKRO] Sunken Chest Aktif! Fokus ambil peti.")
                SimulasiKetuk()
                SudahMelempar = false
                task.wait(1)
            elseif gameUI and gameUI.Enabled then
                -- KONDISI JIKA BAR MINIGAME AKTIF
                if _G.KotakHijau then _G.KotakHijau.BorderColor3 = Color3.fromRGB(255, 255, 255) end
                SudahMelempar = false
                
                if _G.KotakHijau and _G.KotakMerah then
                    local khPos = _G.KotakHijau.AbsolutePosition
                    local kmPos = _G.KotakMerah.AbsolutePosition
                    
                    if khPos.X < (kmPos.X + _G.KotakMerah.AbsoluteSize.X) and (khPos.X + _G.KotakHijau.AbsoluteSize.X) > kmPos.X then
                        task.wait(_G.ReelDelay)
                        SimulasiKetuk() -- Menaik turunkan ikan balon otomatis
                    end
                end
            else
                -- KONDISI SAAT MENUNGGU IKAN DATANG
                if not SudahMelempar then
                    print("[MAKRO] Melempar pancingan...")
                    SimulasiKetuk()
                    WaktuLempar = os.time()
                    SudahMelempar = true
                    task.wait(_G.CastDelay)
                else
                    local SelisihWaktu = os.time() - WaktuLempar
                    
                    if _G.AutoSunkenTimer then
                        -- Jika Sakelar Sunkin ON: Kunci diri 5 detik pertama demi memantau peti
                        if SelisihWaktu < 5 then
                            if _G.KotakHijau then _G.KotakHijau.BorderColor3 = Color3.fromRGB(255, 165, 0) end -- Mode Menghindar
                        else
                            if _G.KotakHijau then _G.KotakHijau.BorderColor3 = Color3.fromRGB(255, 255, 255) end
                            if SelisihWaktu > 25 then -- Sabar menunggu tanda seru sampai 25 detik sebelum recast
                                SimulasiKetuk()
                                SudahMelempar = false
                                task.wait(_G.CastDelay)
                            end
                        end
                    else
                        -- Jika Sakelar Sunkin OFF: Langsung fokus amankan tanda seru, sabar menunggu 25 detik
                        if _G.KotakHijau then _G.KotakHijau.BorderColor3 = Color3.fromRGB(255, 255, 255) end
                        if SelisihWaktu > 25 then
                            SimulasiKetuk()
                            SudahMelempar = false
                            task.wait(_G.CastDelay)
                        end
                    end
                end
            end
        else
            SudahMelempar = false
        end
        task.wait(0.03)
    end
end)

print("[BAGIAN 4 SUKSES] Sistem mesin otomatisasi makro siap dijalankan keseluruhan!")
