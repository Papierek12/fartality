-- // Library.lua
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Library = {}

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

function Library:Init()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Fatality"
    ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 100

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 750, 0, 500)
    Main.Position = UDim2.new(0.5, -375, 0.5, -250)
    Main.BackgroundColor3 = Colors.Background
    Main.BorderSizePixel = 0
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 4)

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
    Instance.new("UIListLayout", TabContainer).FillDirection = Enum.FillDirection.Horizontal
    TabContainer.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabContainer.UIListLayout.Padding = UDim.new(0, 15)

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
                local hitMenu, hitTrigger = false, false
                for _, v in pairs(objects) do
                    if v == ActiveMenu.Frame or v:IsDescendantOf(ActiveMenu.Frame) then hitMenu = true end
                    if v == ActiveMenu.Trigger or v:IsDescendantOf(ActiveMenu.Trigger) then hitTrigger = true end
                end
                if not hitMenu and not hitTrigger then CloseCurrentMenu() end
            end
        end
    end)

    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    function Library:CreateTab(imageId, name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 90, 0, 30)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.Parent = TabContainer

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 16, 0, 16)
        Icon.BackgroundTransparency = 1
        Icon.Image = "rbxassetid://" .. tostring(imageId)
        Icon.ImageColor3 = Colors.DarkText
        Icon.Parent = TabButton
        Instance.new("UIListLayout", TabButton).FillDirection = Enum.FillDirection.Horizontal
        TabButton.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        TabButton.UIListLayout.Padding = UDim.new(0, 6)

        local Label = Instance.new("TextLabel")
        Label.Text = name:upper()
        Label.Font = Enum.Font.GothamBold
        Label.TextSize = 12
        Label.TextColor3 = Colors.DarkText
        Label.BackgroundTransparency = 1
        Label.AutomaticSize = Enum.AutomaticSize.X
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
        Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

        local ContentArea = Instance.new("Frame")
        ContentArea.Position = UDim2.new(0, 140, 0, 10)
        ContentArea.Size = UDim2.new(1, -150, 1, -20)
        ContentArea.BackgroundTransparency = 1
        ContentArea.Parent = PageFrame
        Instance.new("UIListLayout", ContentArea).FillDirection = Enum.FillDirection.Horizontal
        ContentArea.UIListLayout.Padding = UDim.new(0, 10)

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
            Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 4)

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
            local List = Instance.new("UIListLayout", Container)
            List.Padding = UDim.new(0, 8)
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                Container.CanvasSize = UDim2.new(0,0,0, List.AbsoluteContentSize.Y + 10)
            end)

            local SectionObject = {}

            function SectionObject:AddToggle(text, default, callback)
                local ToggleBtn = Instance.new("TextButton")
                ToggleBtn.Size = UDim2.new(1, 0, 0, 20)
                ToggleBtn.BackgroundTransparency = 1
                ToggleBtn.Text = ""
                ToggleBtn.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Text = text
                Lbl.Size = UDim2.new(0.6, 0, 1, 0)
                Lbl.TextColor3 = Colors.LabelText
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextSize = 12
                Lbl.BackgroundTransparency = 1
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = ToggleBtn

                local Box = Instance.new("Frame")
                Box.Size = UDim2.new(0, 14, 0, 14)
                Box.Position = UDim2.new(1, 0, 0.5, 0)
                Box.AnchorPoint = Vector2.new(1, 0.5)
                Box.BackgroundColor3 = Colors.ControlBg
                Box.BorderSizePixel = 0
                Box.Parent = ToggleBtn
                Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 3)

                local Check = Instance.new("Frame")
                Check.Size = UDim2.new(1, 0, 1, 0)
                Check.BackgroundColor3 = Colors.Accent
                Check.Visible = default
                Check.Parent = Box
                Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 3)

                local state = default
                ToggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    Check.Visible = state
                    callback(state)
                end)
            end

            function SectionObject:AddSlider(text, min, max, default, callback)
                local SFrame = Instance.new("Frame")
                SFrame.Size = UDim2.new(1, 0, 0, 25)
                SFrame.BackgroundTransparency = 1
                SFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Text = text
                Lbl.Size = UDim2.new(0.4, 0, 1, 0)
                Lbl.TextColor3 = Colors.LabelText
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextSize = 12
                Lbl.BackgroundTransparency = 1
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = SFrame

                local SliderContainer = Instance.new("Frame")
                SliderContainer.Size = UDim2.new(0.55, 0, 0, 16)
                SliderContainer.Position = UDim2.new(1, 0, 0.5, 0)
                SliderContainer.AnchorPoint = Vector2.new(1, 0.5)
                SliderContainer.BackgroundColor3 = Colors.ControlBg
                SliderContainer.Parent = SFrame
                Instance.new("UICorner", SliderContainer).CornerRadius = UDim.new(0, 4)

                local Bar = Instance.new("Frame")
                Bar.Size = UDim2.new(1, 0, 1, 0)
                Bar.BackgroundTransparency = 1
                Bar.Parent = SliderContainer

                local Fill = Instance.new("Frame")
                Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
                Fill.BackgroundColor3 = Colors.Accent
                Fill.Parent = Bar
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 4)

                local ValLbl = Instance.new("TextLabel")
                ValLbl.Size = UDim2.new(1, 0, 1, 0)
                ValLbl.Text = tostring(default)
                ValLbl.TextColor3 = Colors.Text
                ValLbl.Font = Enum.Font.GothamBold
                ValLbl.TextSize = 10
                ValLbl.BackgroundTransparency = 1
                ValLbl.ZIndex = 2
                ValLbl.Parent = Bar

                local function Update(input)
                    local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Fill.Size = UDim2.new(pos, 0, 1, 0)
                    local val = math.floor((min + (max - min) * pos) * 10) / 10
                    ValLbl.Text = tostring(val)
                    callback(val)
                end

                Bar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Update(input)
                        local move = UserInputService.InputChanged:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseMovement then Update(inp) end
                        end)
                        local ended; ended = UserInputService.InputEnded:Connect(function(inp)
                            if inp.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() ended:Disconnect() end
                        end)
                    end
                end)
            end

            function SectionObject:AddDropdown(text, options, default, callback)
                local current = default or options[1]
                local DFrame = Instance.new("Frame")
                DFrame.Size = UDim2.new(1, 0, 0, 20)
                DFrame.BackgroundTransparency = 1
                DFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Text = text
                Lbl.Size = UDim2.new(0.5, 0, 1, 0)
                Lbl.TextColor3 = Colors.LabelText
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextSize = 12
                Lbl.BackgroundTransparency = 1
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = DFrame

                local Trigger = Instance.new("TextButton")
                Trigger.Size = UDim2.new(0.5, 0, 1, 0)
                Trigger.Position = UDim2.new(1, 0, 0.5, 0)
                Trigger.AnchorPoint = Vector2.new(1, 0.5)
                Trigger.BackgroundColor3 = Colors.ControlBg
                Trigger.Text = tostring(current)
                Trigger.TextColor3 = Colors.DarkText
                Trigger.Font = Enum.Font.Gotham
                Trigger.TextSize = 11
                Trigger.TextXAlignment = Enum.TextXAlignment.Right
                Trigger.Parent = DFrame
                Instance.new("UICorner", Trigger).CornerRadius = UDim.new(0, 4)
                Instance.new("UIPadding", Trigger).PaddingRight = UDim.new(0, 6)

                local ListFrame = Instance.new("Frame")
                ListFrame.Size = UDim2.new(0, 140, 0, #options * 22)
                ListFrame.BackgroundColor3 = Colors.Dropdown
                ListFrame.Visible = false
                ListFrame.ZIndex = 105
                ListFrame.Parent = DropdownContainer
                Instance.new("UICorner", ListFrame).CornerRadius = UDim.new(0, 4)
                local ListLayout = Instance.new("UIListLayout", ListFrame)

                for _, opt in ipairs(options) do
                    local Btn = Instance.new("TextButton")
                    Btn.Size = UDim2.new(1, 0, 0, 22)
                    Btn.BackgroundColor3 = (opt == current) and Colors.DropdownSelectedBg or Colors.Dropdown
                    Btn.TextColor3 = (opt == current) and Colors.Accent or Colors.Text
                    Btn.Text = "  " .. tostring(opt)
                    Btn.Font = Enum.Font.Gotham
                    Btn.TextSize = 11
                    Btn.TextXAlignment = Enum.TextXAlignment.Left
                    Btn.Parent = ListFrame
                    
                    Btn.MouseButton1Click:Connect(function()
                        current = opt
                        Trigger.Text = tostring(current)
                        for _, v in pairs(ListFrame:GetChildren()) do
                            if v:IsA("TextButton") then v.TextColor3 = Colors.Text v.BackgroundColor3 = Colors.Dropdown end
                        end
                        Btn.TextColor3 = Colors.Accent
                        Btn.BackgroundColor3 = Colors.DropdownSelectedBg
                        CloseCurrentMenu()
                        callback(opt)
                    end)
                end

                Trigger.MouseButton1Click:Connect(function()
                    if ListFrame.Visible then CloseCurrentMenu() else
                        CloseCurrentMenu()
                        ListFrame.Visible = true
                        ActiveMenu = {Frame = ListFrame, Trigger = Trigger, Close = function() ListFrame.Visible = false end}
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if ListFrame.Visible then
                        local abs = Trigger.AbsolutePosition
                        local mabs = Main.AbsolutePosition
                        ListFrame.Position = UDim2.new(0, (abs.X - mabs.X) + Trigger.AbsoluteSize.X - 140, 0, abs.Y - mabs.Y + Trigger.AbsoluteSize.Y + 2)
                    end
                end)
            end

            function SectionObject:AddKeybind(text, default, callback)
                local KFrame = Instance.new("Frame")
                KFrame.Size = UDim2.new(1, 0, 0, 20)
                KFrame.BackgroundTransparency = 1
                KFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Text = text
                Lbl.Size = UDim2.new(0.6, 0, 1, 0)
                Lbl.TextColor3 = Colors.LabelText
                Lbl.Font = Enum.Font.Gotham
                Lbl.BackgroundTransparency = 1
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = KFrame

                local Btn = Instance.new("TextButton")
                Btn.Size = UDim2.new(0.35, 0, 1, 0)
                Btn.Position = UDim2.new(1, 0, 0.5, 0)
                Btn.AnchorPoint = Vector2.new(1, 0.5)
                Btn.BackgroundColor3 = Colors.ControlBg
                Btn.TextColor3 = Colors.DarkText
                Btn.Font = Enum.Font.Gotham
                Btn.TextSize = 11
                Btn.Parent = KFrame
                Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

                local function FormatKey(key)
                    if not key then return "None" end
                    if key == Enum.UserInputType.MouseButton1 then return "LMB" end
                    if key == Enum.UserInputType.MouseButton2 then return "RMB" end
                    return key.Name or tostring(key)
                end

                Btn.Text = FormatKey(default)
                local listening = false
                Btn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    Btn.Text = "..."
                    local conn; conn = UserInputService.InputBegan:Connect(function(inp)
                        if inp.UserInputType == Enum.UserInputType.Keyboard or inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType.MouseButton2 then
                            local key = (inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode) or inp.UserInputType
                            conn:Disconnect()
                            listening = false
                            Btn.Text = FormatKey(key)
                            callback(key)
                        end
                    end)
                end)
            end

            function SectionObject:AddColorPicker(text, default, callback)
                local CFrame = Instance.new("Frame")
                CFrame.Size = UDim2.new(1, 0, 0, 20)
                CFrame.BackgroundTransparency = 1
                CFrame.Parent = Container

                local Lbl = Instance.new("TextLabel")
                Lbl.Text = text
                Lbl.Size = UDim2.new(0.6, 0, 1, 0)
                Lbl.TextColor3 = Colors.LabelText
                Lbl.Font = Enum.Font.Gotham
                Lbl.BackgroundTransparency = 1
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                Lbl.Parent = CFrame

                local Preview = Instance.new("TextButton")
                Preview.Size = UDim2.new(0, 24, 0, 14)
                Preview.Position = UDim2.new(1, 0, 0.5, 0)
                Preview.AnchorPoint = Vector2.new(1, 0.5)
                Preview.BackgroundColor3 = default
                Preview.Text = ""
                Preview.Parent = CFrame
                Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 3)

                local Pop = Instance.new("Frame")
                Pop.Size = UDim2.new(0, 140, 0, 120)
                Pop.BackgroundColor3 = Colors.Dropdown
                Pop.Visible = false
                Pop.ZIndex = 110
                Pop.Parent = DropdownContainer
                Instance.new("UICorner", Pop).CornerRadius = UDim.new(0, 4)

                Preview.MouseButton1Click:Connect(function()
                    if Pop.Visible then CloseCurrentMenu() else
                        CloseCurrentMenu()
                        Pop.Visible = true
                        ActiveMenu = {Frame = Pop, Trigger = Preview, Close = function() Pop.Visible = false end}
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if Pop.Visible then
                        local abs = Preview.AbsolutePosition
                        local mabs = Main.AbsolutePosition
                        Pop.Position = UDim2.new(0, (abs.X - mabs.X) - 116, 0, abs.Y - mabs.Y + 20)
                    end
                end)
            end

            return SectionObject
        end

        function TabObject:CreateSubTab(name)
            local Sub = Instance.new("TextButton")
            Sub.Size = UDim2.new(1, 0, 0, 25)
            Sub.BackgroundTransparency = 1
            Sub.Text = name
            Sub.Font = Enum.Font.Gotham
            Sub.TextColor3 = Colors.DarkText
            Sub.TextSize = 12
            Sub.TextXAlignment = Enum.TextXAlignment.Left
            Sub.Parent = Sidebar
        end

        return TabObject
    end

    return Library
end

return Library
