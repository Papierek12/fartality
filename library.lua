-- // Library.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- // UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Fatality"
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 100

-- // Theme Colors
local Colors = {
    Background = Color3.fromRGB(15, 12, 28),
    Section = Color3.fromRGB(22, 19, 38),
    Accent = Color3.fromRGB(180, 20, 60),
    Text = Color3.fromRGB(255, 255, 255),
    LabelText = Color3.fromRGB(220, 220, 220),
    DarkText = Color3.fromRGB(140, 140, 160), 
    ControlBg = Color3.fromRGB(12, 10, 20),
    Dropdown = Color3.fromRGB(18, 15, 30),
    DropdownSelectedBg = Color3.fromRGB(35, 30, 50)
}

-- // Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 750, 0, 500)
Main.Position = UDim2.new(0.5, -375, 0.5, -250)
Main.BackgroundColor3 = Colors.Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 4)
UICorner.Parent = Main

-- // Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 45)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 2
TopBar.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "FATALITY"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Colors.Text
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 100, 1, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local TabContainer = Instance.new("Frame")
TabContainer.Position = UDim2.new(0, 120, 0, 0)
TabContainer.Size = UDim2.new(1, -120, 1, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = TopBar

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabListLayout.Padding = UDim.new(0, 15)
TabListLayout.Parent = TabContainer

local PageContainer = Instance.new("Frame")
PageContainer.Name = "Pages"
PageContainer.Size = UDim2.new(1, 0, 1, -45)
PageContainer.Position = UDim2.new(0, 0, 0, 45)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = Main

local DropdownContainer = Instance.new("Frame")
DropdownContainer.Name = "Dropdowns"
DropdownContainer.Size = UDim2.new(1, 0, 1, 0)
DropdownContainer.BackgroundTransparency = 1
DropdownContainer.ZIndex = 100 
DropdownContainer.Parent = Main

-----------------------------------------------------------
-- // LOGIC // --
-----------------------------------------------------------

-- [NEW] TOGGLE UI VISIBILITY
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

local CurrentTabData = nil
local ActiveMenu = nil 

local function CloseCurrentMenu()
    if ActiveMenu then
        ActiveMenu.Close()
        ActiveMenu = nil
    end
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if ActiveMenu then
            local objects = Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
            local hitMenu = false
            local hitTrigger = false
            for _, v in pairs(objects) do
                if v == ActiveMenu.Frame or v:IsDescendantOf(ActiveMenu.Frame) then hitMenu = true end
                if v == ActiveMenu.Trigger or v:IsDescendantOf(ActiveMenu.Trigger) then hitTrigger = true end
            end
            if not hitMenu and not hitTrigger then CloseCurrentMenu() end
        end
    end
end)

local function CreateTab(imageId, name)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 90, 0, 30)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = ""
    TabButton.Parent = TabContainer

    local Layout = Instance.new("UIListLayout")
    Layout.FillDirection = Enum.FillDirection.Horizontal
    Layout.VerticalAlignment = Enum.VerticalAlignment.Center
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = TabButton

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://" .. tostring(imageId)
    Icon.ImageColor3 = Colors.DarkText
    Icon.Parent = TabButton

    local Label = Instance.new("TextLabel")
    Label.Text = name:upper()
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 12
    Label.TextColor3 = Colors.DarkText
    Label.AutomaticSize = Enum.AutomaticSize.X
    Label.BackgroundTransparency = 1
    Label.Parent = TabButton

    local PageFrame = Instance.new("Frame")
    PageFrame.Size = UDim2.new(1, 0, 1, 0)
    PageFrame.BackgroundTransparency = 1
    PageFrame.Visible = false
    PageFrame.Parent = PageContainer

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 120, 1, -20)
    Sidebar.Position = UDim2.new(0, 10, 0, 10)
    Sidebar.BackgroundTransparency = 1
    Sidebar.Parent = PageFrame

    local SideList = Instance.new("UIListLayout")
    SideList.Padding = UDim.new(0, 5)
    SideList.Parent = Sidebar

    local ContentArea = Instance.new("Frame")
    ContentArea.Position = UDim2.new(0, 140, 0, 10)
    ContentArea.Size = UDim2.new(1, -150, 1, -20)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = PageFrame

    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.FillDirection = Enum.FillDirection.Horizontal
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = ContentArea

    local function Select()
        if CurrentTabData then
            CurrentTabData.Icon.ImageColor3 = Colors.DarkText
            CurrentTabData.Label.TextColor3 = Colors.DarkText
            CurrentTabData.Page.Visible = false
        end
        CurrentTabData = {Icon = Icon, Label = Label, Page = PageFrame}
        Icon.ImageColor3 = Colors.Accent
        Label.TextColor3 = Colors.Text
        PageFrame.Visible = true
    end
    TabButton.MouseButton1Click:Connect(Select)

    local TabObject = {}
    TabObject.Select = Select

    function TabObject:CreateSection(title)
        local SectionFrame = Instance.new("Frame")
        SectionFrame.Size = UDim2.new(0.32, 0, 1, 0)
        SectionFrame.BackgroundColor3 = Colors.Section
        SectionFrame.BorderSizePixel = 0
        SectionFrame.Parent = ContentArea

        local SectionCorner = Instance.new("UICorner")
        SectionCorner.CornerRadius = UDim.new(0, 4)
        SectionCorner.Parent = SectionFrame

        local SectionTitle = Instance.new("TextLabel")
        SectionTitle.Text = title:upper()
        SectionTitle.Size = UDim2.new(1, 0, 0, 30)
        SectionTitle.BackgroundTransparency = 1
        SectionTitle.Font = Enum.Font.GothamBold
        SectionTitle.TextColor3 = Colors.Text
        SectionTitle.TextSize = 11
        SectionTitle.Parent = SectionFrame

        local Container = Instance.new("ScrollingFrame")
        Container.Position = UDim2.new(0, 10, 0, 35)
        Container.Size = UDim2.new(1, -20, 1, -45)
        Container.BackgroundTransparency = 1
        Container.ScrollBarThickness = 2
        Container.BorderSizePixel = 0
        Container.Parent = SectionFrame

        local List = Instance.new("UIListLayout")
        List.Padding = UDim.new(0, 8)
        List.Parent = Container

        List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Container.CanvasSize = UDim2.new(0, 0, 0, List.AbsoluteContentSize.Y + 10)
        end)

        local SectionObject = {}

        function SectionObject:AddToggle(text, default, callback)
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Name = "Toggle"
            ToggleFrame.Size = UDim2.new(1, 0, 0, 20)
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Text = ""
            ToggleFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Colors.LabelText
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame

            local Box = Instance.new("Frame")
            Box.Size = UDim2.new(0, 14, 0, 14)
            Box.AnchorPoint = Vector2.new(1, 0.5)
            Box.Position = UDim2.new(1, 0, 0.5, 0)
            Box.BackgroundColor3 = Colors.ControlBg
            Box.BorderSizePixel = 0
            Box.Parent = ToggleFrame
            
            local BoxCorner = Instance.new("UICorner")
            BoxCorner.CornerRadius = UDim.new(0, 3)
            BoxCorner.Parent = Box

            local Check = Instance.new("Frame")
            Check.Size = UDim2.new(1, 0, 1, 0)
            Check.BackgroundColor3 = Colors.Accent
            Check.Visible = default
            Check.Parent = Box
            
            local CheckCorner = Instance.new("UICorner")
            CheckCorner.CornerRadius = UDim.new(0, 3)
            CheckCorner.Parent = Check

            local state = default
            ToggleFrame.MouseButton1Click:Connect(function()
                state = not state
                Check.Visible = state
                callback(state)
            end)
        end

        function SectionObject:AddSlider(text, min, max, default, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 20)
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Colors.LabelText
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame

            local SliderContainer = Instance.new("Frame")
            SliderContainer.Size = UDim2.new(0.5, 0, 1, 0)
            SliderContainer.Position = UDim2.new(0.5, 0, 0, 0)
            SliderContainer.BackgroundColor3 = Colors.ControlBg
            SliderContainer.BorderSizePixel = 0
            SliderContainer.ClipsDescendants = true
            SliderContainer.Parent = SliderFrame
            
            local SC_Corner = Instance.new("UICorner")
            SC_Corner.CornerRadius = UDim.new(0, 4)
            SC_Corner.Parent = SliderContainer

            local Bar = Instance.new("Frame")
            Bar.Name = "SliderBar"
            Bar.Size = UDim2.new(1, 0, 1, 0)
            Bar.BackgroundTransparency = 1
            Bar.Parent = SliderContainer

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
            Fill.BackgroundColor3 = Colors.Accent
            Fill.BorderSizePixel = 0
            Fill.Parent = Bar
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 4)
            FillCorner.Parent = Fill

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(1, 0, 1, 0)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Colors.Text
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 10
            ValueLabel.ZIndex = 2
            ValueLabel.Parent = Bar

            local function Update(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = min + (max - min) * pos
                val = math.floor(val * 10) / 10
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            Bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Update(input)
                    local moveCon; moveCon = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then moveCon:Disconnect() end
                    end)
                end
            end)
        end
        
        function SectionObject:AddColorPicker(text, default, callback)
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, 0, 0, 20)
            ColorFrame.BackgroundTransparency = 1
            ColorFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Colors.LabelText
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ColorFrame

            local PreviewBtn = Instance.new("TextButton")
            PreviewBtn.Size = UDim2.new(0, 24, 0, 14)
            PreviewBtn.AnchorPoint = Vector2.new(1, 0.5)
            PreviewBtn.Position = UDim2.new(1, 0, 0.5, 0)
            PreviewBtn.BackgroundColor3 = default
            PreviewBtn.BorderSizePixel = 0
            PreviewBtn.Text = ""
            PreviewBtn.Parent = ColorFrame
            
            local PCorner = Instance.new("UICorner")
            PCorner.CornerRadius = UDim.new(0, 3)
            PCorner.Parent = PreviewBtn
            
            -- [FIXED] Changed from Frame to TextButton to block click-through
            local PickerPop = Instance.new("TextButton") 
            PickerPop.Name = "ColorPickerPopup"
            PickerPop.Text = ""
            PickerPop.AutoButtonColor = false
            PickerPop.Size = UDim2.new(0, 140, 0, 170)
            PickerPop.BackgroundColor3 = Colors.Dropdown
            PickerPop.Visible = false
            PickerPop.ZIndex = 101
            PickerPop.Active = true 
            PickerPop.Parent = DropdownContainer
            
            local PopupCorner = Instance.new("UICorner")
            PopupCorner.CornerRadius = UDim.new(0, 6)
            PopupCorner.Parent = PickerPop
            
            local Wheel = Instance.new("ImageLabel")
            Wheel.Name = "Wheel"
            Wheel.Size = UDim2.new(0, 110, 0, 110)
            Wheel.Position = UDim2.new(0.5, -55, 0, 10)
            Wheel.BackgroundTransparency = 1
            Wheel.Image = "rbxassetid://6020299385"
            Wheel.ZIndex = 102
            Wheel.Active = true 
            Wheel.Parent = PickerPop
            
            local Cursor = Instance.new("ImageLabel")
            Cursor.Size = UDim2.new(0, 14, 0, 14)
            Cursor.AnchorPoint = Vector2.new(0.5, 0.5)
            Cursor.Position = UDim2.new(0.5, 0, 0.5, 0)
            Cursor.Image = "rbxassetid://1850167667"
            Cursor.BackgroundTransparency = 1
            Cursor.ZIndex = 103
            Cursor.Parent = Wheel

            local ValBar = Instance.new("Frame")
            ValBar.Name = "ValueBar"
            ValBar.Size = UDim2.new(0, 110, 0, 12)
            ValBar.Position = UDim2.new(0.5, -55, 0, 130)
            ValBar.BackgroundColor3 = Color3.new(1,1,1)
            ValBar.BorderSizePixel = 0
            ValBar.ZIndex = 102
            ValBar.Active = true 
            ValBar.Parent = PickerPop
            
            local VCorner = Instance.new("UICorner")
            VCorner.CornerRadius = UDim.new(0, 4)
            VCorner.Parent = ValBar
            
            local VGradient = Instance.new("UIGradient")
            VGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
                ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
            }
            VGradient.Parent = ValBar
            
            local ValInd = Instance.new("Frame")
            ValInd.Size = UDim2.new(0, 2, 1, 4)
            ValInd.Position = UDim2.new(1, -1, 0.5, -2)
            ValInd.AnchorPoint = Vector2.new(0, 0.5)
            ValInd.BackgroundColor3 = Color3.new(1,1,1)
            ValInd.BorderSizePixel = 0
            ValInd.ZIndex = 103
            ValInd.Parent = ValBar

            local RainbowBtn = Instance.new("TextButton")
            RainbowBtn.Size = UDim2.new(0, 110, 0, 18)
            RainbowBtn.Position = UDim2.new(0.5, -55, 0, 148)
            RainbowBtn.BackgroundColor3 = Colors.ControlBg
            RainbowBtn.Text = "Rainbow: OFF"
            RainbowBtn.TextColor3 = Colors.LabelText
            RainbowBtn.Font = Enum.Font.Gotham
            RainbowBtn.TextSize = 10
            RainbowBtn.ZIndex = 102
            RainbowBtn.Parent = PickerPop
            
            local RCorner = Instance.new("UICorner")
            RCorner.CornerRadius = UDim.new(0, 4)
            RCorner.Parent = RainbowBtn

            local h, s, v = 0, 0, 1
            local rainbow = false
            
            local function UpdateAll()
                local c = Color3.fromHSV(h, s, v)
                PreviewBtn.BackgroundColor3 = c
                if PickerPop.Visible then
                    VGradient.Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.new(0,0,0)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV(h, s, 1))
                    }
                end
                callback(c)
            end

            local function UpdateWheel(input)
                local center = Wheel.AbsolutePosition + (Wheel.AbsoluteSize/2)
                local vector = Vector2.new(input.Position.X, input.Position.Y) - center
                local angle = math.atan2(vector.Y, vector.X)
                local radius = math.min(vector.Magnitude, Wheel.AbsoluteSize.X/2)
                Cursor.Position = UDim2.new(0.5, math.cos(angle) * radius, 0.5, math.sin(angle) * radius)
                h = (math.pi - angle) / (2 * math.pi)
                s = radius / (Wheel.AbsoluteSize.X/2)
                UpdateAll()
            end
            
            Wheel.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    UpdateWheel(input)
                    local moveC; moveC = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then UpdateWheel(input) end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then moveC:Disconnect() end
                    end)
                end
            end)
            
            local function UpdateVal(input)
                local pos = math.clamp((input.Position.X - ValBar.AbsolutePosition.X) / ValBar.AbsoluteSize.X, 0, 1)
                ValInd.Position = UDim2.new(pos, -1, 0.5, 0)
                v = pos
                UpdateAll()
            end
            
            ValBar.InputBegan:Connect(function(input)
                 if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    UpdateVal(input)
                    local moveC; moveC = UserInputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then UpdateVal(input) end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then moveC:Disconnect() end
                    end)
                end
            end)

            RainbowBtn.MouseButton1Click:Connect(function()
                rainbow = not rainbow
                RainbowBtn.Text = "Rainbow: " .. (rainbow and "ON" or "OFF")
                RainbowBtn.TextColor3 = rainbow and Colors.Accent or Colors.LabelText
                if rainbow then
                    task.spawn(function()
                        while rainbow do
                            if not PreviewBtn or not PreviewBtn.Parent then break end
                            local hue = (tick() % 5) / 5
                            local col = Color3.fromHSV(hue, 1, 1)
                            h = hue; s = 1; v = 1
                            PreviewBtn.BackgroundColor3 = col
                            callback(col)
                            task.wait()
                        end
                    end)
                end
            end)

            PreviewBtn.MouseButton1Click:Connect(function()
                if PickerPop.Visible then CloseCurrentMenu() else
                    CloseCurrentMenu()
                    PickerPop.Visible = true
                    ActiveMenu = {Frame = PickerPop, Trigger = PreviewBtn, Close = function() PickerPop.Visible = false end}
                end
            end)
            
            RunService.RenderStepped:Connect(function()
                if PickerPop.Visible then
                    local absPos = PreviewBtn.AbsolutePosition
                    local mainPos = Main.AbsolutePosition
                    local relX = (absPos.X - mainPos.X) + PreviewBtn.AbsoluteSize.X - 140
                    local relY = absPos.Y - mainPos.Y + PreviewBtn.AbsoluteSize.Y + 2
                    PickerPop.Position = UDim2.new(0, relX, 0, relY)
                end
            end)
        end
        
        function SectionObject:AddKeybind(text, default, callback)
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(1, 0, 0, 20)
            KeybindFrame.BackgroundTransparency = 1
            KeybindFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0.6, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Colors.LabelText
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = KeybindFrame

            local KeyButton = Instance.new("TextButton")
            KeyButton.Size = UDim2.new(0.3, 0, 1, 0)
            KeyButton.Position = UDim2.new(0.7, 0, 0, 0)
            KeyButton.BackgroundColor3 = Colors.ControlBg
            KeyButton.BorderSizePixel = 0
            KeyButton.TextColor3 = Colors.DarkText
            KeyButton.Font = Enum.Font.Gotham
            KeyButton.TextSize = 11
            KeyButton.Parent = KeybindFrame
            
            local KCorner = Instance.new("UICorner")
            KCorner.CornerRadius = UDim.new(0, 4)
            KCorner.Parent = KeyButton
            
            local function FormatKey(key)
                if not key then return "None" end
                if key == Enum.UserInputType.MouseButton1 then return "LMB" end
                if key == Enum.UserInputType.MouseButton2 then return "RMB" end
                if key == Enum.UserInputType.MouseButton3 then return "MMB" end
                return key.Name
            end
            
            KeyButton.Text = FormatKey(default)
            
            local listening = false
            KeyButton.MouseButton1Click:Connect(function()
                if listening then return end
                listening = true
                KeyButton.Text = "..."
                KeyButton.TextColor3 = Colors.Accent
                local inputConnection
                inputConnection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                        local key = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode) or input.UserInputType
                        if key == Enum.KeyCode.Escape then key = nil end
                        if inputConnection then inputConnection:Disconnect(); inputConnection = nil end
                        listening = false
                        KeyButton.Text = FormatKey(key)
                        KeyButton.TextColor3 = Colors.DarkText
                        callback(key)
                    end
                end)
            end)
        end
        
        function SectionObject:AddDropdown(text, options, default, callback)
            local current = default or options[1]
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 20)
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Parent = Container

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Colors.LabelText
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = DropdownFrame

            local TriggerBtn = Instance.new("TextButton")
            TriggerBtn.Name = "Trigger"
            TriggerBtn.Size = UDim2.new(0.5, 0, 1, 0)
            TriggerBtn.Position = UDim2.new(0.5, 0, 0, 0)
            TriggerBtn.BackgroundColor3 = Colors.ControlBg
            TriggerBtn.BackgroundTransparency = 0
            TriggerBtn.Text = tostring(current)
            TriggerBtn.TextColor3 = Colors.DarkText
            TriggerBtn.Font = Enum.Font.Gotham
            TriggerBtn.TextSize = 11
            TriggerBtn.TextXAlignment = Enum.TextXAlignment.Right
            TriggerBtn.Parent = DropdownFrame
            
            local TC_Corner = Instance.new("UICorner")
            TC_Corner.CornerRadius = UDim.new(0, 4)
            TC_Corner.Parent = TriggerBtn
            
            local TPad = Instance.new("UIPadding")
            TPad.PaddingRight = UDim.new(0, 6)
            TPad.Parent = TriggerBtn

            -- [FIXED] Changed from Frame to TextButton to block click-through
            local FloatingList = Instance.new("TextButton") 
            FloatingList.Name = text .. "_List"
            FloatingList.Text = ""
            FloatingList.AutoButtonColor = false
            FloatingList.Size = UDim2.new(0, 100, 0, 0)
            FloatingList.BackgroundColor3 = Colors.Dropdown
            FloatingList.BorderSizePixel = 0
            FloatingList.Visible = false
            FloatingList.ZIndex = 101 
            FloatingList.Active = true 
            FloatingList.Parent = DropdownContainer
            
            local FL_Corner = Instance.new("UICorner")
            FL_Corner.CornerRadius = UDim.new(0, 4)
            FL_Corner.Parent = FloatingList
            
            local ListLayout = Instance.new("UIListLayout")
            ListLayout.Parent = FloatingList
            
            for _, option in ipairs(options) do
                local ItemBtn = Instance.new("TextButton")
                ItemBtn.Size = UDim2.new(1, 0, 0, 22)
                ItemBtn.BorderSizePixel = 0
                ItemBtn.Text = "  " .. tostring(option)
                ItemBtn.Font = Enum.Font.Gotham
                ItemBtn.TextSize = 11
                ItemBtn.TextXAlignment = Enum.TextXAlignment.Left
                ItemBtn.ZIndex = 102
                ItemBtn.Parent = FloatingList
                ItemBtn.TextColor3 = (option == current) and Colors.Accent or Colors.Text
                ItemBtn.BackgroundColor3 = (option == current) and Colors.DropdownSelectedBg or Colors.Dropdown
                
                ItemBtn.MouseButton1Click:Connect(function()
                    current = option
                    TriggerBtn.Text = tostring(current)
                    CloseCurrentMenu()
                    for _, btn in pairs(FloatingList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = Colors.Text
                            btn.BackgroundColor3 = Colors.Dropdown
                        end
                    end
                    ItemBtn.TextColor3 = Colors.Accent
                    ItemBtn.BackgroundColor3 = Colors.DropdownSelectedBg
                    callback(current)
                end)
            end

            TriggerBtn.MouseButton1Click:Connect(function()
                if FloatingList.Visible then CloseCurrentMenu() else
                    CloseCurrentMenu()
                    FloatingList.Visible = true
                    TriggerBtn.TextColor3 = Colors.Text
                    FloatingList.Size = UDim2.new(0, 140, 0, #options * 22)
                    ActiveMenu = {Frame = FloatingList, Trigger = TriggerBtn, Close = function() 
                        FloatingList.Visible = false
                        TriggerBtn.TextColor3 = Colors.DarkText
                    end}
                end
            end)
            
            RunService.RenderStepped:Connect(function()
                if FloatingList.Visible then
                    local absPos = TriggerBtn.AbsolutePosition
                    local mainPos = Main.AbsolutePosition
                    local relX = (absPos.X - mainPos.X) + TriggerBtn.AbsoluteSize.X - 140
                    local relY = absPos.Y - mainPos.Y + TriggerBtn.AbsoluteSize.Y + 2
                    FloatingList.Position = UDim2.new(0, relX, 0, relY)
                end
            end)
        end

        return SectionObject
    end

    function TabObject:CreateSubTab(subName)
        local Sub = Instance.new("TextButton")
        Sub.Size = UDim2.new(1, 0, 0, 25)
        Sub.Text = subName
        Sub.Font = Enum.Font.Gotham
        Sub.TextSize = 13
        Sub.TextColor3 = Colors.DarkText
        Sub.BackgroundTransparency = 1
        Sub.TextXAlignment = Enum.TextXAlignment.Left
        Sub.Parent = Sidebar
    end

    return TabObject
end

-- // Dragging Logic
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local objects = Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
        for _, v in pairs(objects) do if v:IsA("TextButton") then return end end
        dragging = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

return CreateTab
