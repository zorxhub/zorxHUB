--============================================================
-- TSB ULTRA LIGHTWEIGHT OPTIMIZER (AUDIO FIX)
-- Fokus: Hapus Efek Berat, Shadow, & Suara Skill (Bukan BGM)
--============================================================

local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

-- 1. Matikan Efek Berat di Lighting & Buang Post-Processing
local function optimizeLighting()
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1000000
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	Lighting.Outlines = false 
	Lighting.Technology = Enum.Technology.Compatibility 
	
	for _, effect in pairs(Lighting:GetChildren()) do
		if effect:IsA("PostEffect") then
			effect.Enabled = false
		end
	end
end

-- 2. Hapus Partikel, Bayangan, & Efek Berat di Map/Skill
local function optimizeMap()
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Explosion") then
			v.Enabled = false
		end
		
		if v:IsA("BasePart") then
			v.CastShadow = false
			if v.Material ~= Enum.Material.SmoothPlastic then
				v.Material = Enum.Material.SmoothPlastic
			end
		end
		
		if v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = 1
		end
	end
end

-- 3. Hapus Aksesoris Karakter (Biar Ringan)
local function optimizeCharacter(char)
	if not char then return end
	for _, accessory in pairs(char:GetChildren()) do
		if accessory:IsA("Accessory") then
			accessory:Destroy()
		end
	end
end

-- 4. Mute HANYA Suara Efek Berat (Bukan BGM)
local function muteHeavySounds()
	-- Mute suara yang ada di dalam efek (workspace)
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("Sound") then
			-- Kalo suara itu nempel di partikel/efek skill, bisukan
			if v.Parent:IsA("ParticleEmitter") or v.Parent:IsA("Explosion") or v.Name:lower():find("hit") or v.Name:lower():find("skill") or v.Name:lower():find("punch") then
				v.Volume = 0
			end
		end
	end
end

-- 5. Jalanin Optimasi Pertama Kali
optimizeLighting()
optimizeMap()
muteHeavySounds()

if player.Character then
	optimizeCharacter(player.Character)
end

player.CharacterAdded:Connect(function(char)
	task.wait(1)
	optimizeCharacter(char)
end)

-- 6. Auto-Cleanup Pas Ada Skill Baru (Biar pas ultimate ga nge-drop)
Workspace.DescendantAdded:Connect(function(descendant)
	if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Explosion") then
		task.wait(0.05)
		if descendant and descendant.Parent then
			descendant.Enabled = false
		end
	end
	
	if descendant:IsA("BasePart") then
		descendant.CastShadow = false
	end
	
	-- Mute suara baru HANYA kalo itu suara skill/hit
	if descendant:IsA("Sound") then
		local sName = descendant.Name:lower()
		if sName:find("hit") or sName:find("skill") or sName:find("punch") or sName:find("impact") then
			descendant.Volume = 0
		end
	end
end)

-- Notifikasi
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "TSB Ultra Optimizer",
	Text = "FPS Aman! Suara BGM nyala, suara efek skill dibisukan.",
	Duration = 5
})