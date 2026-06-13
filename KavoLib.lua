local Kavo = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

function Kavo.CreateLib(title)
    local DarkTheme = {
        MainHeader = Color3.fromRGB(28, 28, 30),
        Background = Color3.fromRGB(36, 36, 38),
        ElementColor = Color3.fromRGB(44, 44, 46),
        TextColor = Color3.fromRGB(255, 255, 255),
        AccentColor = Color3.fromRGB(255, 184, 0)
    }
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KavoDeepSeaHub"
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 525, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -262, 0.5, -175)
    MainFrame.BackgroundColor3 = DarkTheme.Background
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)
    
    local TopHeader = Instance.new("Frame")
    TopHeader.Size = UDim2.new(1, 0, 0, 40)
    TopHeader.BackgroundColor3 = DarkTheme.MainHeader
    TopHeader.Parent = MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -120, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Text = tostring(title or "FISHING HUB")
    TitleLabel.TextColor3 = DarkTheme.TextColor
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 18
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopHeader

    local InfoCloseLabel = Instance.new("TextLabel")
    InfoCloseLabel.Size = UDim2.new(0, 120, 1, 0)
    InfoCloseLabel.Position = UDim2.new(1, -125, 0, 0)
    InfoCloseLabel.Text = "[Tekan Right-Shift]"
    InfoCloseLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    InfoCloseLabel.Font = Enum.Font.SourceSansItalic
    InfoCloseLabel.TextSize = 12
    InfoCloseLabel.BackgroundTransparency = 1
    InfoCloseLabel.TextXAlignment = Enum.TextXAlignment.Right
    InfoCloseLabel.Parent = TopHeader

    local SideTabContainer = Instance.new("Frame")
    SideTabContainer.Size = UDim2.new(0, 140, 1, -40)
    SideTabContainer.Position = UDim2.new(0, 0, 0, 40)
    SideTabContainer.BackgroundColor3 = DarkTheme.MainHeader
    SideTabContainer.Parent = MainFrame
    
    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = SideTabContainer

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -140, 1, -40)
    ContentContainer.Position = UDim2.new(0, 140, 0, 40)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local ElementsEngine = {}
    
    function ElementsEngine:NewTab(tabName)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = DarkTheme.TextColor
        TabButton.BackgroundColor3 = DarkTheme.MainHeader
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = SideTabContainer
        
        local PageScroll = Instance.new("ScrollingFrame")
        PageScroll.Size = UDim2.new(1, -10, 1, -10)
        PageScroll.Position = UDim2.new(0, 5, 0, 5)
        PageScroll.BackgroundTransparency = 1
        PageScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
        PageScroll.Visible = false
        PageScroll.Parent = ContentContainer
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = PageScroll
        PageLayout.Padding = UDim.new(0, 7)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(ContentContainer:GetChildren()) do
                if page:IsA("ScrollingFrame") then page.Visible = false end
            end
            PageScroll.Visible = true
        end)
        
        local SectionEngine = {}
        
        function SectionEngine:NewSection(sectionName)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 0, 20)
            SectionLabel.Text = sectionName:upper()
            SectionLabel.TextColor3 = DarkTheme.AccentColor
            SectionLabel.Font = Enum.Font.SourceSansBold
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Parent = PageScroll
            
            local ComponentEngine = {}
            
            function ComponentEngine:NewToggle(toggleName, desc, callback)
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
                ToggleFrame.BackgroundColor3 = DarkTheme.ElementColor
                ToggleFrame.Parent = PageScroll
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = DarkTheme.TextColor
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Parent = ToggleFrame
                
                local Indicator = Instance.new("TextButton")
                Indicator.Size = UDim2.new(0, 45, 0, 22)
                Indicator.Position = UDim2.new(1, -55, 0.5, -11)
                Indicator.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
                Indicator.Text = "OFF"
                Indicator.TextColor3 = DarkTheme.TextColor
                Indicator.Parent = ToggleFrame
                
                local toggleState = false
                Indicator.MouseButton1Click:Connect(function()
                    toggleState = not toggleState
                    if toggleState then
                        Indicator.BackgroundColor3 = DarkTheme.AccentColor
                        Indicator.Text = "ON"
                    else
                        Indicator.BackgroundColor3 = Color3.fromRGB(90, 90, 95)
                        Indicator.Text = "OFF"
                    end
                    pcall(callback, toggleState)
                end)
            end
            
            function ComponentEngine:NewDropdown(dropName, desc, list, callback)
                local DropFrame = Instance.new("Frame")
                DropFrame.Size = UDim2.new(1, -10, 0, 40)
                DropFrame.BackgroundColor3 = DarkTheme.ElementColor
                DropFrame.Parent = PageScroll
                
                local DropLabel = Instance.new("TextLabel")
                DropLabel.Size = UDim2.new(0.5, 0, 1, 0)
                DropLabel.Position = UDim2.new(0, 10, 0, 0)
                DropLabel.Text = dropName
                DropLabel.TextColor3 = DarkTheme.TextColor
                DropLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropLabel.BackgroundTransparency = 1
                DropLabel.Parent = DropFrame
                
                local MainButton = Instance.new("TextButton")
                MainButton.Size = UDim2.new(0, 120, 0, 25)
                MainButton.Position = UDim2.new(1, -130, 0.5, -12)
                MainButton.BackgroundColor3 = DarkTheme.MainHeader
                MainButton.Text = list[1] or "Pilih..."
                MainButton.TextColor3 = DarkTheme.TextColor
                MainButton.Parent = DropFrame
                
                local internalIndex = 1
                MainButton.MouseButton1Click:Connect(function()
                    internalIndex = internalIndex + 1
                    if internalIndex > #list then internalIndex = 1 end
                    MainButton.Text = list[internalIndex]
                    pcall(callback, list[internalIndex])
                end)
            end
            
            return ComponentEngine
        end
        return SectionEngine
    end
    
    task.spawn(function()
        task.wait(0.1)
        local firstPage = ContentContainer:FindFirstChildOfClass("ScrollingFrame")
        if firstPage then firstPage.Visible = true end
    end)
    
    return ElementsEngine
end

return Kavo
