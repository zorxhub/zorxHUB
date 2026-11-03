-- ============================================================
-- ZORX HUB - MAINTENANCE TESTING (SLIDE DOWN ANIMATION)
-- ============================================================
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local reqFunc = request or (syn and syn.request) or (http and http.request) or http_request

-- ============================================================
-- 1. BERSIHKAN UI LAMA
-- ============================================================
for _, gui in pairs(playerGui:GetChildren()) do
	if gui.Name == "ZorxTopNotifContainer" then
		gui:Destroy()
	end
end
task.wait(0.2)

-- ============================================================
-- 2. FUNGSI NOTIFIKASI ATAS KANAN (ANIMASI TURUN)
-- ============================================================
local function createTopRightNotification(titleText, messageText, iconId, duration, showCountdown)
	duration = duration or 6
	
	local container = playerGui:FindFirstChild("ZorxTopNotifContainer")
	if not container then
		container = Instance.new("ScreenGui")
		container.Name = "ZorxTopNotifContainer"
		container.ResetOnSpawn = false
		container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		container.IgnoreGuiInset = true
		container.DisplayOrder = 999
		container.Parent = playerGui
	end
	
	local notif = Instance.new("Frame")
	notif.Name = "TopNotif"
	notif.Size = UDim2.new(0, 360, 0, 68) 
	-- Posisi awal: Nyembunyi di ATAS layar (-100)
	notif.Position = UDim2.new(1, -20, 0, -100) 
	notif.AnchorPoint = Vector2.new(1, 0)
	notif.BackgroundColor3 = Color3.fromRGB(15, 15, 18) 
	notif.BorderSizePixel = 0
	notif.ClipsDescendants = true
	notif.ZIndex = 1000
	notif.Parent = container

	local nCorner = Instance.new("UICorner")
	nCorner.CornerRadius = UDim.new(0, 8)
	nCorner.Parent = notif

	local nStroke = Instance.new("UIStroke")
	nStroke.Color = Color3.fromRGB(220, 50, 60)
	nStroke.Thickness = 1.5
	nStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	nStroke.Parent = notif

	-- GAMBAR (Tanpa kotak belakang & tanpa border luar)
	local nIcon = Instance.new("ImageLabel")
	nIcon.Size = UDim2.new(0, 36, 0, 36)
	nIcon.Position = UDim2.new(0, 8, 0, 8)
	nIcon.BackgroundTransparency = 1
	nIcon.Image = "rbxassetid://" .. tostring(iconId or "134572030759999")
	nIcon.ScaleType = Enum.ScaleType.Fit
	nIcon.ZIndex = 1002
	nIcon.Parent = notif

	local nTitle = Instance.new("TextLabel")
	nTitle.Size = UDim2.new(1, -75, 0, 14)
	nTitle.Position = UDim2.new(0, 52, 0, 8)
	nTitle.BackgroundTransparency = 1
	nTitle.Text = titleText or "System Announcement"
	nTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	nTitle.Font = Enum.Font.GothamBold
	nTitle.TextSize = 12
	nTitle.TextXAlignment = Enum.TextXAlignment.Left
	nTitle.ZIndex = 1001
	nTitle.Parent = notif

	local nDesc = Instance.new("TextLabel")
	nDesc.Size = UDim2.new(1, -65, 0, 14)
	nDesc.Position = UDim2.new(0, 52, 0, 26)
	nDesc.BackgroundTransparency = 1
	nDesc.Text = messageText or "Pesan broadcast..."
	nDesc.TextColor3 = Color3.fromRGB(200, 200, 210)
	nDesc.Font = Enum.Font.GothamMedium
	nDesc.TextSize = 10
	nDesc.TextXAlignment = Enum.TextXAlignment.Left
	nDesc.TextYAlignment = Enum.TextYAlignment.Center
	nDesc.TextWrapped = false
	nDesc.TextTruncate = Enum.TextTruncate.AtEnd
	nDesc.ZIndex = 1001
	nDesc.Parent = notif

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 18, 0, 18)
	closeBtn.Position = UDim2.new(1, -22, 0, 5)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = ""
	closeBtn.AutoButtonColor = false
	closeBtn.ZIndex = 1002
	closeBtn.Parent = notif

	local closeIcon = Instance.new("ImageLabel")
	closeIcon.Size = UDim2.new(0, 9, 0, 9)
	closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	closeIcon.BackgroundTransparency = 1
	closeIcon.Image = "rbxassetid://85435035697164"
	closeIcon.ImageColor3 = Color3.fromRGB(170, 170, 180)
	closeIcon.ScaleType = Enum.ScaleType.Fit
	closeIcon.ZIndex = 1003
	closeIcon.Parent = closeBtn

	local barBg = Instance.new("Frame")
	barBg.Size = UDim2.new(1, -16, 0, 3) 
	barBg.Position = UDim2.new(0, 8, 1, -8)
	barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 1001
	barBg.Parent = notif

	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = barBg

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(1, 0, 1, 0)
	barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 1002
	barFill.Parent = barBg

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = barFill

	-- ANIMASI DARI ATAS KE BAWAH
	TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Position = UDim2.new(1, -20, 0, 20) -- Posisi akhir di Y=20
	}):Play()

	-- Animasi loading bar
	local barTween = TweenService:Create(barFill, TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 1, 0)
	})
	barTween:Play()

	local function dismiss()
		-- Animasi sembunyi ke atas lagi
		local slideUp = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(1, -20, 0, -100)
		})
		slideUp:Play()
		slideUp.Completed:Connect(function()
			notif:Destroy()
		end)
	end

	closeBtn.MouseButton1Click:Connect(dismiss)

	if not showCountdown then
		task.delay(duration, function()
			if notif and notif.Parent then
				dismiss()
			end
		end)
	end

	return notif, nDesc, barFill, dismiss
end

-- ============================================================
-- 3. FUNGSI MAINTENANCE + COUNTDOWN + AUTO REJOIN
-- ============================================================
local function triggerMaintenanceRejoin()
	-- TEKS DIGANTI DI SINI
	local baseText = "Script disabled. rejoin in "
	local iconId = "134572030759999"
	
	if reqFunc then
		local ok, res = pcall(function()
			return reqFunc({ Url = "https://zorx-broadcast-default-rtdb.firebaseio.com/info/MaintIconId.json", Method = "GET" })
		end)
		if ok and res and (res.StatusCode == 200 or res.Status == 200) then
			local ok2, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
			if ok2 and data and data ~= "" and data ~= "null" then
				iconId = tostring(data)
			end
		end
	end
	
	local notif, descLabel, barFill, dismiss = createTopRightNotification(
		"System Announcement",
		baseText .. "5 seconds.",
		iconId, 
		5,
		true 
	)

	for i = 5, 1, -1 do
		if descLabel and descLabel.Parent then
			descLabel.Text = baseText .. i .. " second" .. (i > 1 and "s" or "") .. "."
		end
		task.wait(1)
	end

	pcall(function()
		if notif then notif:Destroy() end
		for _, gui in pairs(playerGui:GetChildren()) do
			if gui.Name == "ZorxTopNotifContainer" then
				gui:Destroy()
			end
		end
	end)
	
	task.wait(1)

	pcall(function()
		if #Players:GetPlayers() <= 1 then
			TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
		else
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
		end
	end)
end

-- ============================================================
-- 4. PENGECEKAN MAINTENANCE AWAL (KILL SWITCH TOTAL)
-- ============================================================
if reqFunc then
	local success, response = pcall(function()
		return reqFunc({
			Url = "https://zorx-broadcast-default-rtdb.firebaseio.com/info.json",
			Method = "GET"
		})
	end)

	if success and response and (response.StatusCode == 200 or response.Status == 200) then
		local ok, data = pcall(function() return HttpService:JSONDecode(response.Body) end)
		if ok and data and data.Maintenance == true then
			local iconId = "134572030759999"
			local okIcon, resIcon = pcall(function()
				return reqFunc({ Url = "https://zorx-broadcast-default-rtdb.firebaseio.com/info/MaintIconId.json", Method = "GET" })
			end)
			if okIcon and resIcon and (resIcon.StatusCode == 200 or resIcon.Status == 200) then
				local ok2, dataIcon = pcall(function() return HttpService:JSONDecode(resIcon.Body) end)
				if ok2 and dataIcon and dataIcon ~= "" and dataIcon ~= "null" then
					iconId = tostring(dataIcon)
				end
			end

			-- TEKS DIGANTI DI SINI JUGA
			local baseText = "Script disabled. rejoin in "
			local notif, desc, bar, dismiss = createTopRightNotification(
				"System Announcement",
				baseText .. "5 seconds.",
				iconId,
				5,
				true
			)

			for i = 5, 1, -1 do
				if desc and desc.Parent then
					desc.Text = baseText .. i .. " second" .. (i > 1 and "s" or "") .. "."
				end
				task.wait(1)
			end

			pcall(function()
				if notif then notif:Destroy() end
				for _, gui in pairs(playerGui:GetChildren()) do
					if gui.Name == "ZorxTopNotifContainer" then
						gui:Destroy()
					end
				end
			end)
			
			task.wait(1)

			pcall(function()
				if #Players:GetPlayers() <= 1 then
					TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
				else
					TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
				end
			end)

			return -- STOP TOTAL.
		end
	end
end

-- ============================================================
-- 5. LIVE CHECK MAINTENANCE TIAP 4 DETIK
-- ============================================================
task.spawn(function()
	while task.wait(4) do
		if reqFunc then
			local ok, response = pcall(function()
				return reqFunc({
					Url = "https://zorx-broadcast-default-rtdb.firebaseio.com/info/Maintenance.json",
					Method = "GET"
				})
			end)
			if ok and response and (response.StatusCode == 200 or response.Status == 200) then
				local ok2, isMaint = pcall(function() return HttpService:JSONDecode(response.Body) end)
				if ok2 and isMaint == true then
					triggerMaintenanceRejoin()
					break
				end
			end
		end
	end
end)

print("Testing Maintenance Loaded! (Slide Down)")