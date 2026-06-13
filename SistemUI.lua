-- ====================================================================
--         DEEP SEA FISHING HUB - VERSI KECEPATAN INSTAN V3 (FIX) 🌊
-- ====================================================================

-- Fungsi Bypass Penyimpanan Lokal (Mencegah Lag & Mempercepat Loading)
local function muatFileInstan(namaFile, urlGitHub)
    if isfile(namaFile) then
        return loadstring(readfile(namaFile))()
    else
        local sukses, isiFile = pcall(game.HttpGet, game, urlGitHub)
        if sukses and isiFile then
            writefile(namaFile, isiFile)
            return loadstring(isiFile)()
        end
    end
    return loadstring(game:HttpGet(urlGitHub))()
end

-- 1. MEMUAT SYSTEM LOGIKA PANCING DI LATAR BELAKANG VIA LINK GITHUB KAMU
task.spawn(function()
    pcall(function()
        muatFileInstan("SistemPancingLocal.lua", "https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/SistemPancing.lua")
    end)
end)

-- 2. MEMUAT FRAMEWORK ANTARMUKA ASLI DARI LINK GITHUB KAMU SENDIRI
local KavoUi = muatFileInstan("KavoLibLocal.lua", "https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/KavoLib.lua")

-- Inisialisasi Jendela Utama (Menggunakan Fungsi Asli Kavo: CreateLib)
local JendelaUtama = KavoUi.CreateLib("DEEP SEA HUB : BLOX FRUIT")

-- 3. PEMBUATAN HALAMAN TAB MENU (Menghindari Bug Crash Fungsi)
local TabPancing = JendelaUtama:NewTab("Otomatisasi")
local SeksiUtama = TabPancing:NewSection("Kendali Utama Makro")
local SeksiPendukung = TabPancing:NewSection("Sistem Pendukung & AFK")

local TabEkonomi = JendelaUtama:NewTab("Toko & Item")
local SeksiEkonomi = TabEkonomi:NewSection("Manajemen Umpan & Penjualan")

-- ==========================================
-- ISI SEKSI 1: UTAMA (MENGGUNAKAN ELEMEN KAVO)
-- ==========================================

-- Saklar Utama Jalannya Makro
SeksiUtama:NewToggle("Auto Fishing (UTAMA)", "Menyalakan seluruh rangkaian sistem makro pancing", function(state)
    getgenv().AutoFishingState = state
end)

-- Pilihan Kecepatan Tarikan Senar
SeksiUtama:NewDropdown("Mode Tangkapan", "Pilih metode penarikan pancingan", {"Perfect", "Instant"}, function(pilihan)
    getgenv().FishingMode = pilihan
end)

-- Pilihan Prioritas Target Tangkapan
SeksiUtama:NewDropdown("Target Prioritas", "Fokus penarikan objek di dalam game", {"Chest", "Fish"}, function(pilihan)
    getgenv().TargetType = pilihan
end)

-- ==========================================
-- ISI SEKSI 2: AFK & PENDUKUNG
-- ==========================================

-- Saklar Otomatis Hancurkan/Buka Box
SeksiPendukung:NewToggle("Auto Open Semua Jenis Peti", "Menghancurkan peti otomatis dari dalam tas", function(state)
    getgenv().AutoOpenAllChests = state
end)

-- Saklar Anti Deteksi Diam Roblox
SeksiPendukung:NewToggle("Anti-AFK Protection", "Mencegah putus koneksi server (Error 203)", function(state)
    getgenv().AntiAfkEnabled = state
end)

-- Saklar Penghemat Suhu Perangkat (Baterai HP)
SeksiPendukung:NewToggle("FPS Booster (AFK Mode)", "Mematikan rendering game agar perangkat tetap dingin", function(state)
    getgenv().FpsBoostEnabled = state
end)

-- ==========================================
-- ISI SEKSI 3: TOKO & ITEM (AUTO BUY BAIT)
-- ==========================================

-- Saklar Otomatis Membeli Umpan Baru
SeksiEkonomi:NewToggle("Auto Buy Bait", "Otomatis membeli umpan di server saat jumlahnya habis (0)", function(state)
    getgenv().AutoBuyBaitEnabled = state
end)

-- Pilihan Jenis Umpan Semua Lautan (First, Second, Third Sea)
SeksiEkonomi:NewDropdown("Pilih Jenis Umpan", "Tentukan jenis umpan yang dibeli otomatis sesuai lautan kamu", {
    "Basic", "Kelp Bait", "Good Bait", "Frozen Bait", "Abyssal Bait", "Carnivore Bait", "Epic Bait"
}, function(pilihan)
    getgenv().SelectedBaitType = pilihan
end)

-- Saklar Otomatis Jual Hasil Pancing ke NPC
SeksiEkonomi:NewToggle("Auto Sell Fish", "Otomatis menjual seluruh hasil tangkapan saat tas penuh", function(state)
    getgenv().AutoSellEnabled = state
end)

-- Saklar Sembunyi Koordinat Laut Terisolasi
SeksiEkonomi:NewToggle("Teleport Safe Zone", "Memindahkan karakter ke titik laut tersembunyi agar anti-report", function(state)
    getgenv().SafeZoneTeleport = state
end)

-- ==========================================
-- 4. FIX TOMBOL HP: MANIPULASI CORE GUI LANGSUNG
-- ==========================================
local CoreGui = game:GetService("CoreGui")

task.spawn(function()
    task.wait(1.5) -- Menunggu seluruh elemen dasar KavoLib selesai terpasang sempurna
    
    local TargetGui = CoreGui:FindFirstChild("KavoDeepSeaHub")
    if TargetGui then
        local FramePanel = TargetGui:FindFirstChild("MainFrame")
        
        if FramePanel then
            -- Pembuatan tombol melayang bulat minimalis agar mudah digunakan di HP
            local TombolHp = Instance.new("TextButton")
            TombolHp.Name = "MobileToggleBtn"
            TombolHp.Size = UDim2.new(0, 60, 0, 35)
            TombolHp.Position = UDim2.new(0, 15, 0, 130) -- Letak kiri layar agar tidak menutupi tombol serang bawaan game
            TombolHp.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
            TombolHp.Text = "MENU"
            TombolHp.TextColor3 = Color3.fromRGB(255, 184, 0)
            TombolHp.Font = Enum.Font.SourceSansBold
            TombolHp.TextSize = 12
            TombolHp.Active = true
            TombolHp.Draggable = true -- Pengguna HP bebas menggeser letak tombol ini sesuka hati
            TombolHp.Parent = TargetGui

            -- Desain Sudut Melengkung Halus
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 8)
            Corner.Parent = TombolHp
            
            -- Desain Garis Batas Menyala Kuning Emas
            local UIStroke = Instance.new("UIStroke")
            UIStroke.Color = Color3.fromRGB(255, 184, 0)
            UIStroke.Thickness = 1.2
            UIStroke.Parent = TombolHp

            -- Sistem Buka Tutup Panel Utama Lewat Ketukan Tombol HP
            TombolHp.MouseButton1Click:Connect(function()
                FramePanel.Visible = not FramePanel.Visible
            end)
        end
    end
end)

print("[Main-Hub] GUI Berbasis getgenv() Berhasil Dimuat.")
