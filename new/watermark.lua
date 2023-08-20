


local ScreenGui = Instance.new("ScreenGui")
local Backround = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local PurpulText = Instance.new("TextLabel")
local V = Instance.new("Frame")
local UICorner_2 = Instance.new("UICorner")
local PurpulText_2 = Instance.new("TextLabel")

-- Properties

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Backround.Name = "Backround"
Backround.Parent = ScreenGui
Backround.BackgroundColor3 = Color3.new(0, 0, 0)
Backround.BorderColor3 = Color3.new(0, 0, 0)
Backround.BorderSizePixel = 0
Backround.Position = UDim2.new(0.067864269, 0, 0.137135923, 0)
Backround.Size = UDim2.new(0, 197, 0, 35)

UICorner.Parent = Backround

PurpulText.Name = "PurpulText"
PurpulText.Parent = Backround
PurpulText.BackgroundColor3 = Color3.new(1, 1, 1)
PurpulText.BackgroundTransparency = 1
PurpulText.BorderColor3 = Color3.new(0, 0, 0)
PurpulText.BorderSizePixel = 0
PurpulText.Position = UDim2.new(0.119512103, 0, 0.212181091, 0)
PurpulText.Size = UDim2.new(0, 149, 0, 18)
PurpulText.Font = Enum.Font.SourceSansBold
PurpulText.Text = "Purpul"
PurpulText.TextColor3 = Color3.new(0.639216, 0.14902, 0.639216)
PurpulText.TextSize = 24

V.Name = "V"
V.Parent = ScreenGui
V.BackgroundColor3 = Color3.new(0, 0, 0)
V.BorderColor3 = Color3.new(0, 0, 0)
V.BorderSizePixel = 0
V.Position = UDim2.new(0.0848303363, 0, 0.111650482, 0)
V.Size = UDim2.new(0, 141, 0, 21)

UICorner_2.Parent = V

PurpulText_2.Name = "PurpulText"
PurpulText_2.Parent = V
PurpulText_2.BackgroundColor3 = Color3.new(1, 1, 1)
PurpulText_2.BackgroundTransparency = 1
PurpulText_2.BorderColor3 = Color3.new(0, 0, 0)
PurpulText_2.BorderSizePixel = 0
PurpulText_2.Position = UDim2.new(0.191553205, 0, -0.36605835, 0)
PurpulText_2.Size = UDim2.new(0, 85, 0, 36)
PurpulText_2.Font = Enum.Font.SourceSansBold
PurpulText_2.Text = "v0.4"
PurpulText_2.TextColor3 = Color3.new(0.639216, 0.14902, 0.639216)
PurpulText_2.TextSize = 24
