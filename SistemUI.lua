-- ====================================================================
--         DEEP SEA FISHING HUB - ULTIMATE PREMIUM EDITION v3 🌊
-- ====================================================================

-- 1. MEMUAT LOGIKA SISTEM PANCING SECARA ONLINE DARI GITHUB KAMU
loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/SistemPancing.lua"))()

-- 2. MEMUAT FRAMEWORK ORIGINAL PREMIUM UI LIBRARY
local UiFramework = loadstring(game:HttpGet("https://raw.githubusercontent.com/bismaaaa20-cloud/Auto-fishing-blox-fruit/refs/heads/main/KavoLib.lua"))()

-- Inisialisasi Window Utama (Lengkap dengan Animasi Intro)
local Window = UiFramework:MakeWindow({
    Title = "DEEP SEA HUB : BLOX FRUIT",
    SubTitle = "Premium Fishing Macro v3",
    SaveFolder = "DeepSea_Config"
})

-- 3. NOTIFIKASI POP-UP MODERN SAAT BERHASIL DIMUAT
UiFramework:SetNotification({
    Title = "Deep Sea Fishing Hub",
    Description = "Premium UI v3 Berhasil Dimuat!",
    Time = 5
})

-- 4. MEMBUAT TAB UTAMA (Otomatisasi & Fitur Ekonomi)
local TabPancing = Window:MakeTab({
    Name = "Otomatisasi",
    Icon = "rbxassetid://10723351906" -- Ikon jangkar air premium
})

local TabEkonomi = Window:MakeTab({
    Name = "Toko & Item",
    Icon = "rbxassetid://10734950309" -- Ikon keranjang belanja modern
})

-- ==========================================
-- ISI TAB 1: OTOMATISASI PANCINGAN
-- ==========================================
TabPancing:AddSection({
    Name = "Kendali Utama Makro"
})

-- Saklar Utama Pancingan
TabPancing:AddToggle({
    Name = "Auto Fishing (UTAMA)",
    Description = "Menyalakan seluruh rangkaian sistem makro pancing",
    Default = false,
    Callback = function(state)
        getgenv().AutoFishingState = state
    end
})

-- Dropdown Pilihan Metode Penarikan (Tangkapan)
TabPancing:AddDropdown({
    Name = "Mode Tangkapan",
    Description = "Pilih metode penarikan pancingan",
    Options = {"Perfect", "Instant"},
    Default = "Perfect",
    Callback = function(pilihan)
        getgenv().FishingMode = pilihan
    end
})

-- Dropdown Pilihan Prioritas Target
TabPancing:AddDropdown({
    Name = "Target Prioritas",
    Description = "Fokus penarikan objek di dalam game",
    Options = {"Chest", "Fish"},
    Default = "Chest",
    Callback = function(pilihan)
        getgenv().TargetType = pilihan
    end
})

TabPancing:AddSection({
    Name = "Sistem Pendukung & AFK"
})

-- Saklar Otomatis Membuka Peti
TabPancing:AddToggle({
    Name = "Auto Open Semua Jenis Peti",
    Description = "Menghancurkan peti otomatis dari dalam tas",
    Default = true,
    Callback = function(state)
        getgenv().AutoOpenAllChests = state
    end
})

-- Saklar Anti-AFK Roblox
TabPancing:AddToggle({
    Name = "Anti-AFK Protection",
    Description = "Mencegah putus koneksi server (Error 203)",
    Default = true,
    Callback = function(state)
        getgenv().AntiAfkEnabled = state
    end
})

-- Saklar Pengoptimal Perangkat (FPS Booster)
TabPancing:AddToggle({
    Name = "FPS Booster (AFK Mode)",
    Description = "Mematikan rendering game agar perangkat tetap dingin",
    Default = false,
    Callback = function(state)
        getgenv().FpsBoostEnabled = state
    end
})


-- ==========================================
-- ISI TAB 2: TOKO & ITEM (FITUR TERLENGKAP)
-- ==========================================
TabEkonomi:AddSection({
    Name = "Manajemen Umpan & Penjualan"
})

-- Saklar Otomatis Beli Umpan
TabEkonomi:AddToggle({
    Name = "Auto Buy Bait",
    Description = "Otomatis membeli umpan di server saat jumlahnya habis (0)",
    Default = true,
    Callback = function(state)
        getgenv().AutoBuyBaitEnabled = state
    end
})

-- Dropdown Pilihan Semua Jenis Umpan Berdasarkan Lautan (First, Second, Third Sea)
TabEkonomi:AddDropdown({
    Name = "Pilih Jenis Umpan",
    Description = "Tentukan jenis umpan yang dibeli otomatis sesuai lautan kamu",
    Options = {
        "Basic",
        "Kelp Bait",
        "Good Bait",
        "Frozen Bait",
        "Abyssal Bait",
        "Carnivore Bait",
        "Epic Bait"
    },
    Default = "Basic",
    Callback = function(pilihan)
        getgenv().SelectedBaitType = pilihan
    end
})

-- Saklar Otomatis Jual Ikan
TabEkonomi:AddToggle({
    Name = "Auto Sell Fish",
    Description = "Otomatis menjual seluruh hasil tangkapan saat tas penuh",
    Default = true,
    Callback = function(state)
        getgenv().AutoSellEnabled = state
    end
})

-- Saklar Teleport Zona Aman
TabEkonomi:AddToggle({
    Name = "Teleport Safe Zone",
    Description = "Memindahkan karakter ke titik laut tersembunyi agar anti-report",
    Default = true,
    Callback = function(state)
        getgenv().SafeZoneTeleport = state
    end
})
