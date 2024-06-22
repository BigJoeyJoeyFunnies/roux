local rawloadtime = tick() 
local loadtime = math.round(rawloadtime * 1000)  
local ltstring = tostring(loadtime)
local finalloadtime = ltstring:sub(1, 3)local library =  loadfile('bankware/guilib.lua')() -- loadstring(game:HttpGet('https://pastebin.com/raw/CVXCWX8z'))()

-- // Window \\ --
local window = library.new('Bankware', 'bank')

-- // Tabs \\ --
local combat = window.new_tab('rbxassetid://17737804660')
local blatant = window.new_tab('rbxassetid://17737804799') 
local render = window.new_tab('rbxassetid://17737804935')
local ghost = window.new_tab('rbxassetid://17737805024')


-- // Sections \\ --
local combat = combat.new_section('combat')
local render = render.new_section('render')
local blatant = blatant.new_section('blatant')
local ghost = ghost.new_section('ghost')

-- // Sector \\ --
local Aimlock = combat.new_sector('Aimlock', 'Left')

local SPEED = blatant.new_sector('Speed', 'Right')
local Flight = blatant.new_sector('Flight', 'Left')
local Player = blatant.new_sector('Player', 'Left')

local ESP = render.new_sector('ESP', 'Left')
local Atmos = render.new_sector('Atmosphere (kinda broken)', 'Right')


-- // COMBAT \\ 
 
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Holding = false

_G.AimbotEnabled = false
_G.TeamCheck = false
_G.AimPart = "Head"
_G.Sensitivity = 0
_G.CircleSides = 64
_G.CircleColor = Color3.fromRGB(0, 179, 27)
_G.CircleTransparency = 0.7
_G.CircleRadius = 80
_G.CircleFilled = false
_G.CircleVisible = false
_G.CircleThickness = 3
_G.AimbotKey = Enum.UserInputType.MouseButton2 -- Default keybind

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function IsInFOV(position)
    local screenPoint = Camera:WorldToScreenPoint(position)
    return screenPoint.Z > 0
end

local function GetClosestPlayer()
    local MaximumDistance = _G.CircleRadius
    local Target = nil
    local ShortestDistance = MaximumDistance

    for _, v in next, Players:GetPlayers() do
        if v.Name ~= LocalPlayer.Name then
            if _G.TeamCheck == true and v.Team == LocalPlayer.Team then
                continue
            end

            if v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") ~= nil and v.Character:FindFirstChild("Humanoid") ~= nil and v.Character:FindFirstChild("Humanoid").Health ~= 0 then
                local characterPosition = v.Character.HumanoidRootPart.Position
                if IsInFOV(characterPosition) then
                    local screenPoint = Camera:WorldToScreenPoint(characterPosition)
                    local vectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(screenPoint.X, screenPoint.Y)).Magnitude

                    if vectorDistance < ShortestDistance then
                        ShortestDistance = vectorDistance
                        Target = v
                    end
                end
            end
        end
    end

    return Target
end

UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == _G.AimbotKey then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == _G.AimbotKey then
        Holding = false
    end
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = _G.CircleRadius
    FOVCircle.Filled = _G.CircleFilled
    FOVCircle.Color = _G.CircleColor
    FOVCircle.Visible = _G.CircleVisible
    FOVCircle.Transparency = _G.CircleTransparency
    FOVCircle.NumSides = _G.CircleSides
    FOVCircle.Thickness = _G.CircleThickness

    if Holding == true and _G.AimbotEnabled == true then
        local Target = GetClosestPlayer()
        if Target then
            TweenService:Create(Camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Target.Character[_G.AimPart].Position)}):Play()
        end
    end
end)

local toggle1 = Aimlock.element('Toggle', 'Enabled', false, function(v)
   _G.AimbotEnabled = v.Toggle
end)

local toggle = Aimlock.element('Toggle', 'FOVCircle', false, function(v)
   _G.CircleVisible = v.Toggle
end)

toggle:add_color({Color = Color3.fromRGB(0, 179, 27)}, nil, function(v)
   _G.CircleColor = v.Color
end)

local teamCheckToggle = Aimlock.element('Toggle', 'TeamCheck', false, function(v)
    _G.TeamCheck = v.Toggle
end)

local Sensitivity = Aimlock.element('Slider', 'Sensitivity', {default = {min = 0, max = 25, default = 0}}, function(v)
    _G.Sensitivity = v.Slider / 10
end)

local slider = Aimlock.element('Slider', 'Size', {default = {min = 1, max = 360, default = 80}}, function(v)
   _G.CircleRadius = v.Slider
end)

local slider1 = Aimlock.element('Slider', 'Thickness', {default = {min = 1, max = 100, default = 50}}, function(v)
   _G.CircleThickness = v.Slider / 10
end)

local dropdown = Aimlock.element('Dropdown', 'Bodypart', {options = {'Head', 'HumanoidRootPart'}}, function(v)
   _G.AimPart = v.Dropdown
end)


local keybindOptions = {
    MouseButton2 = Enum.UserInputType.MouseButton2,
    MouseButton1 = Enum.UserInputType.MouseButton1,
    T = Enum.KeyCode.T,
    Y = Enum.KeyCode.Y,
    C = Enum.KeyCode.C,
    Z = Enum.KeyCode.Z,
}

local keybindDropdown = Aimlock.element('Dropdown', 'Keybind', {options = {'MouseButton2', 'MouseButton1', 'T', 'Y', 'C', 'Z'}}, function(v)
    _G.AimbotKey = keybindOptions[v.Dropdown]
end)


-- // BLATANT \\ 

local player = game.Players.LocalPlayer
local isNoclipEnabled = false

local function toggleNoclip(enabled)
    isNoclipEnabled = enabled
    if enabled then
        local function disableCollision()
            local character = player.Character
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end

        disableCollision()

        player.CharacterAdded:Connect(function(character)
            disableCollision()
        end)
    else
        local character = player.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local noclipToggle = Player.element('Toggle', 'Noclip', false, toggleNoclip)
 

local gravityEnabled = false
local gravityValue = 50

local toggleGravity = Player.element('Toggle', 'Gravity', false, function(v)
    gravityEnabled = v.Toggle
    game.Workspace.Gravity = gravityEnabled and gravityValue or 196.2
end)

local sliderGravity = Player.element('Slider', 'Gravity', {default = {min = 1, max = 192, default = 50}}, function(v)
    gravityValue = v.Slider
    if gravityEnabled then
        game.Workspace.Gravity = gravityValue
    end
end)


local button = Player.element('Button', 'ChatBypass', nil, function()
    loadstring(game:HttpGet('https://pastes.io/raw/lstrrfipqq'))();
end)

local button = Player.element('Button', 'CustomInfYield', nil, function()
   loadfile('arson/ect/arsoninfyield.lua')()
end)


local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local isFlightEnabled = false
local isInfJumpEnabled = false

local function teleportUp()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local currentPosition = character:GetPrimaryPartCFrame().Position           
            local direction = camera.CFrame.LookVector.Unit            
            local newPosition = currentPosition + direction * 1
            character:SetPrimaryPartCFrame(CFrame.new(newPosition))
        end
    end
end

local function handleFlight()
    if isFlightEnabled then
        teleportUp()
    end
end
game:GetService("RunService").RenderStepped:Connect(handleFlight)

local function toggleFlight(enabled)
    isFlightEnabled = enabled
end

local flightToggle = Flight.element('Toggle', 'Flight', false, function(v)
    toggleFlight(v.Toggle)
end)

local function toggleInfJump(enabled)
    isInfJumpEnabled = enabled
end


local infjump = Flight.element('Button', 'InfJump (V)', nil, function()
    local infiniteJumpButton = Instance.new("TextButton")
    local function setInfinityJumpButton()
        local script = Instance.new("LocalScript", infiniteJumpButton)
    
        infiniteJumpButton.Parent = tab_1
        infiniteJumpButton.Name = "infinityJumpButton"
        infiniteJumpButton.Text = "Infinity Jump [V]"
        infiniteJumpButton.TextScaled = true
        infiniteJumpButton.Font = Enum.Font.Ubuntu
        infiniteJumpButton.BackgroundColor3 = Color3.new(1, 0, 0)
        infiniteJumpButton.Position = UDim2.new(0, 10, 0, 190)
        infiniteJumpButton.Size = UDim2.new(0.9, 0, 0.05, 0)
        infiniteJumpButton.BorderColor3 = Color3.new(1, 1, 1)
    
        local Mouse = game.Players.LocalPlayer:GetMouse()
        local InfiniteJump = false
    
        script.Parent.MouseButton1Click:Connect(function()
            if InfiniteJump == false then
                InfiniteJump = true
                script.Parent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            else
                InfiniteJump = false
                script.Parent.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end)
    
        Mouse.KeyDown:Connect(function(k)
            if k == "v" then
                if InfiniteJump == false then
                    InfiniteJump = true
                    script.Parent.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
                else
                    InfiniteJump = false
                    script.Parent.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                end
            end
        end)
    
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if InfiniteJump == true then
                game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass 'Humanoid'
                    :ChangeState("Jumping")
            end
        end)
    end
    coroutine.wrap(setInfinityJumpButton)()
    end)



local Multiplier = 0.5
local SE = false
local SL = nil

local function MoveCharacter()
    while SE do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Multiplier
        game:GetService("RunService").Stepped:wait()
    end
end

local function adjustSL(speed)
    Multiplier = speed / 100
end

local toggle = SPEED.element('Toggle', 'Speed', false, function(v)
    SE = v.Toggle
    if v.Toggle then
        adjustSL(amount)
        MoveCharacter()
    else
        if SL then
            SL:Disconnect()
        end
    end
end)

local slider = SPEED.element('Slider', 'Amount', {default = {min = 1, max = 10, default = 3}}, function(v)
    amount = v.Slider
    if SE then 
        adjustSL(amount)
    end
end)










-- // RENDER \\ 




local lighting = game:GetService("Lighting")

_G.AtmosEnabled = false
_G.AtmosColor = Color3.fromRGB(0, 0, 100)
_G.TimeOfDay =  21
_G.Brightness = 4
_G.TimeEnabled = false
_G.BrightnessEnabled = false


local toggleAtmos = Atmos.element('Toggle', 'Atmos', false, function(v)
    _G.AtmosEnabled = v.Toggle
    if _G.AtmosEnabled then
        lighting.Ambient = _G.AtmosColor
        lighting.OutdoorAmbient = _G.AtmosColor
        lighting.GlobalShadows = true
        lighting.ShadowColor = _G.AtmosColor
    else
        lighting.Ambient = Color3.fromRGB(127, 127, 127)
        lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        lighting.GlobalShadows = true
        lighting.ShadowColor = Color3.fromRGB(0, 0, 0)
    end
end)

toggleAtmos:add_color({Color = Color3.fromRGB(0, 179, 27)}, nil, function(v)
    _G.AtmosColor = v.Color
    if _G.AtmosEnabled then
        lighting.Ambient = _G.AtmosColor
        lighting.OutdoorAmbient = _G.AtmosColor
        lighting.ShadowColor = _G.AtmosColor
    end
end)

local toggleTime = Atmos.element('Toggle', 'Night', false, function(v)
    _G.TimeEnabled = v.Toggle
    if _G.TimeEnabled then
        lighting.ClockTime = _G.TimeOfDay
    else
        lighting.ClockTime = 12 
    end
end)

local brightnessSlider = Atmos.element('Toggle', 'Brightness', {default = {min = 0, max = 24, default = 12}}, function(v)
    _G.Brightness = v.Value
    if _G.BrightnessEnabled then
        lighting.Brightness = _G.Brightness
    end
end)


local button = Atmos.element('Button', 'CustomSky+PresetLighting', nil, function()

    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    wait()
    
    local cc = Instance.new("ColorCorrectionEffect")
    local lighting = game:GetService("Lighting")
    local sbox = Instance.new("Sky")
    
    sbox.Parent = lighting
    sbox.SkyboxBk = "http://www.roblox.com/asset/?id=17847194040"
    sbox.SkyboxDn = "http://www.roblox.com/asset/?id=17847194040"
    sbox.SkyboxFt = "http://www.roblox.com/asset/?id=17847228157"
    sbox.SkyboxLf = "http://www.roblox.com/asset/?id=17847243129"
    sbox.SkyboxRt = "http://www.roblox.com/asset/?id=17847247515"
    sbox.SkyboxUp = "http://www.roblox.com/asset/?id=17847251824"
    
    

    lighting.Ambient = Color3.fromRGB(138,0,255)
    lighting.FogColor = Color3.fromRGB(138,0,255)
    lighting.ClockTime = 14
    lighting.FogEnd = 2000
    
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v:IsA("BasePart") and v.Material == Enum.Material.Grass then
            v.Transparency = 0.25
            v.Color = Color3.fromRGB(125, 125, 200)
        end
    end
end)



if _G.AtmosEnabled then
    lighting.Ambient = _G.AtmosColor
    lighting.OutdoorAmbient = _G.AtmosColor
    lighting.GlobalShadows = true
    lighting.ShadowColor = _G.AtmosColor
end

if _G.TimeEnabled then
    lighting.ClockTime = _G.TimeOfDay
end

if _G.BrightnessEnabled then
    lighting.Brightness = _G.Brightness
end



_G.ESPEnabled = false
_G.TeamCheck = false
_G.ESPColor = Color3.fromRGB(0, 179, 27)

local toggle = ESP.element('Toggle', 'ESP', false, function(v)
    _G.ESPEnabled = v.Toggle
end)

toggle:add_color({Color = Color3.fromRGB(0, 179, 27)}, nil, function(v)
    _G.ESPColor = v.Color
end)



local RunS = game:GetService("RunService")
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer

local function updateESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart

        if rootPart:FindFirstChild("esp") then
            rootPart.esp:Destroy()
        end

        if _G.ESPEnabled then
            if _G.TeamCheck and player.Team == lplr.Team then
                return
            end

            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "esp"
            billboardGui.Parent = rootPart
            billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            billboardGui.AlwaysOnTop = true
            billboardGui.Size = UDim2.new(6, 0, 8, 0)

            local frame = Instance.new("Frame")
            frame.Parent = billboardGui
            frame.Size = UDim2.new(1, 0, 1, 0)
            frame.BackgroundTransparency = 1

            local outline = Instance.new("UIStroke")
            outline.Parent = frame
            outline.Color = _G.ESPColor
            outline.Thickness = 3

            local innerFrame = Instance.new("Frame")
            innerFrame.Parent = frame
            innerFrame.Size = UDim2.new(1, -outline.Thickness * 2, 1, -outline.Thickness * 2)
            innerFrame.Position = UDim2.new(0, outline.Thickness, 0, outline.Thickness)
            innerFrame.BackgroundTransparency = 1
        end
    end
end

local function HandlePlayerTeamChange(player)
    updateESP(player)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        updateESP(player)
    end)
end

for _, player in pairs(plrs:GetPlayers()) do
    HandlePlayerTeamChange(player)
end

plrs.PlayerAdded:Connect(function(player)
    HandlePlayerTeamChange(player)
end)

RunS.RenderStepped:Connect(function()
    for _, player in pairs(plrs:GetPlayers()) do
        updateESP(player)
    end
end)



local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local esp_settings = {
    textsize = 23,
    colour = Color3.fromRGB(0, 179, 27),
    font = "GothamSemibold"
}

local function createEsp()
    local gui = Instance.new("BillboardGui")
    local esp = Instance.new("TextLabel", gui)

    gui.Name = "Cracked esp"
    gui.ResetOnSpawn = false
    gui.AlwaysOnTop = true
    gui.LightInfluence = 0
    gui.Size = UDim2.new(1.75, 0, 1.75, 0)
    
    esp.BackgroundColor3 = esp_settings.colour
    esp.Text = ""
    esp.Size = UDim2.new(0.0001, 0.00001, 0.0001, 0.00001)
    esp.BorderSizePixel = 0
    esp.Font = Enum.Font[esp_settings.font]
    esp.TextSize = esp_settings.textsize
    esp.TextColor3 = esp_settings.colour

    return gui
end

_G.NametagEnabled = false

local toggle = ESP.element('Toggle', 'Nametag', false, function(v)
    _G.NametagEnabled = v.Toggle
end)

toggle:add_color({Color = Color3.fromRGB(0, 179, 27)}, nil, function(v)
    esp_settings.colour = v.Color
    updateEspSettings()
end)

local sizeSlider = ESP.element('Slider', 'Size', {default = {min = 0, max = 50, default = 8}}, function(v)
    esp_settings.textsize = v
    updateEspSettings()
end)

local fontDropdown = ESP.element('Dropdown', 'Font', {options = {"GothamSemibold", "Arial", "SourceSans"}}, function(v)
    esp_settings.font = v.Dropdown
    updateEspSettings()
end)

local function updateEspSettings()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local gui = player.Character.Head:FindFirstChild("Cracked esp")
            if gui and gui:IsA("BillboardGui") then
                local esp = gui:FindFirstChild("TextLabel")
                if esp and esp:IsA("TextLabel") then
                    esp.TextSize = esp_settings.textsize
                    esp.TextColor3 = esp_settings.colour
                    esp.Font = Enum.Font[esp_settings.font]
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if _G.NametagEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                if player.Character.Head:FindFirstChild("Cracked esp") == nil then
                    local gui = createEsp()
                    gui.Parent = player.Character.Head
                    gui.TextLabel.Text = player.Name
                end
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local gui = player.Character.Head:FindFirstChild("Cracked esp")
                if gui and gui:IsA("BillboardGui") then
                    gui:Destroy()
                end
            end
        end
    end
end)

local RunS = game:GetService("RunService")
local plrs = game:GetService("Players")
local lplr = plrs.LocalPlayer
local clr = Color3.fromRGB(0, 179, 27)
local chamsEnabled = false
local insideTransparency = 0.5
local outsideTransparency = 0.5

RunS.RenderStepped:Connect(function()
    if chamsEnabled then
        for _, player in pairs(plrs:GetPlayers()) do
            if player ~= lplr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                if not rootPart:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "Highlight"
                    highlight.Parent = rootPart
                    highlight.Adornee = player.Character
                    highlight.FillColor = clr
                    highlight.OutlineColor = clr
                    highlight.FillTransparency = insideTransparency
                    highlight.OutlineTransparency = outsideTransparency
                else
                    local highlight = rootPart:FindFirstChild("Highlight")
                    highlight.FillColor = clr
                    highlight.OutlineColor = clr
                    highlight.FillTransparency = insideTransparency
                    highlight.OutlineTransparency = outsideTransparency
                end
            end
        end
    else
        for _, player in pairs(plrs:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                if rootPart:FindFirstChild("Highlight") then
                    rootPart:FindFirstChild("Highlight"):Destroy()
                end
            end
        end
    end
end)

local toggle = ESP.element('Toggle', 'Chams', false, function(v)
   chamsEnabled = v.Toggle
   if not chamsEnabled then
        for _, player in pairs(plrs:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                if rootPart:FindFirstChild("Highlight") then
                    rootPart:FindFirstChild("Highlight"):Destroy()
                end
            end
        end
    end
end)

toggle:add_color({Color = Color3.fromRGB(0, 179, 27)}, nil, function(v)
   clr = v.Color
end)

local insideSlider = ESP.element('Slider', 'InsideTransparency', {default = {min = 1, max = 100, default = 50}}, function(v)
   insideTransparency = v.Slider / 100
end)

local outsideSlider = ESP.element('Slider', 'OutsideTransparency', {default = {min = 1, max = 100, default = 50}}, function(v)
   outsideTransparency = v.Slider / 100
end)




-- // GHOST \\ 














wait(0.1)
game.StarterGui:SetCore("SendNotification", {Title = "BANKWARE", Text = "MADE BY YOUR KING BANK", Duration = 4})
game.StarterGui:SetCore("SendNotification", {Title = "BANKWARE", Text = "Bankware was loaded in: " .. finalloadtime .. " milliseconds", Duration = 4})

print([[
  ____          _   _ _  __
 |  _ \   /\   | \ | | |/ /
 | |_) | /  \  |  \| | ' / 
 |  _ < / /\ \ | . ` |  <  
 | |_) / ____ \| |\  | . \ 
 |____/_/    \_\_| \_|_|\_\
                        
]])
