-- ====================================================================
--         DEEP SEA FISHING HUB - VERSI KECEPATAN INSTAN v3 🌊
-- ====================================================================

-- Fungsi Utama untuk Menyimpan File ke Folder Lokal Perangkat (Bikin Loading Instan)
local function muatSistemPancingLocal()
    local namaFile = "SistemPancingLocal.lua"
    local urlGitHub = "https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/SistemPancing.lua"
    
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

local function muatKavoLibLocal()
    local namaFile = "KavoLibLocal.lua"
    local urlGitHub = "https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/KavoLib.lua"
    
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

-- 1. MEMUAT LOGIKA SISTEM PANCING SECARA INSTAN DI LATAR BELAKANG
task.spawn(function()
    pcall(function()
        muatSistemPancingLocal()
    end)
end)

-- 2. MEMUAT LIBRARY ANTARMUKA DARI GITHUB KAMU SENDIRI
local UiFramework = muatKavoLibLocal()

-- Inisialisasi Jendela Utama Menu Hub
local Window = UiFramework:MakeWindow({
    Title = "DEEP SEA HUB : BLOX FRUIT",
    SubTitle = "Fishing Macro v3",
    SaveFolder = "DeepSea_Config"
})

-- Memunculkan Notifikasi Saat Berhasil Masuk Layar Game
UiFramework:SetNotification({
    Title = "Deep Sea Fishing Hub",
    Description = "UI Berhasil Dimuat!",
    Time = 2
})

-- 3. MEMBUAT HALAMAN TAB MENU UTAMA
local TabPancing = Window:MakeTab({
    Name = "Otomatisasi",
    Icon = "rbxassetid://10723351906" -- Ikon jangkar air
})

local TabEkonomi = Window:MakeTab({
    Name = "Toko & Item",
    Icon = "rbxassetid://10734950309" -- Ikon keranjang belanja
})

-- ==========================================
-- HALAMAN TAB 1: OTOMATISASI PANCINGAN
-- ==========================================
TabPancing:AddSection({ Name = "Kendali Utama Makro" })

-- Saklar Utama Jalannya Sistem
TabPancing:AddToggle({
    Name = "Auto Fishing (UTAMA)",
    Description = "Menyalakan seluruh rangkaian sistem makro pancing",
    Default = false,
    Callback = function(state) getgenv().AutoFishingState = state end
})

-- Dropdown Pilihan Kecepatan Tangkapan
TabPancing:AddDropdown({
    Name = "Mode Tangkapan",
    Description = "Pilih metode penarikan pancingan",
    Options = {"Perfect", "Instant"},
    Default = "Perfect",
    Callback = function(pilihan) getgenv().FishingMode = pilihan end
})

-- Dropdown Pilihan Fokus Objek
TabPancing:AddDropdown({
    Name = "Target Prioritas",
    Description = "Fokus penarikan objek di dalam game",
    Options = {"Chest", "Fish"},
    Default = "Chest",
    Callback = function(pilihan) getgenv().TargetType = pilihan end
})

TabPancing:AddSection({ Name = "Sistem Pendukung & AFK" })

-- Saklar Otomatis Buka Box/Chest
TabPancing:AddToggle({
    Name = "Auto Open Semua Jenis Peti",
    Description = "Menghancurkan peti otomatis dari dalam tas",
    Default = true,
    Callback = function(state) getgenv().AutoOpenAllChests = state end
})

-- Saklar Anti Deteksi Diam 20 Menit Roblox
TabPancing:AddToggle({
    Name = "Anti-AFK Protection",
    Description = "Mencegah putus koneksi server (Error 203)",
    Default = true,
    Callback = function(state) getgenv().AntiAfkEnabled = state end
})

-- Saklar Penghemat Baterai/Suhu HP (FPS Booster)
TabPancing:AddToggle({
    Name = "FPS Booster (AFK Mode)",
    Description = "Mematikan rendering game agar perangkat tetap dingin",
    Default = false,
    Callback = function(state) getgenv().FpsBoostEnabled = state end
})

-- ==========================================
-- HALAMAN TAB 2: TOKO & ITEM
-- ==========================================
TabEkonomi:AddSection({ Name = "Manajemen Umpan & Penjualan" })

-- Saklar Otomatis Membeli Umpan Baru
TabEkonomi:AddToggle({
    Name = "Auto Buy Bait",
    Description = "Otomatis membeli umpan di server saat jumlahnya habis (0)",
    Default = true,
    Callback = function(state) getgenv().AutoBuyBaitEnabled = state end
})

-- Dropdown Pilihan Jenis Umpan Berdasarkan Lautan (First, Second, Third Sea)
TabEkonomi:AddDropdown({
    Name = "Pilih Jenis Umpan",
    Description = "Tentukan jenis umpan yang dibeli otomatis sesuai lautan kamu",
    Options = {
        "Basic", "Kelp Bait", "Good Bait",
        "Frozen Bait", "Abyssal Bait",
        "Carnivore Bait", "Epic Bait"
    },
    Default = "Basic",
    Callback = function(pilihan) getgenv().SelectedBaitType = pilihan end
})

-- Saklar Otomatis Menjual Ikan ke NPC Merchant
TabEkonomi:AddToggle({
    Name = "Auto Sell Fish",
    Description = "Otomatis menjual seluruh hasil tangkapan saat tas penuh",
    Default = true,
    Callback = function(state) getgenv().AutoSellEnabled = state end
})

-- Saklar Sembunyi Tempat Memancing Terisolasi
TabEkonomi:AddToggle({
    Name = "Teleport Safe Zone",
    Description = "Memindahkan karakter ke titik laut tersembunyi agar anti-report",
    Default = true,
    Callback = function(state) getgenv().SafeZoneTeleport = state end
})
