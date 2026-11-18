local RunService = game:GetService("RunService")

local state = _G.SKSpotifyState
if type(state) ~= "table" then
    state = {
        title = "not playing", artist = "-",
        position = 0, duration = 0,
        playing = false, on = false,
    }
    _G.SKSpotifyState = state
end

-- ===== the icon =================================================
local function skMiniIconAsset()
    pcall(function()
        if makefolder then
            pcall(makefolder, "starkill.cc PL")
            pcall(makefolder, "starkill.cc PL/images")
        end
    end)
    local path = "starkill.cc PL/images/spotify.png"
    local url = "https://raw.githubusercontent.com/hoxj/atlanta-ui-lib/main/menu/spotify%20miniplayer/spotify.png"
    local function pngOk(d)
        return type(d) == "string" and #d > 8
            and d:sub(1, 4) == string.char(137) .. "PNG"
    end
    local have = false
    if isfile and isfile(path) then
        local okR, cur = pcall(function() return readfile(path) end)
        have = okR and pngOk(cur)
        if not have and delfile then
            pcall(delfile, path)
        end
    end
    if not have then
        pcall(function()
            if writefile then
                local d = game:HttpGet(url)
                if pngOk(d) then
                    writefile(path, d)
                    have = true
                end
            end
        end)
    end
    if have and getcustomasset then
        local okA, a = pcall(getcustomasset, path)
        if okA and type(a) == "string" and a ~= "" then return a end
    end
    return nil
end

-- ===== the gui ==================================================
local gui, frame, icon, title, artist, fill, dur
local function build()
    if gui and gui.Parent then return end
    gui = Instance.new("ScreenGui")
    gui.Name = "SKSpotifyPlayer"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 13
    gui.Enabled = false
    gui.Parent = (typeof(gethui) == "function" and gethui()) or game:GetService("CoreGui")

    frame = Instance.new("Frame")
    frame.Name = "Player"
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, -30, 0, 140)
    frame.Size = UDim2.new(0, 210, 0, 58)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(35, 35, 35)
    stroke.Thickness = 1
    stroke.Parent = frame

    icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 16, 0, 16)
    icon.Position = UDim2.new(0, 10, 0, 8)
    icon.ImageColor3 = Color3.fromRGB(30, 215, 96)
    icon.Image = skMiniIconAsset() or ""
    icon.Visible = (icon.Image ~= "")
    icon.Parent = frame
    if icon.Image == "" then
        -- retry in the background + a green dot so the slot is never empty
        local dot = Instance.new("Frame")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0.5, 0, 0.5, 0)
        dot.Size = UDim2.new(0, 8, 0, 8)
        dot.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
        dot.BorderSizePixel = 0
        dot.Parent = icon
        local dc = Instance.new("UICorner")
        dc.CornerRadius = UDim.new(1, 0)
        dc.Parent = dot
        task.spawn(function()
            for _ = 1, 20 do
                task.wait(3)
                local a = skMiniIconAsset()
                if a and a ~= "" then
                    icon.Image = a
                    dot.Visible = false
                    icon.Visible = true
                    break
                end
            end
        end)
    end

    title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    pcall(function()
        if type(_G.SKSpotifyFont) == "userdata" or type(_G.SKSpotifyFont) == "table" then
            title.FontFace = _G.SKSpotifyFont
        end
    end)
    title.Text = tostring(state.title or "not playing")
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 14
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Position = UDim2.new(0, 32, 0, 6)
    title.Size = UDim2.new(1, -42, 0, 16)
    title.Parent = frame

    artist = Instance.new("TextLabel")
    artist.Name = "Artist"
    artist.BackgroundTransparency = 1
    pcall(function()
        if type(_G.SKSpotifyFont) == "userdata" or type(_G.SKSpotifyFont) == "table" then
            artist.FontFace = _G.SKSpotifyFont
        end
    end)
    artist.Text = tostring(state.artist or "-")
    artist.TextColor3 = Color3.fromRGB(170, 170, 170)
    artist.TextSize = 12
    artist.TextTruncate = Enum.TextTruncate.AtEnd
    artist.TextXAlignment = Enum.TextXAlignment.Left
    artist.Position = UDim2.new(0, 32, 0, 22)
    artist.Size = UDim2.new(1, -42, 0, 14)
    artist.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Name = "Progress"
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.BorderSizePixel = 0
    barBg.Position = UDim2.new(0, 10, 1, -18)
    barBg.Size = UDim2.new(1, -60, 0, 4)
    barBg.Parent = frame
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg

    fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.BackgroundColor3 = Color3.fromRGB(30, 215, 96)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Parent = barBg
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    dur = Instance.new("TextLabel")
    dur.Name = "Duration"
    dur.BackgroundTransparency = 1
    dur.Font = Enum.Font.Arial
    dur.Text = "0:00"
    dur.TextColor3 = Color3.fromRGB(170, 170, 170)
    dur.TextSize = 11
    dur.TextXAlignment = Enum.TextXAlignment.Right
    dur.Position = UDim2.new(1, -48, 1, -24)
    dur.Size = UDim2.new(0, 40, 0, 13)
    dur.Parent = frame

    -- draggable through the starkill library when present
    pcall(function()
        if _G.SKSpotifyDraggify then
            _G.SKSpotifyDraggify(frame)
        end
    end)
end

-- ===== the show hook ===========================================
_G.SKMiniplayerShow = function(on)
    build()
    if gui then
        gui.Enabled = on and true or false
    end
end

-- if the engine is already running (starkill loaded this file after the
-- island button was flipped on), show right away
if state.on then
    task.defer(function()
        pcall(function()
            _G.SKMiniplayerShow(true)
        end)
    end)
end

-- ===== the render loop =========================================
RunService.RenderStepped:Connect(function()
    if not (gui and gui.Parent and gui.Enabled) then return end
    if title and title.Text ~= tostring(state.title or "") then
        title.Text = tostring(state.title or "")
    end
    if artist and artist.Text ~= tostring(state.artist or "") then
        artist.Text = tostring(state.artist or "")
    end
    if fill and dur then
        local pos = tonumber(state.position) or 0
        local len = tonumber(state.duration) or 0
        local ratio = (len > 0) and math.clamp(pos / len, 0, 1) or 0
        fill.Size = UDim2.fromScale(ratio, 1)
        dur.Text = math.floor(pos / 60) .. ":" .. string.format("%02i", math.floor(pos % 60))
    end
end)
