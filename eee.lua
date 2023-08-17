-- // Created by @_MyNamesGabe_ Follow me on spoti pls: https://spoti.fi/3tmyMJ7

local l = game:GetService('Lighting');

for i,v in pairs(l:GetChildren()) do
	v:Destroy();
end

-- // Sky
local Sky = Instance.new('Sky', l);
Sky.MoonTextureId = 'rbxasset://sky/moon.jpg';
Sky.SkyboxBk = 'http://www.roblox.com/asset/?id=245710263';
Sky.SkyboxDn = 'http://www.roblox.com/asset/?id=245710630';
Sky.SkyboxFt = 'http://www.roblox.com/asset/?id=245710380';
Sky.SkyboxLf = 'http://www.roblox.com/asset/?id=245710319';
Sky.SkyboxRt = 'http://www.roblox.com/asset/?id=245710230';
Sky.SkyboxUp = 'http://www.roblox.com/asset/?id=245710496';
Sky.StarCount = 3000;
Sky.SunAngularSize = 21;
Sky.SunTextureId = 'rbxasset://sky/sun.jpg';

-- // Blur

local blur = Instance.new('BlurEffect', l);
blur.Size = 2;

-- // Depth Of Field

local dept = Instance.new('DepthOfFieldEffect', l);
dept.FarIntensity = 1;
dept.FocusDistance = 51.25;
dept.InFocusRadius = 50;
dept.NearIntensity = 1;

local ter = workspace.Terrain

local config = {

	Terrain = true;

}



if config.Terrain then
	-- settings {
	ter.WaterColor = Color3.fromRGB(0, 59, 255)
	ter.WaterWaveSize = 0.15
	ter.WaterWaveSpeed = 22
	ter.WaterTransparency = 1
	ter.WaterReflectance = 0.05
	-- settings }
end
