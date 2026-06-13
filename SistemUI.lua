-- ====================================================================
--         DEEP SEA FISHING HUB - CUSTOM GITHUB LOAD 🌊
-- ====================================================================

-- 1. MEMUAT LINK KAVOLIB DAN SISTEMPANCING YANG TADI AKU KASIH
local KavoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/KavoLib.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/SistemPancing.lua"))()

-- 2. INISIALISASI JENDELA UTAMA MENGGUNAKAN LIBRARY KAMU
local JendelaUtama = KavoUi.CreateLib("DEEP SEA HUB : BLOX FRUIT")
local TabPancing = JendelaUtama:NewTab("Otomatisasi")
local SeksiUtama = TabPancing:NewSection("Kendali Utama Makro")

-- 3. ELEMEN KONTROL (TOGGLE & DROPDOWN)
SeksiUtama:NewToggle("Auto Fishing (UTAMA)", "Menyalakan seluruh rangkaian sistem makro pancing", function(state)
    getgenv().AutoFishingState = state
end)

SeksiUtama:NewDropdown("Mode Tangkapan", "Metode penarikan", {"Perfect", "Instant"}, function(pilihan)
    getgenv().FishingMode = pilihan
end)

SeksiUtama:NewDropdown("Target Prioritas", "Fokus objek", {"Chest", "Fish"}, function(pilihan)
    getgenv().TargetType = pilihan
end)

SeksiUtama:NewToggle("Auto Open Semua Jenis Peti", "Menghancurkan peti otomatis di tas", function(state)
    getgenv().AutoOpenAllChests = state
end)

SeksiUtama:NewToggle("Anti-AFK Protection", "Mencegah terputusnya koneksi server 20 menit", function(state)
    getgenv().AntiAfkEnabled = state
end)

SeksiUtama:NewToggle("FPS Booster (AFK Mode)", "Mematikan render game agar perangkat tetap dingin", function(state)
    getgenv().FpsBoostEnabled = state
end)

-- 4. KONTROL INTERFAZ MOBILE (TOMBOL MENU HP MODEL BULAT PREMIUM)
local CoreGui = game:GetService("CoreGui")
local TargetGui = CoreGui:WaitForChild("KavoDeepSeaHub", 5)

if TargetGui then
    local FramePanel = TargetGui:WaitForChild("MainFrame", 5)
    
    if FramePanel then
        local TombolHp = Instance.new("TextButton")
        TombolHp.Name = "MobileToggleButton"
        TombolHp.Size = UDim2.new(0, 65, 0, 35)
        TombolHp.Position = UDim2.new(0.05, 0, 0.15, 0)
        TombolHp.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
        TombolHp.Text = "MENU"
        TombolHp.TextColor3 = Color3.fromRGB(255, 184, 0)
        TombolHp.Font = Enum.Font.SourceSansBold
        TombolHp.TextSize = 13
        TombolHp.Active = true
        TombolHp.Draggable = true
        TombolHp.Parent = TargetGui

        -- Menambahkan sudut melingkar modern biar tombol HP mirip Redz Hub asli
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 8)
        UICorner.Parent = TombolHp

        -- Mengaktifkan fungsi buka tutup menu utama
        TombolHp.MouseButton1Click:Connect(function()
            FramePanel.Visible = not FramePanel.Visible
        end)
    end
end

print("[Main-Hub] GUI Berbasis getgenv() Berhasil Dimuat.")
