
-- variables
	local uis = cloneref(game:GetService("UserInputService"))
	local players = cloneref(game:GetService("Players"))
	local ws = cloneref(game:GetService("Workspace"))
	local http_service = cloneref(game:GetService("HttpService"))
	local gui_service = cloneref(game:GetService("GuiService"))
	local lighting = cloneref(game:GetService("Lighting"))
	local run = cloneref(game:GetService("RunService"))
	local stats = cloneref(game:GetService("Stats"))
	local coregui = cloneref(game:GetService("CoreGui"))
	local debris = cloneref(game:GetService("Debris"))
	local tween_service = cloneref(game:GetService("TweenService"))
	local sound_service = cloneref(game:GetService("SoundService"))
	local starter_gui = cloneref(game:GetService("StarterGui"))
	local rs = cloneref(game:GetService("ReplicatedStorage"))

	local vec2 = Vector2.new
	local vec3 = Vector3.new
	local dim2 = UDim2.new
	local dim = UDim.new 
	local rect = Rect.new
	local cfr = CFrame.new
	local empty_cfr = cfr()
	local point_object_space = empty_cfr.PointToObjectSpace
	local angle = CFrame.Angles
	local dim_offset = UDim2.fromOffset

	local color = Color3.new
	local hsv = Color3.fromHSV
	local rgb = Color3.fromRGB
	local hex = Color3.fromHex
	local rgbseq = ColorSequence.new
	local rgbkey = ColorSequenceKeypoint.new
	local numseq = NumberSequence.new
	local numkey = NumberSequenceKeypoint.new

	local camera = ws.CurrentCamera
	local lp = players.LocalPlayer 
	local mouse = lp:GetMouse() 
	local gui_offset = gui_service:GetGuiInset().Y

	local max = math.max 
	local floor = math.floor 
	local min = math.min 
	local abs = math.abs 
	local noise = math.noise
	local rad = math.rad 
	local random = math.random 
	local pow = math.pow 
	local sin = math.sin 
	local pi = math.pi 
	local tan = math.tan 
	local atan2 = math.atan2 
	local cos = math.cos 
	local round = math.round;
	local clamp = math.clamp; 
	local ceil = math.ceil; 
	local sqrt = math.sqrt;
	local acos = math.acos; 

	local insert = table.insert 
	local find = table.find 
	local remove = table.remove
	local concat = table.concat
-- 

	local library = {
		directory = "starkill.cc PL",
		folders = {
			"/fonts",
			"/configs",
			"/images",
			"/audio"
		},
		flags = {},
		config_flags = {},
		visible_flags = {}, 
		guis = {}, 
		connections = {},   
		notifications = {},
		playerlist_data = {},
		viewing_player = nil,
		current_target = nil,

		current_tab, 
		current_element_open, 
		dock_button_holder,  
		old_config; 
		font, 
		keybind_list,
		binds = {}, 
		
		copied_flag; 
		is_rainbow;

		instances = {}; 
		drawings = {};

		display_orders = 0; 
	}

	local flags = library.flags
	local config_flags = library.config_flags

	local themes = {
		preset = {
			["outline"] = hex("#000000"), -- 
			["inline"] = hex("#202020"), --
			["accent"] = hex("#b4b4ff"), --
			["high_contrast"] = hex("#121212"),
			["low_contrast"] = hex("#121212"),
			["text"] = hex("#B4B4B4"),
			["text_outline"] = rgb(0, 0, 0),
			["glow"] = hex("#b4b4ff"), 
		},

		utility = {
			["outline"] = {
				["BackgroundColor3"] = {}, 	
				["Color"] = {}, 
			},
			["inline"] = {
				["BackgroundColor3"] = {}, 	
				["ImageColor3"] = {},
			},
			["accent"] = {
				["BackgroundColor3"] = {}, 	
				["TextColor3"] = {}, 
				["ImageColor3"] = {}, 
				["ScrollBarImageColor3"] = {} 
			},
			["contrast"] = {
				["Color"] = {}, 	
			},
			["text"] = {
				["TextColor3"] = {}, 	
			},
			["text_outline"] = {
				["Color"] = {}, 	
			},
			["glow"] = {
				["ImageColor3"] = {}, 	
			}, 
			["high_contrast"] = {
				["BackgroundColor3"] = {},
			},
			["low_contrast"] = {
				["BackgroundColor3"] = {},
			}
		}, 

		find = {
			["Frame"] = "BackgroundColor3", 
			["TextLabel"] = "TextColor3", 
			["UIGradient"] = "Color",
			["UIStroke"] = "Color",
			["ImageLabel"] = "ImageColor3",
			["TextButton"] = "BackgroundColor3", 
			["ScrollingFrame"] = "ScrollBarImageColor3"
		}
	}

	local keys = {
		[Enum.KeyCode.LeftShift] = "LS",
		[Enum.KeyCode.RightShift] = "RS",
		[Enum.KeyCode.LeftControl] = "LC",
		[Enum.KeyCode.RightControl] = "RC",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.Backspace] = "BS",
		[Enum.KeyCode.Return] = "Ent",
		[Enum.KeyCode.LeftAlt] = "LA",
		[Enum.KeyCode.RightAlt] = "RA",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.One] = "1",
		[Enum.KeyCode.Two] = "2",
		[Enum.KeyCode.Three] = "3",
		[Enum.KeyCode.Four] = "4",
		[Enum.KeyCode.Five] = "5",
		[Enum.KeyCode.Six] = "6",
		[Enum.KeyCode.Seven] = "7",
		[Enum.KeyCode.Eight] = "8",
		[Enum.KeyCode.Nine] = "9",
		[Enum.KeyCode.Zero] = "0",
		[Enum.KeyCode.KeypadOne] = "Num1",
		[Enum.KeyCode.KeypadTwo] = "Num2",
		[Enum.KeyCode.KeypadThree] = "Num3",
		[Enum.KeyCode.KeypadFour] = "Num4",
		[Enum.KeyCode.KeypadFive] = "Num5",
		[Enum.KeyCode.KeypadSix] = "Num6",
		[Enum.KeyCode.KeypadSeven] = "Num7",
		[Enum.KeyCode.KeypadEight] = "Num8",
		[Enum.KeyCode.KeypadNine] = "Num9",
		[Enum.KeyCode.KeypadZero] = "Num0",
		[Enum.KeyCode.Minus] = "-",
		[Enum.KeyCode.Equals] = "=",
		[Enum.KeyCode.Tilde] = "~",
		[Enum.KeyCode.LeftBracket] = "[",
		[Enum.KeyCode.RightBracket] = "]",
		[Enum.KeyCode.RightParenthesis] = ")",
		[Enum.KeyCode.LeftParenthesis] = "(",
		[Enum.KeyCode.Semicolon] = ",",
		[Enum.KeyCode.Quote] = "'",
		[Enum.KeyCode.BackSlash] = "\\",
		[Enum.KeyCode.Comma] = ",",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Slash] = "/",
		[Enum.KeyCode.Asterisk] = "*",
		[Enum.KeyCode.Plus] = "+",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Backquote] = "`",
		[Enum.UserInputType.MouseButton1] = "MB1",
		[Enum.UserInputType.MouseButton2] = "MB2",
		[Enum.UserInputType.MouseButton3] = "MB3",
		[Enum.KeyCode.Escape] = "ESC",
		[Enum.KeyCode.Space] = "SPC",
	}
		
	library.__index = library

	for _, path in next, library.folders do 
		pcall(function()
			if type(makefolder) == "function" then
				makefolder(library.directory .. path)
			end
		end)
	end 

	
	pcall(function()
		writefile("Tahoma-Modern-Bold.ttf", game:HttpGet("https://raw.githubusercontent.com/i77lhm/storage/refs/heads/main/fonts/Tahoma-Modern-Bold.ttf"))
		local tahomaDescriptor = {
			name = "TahomaModernBold",
			faces = {
				{
					name = "Bold",
					weight = 700,
					style = "normal",
					assetId = getcustomasset("Tahoma-Modern-Bold.ttf")
				}
			}
		}
		writefile("Tahoma-Modern-Bold.json", http_service:JSONEncode(tahomaDescriptor))
		library.font = Font.new(getcustomasset("Tahoma-Modern-Bold.json"), Enum.FontWeight.Bold)
	end)
	if not library.font then
		pcall(function()
			if type(writefile) == "function" and type(getcustomasset) == "function" then
				writefile("ArialBold.ttf", game:HttpGet("https://raw.githubusercontent.com/hoxj/atlanta-ui-lib/main/menu/ArialBold.ttf"))
				local arialBoldDescriptor = {
					name = "ArialBold",
					faces = {
						{
							name = "Bold",
							weight = 700,
							style = "normal",
							assetId = getcustomasset("ArialBold.ttf")
						}
					}
				}
				writefile("ArialBold.json", http_service:JSONEncode(arialBoldDescriptor))
				library.font = Font.new(getcustomasset("ArialBold.json"), Enum.FontWeight.Bold)
			end
		end)
	end
	if not library.font then
		library.font = Font.new("rbxasset://fonts/families/SourceSans.json")
	end

	local config_holder 
-- 
		function library:hoverify(hover, parent) 
			local hover_instance = library:create("Frame", {
				Parent = parent,
				BackgroundTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 1;
			}) library:apply_theme(hover_instance, "accent", "BackgroundColor3") 

			hover.MouseEnter:Connect(function()
				library:tween(hover_instance, {
					BackgroundTransparency = 0, 
				}) 
			end)
			
			hover.MouseLeave:Connect(function()
				library:tween(hover_instance, {
					BackgroundTransparency = 1, 
				}) 
			end)

			return hover_instance;
		end 

		function library:hovering(Object)
			if type(Object) == "table" then 
				local Pass = false;

				for _,obj in Object do 
					if library:hovering(obj) then 
						Pass = true
						return Pass
					end 
				end 
			else 
				local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
				local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X
				
				return (y_cond and x_cond)
			end 
		end  

		function library:make_resizable(frame) 
			local Frame = Instance.new("TextButton")
			Frame.Position = dim2(1, -10, 1, -10)
			Frame.BorderColor3 = rgb(0, 0, 0)
			Frame.Size = dim2(0, 10, 0, 10)
			Frame.BorderSizePixel = 0
			Frame.BackgroundColor3 = rgb(255, 255, 255)
			Frame.Parent = frame
			Frame.BackgroundTransparency = 1 
			Frame.Text = ""

			local resizing = false 
			local start_size 
			local start 
			local og_size = frame.Size  

			Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = true
					start = input.Position
					start_size = frame.Size
				end
			end)

			Frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event) 
				if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_size = dim2(
						start_size.X.Scale,
						math.clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							og_size.X.Offset,
							viewport_x
						),
						start_size.Y.Scale,
						math.clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							og_size.Y.Offset,
							viewport_y
						)
					)
					frame.Size = current_size
				end
			end)
		end

		function library:draggify(frame)
			local dragging = false 
			local start_size = frame.Position
			local start 

			frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					start = input.Position
					start_size = frame.Position

					if library.current_element_open then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
						library.current_element_open = nil 
					end 

					if frame.Parent:IsA("ScreenGui") and frame.Parent.DisplayOrder ~= 999999 then 
						library.display_orders += 1
						frame.Parent.DisplayOrder = library.display_orders
					end   
				end
			end)

			frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event) 
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_position = dim2(
						0,
						clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							0,
							viewport_x - frame.Size.X.Offset
						),
						0,
						clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							0,
							viewport_y - frame.Size.Y.Offset
						)
					)

					frame.Position = current_position
				end
			end)
		end

		function library:new_drawing(class, properties)
			local ins = Drawing.new(class)

			for _, v in next, properties do 
				ins[_] = v
			end 

			insert(library.drawings, ins)

			return ins 
		end 
		
		function library:new_item(class, properties) 
			local ins = Instance.new(class)

			for _, v in next, properties do 
				ins[_] = v
			end 

			insert(library.instances, ins)

			return ins 
		end 

		function library:convert_enum(enum)
			local enum_parts = {}
		
			for part in string.gmatch(enum, "[%w_]+") do
				insert(enum_parts, part)
			end
		
			local enum_table = Enum
			for i = 2, #enum_parts do
				local enum_item = enum_table[enum_parts[i]]
		
				enum_table = enum_item
			end
		
			return enum_table
		end

		function library:tween(obj, properties) 
			if not obj or typeof(obj) ~= "Instance" or not obj.Parent then return nil end
			local ok, tween = pcall(function()
				return tween_service:Create(obj, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), properties)
			end)
			if ok and tween then tween:Play() return tween end
			return nil
		end 

local function get_config_name_from_path(file)
		if type(file) ~= "string" then return nil end
		local name = file:match("([^\\/]+)%.cfg$")
		if name and #name > 0 then
			return name
		end
		name = file:match("([^\\/]+)$") or file
		return name:gsub("%.cfg$", "")
	end

	local function sanitize_config_name(name)
		name = tostring(name or "")
		name = name:gsub("[%/\\]", "_")
		name = name:gsub("%.cfg$", "")
		name = name:gsub("^%s+", ""):gsub("%s+$", "")
		return name
	end

	function library:config_list_update() 
		if not config_holder then return end 
	
		local list = {}
	
		for idx, file in next, listfiles(library.directory .. "/configs") do
			local name = get_config_name_from_path(file)
			if name and #name > 0 then
				list[#list + 1] = name
			end
		end
		
		config_holder.refresh_options(list)
	end

		function library:get_config()
			local Config = {}
		
			for _, v in flags do
				if type(v) == "table" and v.key then
					Config[_] = {active = v.active, mode = v.mode, key = tostring(v.key)}
				elseif type(v) == "table" and v["Transparency"] and v["Color"] then
					Config[_] = {Transparency = v["Transparency"], Color = v["Color"]:ToHex()}
				else
					Config[_] = v
				end
			end 
			
			return http_service:JSONEncode(Config)
		end

		function library:load_config(config_json) 
			local config = http_service:JSONDecode(config_json)
		
			for _, v in next, config do 
				local function_set = library.config_flags[_]
				
				if function_set then 
					if type(v) == "table" and v["Transparency"] and v["Color"] then
						function_set(hex(v["Color"]), v["Transparency"])
					elseif type(v) == "table" and v["active"] then 
						function_set(v)
					else 
						function_set(v)
					end
				end 
			end
			for flag, val in next, flags do
				if type(val) == "table" and val.key ~= nil then
					local fn = library.config_flags[flag]
					if fn then pcall(function() fn(val) end) end
				end
			end
		end 
		
		function library:round(number, float) 
			local multiplier = 1 / (float or 1)

			return floor(number * multiplier + 0.5) / multiplier
		end 

		function library:apply_theme(instance, theme, property) 
			insert(themes.utility[theme][property], instance)
		end

		function library:update_theme(theme, color)
			for _, property in next, themes.utility[theme] do 

				for m, object in next, property do 
					if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then
						object[_] = color 
					end
				end 
			end 

			themes.preset[theme] = color 
		end 

		function library:connection(signal, callback)
			local connection = signal:Connect(callback)
			
			insert(library.connections, connection)

			return connection 
		end

		function library:apply_stroke(parent) 
			local stroke = library:create("UIStroke", {
				Parent = parent,
				Color = themes.preset.text_outline, 
				LineJoinMode = Enum.LineJoinMode.Miter
			}) 
			
			library:apply_theme(stroke, "text_outline", "Color")
		end

		function library:create(instance, options)
			local ins = Instance.new(instance) 
			
			for prop, value in next, options do 
				ins[prop] = value
			end
			
			if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then 	
				library:apply_theme(ins, "text", "TextColor3")
				library:apply_stroke(ins)
			elseif instance == "ScreenGui" then 
				insert(library.guis, ins)
			end
			
			return ins 
		end
	-- 

	-- elements 
		local tooltip_sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = gethui(),
			Name = "",
			DisplayOrder = 500, 
		})

		function library:tool_tip(options) 
			local cfg = {
				name = options.name or "hi", 
				path = options.path or nil, 
			}

			if cfg.path then 
				local watermark_outline = library:create("Frame", {
					Parent = tooltip_sgui,
					Name = "",
					Size = dim2(0, 0, 0, 22),
					Position = dim2(0, 500, 0, 300),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					Visible = false,
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = themes.preset.outline
				})
				
				local watermark_inline = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				local watermark_background = library:create("Frame", {
					Parent = watermark_inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = watermark_background,
					Name = "",
					Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local text = library:create("TextLabel", {
					Parent = watermark_background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = " " .. cfg.name .. " ",
					Size = dim2(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = text,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				cfg.path.MouseEnter:Connect(function()
					watermark_outline.Visible = true 
				end)   

				cfg.path.MouseLeave:Connect(function()
					watermark_outline.Visible = false 
				end)

				library:connection(uis.InputChanged, function(input)
					if watermark_outline.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
						watermark_outline.Position = dim_offset(input.Position.X + 10, input.Position.Y + 10)
					end
				end)
			end 
			
			return cfg
		end 

		function library:panel(options) 
			local cfg = {
				name = options.text or options.name or "Window", 
				size = options.size or dim2(0, 530, 0, 590),
				position = options.position or dim2(0, 500, 0, 500),
				anchor_point = options.anchor_point or vec2(0, 0),

				-- button
				image = options.image or "rbxassetid://79856374238119",
				open = options.open or true,

				-- ignore
				items = {},
			}
			
			local items = cfg.items do 
				-- Panel
					items.sgui = library:create("ScreenGui", {
						Enabled = true,
						Parent = gethui(),
						Name = "" 
					})
					
					items.main_holder = library:create("Frame", {
						Parent = items.sgui,
						Name = "",
						AnchorPoint = vec2(cfg.anchor_point.X, cfg.anchor_point.Y),
						Position = cfg.position,
						Active = true, 
						BorderColor3 = rgb(0, 0, 0),
						Size = cfg.size,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.outline
					})
					library:draggify(items.main_holder)
					library:make_resizable(items.main_holder)

					local Close = library:create( "TextButton" , {
						Parent = items.main_holder;
						FontFace = library.font;
						Name = "\0";
						AnchorPoint = vec2(1, 0);
						Active = false;
						BorderColor3 = rgb(0, 0, 0);
						Text = "X";
						Size = dim2(0, 0, 0, 0);
						Selectable = false;
						Position = dim2(1, -7, 0, 5);
						BorderSizePixel = 0;
						BackgroundTransparency = 1;
						TextXAlignment = Enum.TextXAlignment.Right;
						AutomaticSize = Enum.AutomaticSize.XY;
						TextColor3 = themes.preset.text;
						TextSize = 12;
						ZIndex = 100;
						BackgroundColor3 = rgb(255, 255, 255)
					});

					library:create( "UIStroke" , {
						Parent = Close
					});         
					
					Close.MouseButton1Click:Connect(function()
						items.sgui.Enabled = false;
					end)

					
					items.window_inline = library:create("Frame", {
						Parent = items.main_holder,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent
					})
					
					library:apply_theme(items.window_inline, "accent", "BackgroundColor3") 
					
					items.window_holder = library:create("Frame", {
						Parent = items.window_inline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = themes.preset.outline,
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
								
					items.UIGradient = library:create("UIGradient", {
						Parent = items.window_holder,
						Name = "",
						Rotation = 90,
						Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
					})
		
					library:apply_theme(items.UIGradient, "contrast", "Color") 
					
					items.text = library:create("TextLabel", {
						Parent = items.window_holder,
						Name = "",
						FontFace = library.font,
						TextColor3 = themes.preset.accent,
						BorderColor3 = rgb(0, 0, 0),
						Text = cfg.name,
						BackgroundTransparency = 1,
						Position = dim2(0, 2, 0, 4),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(items.text, "accent", "TextColor3")
					
					items.UIStroke = library:create("UIStroke", {
						Parent = items.text,
						Name = "",
						LineJoinMode = Enum.LineJoinMode.Miter
					})
					
					items.UIPadding = library:create("UIPadding", {
						Parent = items.window_holder,
						Name = "",
						PaddingBottom = dim(0, 4),
						PaddingRight = dim(0, 4),
						PaddingLeft = dim(0, 4)
					})
					
					items.outline = library:create("Frame", {
						Parent = items.window_holder,
						Name = "",
						Position = dim2(0, 0, 0, 18),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 1, -18),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.inline
					})
					
					library:apply_theme(items.outline, "inline", "BackgroundColor3") 
					
					items.inline = library:create("Frame", {
						Parent = items.outline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.outline
					})
					
					library:apply_theme(items.inline, "outline", "BackgroundColor3") 
					
					items.holder = library:create("Frame", {
						Parent = items.inline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					items.UIGradient = library:create("UIGradient", {
						Parent = items.holder,
						Name = "",
						Rotation = 90,
						Color = rgbseq{
							rgbkey(0, rgb(41, 41, 55)),
							rgbkey(1, rgb(35, 35, 47))
						}
					})
					
					library:apply_theme(items.UIGradient, "contrast", "Color") 
					
					items.UIPadding = library:create("UIPadding", {
						Parent = items.holder,
						Name = "",
						PaddingTop = dim(0, 5),
						PaddingBottom = dim(0, 5),
						PaddingRight = dim(0, 5),
						PaddingLeft = dim(0, 5)
					})
					
					items.glow = library:create("ImageLabel", {
						Parent = items.main_holder,
						Name = "",
						ImageColor3 = themes.preset.glow,
						ScaleType = Enum.ScaleType.Slice,
						BorderColor3 = rgb(0, 0, 0),
						BackgroundColor3 = rgb(255, 255, 255),
						Visible = true,
						Image = "http://www.roblox.com/asset/?id=18245826428",
						BackgroundTransparency = 1,
						ImageTransparency = 0.8, 
						Position = dim2(0, -20, 0, -20),
						Size = dim2(1, 40, 1, 40),
						ZIndex = 2,
						BorderSizePixel = 0,
						SliceCenter = rect(vec2(21, 21), vec2(79, 79))
					}) library:apply_theme(items.glow, "glow", "ImageColor3") 
				-- 
				
				-- Button
					items.button = library:create("TextButton", {
						Parent = library.dock_holder,
						Name = "",
						TextColor3 = rgb(0, 0, 0),
						BorderColor3 = rgb(0, 0, 0),
						Text = "",
						Size = dim2(0, 25, 0, 25),
						BorderSizePixel = 0,
						TextSize = 14,
						BackgroundColor3 = themes.preset.inline
					})
					
					local button_inline = library:create("Frame", {
						Parent = items.button,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.outline
					}) library:apply_theme(button_inline, "outline", "BackgroundColor3") 
					
					local button_inline = library:create("Frame", {
						Parent = button_inline,
						Name = "",
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, -2, 1, -2),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(button_inline, "inline", "BackgroundColor3")
					
					local UIGradient = library:create("UIGradient", {
						Parent = button_inline,
						Name = "",
						Rotation = 90,
						Color = rgbseq{
							rgbkey(0, rgb(35, 35, 47)),
							rgbkey(1, rgb(41, 41, 55))
						}
					}) library:apply_theme(UIGradient, "contrast", "Color") 
					
					items.Icon = library:create("ImageLabel", {
						Parent = button_inline,
						Name = "",
						ImageColor3 = themes.preset.accent,
						Image = cfg.image,
						BackgroundTransparency = 1,
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(items.Icon, "accent", "ImageColor3") library:apply_theme(items.Icon, "inline", "ImageColor3") 
					
					local UIPadding = library:create("UIPadding", {
						Parent = button_inline,
						Name = "",
						PaddingTop = dim(0, 4),
						PaddingBottom = dim(0, 4),
						PaddingRight = dim(0, 4),
						PaddingLeft = dim(0, 4)
					})
				-- 

				library:tool_tip({name = cfg.name, path = items.button})
			end 

			items.sgui:GetPropertyChangedSignal("Enabled"):Connect(function()
				items.Icon.ImageColor3 = items.sgui.Enabled and themes.preset.accent or themes.preset.inline
			end)

			items.button.MouseButton1Click:Connect(function()
				items.sgui.Enabled = not items.sgui.Enabled
			end)
			
			return setmetatable(cfg, library)
		end 

		local sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = gethui(),
			Name = "",
			DisplayOrder = 999999, 
		})

		local notif_holder = library:create("ScreenGui", {
			Parent = gethui(),
			Name = "",
			IgnoreGuiInset = true, 
			DisplayOrder = 999999, 
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		})

		function library:fold_elements(origin, elements)
			for _, x in next, elements do 
				local flag = library.visible_flags[x]

				if flag then    
					flag(flags[origin])
				end     
			end 
		end 

		function library:indicator() 
			local cfg = {
				items = {};
			}

			local items = cfg.items; do 
				items.Window = library:create( "Frame" , {
					Parent = sgui;
					Name = "\0";
					Position = dim2(0, 400, 0, 500);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 322, 0, 147);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Window, "outline", "BackgroundColor3"); library:draggify(items.Window)
				
				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Indicators";
					Parent = items.Window;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				}); 

				items.Accent = library:create( "Frame" , {
					Parent = items.Window;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3")
				
				items.Background = library:create( "Frame" , {
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.high_contrast
				});	library:apply_theme(items.Background, "high_contrast", "BackgroundColor3")
				
				items.Inline = library:create( "Frame" , {
					Parent = items.Background;
					Name = "\0";
					Position = dim2(0, 4, 0, 18);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -22);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")
				
				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3"); local image_holder = items.LowContrast;
				
				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Info";
					Parent = items.Outline;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});

				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});
				
				items.Accent = library:create( "Frame" , {
					Name = "\0";
					Parent = items.LowContrast;
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 2);
					BackgroundColor3 = themes.preset.accent;
					BorderSizePixel = 0;
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3");
				
				items.Shadow = library:create( "Frame" , {
					AnchorPoint = vec2(0, 1);
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 0, 1, 0);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 1);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent;
				}); library:apply_theme(items.Shadow, "accent", "BackgroundColor3");
				
				library:create( "UIGradient" , {
					Rotation = 90;
					Parent = items.Shadow;
					Color = rgbseq{rgbkey(0, rgb(150, 150, 150)), rgbkey(1, rgb(150, 150, 150))}
				});
				
				items.holder = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 76, 0, 21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
				});	

				library:create("UIListLayout", {
					Parent = items.holder,
					Padding = dim(0, 4),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.Inline = library:create( "Frame" , {
					Parent = image_holder;
					Name = "\0";
					Position = dim2(0, 10, 0, 28);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 68, 0, 67);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")
				
				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")
				
				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.Profile = library:create( "ImageLabel" , {
					BorderColor3 = rgb(0, 0, 0);
					Parent = items.LowContrast;
					Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
					BackgroundTransparency = 1;
					Name = "\0";
					Size = dim2(1, 0, 1, 0);
					BorderSizePixel = 0;
				});	

				local section = setmetatable(items, library)
				items.label = section:label({name = "Player: "})
				items.slider = section:slider({name = "Health", custom = rgb(255, 0, 0), min = 0, max = 100, default = 50, input = true})
				
				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});            
			end

			function cfg.set_visible(bool)
				items.Window.Visible = bool
			end 

			function cfg.change_health(int)
				items.slider.set(int)
			end

			function cfg.change_profile(player)
				items.label.set(string.format("Player: %s (%s)", player.Name, player.DisplayName))
				items.Profile.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=".. player.UserId .."&width=420&height=420&format=png"
			end 

			return setmetatable(cfg, library)
		end     

		function library:window(properties)
			local window = {opened = true}            
			local opened = {}
			local dock_outline;
			local blur = nil

			library.cache = library:create("ScreenGui", {
				Enabled = false,
				Parent = gethui(),
				Name = "" 
			})

			function window.set_menu_visibility(bool) 
				window.opened = bool 
				
				if bool then 
					for _,gui in opened do 
						gui.Enabled = true 
						opened = {}
					end 
				else
					for _,gui in library.guis do 
						if gui.Enabled then 
							gui.Enabled = false
							table.insert(opened, gui)
						end
					end
				end

				dock_outline.Visible = bool;

				sgui.Enabled = true
				notif_holder.Enabled = true
				tooltip_sgui.Enabled = true
				library.cache.Enabled = false

				for _,tooltip in tooltip_sgui:GetChildren() do 
					tooltip.Visible = false;
				end 

				if library.current_element_open then 
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false 
					library.current_element_open = nil 
				end

				-- round 9: script-side "menu opened" hook (the
				-- HUDs pop up so they can be dragged around)
				pcall(function()
					if library.on_menu_visibility then
						library.on_menu_visibility(bool)
					end
				end)
			end 

				dock_outline = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Visible = true,
					BorderColor3 = rgb(0, 0, 0),
					AnchorPoint = vec2(0.5, 0),
					Position = dim2(0.5, 0, 0, 20),
					Size = dim2(0, 157, 0, 39),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}); 

				library:apply_theme(dock_outline, "outline", "BackgroundColor3"); 
				dock_outline.Position = dim2(0, dock_outline.AbsolutePosition.X, 0, dock_outline.AbsolutePosition.Y); 
				dock_outline.AnchorPoint = vec2(0, 0); 
				library:draggify(dock_outline);

				local dock_inline = library:create("Frame", {
					Parent = dock_outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(dock_inline, "inline", "BackgroundColor3") 
				
				local dock_holder = library:create("Frame", {
					Parent = dock_inline,
					Name = "",
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = themes.preset.outline,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				}) library:apply_theme(dock_holder, "outline", "BackgroundColor3") 
				
				local accent = library:create("Frame", {
					Parent = dock_holder,
					Name = "",
					Size = dim2(1, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(accent, "accent", "BackgroundColor3") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
				})
				
				local button_holder = library:create("Frame", {
					Parent = dock_holder,
					Name = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				}) library.dock_holder = button_holder;
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = button_holder,
					Name = "",
					Padding = dim(0, 5),
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = button_holder,
					Name = "",
					PaddingTop = dim(0, 6),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
						
				local UIGradient = library:create("UIGradient", {
					Parent = dock_holder,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
			-- 

				local outline = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Visible = false, 
					Active = true,
					Draggable = false,
					Position = dim2(0, 50, 0, 200),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 260, 0, 25),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(outline, "outline", "BackgroundColor3")
				library:make_resizable(outline)
				library.keybind_list_frame = outline 
				
				do
					local dragging = false
					local dragStart, startPos
					outline.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = true
							dragStart = input.Position
							startPos = outline.Position
						end
					end)
					uis.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							dragging = false
						end
					end)
					uis.InputChanged:Connect(function(input)
						if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
							local vp = camera.ViewportSize
							local newX = clamp(startPos.X.Offset + (input.Position.X - dragStart.X), 0, vp.X - outline.Size.X.Offset)
							local newY = clamp(startPos.Y.Offset + (input.Position.Y - dragStart.Y), 0, vp.Y - outline.Size.Y.Offset)
							outline.Position = dim2(0, newX, 0, newY)
							flags["keybind_list_x"] = newX
							flags["keybind_list_y"] = newY
						end
					end)
				end
				local inline = library:create("Frame", {
					Parent = outline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				library:apply_theme(inline, "inline", "BackgroundColor3")

				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, themes.preset.high_contrast),
						rgbkey(1, themes.preset.low_contrast)
					}
				})
				library:apply_theme(UIGradient, "contrast", "Color") 
				
				local bg = library:create("Frame", {
					Parent = background,
					Name = "a",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}); library:apply_theme(bg, "accent", "BackgroundColor3")
				
				
				library:create("UIGradient", {
					Parent = bg,
					Name = "",
					Enabled = true, 
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				local text = library:create("TextLabel", {
					Parent = background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "Keybinds",
					BackgroundTransparency = 1,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					BackgroundColor3 = themes.preset.text
				}, "text")
				
				local UIStroke = library:create("UIStroke", {
					Parent = text,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local text_holder = library:create("Frame", {
					Parent = background,
					Name = "",
					Position = dim2(0, -2, 1, 1),
					Size = dim2(1, 4, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.outline
				})
				library:apply_theme(text_holder, "outline", "BackgroundColor3")

				local inline = library:create("Frame", {
					Parent = text_holder,
					Name = "",
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				library:apply_theme(inline, "inline", "BackgroundColor3")
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library.keybind_list = background
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, themes.preset.high_contrast),
						rgbkey(1, themes.preset.low_contrast)
					}
				})
				library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIListLayout", {
					Parent = background,
					Name = "",
					Padding = dim(0, -1),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				library:create("UIPadding", {
					Parent = background,
					Name = "",
					PaddingBottom = dim(0, 4),
					PaddingLeft = dim(0, 5)
				})
			--  

				local main_window = library:panel({
					name = "starkill.cc | " .. os.date("%b %d %Y"), 
					size = dim2(0, 604, 0, 628),
					position = dim2(0, (camera.ViewportSize.X / 2) - 302 - 96, 0, (camera.ViewportSize.Y / 2) - 421 - 12),
					image = "rbxassetid://98823308062942",
				})

				local items = main_window.items

				window["tab_holder"] = library:create("Frame", {
					Parent = items.holder,
					Name = " ",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 22),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:create("UIListLayout", {
					Parent = window["tab_holder"],
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 2),
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				local section_holder = library:create("Frame", {
					Parent = items.holder,
					Name = " ",
					BackgroundTransparency = 1,
					Position = dim2(0, -1, 0, 19),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, -22),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				window["section_holder"] = section_holder

				local outline = library:create("Frame", {
					Parent = section_holder,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				
				library:apply_theme(outline, "outline", "BackgroundColor3") 

				local inline = library:create("Frame", {
					Parent = outline,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				library:apply_theme(inline, "inline", "BackgroundColor3") 

				local background = library:create("Frame", {
					Parent = inline,
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library.section_holder = background

				library:create("UIPadding", {
					Parent = background,
					PaddingTop = dim(0, 4),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})

				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				})
				
				library:apply_theme(UIGradient, "contrast", "Color") 
				library:make_resizable(items.main_holder) 
			-- 

			-- theming 
				local style = library:panel({
					name = "Style", 
					anchor_point = vec2(0, 0),
					size = dim2(0, 394, 0, 520),
					position = dim2(0, main_window.items.main_holder.AbsolutePosition.X + main_window.items.main_holder.AbsoluteSize.X + 2, 0, main_window.items.main_holder.AbsolutePosition.Y),
					image = "rbxassetid://115194686863276",
				})

local watermark = library:watermark({
    default = "starkill.cc v1.5.3.2"
})  

task.spawn(function()
    while task.wait(0.5) do 
        local fps = math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
        local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        
        local player = game:GetService("Players").LocalPlayer
        local username = player.Name
        local userId = player.UserId
        
        local executorName = "unknown"
        local ok, ex = pcall(identifyexecutor)
        if ok and ex then
            executorName = string.lower(string.split(ex, " ")[1])
        end
        
        local text = "starkill.cc v1.5.3.2"
        local wmOpts = flags["wm_options"] or {}
        if type(wmOpts) ~= "table" then wmOpts = {wmOpts} end
        
        local function has(opt)
            for _, v in ipairs(wmOpts) do
                if v == opt then return true end
            end
            return false
        end
        
        if has("fps") then
            text = text .. " | " .. fps .. " fps"
        end
        if has("ping") then
            text = text .. " | " .. ping .. " ms"
        end
        if has("executor") then
            text = text .. " | " .. executorName
        end
        if has("username") then
            text = text .. " | " .. username
        end
        if has("userid") then
            if has("username") then
                text = text .. " (" .. userId .. ")"
            else
                text = text .. " | (" .. userId .. ")"
            end
        end
        
        watermark.change_text(text)
    end 
end)

				local items = style.items

				local column = setmetatable(items, library):column() 
				local section = column:section({name = "Theme"})
				section:label({name = "Accent"})
				:colorpicker({name = "Accent", color = themes.preset.accent, flag = "accent", callback = function(color, alpha)
					library:update_theme("accent", color)
				end, flag = "Accent"})
				section:label({name = "Contrast"})
				:colorpicker({name = "Low", color = themes.preset.low_contrast, flag = "low_contrast", callback = function(color)
					if (flags["high_contrast"] and flags["low_contrast"]) then 
						library:update_theme("contrast", rgbseq{
							rgbkey(0, flags["low_contrast"].Color),
							rgbkey(1, flags["high_contrast"].Color)
						})
					end 

					library:update_theme("low_contrast", flags["low_contrast"].Color)
				end})
				:colorpicker({name = "High", color = themes.preset.high_contrast, flag = "high_contrast", callback = function(color)
					library:update_theme("contrast", rgbseq{
						rgbkey(0, flags["low_contrast"].Color),
						rgbkey(1, flags["high_contrast"].Color)
					})

					library:update_theme("high_contrast", flags["high_contrast"].Color)
				end})
				section:label({name = "Inline"})
				:colorpicker({name = "Inline", color = themes.preset.inline, callback = function(color, alpha)
					library:update_theme("inline", color)
				end, flag = "Inline"})
				section:label({name = "Outline"})
				:colorpicker({name = "Outline", color = themes.preset.outline, callback = function(color, alpha)
					library:update_theme("outline", color)
				end, flag = "Outline"})
				section:label({name = "Text Color"})
				:colorpicker({name = "Main", color = themes.preset.text, callback = function(color, alpha)
					library:update_theme("text", color)
				end, flag = "Main"})
				:colorpicker({name = "Outline", color = themes.preset.text_outline, callback = function(color, alpha)
					library:update_theme("text_outline", color)
				end, flag = "Outline"})
				section:label({name = "Glow"})
				:colorpicker({name = "Glow", color = themes.preset.glow, callback = function(color, alpha)
					library:update_theme("glow", color)
				end, flag = "Glow"})
				section:label({name = "UI Bind"})
				:keybind({callback = window.set_menu_visibility, key = Enum.KeyCode.Insert})
				local section = column:section({name = "Other"})
				section:toggle({name = "Keybind List", flag = "keybind_list", callback = function(bool)
					library.keybind_list_frame.Visible = bool
					if bool and flags["keybind_list_x"] ~= nil and flags["keybind_list_y"] ~= nil then
						local vp = camera.ViewportSize
						local x = math.clamp(flags["keybind_list_x"], 0, math.max(0, vp.X - library.keybind_list_frame.Size.X.Offset))
						local y = math.clamp(flags["keybind_list_y"], 0, math.max(0, vp.Y - library.keybind_list_frame.Size.Y.Offset))
						library.keybind_list_frame.Position = dim2(0, x, 0, y)
					end
				end})
				section:toggle({name = "Watermark", flag = "watermark", default = true, callback = function(bool)
					watermark.set_visible(bool)
				end})
				section:dropdown({name = "Watermark Options", flag = "wm_options", items = {"fps", "ping", "executor", "username", "userid"}, default = {"fps", "ping", "executor", "username", "userid"}, multi = true, callback = function(selected) end})
				section:button_holder({})
				section:button({name = "Copy JobId", callback = function()
					setclipboard(game.JobId)
				end})
				section:button_holder({})
				section:button({name = "Copy GameID", callback = function()
					setclipboard(game.GameId)
				end})
				section:button_holder({})
				section:button({name = "Copy Join Script", callback = function()
					setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
				end})
				section:button_holder({})
				section:button({name = "Rejoin", callback = function()
					game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
				end})
				section:button_holder({})
				section:button({name = "Join New Server", callback = function()
					local apiRequest = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
					local data = apiRequest.data[random(1, #apiRequest.data)]
						
					if data.playing <= flags["max_players"] then 
						game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, data.id)
					end 
				end})
				section:slider({name = "Max Players", flag = "max_players", min = 0, max = 40, default = 15, interval = 1})
				-- round 9: spotify player (vape V4 Render/Spotify.lua port)
				section:button_holder({})
				section:button({name = "Spotify Player", callback = function()
					if library.spotify_player and library.spotify_player.toggle then
						library.spotify_player.toggle()
					end
				end})
			-- 

				local holder = library:panel({
					name = "Configurations", 
					size = dim2(0, 324, 0, 450),
					position = dim2(0, items.main_holder.AbsolutePosition.X + items.main_holder.AbsoluteSize.X + 2, 0, items.main_holder.AbsolutePosition.Y),
					image = "rbxassetid://105199726008012",
				}) 

				local items = holder.items

				getgenv().load_config = function(name)
				local config_name = sanitize_config_name(name)
				if config_name == "" then return end
				library:load_config(readfile(library.directory .. "/configs/" .. config_name .. ".cfg"))
			end

			local column = setmetatable(items, library):column() 
				local section = column:section({name = "Options"})
					config_holder = section:list({flag = "config_name_list"})
					section:textbox({flag = "config_name_text_box"})
					section:button_holder({})
					section:button({name = "Create", callback = function()
						local config_name = sanitize_config_name(flags["config_name_text_box"])
						if config_name == "" then
							library:notification({text = "Please enter a valid config name.", time = 3})
							return
						end
						writefile(library.directory .. "/configs/" .. config_name .. ".cfg", library:get_config())
						library:config_list_update()
					end})
					
					local saveConfirmed = false
					local saveBtn
					saveBtn = section:button({name = "Save", callback = function()
						if not saveConfirmed then
							saveConfirmed = true
							if saveBtn then pcall(function() saveBtn.set_name("Save?", rgb(255, 255, 0)) end) end
							task.delay(5, function()
								if saveConfirmed then
									saveConfirmed = false
									if saveBtn then pcall(function() saveBtn.set_name("Save") end) end
								end
							end)
							return
						end
						saveConfirmed = false
						if saveBtn then pcall(function() saveBtn.set_name("Save") end) end
						local config_name = sanitize_config_name(flags["config_name_list"])
						if config_name == "" then return end
						writefile(library.directory .. "/configs/" .. config_name .. ".cfg", library:get_config())
						library:config_list_update()
						library:notification({text = "Saved Config: " .. config_name, time = 3})
					end})
					
					section:button_holder({})
					section:button({name = "Load", callback = function()
						local config_name = sanitize_config_name(flags["config_name_list"])
						local config_path = library.directory .. "/configs/" .. config_name .. ".cfg"
						if pcall(readfile, config_path) then
							library:load_config(readfile(config_path))
							library:notification({text = "Loaded Config: " .. config_name, time = 3})
						else
							library:notification({text = "Config file not found!", time = 3})
						end
					end})
					
					local deleteConfirmed = false
					local deleteBtn
					deleteBtn = section:button({name = "Delete", callback = function()
						if not deleteConfirmed then
							deleteConfirmed = true
							if deleteBtn then pcall(function() deleteBtn.set_name("Delete?", rgb(255, 0, 0)) end) end
							task.delay(5, function()
								if deleteConfirmed then
									deleteConfirmed = false
									if deleteBtn then pcall(function() deleteBtn.set_name("Delete") end) end
								end
							end)
							return
						end
						deleteConfirmed = false
						if deleteBtn then pcall(function() deleteBtn.set_name("Delete") end) end
						local config_name = sanitize_config_name(flags["config_name_list"])
						if config_name == "" then return end
						delfile(library.directory .. "/configs/" .. config_name .. ".cfg")
						library:config_list_update()
					end})
					
					section:button_holder({})
					section:button({name = "Refresh Configs", callback = function()
						library:config_list_update()
					end})
					section:button_holder({})
					
					local unloadConfigConfirmed = false
					local unloadConfigBtn
					unloadConfigBtn = section:button({name = "Unload Config", callback = function()
						if not unloadConfigConfirmed then
							unloadConfigConfirmed = true
							if unloadConfigBtn then pcall(function() unloadConfigBtn.set_name("Are you sure?", rgb(255, 255, 0)) end) end
							task.delay(5, function()
								if unloadConfigConfirmed then
									unloadConfigConfirmed = false
									if unloadConfigBtn then pcall(function() unloadConfigBtn.set_name("Unload Config") end) end
								end
							end)
							return
						end
						unloadConfigConfirmed = false
						if unloadConfigBtn then pcall(function() unloadConfigBtn.set_name("Unload Config") end) end
						library:load_config(library.old_config)
					end})
					section:button_holder({})
					
					local unloadMenuConfirmed = false
					local unloadMenuBtn
					unloadMenuBtn = section:button({name = "Unload Menu", callback = function()
						if not unloadMenuConfirmed then
							unloadMenuConfirmed = true
							if unloadMenuBtn then pcall(function() unloadMenuBtn.set_name("Are you sure?", rgb(255, 0, 0)) end) end
							task.delay(5, function()
								if unloadMenuConfirmed then
									unloadMenuConfirmed = false
									if unloadMenuBtn then pcall(function() unloadMenuBtn.set_name("Unload Menu") end) end
								end
							end)
							return
						end
						library:load_config(library.old_config)
						for _, gui in library.guis do 
							gui:Destroy() 
						end 
						for _, connection in library.connections do 
							connection:Disconnect() 
						end
						if blur then blur:Destroy() end
					end})
			-- 
					
			-- playerlist 
				local holder = library:panel({
					name = "Playerlist", 
					anchor_point = vec2(0, 0),
					size = dim2(0, 529, 0, 445),
					position = dim2(0, main_window.items.main_holder.AbsolutePosition.X - 531, 0, main_window.items.main_holder.AbsolutePosition.Y),
					image = "rbxassetid://107070078834415",
				})  
				
				local items = holder.items

				local column = setmetatable(items, library):column() 
				local section = column:section({name = "Playerlist"})
				local main_holder = section.holder
				local playerlist = section:playerlist({})
				section.holder = playerlist.actions_holder
				local prio_dropdown = section:dropdown({name = "Priority", items = {"Enemy", "Priority", "Neutral", "Friendly"}, default = "Neutral", flag = "PLAYERLIST_DROPDOWN", callback = function(text)
					library.prioritize(text)
				end})

				if prio_dropdown and prio_dropdown.left_holder then
					local wrapper = setmetatable({ right_holder = prio_dropdown.left_holder }, { __index = library })
					
					wrapper:colorpicker({
						name = "Enemy Color",
						flag = "ESP_Enemy_Color",
						color = rgb(255, 0, 0),
						callback = function(val)
							if playerlist and playerlist.patterns then
								playerlist.patterns["Enemy"] = val
							end
							if playerlist and playerlist.refresh_player_colors then
								playerlist.refresh_player_colors()
							end
						end
					})
					
					wrapper:colorpicker({
						name = "Priority Color",
						flag = "ESP_Priority_Color",
						color = rgb(255, 255, 0),
						callback = function(val)
							if playerlist and playerlist.patterns then
								playerlist.patterns["Priority"] = val
							end
							if playerlist and playerlist.refresh_player_colors then
								playerlist.refresh_player_colors()
							end
						end
					})
					
					wrapper:colorpicker({
						name = "Friendly Color",
						flag = "ESP_Friendly_Color",
						color = hex("23ff0a"),
						callback = function(val)
							if playerlist and playerlist.patterns then
								playerlist.patterns["Friendly"] = val
							end
							if playerlist and playerlist.refresh_player_colors then
								playerlist.refresh_player_colors()
							end
						end
					})
				end
				section:dropdown({name = "Priority color elements", flag = "ESP_PRIORITY_ELEMENTS", items = {"Box", "Box Fill", "Name", "Distance", "Tool", "Health Bar", "Health Text", "Tracer", "Flags", "Highlight", "Mesh Chams", "Glow"}, default = {"Name"}, multi = true, scrolling = true, callback = function(selected) end})
				-- round 6: 2x2 action grid (target / view / tp / kill)
				local actionGrid = library:create("Frame", {
					Parent = section.holder,
					Name = "action_grid",
					Size = dim2(1, -8, 0, 0),
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				})
				library:create("UIGridLayout", {
					Parent = actionGrid,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					CellSize = dim2(0.5, -5, 0, 18),
					CellPadding = dim2(0, 6, 0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				local gridHost = setmetatable({ current_holder = actionGrid }, { __index = library })
				gridHost:button({name = "target", callback = function()
					if not library.selected_player then return end
					if library.current_target == library.selected_player then
						local playerName = library.current_target
						local prev = library.target_previous_priority or "Neutral"
						library.current_target = nil
						library.target_previous_priority = nil
						if playerName and library.set_priority_for_player then
							library.set_priority_for_player(playerName, prev)
						end
					else
						local path = library.playerlist_data[library.selected_player]
						if path then
							library.target_previous_priority = path.priority
						end
						library.current_target = library.selected_player
						library.prioritize("Priority")
					end
				end})
				gridHost:button({name = "view", callback = function()
					if not library.selected_player then return end
					local p = players:FindFirstChild(library.selected_player)
					if library.viewing_player == library.selected_player then
						library.viewing_player = nil
						if lp.Character then local h = lp.Character:FindFirstChildOfClass("Humanoid") if h then ws.CurrentCamera.CameraSubject = h end end
						if library.view_conn then library.view_conn:Disconnect() library.view_conn = nil end
						return
					end
					if p then
						library.viewing_player = library.selected_player
						if library.view_conn then library.view_conn:Disconnect() end
						library.view_conn = run.Heartbeat:Connect(function()
							if library.viewing_player ~= library.selected_player or not p.Parent then
								library.view_conn:Disconnect()
								library.view_conn = nil
								return
							end
							if p.Character then
								local h = p.Character:FindFirstChildOfClass("Humanoid")
								if h and ws.CurrentCamera.CameraSubject ~= h then
									ws.CurrentCamera.CameraSubject = h
								end
							end
						end)
					end
				end})
				gridHost:button({name = "tp", callback = function()
					if not library.selected_player or not lp.Character then return end
					local p = players:FindFirstChild(library.selected_player)
					if not p or not p.Character then return end
					local myRoot = lp.Character:FindFirstChild("HumanoidRootPart")
					local theirRoot = p.Character:FindFirstChild("HumanoidRootPart")
					if not myRoot or not theirRoot then return end
					pcall(function()
						local targetCF = theirRoot.CFrame
						myRoot.CFrame = targetCF
						local held = 0
						local conn
						conn = game:GetService("RunService").Heartbeat:Connect(function()
							if not myRoot or not myRoot.Parent then if conn then conn:Disconnect() end return end
							myRoot.CFrame = targetCF
							held = held + 1
							if held >= 8 then if conn then conn:Disconnect() end end
						end)
					end)
				end})
				gridHost:button({name = "kill", callback = function()
					if not library.selected_player then return end
					-- round 6: the script side (KillEngine) provides this
					if library.on_kill_request then
						library.on_kill_request(library.selected_player)
					end
				end})

				-- round 6: gun for kill - every gun in the game (live scan of
				-- ReplicatedStorage.Tools + the auto equip gun list + m700 /
				-- revolver), so the list always matches the real tool names
				local gunItems = {}
				do
					local seen = {}
					local function addGun(g)
						if type(g) == "string" and g ~= "" and not seen[g] then
							seen[g] = true
							gunItems[#gunItems + 1] = g
						end
					end
					pcall(function()
						local tools = game:GetService("ReplicatedStorage"):FindFirstChild("Tools")
						if tools then
							local live = {}
							for _, t in ipairs(tools:GetChildren()) do
								if t:IsA("Tool")
										and (t:GetAttribute("Damage") ~= nil
											or t:GetAttribute("Range") ~= nil
											or t:GetAttribute("Behavior") ~= nil
											or t:GetAttribute("Local_CurrentAmmo") ~= nil) then
									live[#live + 1] = t.Name
								end
							end
							table.sort(live)
							for _, g in ipairs(live) do addGun(g) end
						end
					end)
					for _, g in ipairs({"AK-47", "Remington 870", "M9", "M700", "Revolver", "MP5", "M4A1", "FAL", "Sniper", "Taser"}) do addGun(g) end
				end

				-- round 6: live settings for the kill engine (the gun +
				-- orbit sliders keep working while it is orbiting)
				-- round 7: orbit_speed uses juju's exact strafe semantics -
				-- the "%" slider from the da hood script (1-100, default 75)
				-- round 9: follow mode - underground / above / behind
				library.kill_settings = { gun = "AK-47", orbit_speed = 75, orbit_distance = 8, follow_mode = "underground" }
				section:dropdown({name = "gun", flag = "KILL_GUN", items = gunItems, default = "AK-47", tooltip = "gun used by the kill button (auto equipped on the selected target)", callback = function(v) library.kill_settings.gun = v end})
				section:dropdown({name = "follow mode", flag = "KILL_FOLLOW_MODE", items = {"underground", "above", "behind"}, default = "underground", tooltip = "underground = the strafe ring 8 studs under the target. above = the ring 8 studs over the target. behind = a fixed spot 5 studs behind the target's back, facing them", callback = function(v) library.kill_settings.follow_mode = v end})
				section:slider({name = "orbit speed", min = 1, max = 100, default = 75, interval = 1, suffix = " %", flag = "KILL_ORBIT_SPEED", tooltip = "juju strafe speed: the spoofed hrp sweeps this many full revolutions per second around the target (75 = the classic da hood strafe ring) - underground / above modes only", callback = function(v) library.kill_settings.orbit_speed = v end})
				section:slider({name = "orbit distance", min = 4, max = 30, default = 8, interval = 1, suffix = " studs", flag = "KILL_ORBIT_DIST", tooltip = "how far the spoofed hrp orbits from the target (underground / above modes only)", callback = function(v) library.kill_settings.orbit_distance = v end})
				section.holder = main_holder
				section:button_holder({})
				section:colorpicker({name = "Enemy ESP color", flag = "ESP_Enemy_Color", color = hex("ff0a1f"), callback = function(c) end})
				section:colorpicker({name = "Friendly ESP color", flag = "ESP_Friendly_Color", color = hex("23ff0a"), callback = function(c) end})
			--  

			-- round 9: spotify player (vape V4 Render/Spotify.lua port)
			do
			    local wsConnect = (type(WebSocket) == "table" and type(WebSocket.connect) == "function") and WebSocket.connect or nil
			    local skRequestFn = request or (syn and syn.request) or http_request or (http and http.request) or nil
			    if not wsConnect or not skRequestFn then
				-- no websocket / request support: the button explains instead of failing silently
				library.spotify_player = {
				    toggle = function()
					library:notification({text = "spotify: this executor is missing " .. (not skRequestFn and "request" or "websocket") .. " support", time = 5})
				    end,
				}
			    else
				local dir = library.directory
				local httpService = game:GetService("HttpService")
				local skGuiParent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")

				-- ===== pure-lua sha1 + base64 (the vape port relies on
				-- hash.sha1 / base64decode which are not guaranteed) =====
				local function skSha1(msg)
				    local len = #msg
				    local padded = msg .. "\128" .. string.rep("\0", (55 - len) % 64) .. string.pack(">I8", len * 8)
				    local h0, h1, h2, h3, h4 = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0
				    local w = table.create(80)
				    for off = 1, #padded, 64 do
					for i = 1, 16 do
					    w[i] = string.unpack(">I4", padded, off + (i - 1) * 4)
					end
					for i = 17, 80 do
					    w[i] = bit32.rrotate(bit32.bxor(bit32.bxor(w[i-3], w[i-8]), bit32.bxor(w[i-14], w[i-16])), 1)
					end
					local a, b, c, d, e = h0, h1, h2, h3, h4
					for i = 1, 80 do
					    local f, k
					    if i <= 20 then
						f = bit32.bor(bit32.band(b, c), bit32.band(bit32.bnot(b), d)); k = 0x5A827999
					    elseif i <= 40 then
						f = bit32.bxor(bit32.bxor(b, c), d); k = 0x6ED9EBA1
					    elseif i <= 60 then
						f = bit32.bor(bit32.bor(bit32.band(b, c), bit32.band(b, d)), bit32.band(c, d)); k = 0x8F1BBCDC
					    else
						f = bit32.bxor(bit32.bxor(b, c), d); k = 0xCA62C1D6
					    end
					    local temp = (bit32.rrotate(a, 5) + f + e + k + w[i]) % 0x100000000
					    e = d; d = c; c = bit32.rrotate(b, 30); b = a; a = temp
					end
					h0 = (h0 + a) % 0x100000000
					h1 = (h1 + b) % 0x100000000
					h2 = (h2 + c) % 0x100000000
					h3 = (h3 + d) % 0x100000000
					h4 = (h4 + e) % 0x100000000
				    end
				    return string.format("%08x%08x%08x%08x%08x", h0, h1, h2, h3, h4)
				end

				local skB64Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
				local skB64Lookup = {}
				for i = 1, #skB64Alphabet do skB64Lookup[skB64Alphabet:sub(i, i)] = i - 1 end
				local function skBase64Decode(s)
				    if type(s) ~= "string" then return "" end
				    s = s:gsub("=+$", ""):gsub("[^%w%+%/]", "")
				    local out = {}
				    local i = 1
				    while i <= #s do
					local rem = #s - i + 1
					local a = skB64Lookup[s:sub(i, i)] or 0
					local b = skB64Lookup[s:sub(i + 1, i + 1)] or 0
					if rem >= 4 then
					    local c = skB64Lookup[s:sub(i + 2, i + 2)] or 0
					    local d = skB64Lookup[s:sub(i + 3, i + 3)] or 0
					    local n = a * 262144 + b * 4096 + c * 64 + d
					    out[#out + 1] = string.char(math.floor(n / 65536) % 256, math.floor(n / 256) % 256, n % 256)
					elseif rem == 3 then
					    local c = skB64Lookup[s:sub(i + 2, i + 2)] or 0
					    local n = a * 4096 + b * 64 + c
					    out[#out + 1] = string.char(math.floor(n / 65536) % 256, math.floor(n / 256) % 256)
					elseif rem == 2 then
					    local n = a * 64 + b
					    out[#out + 1] = string.char(math.floor(n / 256) % 256)
					else
					    break
					end
					i = i + 4
				    end
				    return table.concat(out)
				end

				-- ===== the window (target hud look, round 10: art + like + icon) =====
				local SPOTIFY_W, SPOTIFY_H = 224, 106
				local spotifyGui = Instance.new("ScreenGui")
				spotifyGui.Name = "SKSpotifyPlayer"
				spotifyGui.ResetOnSpawn = false
				spotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				spotifyGui.DisplayOrder = 5
				spotifyGui.Enabled = false
				spotifyGui.Parent = skGuiParent

				local spotifyFrame = Instance.new("Frame")
				spotifyFrame.Name = "Spotify"
				spotifyFrame.AnchorPoint = Vector2.new(1, 0)
				spotifyFrame.Position = UDim2.new(1, -16, 0, 40)
				spotifyFrame.Size = UDim2.new(0, SPOTIFY_W, 0, SPOTIFY_H)
				spotifyFrame.BackgroundColor3 = themes.preset.outline
				spotifyFrame.BorderSizePixel = 0
				spotifyFrame.Parent = spotifyGui
				library:apply_theme(spotifyFrame, "outline", "BackgroundColor3")

				local spAccent = Instance.new("Frame")
				spAccent.Position = UDim2.new(0, 1, 0, 1)
				spAccent.Size = UDim2.new(1, -2, 1, -2)
				spAccent.BackgroundColor3 = themes.preset.accent
				spAccent.BorderSizePixel = 0
				spAccent.Parent = spotifyFrame
				library:apply_theme(spAccent, "accent", "BackgroundColor3")

				local spBody = Instance.new("Frame")
				spBody.Position = UDim2.new(0, 1, 0, 1)
				spBody.Size = UDim2.new(1, -2, 1, -2)
				spBody.BackgroundColor3 = themes.preset.high_contrast
				spBody.BorderSizePixel = 0
				spBody.Parent = spAccent

				local function skLabel(text, textSize, color, xAlign)
				    local lbl = Instance.new("TextLabel")
				    lbl.Text = text
				    lbl.FontFace = library.font
				    lbl.TextSize = textSize
				    lbl.TextColor3 = color
				    lbl.BackgroundTransparency = 1
				    lbl.BorderSizePixel = 0
				    lbl.TextXAlignment = xAlign or Enum.TextXAlignment.Left
				    lbl.TextTruncate = Enum.TextTruncate.AtEnd
				    lbl.Size = UDim2.new(1, 0, 1, 0)
				    lbl.Parent = nil
				    local stroke = Instance.new("UIStroke")
				    stroke.Color = themes.preset.text_outline
				    stroke.LineJoinMode = Enum.LineJoinMode.Miter
				    stroke.Parent = lbl
				    library:apply_theme(stroke, "text_outline", "Color")
				    return lbl
				end

				-- header (icon + text) - the icon downloads once from the
				-- vape repo assets; if that fails the text stands alone
				local spHeaderIcon = Instance.new("ImageLabel")
				spHeaderIcon.Name = "Icon"
				spHeaderIcon.Size = UDim2.new(0, 12, 0, 12)
				spHeaderIcon.Position = UDim2.new(0, 5, 0, 1)
				spHeaderIcon.BackgroundTransparency = 1
				spHeaderIcon.BorderSizePixel = 0
				spHeaderIcon.Visible = false
				spHeaderIcon.Parent = spBody
				local spHeader = skLabel("spotify", 13, Color3.fromRGB(255, 255, 255))
				spHeader.Position = UDim2.new(0, 0, 0, 2)
				spHeader.Size = UDim2.new(1, -28, 0, 16)
				spHeader.Parent = spBody
				local spHeaderPad = Instance.new("UIPadding")
				spHeaderPad.PaddingLeft = UDim.new(0, 20)
				spHeaderPad.Parent = spHeader
				do
				    local iconPath = dir .. "/spotify_icon.png"
				    pcall(function()
					if type(isfile) == "function" and type(writefile) == "function" and not isfile(iconPath) then
					    local data = game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/src/guis/new/assets/spotify.png")
					    writefile(iconPath, data)
					end
				    end)
				    pcall(function()
					spHeaderIcon.Image = getcustomasset(iconPath)
					spHeaderIcon.Visible = true
				    end)
				end

				-- the like-song icon holder (top right): a heart built from
				-- frames (a rotated square + two circles) inside a target-hud
				-- styled box - gray = not liked, green = liked, click toggles
				local spLikeHolder = Instance.new("TextButton")
				spLikeHolder.Name = "Like"
				spLikeHolder.AnchorPoint = Vector2.new(1, 0)
				spLikeHolder.Position = UDim2.new(1, -3, 0, 1)
				spLikeHolder.Size = UDim2.new(0, 18, 0, 18)
				spLikeHolder.BackgroundColor3 = themes.preset.outline
				spLikeHolder.BorderSizePixel = 0
				spLikeHolder.AutoButtonColor = false
				spLikeHolder.Text = ""
				spLikeHolder.Parent = spBody
				library:apply_theme(spLikeHolder, "outline", "BackgroundColor3")
				local spLikeInline = Instance.new("Frame")
				spLikeInline.Position = UDim2.new(0, 1, 0, 1)
				spLikeInline.Size = UDim2.new(1, -2, 1, -2)
				spLikeInline.BackgroundColor3 = themes.preset.inline
				spLikeInline.BorderSizePixel = 0
				spLikeInline.Parent = spLikeHolder
				library:apply_theme(spLikeInline, "inline", "BackgroundColor3")
				local spLikeHeartParts = {}
				local function skHeartPart(w, x, y, round)
				    local f = Instance.new("Frame")
				    f.AnchorPoint = Vector2.new(0.5, 0.5)
				    f.Position = UDim2.new(0, x, 0, y)
				    f.Size = UDim2.new(0, w, 0, w)
				    f.BackgroundColor3 = Color3.fromRGB(170, 170, 170)
				    f.BorderSizePixel = 0
				    f.ZIndex = 2
				    if round then
					local c = Instance.new("UICorner")
					c.CornerRadius = UDim.new(0.5, 0)
					c.Parent = f
				    else
					f.Rotation = 45
				    end
				    f.Parent = spLikeHolder
				    spLikeHeartParts[#spLikeHeartParts + 1] = f
				    return f
				end
				skHeartPart(8, 9, 11, false) -- the rotated square (bottom point)
				skHeartPart(8, 6, 8, true)  -- left lobe
				skHeartPart(8, 12, 8, true) -- right lobe
				local function skUpdateLikeUI(liked)
				    local col = liked and Color3.fromRGB(80, 200, 80) or Color3.fromRGB(170, 170, 170)
				    for _, f in ipairs(spLikeHeartParts) do
					f.BackgroundColor3 = col
				    end
				end
				local skToggleLike = nil -- assigned by the engine (FIX 2c)
				spLikeHolder.MouseButton1Click:Connect(function()
				    if skToggleLike then skToggleLike() end
				end)

				-- album art (from the track lookup coverArt)
				local spArtOuter = Instance.new("Frame")
				spArtOuter.Name = "Art"
				spArtOuter.Position = UDim2.new(0, 8, 0, 22)
				spArtOuter.Size = UDim2.new(0, 48, 0, 48)
				spArtOuter.BackgroundColor3 = themes.preset.outline
				spArtOuter.BorderSizePixel = 0
				spArtOuter.Parent = spBody
				library:apply_theme(spArtOuter, "outline", "BackgroundColor3")
				local spArtInline = Instance.new("Frame")
				spArtInline.Position = UDim2.new(0, 1, 0, 1)
				spArtInline.Size = UDim2.new(1, -2, 1, -2)
				spArtInline.BackgroundColor3 = themes.preset.inline
				spArtInline.BorderSizePixel = 0
				spArtInline.Parent = spArtOuter
				library:apply_theme(spArtInline, "inline", "BackgroundColor3")
				local spArt = Instance.new("ImageLabel")
				spArt.Size = UDim2.new(1, 0, 1, 0)
				spArt.BackgroundTransparency = 1
				spArt.BorderSizePixel = 0
				spArt.ScaleType = Enum.ScaleType.Stretch
				spArt.Image = ""
				spArt.Parent = spArtInline

				local spTitle = skLabel("not playing", 13, Color3.fromRGB(255, 255, 255))
				spTitle.Position = UDim2.new(0, 64, 0, 24)
				spTitle.Size = UDim2.new(1, -70, 0, 14)
				spTitle.Parent = spBody

				local spArtist = skLabel("", 11, Color3.fromRGB(170, 170, 170))
				spArtist.Position = UDim2.new(0, 65, 0, 40)
				spArtist.Size = UDim2.new(1, -71, 0, 12)
				spArtist.Parent = spBody

				-- the progress bar: health-bar style, NOT rounded
				local spBarOuter = Instance.new("Frame")
				spBarOuter.Position = UDim2.new(0, 7, 0, 76)
				spBarOuter.Size = UDim2.new(1, -14, 0, 8)
				spBarOuter.BackgroundColor3 = themes.preset.outline
				spBarOuter.BorderSizePixel = 0
				spBarOuter.Parent = spBody
				library:apply_theme(spBarOuter, "outline", "BackgroundColor3")

				local spBarInline = Instance.new("Frame")
				spBarInline.Position = UDim2.new(0, 1, 0, 1)
				spBarInline.Size = UDim2.new(1, -2, 1, -2)
				spBarInline.BackgroundColor3 = themes.preset.outline
				spBarInline.BorderSizePixel = 0
				spBarInline.Parent = spBarOuter
				library:apply_theme(spBarInline, "outline", "BackgroundColor3")

				local spBarTrack = Instance.new("Frame")
				spBarTrack.Position = UDim2.new(0, 1, 0, 1)
				spBarTrack.Size = UDim2.new(1, -2, 1, -2)
				spBarTrack.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				spBarTrack.BorderSizePixel = 0
				spBarTrack.Parent = spBarInline
				local spTrackGrad = Instance.new("UIGradient")
				spTrackGrad.Rotation = 90
				spTrackGrad.Color = ColorSequence.new(themes.preset.low_contrast, themes.preset.high_contrast)
				spTrackGrad.Parent = spBarTrack
				library:apply_theme(spTrackGrad, "contrast", "Color")

				local spBarFill = Instance.new("Frame")
				spBarFill.Size = UDim2.fromScale(0, 1)
				spBarFill.BackgroundColor3 = themes.preset.accent
				spBarFill.BorderSizePixel = 0
				spBarFill.Parent = spBarTrack
				library:apply_theme(spBarFill, "accent", "BackgroundColor3")
				local spFillGrad = Instance.new("UIGradient")
				spFillGrad.Rotation = 90
				spFillGrad.Color = ColorSequence.new({
				    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
				    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 190, 190)),
				    ColorSequenceKeypoint.new(1, Color3.fromRGB(125, 125, 125)),
				})
				spFillGrad.Parent = spBarFill

				local spTimeCur = skLabel("0:00", 10, Color3.fromRGB(180, 180, 180))
				spTimeCur.Position = UDim2.new(0, 8, 0, 88)
				spTimeCur.Size = UDim2.new(0, 80, 0, 12)
				spTimeCur.Parent = spBody

				local spTimeLen = skLabel("0:00", 10, Color3.fromRGB(180, 180, 180), Enum.TextXAlignment.Right)
				spTimeLen.AnchorPoint = Vector2.new(1, 0)
				spTimeLen.Position = UDim2.new(1, -8, 0, 88)
				spTimeLen.Size = UDim2.new(0, 80, 0, 12)
				spTimeLen.Parent = spBody

				-- drag + position saved through the CONFIG SYSTEM (round 10):
				-- the drag writes library.flags.spotify_x / spotify_y, which
				-- get_config saves into your .cfg file, and the config_flags
				-- loaders below apply them on load - no separate txt file
				local function spApplyPos(x, y)
				    spotifyFrame.AnchorPoint = Vector2.new(0, 0)
				    spotifyFrame.Position = UDim2.new(0, x, 0, y)
				end
				do
				    local dragging, dragStart, startPos = false, nil, nil
				    spotifyFrame.Active = true
				    spotifyFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
					    dragging = true
					    dragStart = uis:GetMouseLocation()
					    local ap = spotifyFrame.AbsolutePosition
					    startPos = Vector2.new(ap.X, ap.Y)
					end
				    end)
				    uis.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					    local mouse = uis:GetMouseLocation()
					    local vp = camera.ViewportSize
					    local x = math.clamp(startPos.X + (mouse.X - dragStart.X), 0, math.max(0, vp.X - SPOTIFY_W))
					    local y = math.clamp(startPos.Y + (mouse.Y - dragStart.Y), 0, math.max(0, vp.Y - SPOTIFY_H))
					    spApplyPos(x, y)
					end
				    end)
				    uis.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
					    dragging = false
					    pcall(function()
						local ap = spotifyFrame.AbsolutePosition
						flags["spotify_x"] = math.floor(ap.X)
						flags["spotify_y"] = math.floor(ap.Y)
						-- round 10: delete the old separate position file
						local oldPos = dir .. "/spotify_pos.txt"
						if type(isfile) == "function" and type(delfile) == "function" and isfile(oldPos) then
						    pcall(delfile, oldPos)
						end
					    end)
					end
				    end)
				end
				-- round 10: the position loads back from the config file
				library.config_flags["spotify_x"] = function(v)
				    if type(v) == "number" then
					spApplyPos(v, flags["spotify_y"] or spotifyFrame.Position.Y.Offset)
				    end
				end
				library.config_flags["spotify_y"] = function(v)
				    if type(v) == "number" then
					spApplyPos(flags["spotify_x"] or spotifyFrame.Position.X.Offset, v)
				    end
				end

				-- ===== the engine (vape V4 Render/Spotify.lua) =====
				local function fmtTime(t)
				    t = math.max(tonumber(t) or 0, 0)
				    return string.format("%d:%02d", math.floor(t / 60), math.floor(t % 60))
				end

				local function safeRequest(...)
				    local success, req = pcall(skRequestFn, ...)
				    if success then return req end
				    return { Success = false, Body = tostring(req) }
				end

				-- round 10b: tolerant JSON decode. Executors differ: some return
				-- the body already decoded as a table, some prepend a UTF-8 BOM,
				-- some leave trailing NULs. A plain JSONDecode throws on all of
				-- those, which surfaced as a cryptic "Can't parse JSON".
				local function skDecodeJSON(body)
				    if type(body) == "table" then return body end
				    if type(body) ~= "string" then return nil end
				    local ok, decoded = pcall(httpService.JSONDecode, httpService, body)
				    if ok then return decoded end
				    local cleaned = body:gsub("^\239\187\191", ""):gsub("%z+$", "")
				    if cleaned ~= body then
					local ok2, decoded2 = pcall(httpService.JSONDecode, httpService, cleaned)
					if ok2 then return decoded2 end
				    end
				    return nil
				end

				local SpotifyHandler = { Cache = {}, active = false }

				do
				    local BLOCK_SIZE = 64
				    local xor_with_0x5c, xor_with_0x36 = {}, {}
				    for i = 0, 255 do
					xor_with_0x5c[string.char(i)] = string.char(bit32.bxor(0x5c, i))
					xor_with_0x36[string.char(i)] = string.char(bit32.bxor(0x36, i))
				    end

				    local function numberToByteString(number)
					local bytes = {}
					while number ~= 0 do
					    table.insert(bytes, string.char(bit32.band(number, 0xff)))
					    number = bit32.rshift(number, 8)
					end
					return string.rep('\0', math.max(0, 8 - #bytes)) .. table.concat(bytes, ''):reverse()
				    end

				    local function randomHexString()
					local data = table.create(20)
					for i = 1, 20 do
					    data[i] = string.format('%02x', math.random(0, 255))
					end
					return table.concat(data)
				    end

				    local function hex_to_binary(hex)
					return (hex:gsub('..', function(num)
					    return string.char(tonumber(num, 16))
					end))
				    end

				    local function hmac(key, text)
					if #key > BLOCK_SIZE then
					    key = hex_to_binary(skSha1(key))
					end
					local key_xord_with_0x36 = key:gsub('.', xor_with_0x36) .. string.rep(string.char(0x36), BLOCK_SIZE - #key)
					local key_xord_with_0x5c = key:gsub('.', xor_with_0x5c) .. string.rep(string.char(0x5c), BLOCK_SIZE - #key)
					return hex_to_binary(skSha1(key_xord_with_0x5c .. hex_to_binary(skSha1(key_xord_with_0x36 .. text))))
				    end

				    local function stringToBytes(str)
					local bytes = table.create(#str)
					for i = 1, #str do
					    bytes[i] = string.byte(str:sub(i, i))
					end
					return bytes
				    end

				    function SpotifyHandler.generateOTP(input, secret)
					local hash = hmac(secret, numberToByteString(input))
					local offset = bit32.band(string.byte(hash:sub(-1, -1)), 0x0f) + 1
					local bHash = stringToBytes(hash)
					local code = bit32.bor(
					    bit32.lshift(bit32.band(bHash[offset], 0x7f), 24),
					    bit32.lshift(bit32.band(bHash[offset + 1], 0xff), 16),
					    bit32.lshift(bit32.band(bHash[offset + 2], 0xff), 8),
					    bit32.band(bHash[offset + 3], 0xff)
					)
					local str_code = tostring(math.floor(code % (10 ^ 6)))
					while #str_code < 6 do str_code = '0' .. str_code end
					return str_code
				    end

				    function SpotifyHandler.readURLAndConfig(code)
					local appCfg = code:find('appServerConfig" type="text/plain">')
					local cfgData = nil
					if appCfg then
					    local okCfg, cfgDecoded = pcall(function()
						return httpService:JSONDecode(skBase64Decode(code:sub(appCfg + 35, code:find('<', appCfg + 1) - 1)))
					    end)
					    if okCfg and type(cfgDecoded) == "table" then cfgData = cfgDecoded end
					end
					return code:match('(https://[^"\']+/web%-player%.[0-9a-f]+%.js)'), cfgData
				    end

				    function SpotifyHandler.readOTPCodes(code)
					local secret = code:find("{secret:'")
					if secret then
					    local version = code:find('%,version', secret + 1)
					    local endbracket = code:find('}', version + 1)
					    local otpCode = code:sub(secret + 9, version - 2)
					    local hashedOtp = table.create(#otpCode)
					    for i = 1, #otpCode do
						hashedOtp[i] = bit32.bxor(string.byte(otpCode:sub(i, i)), (i - 1) % 33 + 9)
					    end
					    return table.concat(hashedOtp, ''), tonumber(code:sub(version + 9, endbracket - 1))
					end
				    end

				    function SpotifyHandler.readFetchHash(code)
					local query = code:find('fetchEntitiesForRecentlyPlayed","query",')
					local ending = code:find('",null', query)
					return query and ending and code:sub(query + 41, ending - 1)
				    end
				end

				function SpotifyHandler:Callback(data)
				    if data.player_state then
					local currentTime = (data.timestamp / 1000)
					local posAsTime = tonumber(data.player_state.position_as_of_timestamp) / 1000
					local diff = currentTime - (tonumber(data.player_state.timestamp) / 1000)
					self.playPosition = posAsTime + (data.player_state.is_paused and 0 or diff)
					self.playRate = data.player_state.playback_speed
					self.playDuration = tonumber(data.player_state.duration or 1000) / 1000
					if data.player_state.track then
					    self:RequestCache(data.player_state.track.uri, data.player_state.track)
					    self.track = data.player_state.track.uri
					    -- round 10: liked state is per track - re-check it
					    self.liked = nil
					    spTitle.Text = data.player_state.track.metadata.title
						or (self.Cache[self.track] and self.Cache[self.track].Title) or "unknown"
					    spArtist.Text = (self.Cache[self.track] and table.concat(self.Cache[self.track].Artists, ', ')) or ""
					    spArt.Image = (self.Cache[self.track] and self.Cache[self.track].Art) or ""
					    self:RefreshLikeState()
					end
				    end
				end

				-- round 10: the like-song support (api.spotify.com with the
				-- web-player token) - poll the liked state per track, toggle
				-- on click
				local function skTrackIdFromUri(uri)
				    return type(uri) == "string" and uri:match("^spotify:track:(.+)$") or nil
				end
				function SpotifyHandler:RefreshLikeState()
				    local trackId = skTrackIdFromUri(self.track)
				    if not trackId or not self.Data or not self.Data.accessToken or not self.clientToken then
					skUpdateLikeUI(false)
					return
				    end
				    task.spawn(function()
					local res = safeRequest({
					    Url = 'https://api.spotify.com/v1/me/tracks/contains?ids=' .. trackId,
					    Method = 'GET',
					    Headers = {
						Accept = 'application/json',
						Authorization = 'Bearer ' .. self.Data.accessToken,
						['client-token'] = self.clientToken,
						Origin = 'https://open.spotify.com',
						Referer = 'https://open.spotify.com/',
						['User-Agent'] = self.Headers['User-Agent']
					    }
					})
					if res.Success then
					    local contains = skDecodeJSON(res.Body)
					    if type(contains) == "table" and type(contains[1]) == "boolean" then
						self.liked = contains[1]
						skUpdateLikeUI(self.liked)
					    end
					end
				    end)
				end
				function SpotifyHandler:ToggleLike()
				    local trackId = skTrackIdFromUri(self.track)
				    if not trackId or not self.Data or not self.Data.accessToken then return end
				    local want = not self.liked
				    task.spawn(function()
					local res = safeRequest({
					    Url = 'https://api.spotify.com/v1/me/tracks?ids=' .. trackId,
					    Method = want and 'PUT' or 'DELETE',
					    Headers = {
						['Accept-Encoding'] = 'identity',
						Authorization = 'Bearer ' .. self.Data.accessToken,
						['client-token'] = self.clientToken,
						['Content-Type'] = 'application/json',
						Origin = 'https://open.spotify.com',
						Referer = 'https://open.spotify.com/',
						['User-Agent'] = self.Headers['User-Agent']
					    }
					})
					if res.Success then
					    self.liked = want
					    skUpdateLikeUI(want)
					else
					    library:notification({text = 'Spotify: failed to ' .. (want and 'like' or 'unlike') .. ' the song (the token may lack the library permission)', time = 8})
					end
				    end)
				end
				skToggleLike = function() SpotifyHandler:ToggleLike() end

				function SpotifyHandler:Refresh()
				    local mainPage = safeRequest({
					Url = 'https://open.spotify.com',
					Method = 'GET',
					Headers = self.Headers
				    })
				    if mainPage.Success then
					local scriptUrl, appCfg = self.readURLAndConfig(mainPage.Body)
					if scriptUrl and appCfg then
					    local scriptCode = safeRequest({
						Url = scriptUrl,
						Method = 'GET',
						Headers = self.Headers
					    })
					    if scriptCode.Success then
						local fetchKey = self.readFetchHash(scriptCode.Body)
						local otpCode, version = self.readOTPCodes(scriptCode.Body)
						if otpCode and version then
						    local localKey = self.generateOTP(os.time() // 30, otpCode)
						    local serverKey = self.generateOTP(appCfg.serverTime // 30, otpCode)
						    local authData = safeRequest({
							Url = 'https://open.spotify.com/api/token?reason=init&productType=web-player&totp=' .. localKey .. '&totpServer=' .. serverKey .. '&totpVer=' .. version,
							Method = 'GET',
							Headers = self.Headers
						    })
						    if authData.Success then
							-- round 10b: the token endpoint returns JSON only when the cookie
							-- is valid. Guard the decode so a bad/expired sp_dc gives a clear
							-- message instead of "Can't parse JSON".
							local decoded = skDecodeJSON(authData.Body)
							if type(decoded) ~= "table" then
							-- round 10b: tell apart a compressed/non-text body (executor
							-- did not decode it) from a real Spotify rejection
							    local rawBody = tostring(authData.Body or "")
							    local printable = rawBody:gsub("[%c]", "")
							    if #rawBody > 0 and #printable < #rawBody * 0.85 then
								error("Spotify auth returned a compressed/non-text response - your executor did not decompress the reply. Update the executor (or use one with a working request/gzip).")
							    end
							    local snippet = rawBody:gsub("%s+", " "):sub(1, 160)
							    error("Spotify rejected the sign-in (sp_dc cookie invalid or expired). Server said: " .. snippet)
							end
							authData = decoded
							if not authData.accessToken then
							    -- round 10b: Spotify puts the reason in error.message when the
							    -- response is the 400 json (expired cookie / expired otp version)
							    local err = authData.error
							    local reason = authData.error_description
							    if type(err) == "table" then reason = reason or err.message end
							    if type(err) == "string" then reason = reason or err end
							    if authData.totpVerExpired then reason = reason or "the web player otp version expired - spotify updated their player, the script needs an update" end
							    error("Spotify auth failed: " .. tostring(reason or "no access token in the response"))
							end
							return {
							    clientId = authData.clientId,
							    clientVersion = appCfg.clientVersion,
							    correlationId = appCfg.correlationId,
							    fetchKey = fetchKey,
							    accessToken = authData.accessToken,
							    expireTime = authData.accessTokenExpirationTimestampMs / 1000
							}
						    else
							error('Failed to get auth data: ' .. tostring(authData.Body))
						    end
						else
						    error('Failed to get OTP codes')
						end
					    else
						error('Failed to get script data: ' .. tostring(scriptCode.Body))
					    end
					else
					    error('Failed to read the Spotify web player page - the sp_dc cookie is invalid/expired, or Spotify changed the page. Try copying sp_dc again.')
					end
				    else
					error('Failed to get main page: ' .. tostring(mainPage.Body))
				    end
				end

				function SpotifyHandler:GetSession()
				    local sessionData = safeRequest({
					Url = 'https://clienttoken.spotify.com/v1/clienttoken',
					Method = 'POST',
					Headers = {
					    Accept = 'application/json',
					    ['Accept-Encoding'] = 'identity',
					    ['Content-Type'] = 'application/json',
					    Origin = 'https://open.spotify.com',
					    Referer = 'https://open.spotify.com/',
					    ['User-Agent'] = self.Headers['User-Agent']
					},
					Body = httpService:JSONEncode({
					    client_data = {
						client_id = self.Data.clientId,
						client_version = self.Data.clientVersion,
						js_sdk_data = {
						    device_brand = 'unknown',
						    device_id = self.Data.correlationId,
						    device_model = 'unknown',
						    device_type = 'computer',
						    os = 'windows',
						    os_version = 'NT 10.0'
						}
					    }
					})
				    })
				    if sessionData.Success then
					local decodedSess = skDecodeJSON(sessionData.Body)
					if type(decodedSess) ~= "table" or not decodedSess.granted_token then
					    error('Failed to get device session: ' .. tostring(sessionData.Body):sub(1, 160))
					end
					return decodedSess.granted_token.token
				    else
					error('Failed to get device session: ' .. tostring(sessionData.Body))
				    end
				end

				function SpotifyHandler:RequestCache(id, data)
				    if not self.Cache[id] then
					self.Cache[id] = { Artists = { 'None' }, Title = 'Unknown' }
					if id:find('spotify:local') then
					    local lArtist = data.metadata.artist_uri:sub(15)
					    self.Cache[id].Artists = { lArtist ~= '' and lArtist or 'None' }
					    spArtist.Text = table.concat(self.Cache[id].Artists, ', ')
					    spArt.Image = "" -- round 10: local files have no art
					    return
					end
					if self.Data.fetchKey then
					    task.spawn(function()
						local dataRequest = safeRequest({
						    Url = 'https://api-partner.spotify.com/pathfinder/v2/query',
						    Method = 'POST',
						    Headers = {
							Accept = 'application/json',
							['Accept-Encoding'] = 'identity',
							Authorization = 'Bearer ' .. self.Data.accessToken,
							['Content-Type'] = 'application/json',
							['client-token'] = self.clientToken,
							Origin = 'https://open.spotify.com',
							Referer = 'https://open.spotify.com/',
							['User-Agent'] = self.Headers['User-Agent']
						    },
						    Body = httpService:JSONEncode({
							extensions = {
							    persistedQuery = {
								sha256Hash = self.Data.fetchKey,
								version = 1
							    }
							},
							variables = {
							    uris = { id }
							},
							operationName = 'fetchEntitiesForRecentlyPlayed'
						    })
						})
						if dataRequest.Success then
						    local okD, data2 = pcall(httpService.JSONDecode, httpService, dataRequest.Body)
						    if okD and data2 and data2.data and data2.data.lookup then
							local track = data2.data.lookup[1]
							if track and track.data then
							    table.clear(self.Cache[id].Artists)
							    if track.data.__typename == 'Track' then
								self.Cache[id].Title = track.data.name
								for _, artist in ipairs(track.data.artists.items) do
								    table.insert(self.Cache[id].Artists, artist.profile.name)
								end
								-- round 10: album art (the biggest coverArt source)
								local coverArt = track.data.albumOfTrack and track.data.albumOfTrack.coverArt
								if coverArt and type(coverArt.sources) == "table" and #coverArt.sources > 0 then
								    self.Cache[id].Art = coverArt.sources[#coverArt.sources].url
								end
							    elseif track.data.__typename == 'Episode' then
								table.insert(self.Cache[id].Artists, track.data.podcastV2.data.publisher.name)
							    end
							    if self.track == id then
								spTitle.Text = self.Cache[id].Title
								spArtist.Text = table.concat(self.Cache[id].Artists, ', ')
								spArt.Image = self.Cache[id].Art or ""
							    end
							end
						    end
						end
					    end)
					end
				    end
				end

				function SpotifyHandler:RegisterDevice(connectionId)
				    if not self.connectionId then
					self.connectionId = connectionId
					local sessionId = randomHexString()
					local deviceReq = safeRequest({
					    Url = 'https://' .. self.Dealer.Client .. '/track-playback/v1/devices',
					    Method = 'POST',
					    Headers = {
						['Accept-Encoding'] = 'identity',
						Authorization = 'Bearer ' .. self.Data.accessToken,
						['Content-Type'] = 'application/json',
						['client-token'] = self.clientToken,
						Origin = 'https://open.spotify.com',
						Referer = 'https://open.spotify.com/',
						['User-Agent'] = self.Headers['User-Agent']
					    },
					    Body = httpService:JSONEncode({
						device = {
						    brand = 'spotify',
						    capabilities = {
							change_volume = true,
							enable_play_token = true,
							supports_file_media_type = true,
							play_token_lost_behavior = 'pause',
							disable_connect = false,
							audio_podcasts = true,
							video_playback = true,
							manifest_formats = {
							    'file_ids_mp3',
							    'file_urls_mp3',
							    'manifest_urls_audio_ad',
							    'manifest_ids_video',
							    'file_urls_external',
							    'file_ids_mp4',
							    'file_ids_mp4_dual',
							    'manifest_urls_audio_ad'
							},
							supports_preferred_media_type = true,
							supports_playback_offsets = true,
							supports_playback_speed = true
						    },
						    device_id = sessionId,
						    device_type = 'computer',
						    metadata = {},
						    model = 'web_player',
						    name = 'Web Player (Firefox)',
						    platform_identifier = 'web_player windows 10;firefox 158.0;desktop',
						    is_group = false,
						    is_public = false,
						    correlation_id = self.Data.correlationId,
						    client_version = 'harmony:4.81.1-1f3d48b7f'
						},
						outro_endcontent_snooping = false,
						connection_id = self.connectionId,
						client_version = 'harmony:4.81.1-1f3d48b7f',
						volume = 65535
					    }):gsub('"metadata":%[%]', '"metadata":{}')
					})
					if deviceReq.Success then
					    local registerReq = safeRequest({
						Url = 'https://' .. self.Dealer.Client .. '/connect-state/v1/devices/hobs_' .. sessionId,
						Method = 'PUT',
						Headers = {
						    Accept = 'application/json',
						    ['Accept-Encoding'] = 'identity',
						    Authorization = 'Bearer ' .. self.Data.accessToken,
						    ['client-token'] = self.clientToken,
						    Origin = 'https://open.spotify.com',
						    Referer = 'https://open.spotify.com/',
						    ['x-spotify-connection-id'] = self.connectionId,
						    ['User-Agent'] = self.Headers['User-Agent']
						},
						Body = httpService:JSONEncode({
						    member_type = 'CONNECT_STATE',
						    device = {
							device_info = {
							    capabilities = {
								can_be_player = false,
								hidden = true,
								needs_full_player_state = true
							    }
							}
						    }
						})
					    })
					    if registerReq.Success then
						local okR, regData = pcall(httpService.JSONDecode, httpService, registerReq.Body)
						if okR and regData then
						    self:Callback(regData)
						end
					    else
						library:notification({text = 'Spotify: Failed to register device: ' .. tostring(registerReq.Body), time = 30})
					    end
					else
					    library:notification({text = 'Spotify: Failed to register device: ' .. tostring(deviceReq.Body), time = 30})
					end
				    end
				end

				function SpotifyHandler:RegisterSocket()
				    if not self.Dealer then
					local dealerReq = safeRequest({
					    Url = 'https://apresolve.spotify.com/?type=dealer-g2&type=spclient',
					    Method = 'GET',
					    Headers = {
						Origin = 'https://open.spotify.com',
						Referer = 'https://open.spotify.com/',
						['User-Agent'] = self.Headers['User-Agent']
					    }
					})
					if dealerReq.Success then
					    local okD, dealerData = pcall(httpService.JSONDecode, httpService, dealerReq.Body)
					    if okD and dealerData and dealerData['dealer-g2'] and dealerData['dealer-g2'][1]
						and dealerData.spclient and dealerData.spclient[1] then
						self.Dealer = {
						    Dealer = dealerData['dealer-g2'][1]:sub(1, dealerData['dealer-g2'][1]:find(':') - 1),
						    Client = dealerData.spclient[1]:sub(1, dealerData.spclient[1]:find(':') - 1)
						}
					    else
						library:notification({text = 'Spotify: No available dealers', time = 30})
						return
					    end
					else
					    library:notification({text = 'Spotify: Failed to get dealers: ' .. tostring(dealerReq.Body), time = 30})
					    return
					end
				    end
				    self.Socket = wsConnect('wss://' .. self.Dealer.Dealer .. '/?access_token=' .. self.Data.accessToken)
				    self.syncTime = os.clock() - 6
				    self.Socket.OnMessage:Connect(function(payload)
					local okP, data = pcall(httpService.JSONDecode, httpService, payload)
					if not okP or type(data) ~= "table" then return end
					if data.headers and data.headers['Spotify-Connection-Id'] then
					    self.syncTime = nil
					    self:RegisterDevice(data.headers['Spotify-Connection-Id'])
					elseif data.payloads and #data.payloads > 0 then
					    for _, pd in ipairs(data.payloads) do
						if pd.cluster and pd.cluster.player_state then
						    self:Callback(pd.cluster)
						    break
						end
					    end
					elseif data.type == 'pong' then
					    self.syncTime = nil
					end
				    end)
				    self.Socket.OnClose:Connect(function()
					self.connectionId = nil
					self.syncTime = nil
					self.Socket = nil
				    end)
				end

				function SpotifyHandler:Start()
				    if self._starting then return end
				    self._starting = true
				    local function done() self._starting = false end
				    if not self.active then done() return end
				    local cookiePath = dir .. "/spotify.txt"
				    -- round 10: the cookie file is CREATED if it doesn't exist
				    -- (it never did - nothing ever wrote it, so "I see no
				    -- spotify.txt" was always true). Open it, paste your sp_dc
				    -- cookie, press the button again.
				    pcall(function()
					if type(writefile) == "function" and (type(isfile) ~= "function" or not isfile(cookiePath)) then
					    writefile(cookiePath, "")
					end
				    end)
				    local cookie = ""
				    pcall(function()
					if type(readfile) == "function" and type(isfile) == "function" and isfile(cookiePath) then
					    cookie = readfile(cookiePath) or ""
					end
				    end)
				    cookie = cookie:gsub('%s+', '')
				    -- round 10b: accept the cookie however it was copied - just the value,
				    -- the whole "sp_dc=...;" pair, a quoted value, or the full cookie header
				    cookie = cookie:gsub('^["\']+', ''):gsub('["\']+$', '')
				    local dcMatch = cookie:match('sp_dc=([^;]+)')
				    if dcMatch then cookie = dcMatch end
				    cookie = cookie:gsub('^["\']+', ''):gsub('["\']+$', '')
				    cookie = cookie:gsub(';+$', '')
				    if cookie == "" then
					library:notification({text = 'Spotify: open ' .. cookiePath .. ' and paste your sp_dc cookie (browser devtools > cookies > open.spotify.com > sp_dc), then press the button again', time = 30})
					done()
					return
				    end
				    self.Headers = {
					Cookie = 'sp_dc=' .. cookie .. ';',
					['Accept-Encoding'] = 'identity', -- round 10b: never get brotli back
					['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:158.0) Gecko/20100101 Firefox/158.0'
				    }
				    local dataPath = dir .. "/spotifydata.txt"
				    local data = nil
				    if type(isfile) == "function" and isfile(dataPath) then
					pcall(function()
					    data = httpService:JSONDecode(readfile(dataPath))
					end)
					if type(data) ~= "table" then data = nil end
				    end
				    if not (data and data.expireTime and data.expireTime > os.time()) then
					library:notification({text = 'Spotify: Authenticating...', time = 10})
					local success, res = pcall(function()
					    return self:Refresh()
					end)
					if not success then
					    library:notification({text = 'Spotify: ' .. tostring(res), time = 10})
					    done()
					    return
					end
					data = res
					library:notification({text = 'Spotify: Logged in!', time = 10})
					pcall(function()
					    if type(writefile) == "function" then
						writefile(dataPath, httpService:JSONEncode(data))
					    end
					end)
				    end
				    self.Data = data
				    if not self.clientToken then
					local success, deviceToken = pcall(function()
					    return self:GetSession()
					end)
					if not success then
					    library:notification({text = 'Spotify: ' .. tostring(deviceToken), time = 10})
					    done()
					    return
					end
					self.clientToken = deviceToken
				    end
				    self:RegisterSocket()
				    local pingCooldown = os.clock() + 30
				    while self.active do
					local delta = task.wait(0.1)
					if not self.active then break end
					if self.Socket then
					    if self.syncTime and (os.clock() - self.syncTime) > 10 then
						pingCooldown = os.clock() + 30
						self.Socket:Close()
						self.Socket.OnClose:Wait()
						if not self.active then break end
						self:RegisterSocket()
					    elseif pingCooldown < os.clock() then
						pcall(function() self.Socket:Send('{"type":"ping"}') end)
						self.syncTime = os.clock()
						pingCooldown = os.clock() + 30
					    end
					    if self.playPosition then
						self.playPosition = math.clamp(
						    self.playPosition + (delta * (self.playRate or 1)),
						    0.01, self.playDuration or 1
						)
						spTimeCur.Text = fmtTime(self.playPosition)
						spTimeLen.Text = fmtTime(self.playDuration or 0)
						spBarFill.Size = UDim2.fromScale(
						    self.playPosition / math.max(self.playDuration or 1, 0.01), 1
						)
					    end
					end
				    end
				    done()
				end

				library.spotify_player = {}
				function library.spotify_player.toggle()
				    if SpotifyHandler.active then
					SpotifyHandler.active = false
					if SpotifyHandler.Socket then
					    pcall(function() SpotifyHandler.Socket:Close() end)
					end
					SpotifyHandler.Socket = nil
					SpotifyHandler.connectionId = nil
					spotifyGui.Enabled = false
					spTitle.Text = "not playing"
					spArtist.Text = ""
					spArt.Image = ""
					spTimeCur.Text = "0:00"
					spTimeLen.Text = "0:00"
					spBarFill.Size = UDim2.fromScale(0, 1)
					skUpdateLikeUI(false)
				    else
					SpotifyHandler.active = true
					spotifyGui.Enabled = true
					spTitle.Text = "connecting..."
					spArtist.Text = ""
					spArt.Image = ""
					task.spawn(function()
					    pcall(function() SpotifyHandler:Start() end)
					end)
				    end
				end
			    end
			end
			--

			return setmetatable(window, library)
		end

		function library:watermark(options) 
			local cfg = {
				default = options.text or options.default or os.date('drain.lol | %b %d %Y | %H:%M')
			}

			local watermark_outline = library:create("Frame", {
				Parent = sgui,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				AnchorPoint = vec2(1, 1),
				Position = dim2(1, -20, 0, 20),
				Size = dim2(0, 0, 0, 24),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(watermark_outline, "outline", "BackgroundColor3") 
			watermark_outline.Position = dim_offset(watermark_outline.AbsolutePosition.X, watermark_outline.AbsolutePosition.Y)
			library:draggify(watermark_outline)

			local watermark_inline = library:create("Frame", {
				Parent = watermark_outline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(watermark_inline, "inline", "BackgroundColor3") 
			
			local watermark_background = library:create("Frame", {
				Parent = watermark_inline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIGradient = library:create("UIGradient", {
				Parent = watermark_background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			}) library:apply_theme(UIGradient, "contrast", "Color") 
			
			local text = library:create("TextLabel", {
				Parent = watermark_background,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "  drain.lol | Beta | Aug 29 2024 | 07:29:00  ",
				Size = dim2(0, 0, 1, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, -1, 0, 1),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			library:create("UIStroke", {
				Parent = text,
				Name = "",
				LineJoinMode = Enum.LineJoinMode.Miter
			})
			
			local accent = library:create("Frame", {
				Parent = watermark_outline,
				Name = "",
				Position = dim2(0, 2, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -4, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3") 
			
			local UIGradient = library:create("UIGradient", {
				Parent = accent,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
			})
			
			function cfg.change_text(input)
				text.Text = "  ".. input .."  "
			end 

			function cfg.set_visible(bool) 
				watermark_outline.Visible = bool
			end 


			cfg.change_text(cfg.default)

			return cfg 

		end 

		function library:esp_preview(properties)
			local cfg = {items = {}, rotation = 0; objects = {};}
			local props = properties or {}
			local get_settings = props.get_settings or library.esp_preview_get_settings

			local character = nil
			local function build_character()
				-- round 6: capture the local player exactly ONCE.
				-- Re-captures are what froze the dummy mid-fall (the clone
				-- copies the CURRENT animated part CFrames) and what let
				-- applied self materials leak into the preview.
				if character then return end
				if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
					lp.Character.Archivable = true
					character = lp.Character:Clone()
					lp.Character.Archivable = false
					if character:FindFirstChild("Animate") then character.Animate:Destroy() end
					for _, v in ipairs(character:GetDescendants()) do
						if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("ModuleScript") then
							v:Destroy()
						elseif v:IsA("BasePart") then
							v.Anchored = true
							v.CanCollide = false
						end
					end
					local hum = character:FindFirstChildOfClass("Humanoid")
					if hum then
						hum.WalkSpeed = 0
						hum.JumpPower = 0
						hum.AutoRotate = false
						if hum:FindFirstChild("Animator") then hum.Animator:Destroy() end
					end
					if not character.PrimaryPart then
						character.PrimaryPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
					end

					-- round 6: reset the clone to the rig REST pose (the
					-- Motor6D C0/C1 chain - the same trick the csync dummy
					-- builder uses) so the preview can never be frozen
					-- mid-walk / mid-fall, no matter when it was captured
					do
						local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character.PrimaryPart
						if root then
							local joints = {}
							for _, d in ipairs(character:GetDescendants()) do
								if d:IsA("Motor6D") and d.Part0 and d.Part1 then joints[#joints + 1] = d end
							end
							local rel = { [root] = CFrame.new() }
							local changed, guard = true, 0
							while changed and guard < 64 do
								changed = false
								guard = guard + 1
								for _, j in ipairs(joints) do
									local p0, p1 = j.Part0, j.Part1
									if rel[p0] and not rel[p1] then
										rel[p1] = rel[p0] * j.C0 * j.C1:Inverse()
										changed = true
									elseif rel[p1] and not rel[p0] then
										rel[p0] = rel[p1] * j.C1 * j.C0:Inverse()
										changed = true
									end
								end
							end
							local base = root.CFrame
							for part, r in pairs(rel) do
								if part ~= root and part:IsA("BasePart") and part.Parent then
									part.CFrame = base * r
								end
							end
						end
					end

					if cfg.items.viewportframe and cfg.items.viewportframe.Parent then
						character.Parent = cfg.items.viewportframe
						if cfg.items.camera then
							cfg.items.camera.CameraSubject = character
						end
						if cfg.preview_highlight then cfg.preview_highlight:Destroy() end
						local hi = Instance.new("Highlight")
						hi.Parent = character
						hi.Adornee = character
						hi.Enabled = false
						hi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						cfg.preview_highlight = hi
					end
				end
			end

			build_character()

			-- round 6: these stay as retry hooks ONLY - once a capture
			-- succeeded they never rebuild the preview again
			library:connection(lp.CharacterAppearanceLoaded, build_character)
			library:connection(lp.CharacterAdded, function()
				task.wait(1)
				build_character()
			end)

			local function flag_color(key) 
				local v = flags[key] 
				return type(v) == "table" and v.Color or v or rgb(255,255,255) 
			end
			local function flag_bool(key) 
				local v = flags[key] 
				return v == true 
			end

			local items = cfg.items; do 
				items.viewportframe = library:create( "ViewportFrame" , {
					Parent = self.holder;
					BackgroundTransparency = 1;
					Size = dim2(1, 0, 0, 180);
					BorderColor3 = rgb(0, 0, 0);
					ZIndex = 1;
					Position = dim2(0, 0, 0, 10);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				items.camera = library:create( "Camera" , {
					FieldOfView = 70.00022888183594;
					CameraType = Enum.CameraType.Track;
					Focus = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
					CFrame = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
					Parent = ws;
					Name = "\0"
				}); 

				items.viewportframe.CurrentCamera = items.camera
				if character then
					character.Parent = items.viewportframe
					items.camera.CameraSubject = character
					local hi = Instance.new("Highlight")
					hi.Parent = character
					hi.Adornee = character
					hi.Enabled = false
					hi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					cfg.preview_highlight = hi
				end

				library:connection(run.RenderStepped, function()
					task.wait()
					cfg.rotation = (cfg.rotation or 0) + 0.5
					if character and character.Parent and character:FindFirstChild("HumanoidRootPart") then
						local charPos = Vector3.new(0, 2, -6)
						character:SetPrimaryPartCFrame(cfr(charPos) * angle(0, math.rad(cfg.rotation), 0))
						items.camera.CFrame = cfr(Vector3.new(0, 0, 0), Vector3.new(0, 0, -6))
						
						if flag_bool("esp_dynamic_box") then
							local camCF = items.camera.CFrame
							local camPos = camCF.Position
							local lookDir = camCF.LookVector
							local rightVec = camCF.RightVector
							local upVec = camCF.UpVector
							local vpSize = items.viewportframe.AbsoluteSize
							local focalLength = (vpSize.Y / 2) / math.tan(math.rad(items.camera.FieldOfView / 2))
							
							local minV = Vector2.new(math.huge, math.huge)
							local maxV = Vector2.new(-math.huge, -math.huge)
							for _, part in ipairs(character:GetChildren()) do
								if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
									local cf = part.CFrame
									local sz = part.Size
									local HX, HY, HZ = sz.X * 0.5, sz.Y * 0.5, sz.Z * 0.5
									for _, offset in ipairs({
										Vector3.new(HX, HY, HZ), Vector3.new(HX, HY, -HZ),
										Vector3.new(HX, -HY, HZ), Vector3.new(HX, -HY, -HZ),
										Vector3.new(-HX, HY, HZ), Vector3.new(-HX, HY, -HZ),
										Vector3.new(-HX, -HY, HZ), Vector3.new(-HX, -HY, -HZ)
									}) do
										local cornerPos = cf * offset
										local relCorner = cornerPos - camPos
										local cz = relCorner:Dot(lookDir)
										if cz > 0 then
											local cx = relCorner:Dot(rightVec)
											local cy = relCorner:Dot(upVec)
											local screenX = (cx / cz) * focalLength + (vpSize.X / 2)
											local screenY = -(cy / cz) * focalLength + (vpSize.Y / 2)
											if screenX < minV.X then minV = Vector2.new(screenX, minV.Y) end
											if screenX > maxV.X then maxV = Vector2.new(screenX, maxV.Y) end
											if screenY < minV.Y then minV = Vector2.new(minV.X, screenY) end
											if screenY > maxV.Y then maxV = Vector2.new(maxV.X, screenY) end
										end
									end
								end
							end
							
							local padding = 3
							local sizeX = math.max(1, math.floor((maxV.X - minV.X) + padding * 2))
							local sizeY = math.max(1, math.floor((maxV.Y - minV.Y) + padding * 2))
							cfg.objects["holder"].Size = UDim2.fromOffset(sizeX, sizeY)
							cfg.objects["holder"].Position = UDim2.fromOffset(math.floor(minV.X - padding), math.floor(minV.Y - padding))
						else
							cfg.objects["holder"].Size = UDim2.fromOffset(110, 150)
							local vpX = items.viewportframe.AbsoluteSize.X
							local vpY = items.viewportframe.AbsoluteSize.Y
							cfg.objects["holder"].Position = UDim2.fromOffset(math.floor((vpX - 110) / 2), math.floor((vpY - 150) / 2))
						end
						
						local teamCol = lp.Team and lp.Team.TeamColor and lp.Team.TeamColor.Color or rgb(255, 255, 255)
						local teamElems = flags["ESP_TEAM_COLOR_ELEMENTS"] or {}
						if type(teamElems) == "string" then teamElems = {teamElems} end
						local function hasElem(elem)
							for _, v in ipairs(teamElems) do if v == elem then return true end end
							return false
						end
						
						local function set_obj_prop(obj_name, prop, val)
							if cfg.objects[obj_name] then cfg.objects[obj_name][prop] = val end
						end

						if hasElem("Name") then set_obj_prop("name", "TextColor3", teamCol) end
						if hasElem("Distance") then set_obj_prop("distance", "TextColor3", teamCol) end
						if hasElem("Tool") then set_obj_prop("weapon", "TextColor3", teamCol) end
						if hasElem("Box") then set_obj_prop("box_color", "Color", teamCol) end
						if hasElem("Box Fill") and cfg.objects["box_fill"] then
							local grad = cfg.objects["box_fill"]:FindFirstChildOfClass("UIGradient")
							if grad then grad.Color = ColorSequence.new(teamCol) end
						end
						if hasElem("Mesh Chams") or hasElem("Glow") then
							local st = get_settings and get_settings()
							if st and st.ChamsSettings then
								if st.ChamsSettings.MeshChamsColor then st.ChamsSettings.MeshChamsColor = teamCol end
								if st.ChamsSettings.GlowColor then st.ChamsSettings.GlowColor = teamCol end
							end
						end
					end
				end)
			end 

			local objects = cfg.objects; do 
				objects[ "holder" ] = library:create( "Frame" , {
					Parent = items.viewportframe;
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 0, 0, 0);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 110, 0, 150);
					BorderSizePixel = 0;
					AnchorPoint = vec2(0, 0);
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				objects[ "box_outline" ] = library:create( "UIStroke" , {
					Parent = objects[ "holder" ];
					LineJoinMode = Enum.LineJoinMode.Miter
				});
				
				objects[ "name" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					Parent = objects[ "holder" ];
					TextColor3 = flag_color("esp_name_color");
					BorderColor3 = rgb(0, 0, 0);
					Text = string.format("%s (@%s)", lp.DisplayName or lp.Name, lp.Name);
					Name = "\0";
					TextStrokeTransparency = 0;
					AnchorPoint = vec2(0.5, 1);
					Size = dim2(1, 0, 0, 0);
					BackgroundTransparency = 1;
					Position = dim2(0.5, 0, 0, -5);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 14;
				});
				
				objects[ "box_handler" ] = library:create( "Frame" , {
					Parent = objects[ "holder" ];
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				objects[ "box_color" ] = library:create( "UIStroke" , {
					Color = flag_color("esp_box_color");
					LineJoinMode = Enum.LineJoinMode.Miter;
					Name = "\0";
					Parent = objects[ "box_handler" ]
				});
				
				objects[ "outline" ] = library:create( "Frame" , {
					Parent = objects[ "box_handler" ];
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				
				library:create( "UIStroke" , {
					Parent = objects[ "outline" ];
					LineJoinMode = Enum.LineJoinMode.Miter
				});  

				objects[ "corners" ] = library:create( "Frame" , {
					Parent = objects[ "holder" ];
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 0, 0, 0);
					Size = dim2(1, 0, 1, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});

				local cornerNames = { "LeftTop", "LeftSide", "RightTop", "RightSide", "BottomLeft", "BottomDown", "BottomRightSide", "BottomRightDown" }
				for _, name in ipairs(cornerNames) do
					local fOutline = library:create("Frame", {
						Parent = objects["corners"],
						Name = name .. "_Outline",
						BackgroundColor3 = rgb(0, 0, 0),
						BorderSizePixel = 0,
						ZIndex = 1,
						Visible = false
					})
					local fMain = library:create("Frame", {
						Parent = objects["corners"],
						Name = name .. "_Main",
						BackgroundColor3 = flag_color("esp_box_color"),
						BorderSizePixel = 0,
						ZIndex = 2,
						Visible = false
					})
					objects[name] = {Main = fMain, Outline = fOutline}
				end
				
				objects[ "healthbar_holder" ] = library:create( "Frame" , {
					Parent = objects[ "holder" ];
					Name = "HealthBarOutline";
					BorderColor3 = rgb(0, 0, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(0, 0, 0);
					Visible = false;
				});
				
				objects[ "healthbar_container" ] = library:create( "Frame" , {
					Parent = objects[ "healthbar_holder" ];
					Name = "HealthBarContainer";
					BackgroundTransparency = 1;
					ClipsDescendants = true;
					BorderSizePixel = 0;
				});
				
				objects[ "healthbar" ] = library:create( "Frame" , {
					Parent = objects[ "healthbar_container" ];
					Name = "HealthBar";
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});

				objects[ "healthbar_gradient" ] = library:create( "UIGradient" , {
					Parent = objects[ "healthbar" ];
					Rotation = 90;
				});
				
				objects[ "box_fill" ] = library:create( "Frame" , {
					Parent = objects[ "holder" ];
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundTransparency = 0.15;
					BackgroundColor3 = rgb(255, 255, 255)
				});
				local box_fill_grad = library:create( "UIGradient" , { Parent = objects[ "box_fill" ]; Rotation = -270 });
				
				objects[ "health_text" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					Parent = objects[ "holder" ];
					TextColor3 = flag_color("esp_healthtext_color");
					Text = "100";
					TextStrokeTransparency = 0;
					AnchorPoint = vec2(1, 0.5);
					Size = dim2(0, 28, 0, 14);
					BackgroundTransparency = 1;
					Position = dim2(0, -8 - 4 - 2, 0.5, 0);
					BorderSizePixel = 0;
					TextSize = 12;
				});
				
				objects[ "flag" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					Parent = objects[ "holder" ];
					TextColor3 = flag_color("esp_flag_innocent");
					Text = "Innocent";
					TextStrokeTransparency = 0;
					AnchorPoint = vec2(0, 0);
					AutomaticSize = Enum.AutomaticSize.XY;
					BackgroundTransparency = 1;
					Position = dim2(1, 5, 0, 0);
					BorderSizePixel = 0;
					TextSize = 12;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				
				objects[ "team_flag" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					Parent = objects[ "holder" ];
					TextColor3 = rgb(255, 200, 100);
					Text = "Inmates";
					TextStrokeTransparency = 0;
					AnchorPoint = vec2(0, 0);
					AutomaticSize = Enum.AutomaticSize.XY;
					BackgroundTransparency = 1;
					Position = dim2(1, 5, 0, 14);
					BorderSizePixel = 0;
					TextSize = 12;
					TextXAlignment = Enum.TextXAlignment.Left;
				});
				
				objects[ "distance" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = flag_color("esp_distance_color");
					BorderColor3 = rgb(0, 0, 0);
					Text = "127m";
					Parent = objects[ "holder" ];
					TextStrokeTransparency = 0;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					BackgroundTransparency = 1;
					Position = dim2(0.5, 0, 1, 5);
					AnchorPoint = vec2(0.5, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});                

				objects[ "weapon" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = flag_color("esp_weapon_color");
					BorderColor3 = rgb(0, 0, 0);
					Text = "[ Weapon ]";
					Parent = objects[ "holder" ];
					TextStrokeTransparency = 0;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					BackgroundTransparency = 1;
					Position = dim2(0.5, 0, 1, 19);
					AnchorPoint = vec2(0.5, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});

				objects[ "ammobar_holder" ] = library:create( "Frame" , {
					Parent = objects[ "holder" ];
					Name = "AmmoBarOutline";
					BorderColor3 = rgb(0, 0, 0);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(0, 0, 0);
					Visible = false;
				});
				
				objects[ "ammobar_container" ] = library:create( "Frame" , {
					Parent = objects[ "ammobar_holder" ];
					Name = "AmmoBarContainer";
					BackgroundTransparency = 1;
					ClipsDescendants = true;
					BorderSizePixel = 0;
				});
				
				objects[ "ammobar" ] = library:create( "Frame" , {
					Parent = objects[ "ammobar_container" ];
					Name = "AmmoBar";
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 215, 60);
				});
				
				objects[ "ammo_text" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = flag_color("esp_ammo_text_color");
					BorderColor3 = rgb(0, 0, 0);
					Text = "30/30";
					Parent = objects[ "holder" ];
					TextStrokeTransparency = 0;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					BackgroundTransparency = 1;
					Position = dim2(0.5, 0, 1, 3);
					AnchorPoint = vec2(0.5, 0);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});
			end 

			local function update_corners()
				local w = objects["holder"].Size.X.Offset
				local h = objects["holder"].Size.Y.Offset
				local cornerLen = math.floor(w * 0.3)
				local t = 1
				
				local function setHoriz(seg, x, y, len)
					seg.Main.Position = UDim2.fromOffset(x, y)
					seg.Main.Size = UDim2.fromOffset(len, t)
					seg.Outline.Position = UDim2.fromOffset(x - 1, y - 1)
					seg.Outline.Size = UDim2.fromOffset(len + 2, t + 2)
				end
				local function setVert(seg, x, y, len)
					seg.Main.Position = UDim2.fromOffset(x, y)
					seg.Main.Size = UDim2.fromOffset(t, len)
					seg.Outline.Position = UDim2.fromOffset(x - 1, y - 1)
					seg.Outline.Size = UDim2.fromOffset(t + 2, len + 2)
				end

				setHoriz(objects["LeftTop"], 0, 0, cornerLen)
				setVert(objects["LeftSide"], 0, 0, cornerLen)

				setHoriz(objects["RightTop"], w - cornerLen, 0, cornerLen)
				setVert(objects["RightSide"], w - t, 0, cornerLen)

				setHoriz(objects["BottomLeft"], 0, h - t, cornerLen)
				setVert(objects["BottomDown"], 0, h - cornerLen, cornerLen)

				setHoriz(objects["BottomRightDown"], w - cornerLen, h - t, cornerLen)
				setVert(objects["BottomRightSide"], w - t, h - cornerLen, cornerLen)
			end

			cfg.change_health = function()
				local st = get_settings and get_settings()
				local smooth = (st and st.HealthSmooth) or 0.05
				local barW = (st and st.HealthBarWidth) or 3
				local textSize = (st and st.TextSize) or 14
				local lineH = math.max(12, textSize - 2) + 4
				
				local fullH = objects["holder"].Size.Y.Offset
				if fullH < 50 then fullH = 150 end
				
				if flag_bool("esp_healthbar") and objects[ "healthbar_holder" ].Parent == objects[ "holder" ] then
					local target = 0.5 + 0.5 * math.sin(tick() * 2)
					cfg._health_prev = (cfg._health_prev or target) + (target - (cfg._health_prev or target)) * math.min(smooth * 30, 1)
					local mult = math.clamp(cfg._health_prev, 0, 1)
					
					local lowC = flag_color("esp_health_low")
					local highC = flag_color("esp_health_high")
					local midC = flag_color("esp_health_mid")
					
					if objects[ "healthbar_gradient" ] then
						objects[ "healthbar_gradient" ].Color = ColorSequence.new({
							ColorSequenceKeypoint.new(0, highC),
							ColorSequenceKeypoint.new(0.5, midC),
							ColorSequenceKeypoint.new(1, lowC),
						})
						objects[ "healthbar_gradient" ].Rotation = 90
					end
					
					local barHeight = math.max(math.floor(fullH * mult), 1)
					local visibleHeight = math.min(barHeight, fullH)
					
					if flag_bool("esp_healthbar_resize_outline") then
						objects[ "healthbar_holder" ].Size = UDim2.fromOffset(barW + 2, visibleHeight + 2)
						objects[ "healthbar_holder" ].Position = UDim2.fromOffset(- (barW + 4), fullH - visibleHeight - 1)
						objects[ "healthbar_holder" ].Visible = true
						
						objects[ "healthbar_container" ].Size = UDim2.fromOffset(barW, visibleHeight)
						objects[ "healthbar_container" ].Position = UDim2.fromOffset(1, 1)
					else
						objects[ "healthbar_holder" ].Size = UDim2.fromOffset(barW + 2, fullH + 2)
						objects[ "healthbar_holder" ].Position = UDim2.fromOffset(- (barW + 4), -1)
						objects[ "healthbar_holder" ].Visible = true
						
						objects[ "healthbar_container" ].Size = UDim2.fromOffset(barW, visibleHeight)
						objects[ "healthbar_container" ].Position = UDim2.fromOffset(1, fullH - visibleHeight + 1)
					end
					
					objects[ "healthbar" ].Size = UDim2.fromOffset(barW, fullH + 1)
					objects[ "healthbar" ].Position = UDim2.fromOffset(0, -((fullH + 1) - barHeight))
					
					if objects[ "health_text" ] and objects[ "health_text" ].Parent == objects[ "holder" ] and flag_bool("esp_healthtext") then
						local hpVal = math.floor(mult * 100)
						if hpVal >= 100 then
							objects["health_text"].Visible = false
						else
							objects["health_text"].Visible = true
							objects["health_text"].Text = tostring(hpVal)
							local hbCenterX = - (barW / 2) - 3
							local hbFillTopY = fullH - visibleHeight - 2
							objects["health_text"].AnchorPoint = Vector2.new(0.5, 0.5)
							objects["health_text"].AutomaticSize = Enum.AutomaticSize.XY
							objects["health_text"].Size = UDim2.new(0, 0, 0, 0)
							objects["health_text"].Position = dim2(0, hbCenterX, 0, hbFillTopY)
						end
					else
						if objects[ "health_text" ] then objects[ "health_text" ].Visible = false end
					end
				else
					objects[ "healthbar_holder" ].Visible = false
					if objects[ "health_text" ] then objects[ "health_text" ].Visible = false end
				end
				
				local ammoTarget = 0.5 + 0.5 * math.sin(tick() * 1.5)
				cfg._ammo_prev = (cfg._ammo_prev or ammoTarget) + (ammoTarget - (cfg._ammo_prev or ammoTarget)) * math.min(smooth * 30, 1)
				local ammoRatio = math.clamp(cfg._ammo_prev, 0, 1)
				local maxAmmo = 30
				local currentAmmo = math.floor(ammoRatio * maxAmmo)
				local ammoTextStr = string.format("%d/%d", currentAmmo, maxAmmo)
				
				local currentY = 3
				
				if flag_bool("esp_ammo_bar") and objects[ "ammobar_holder" ].Parent == objects[ "holder" ] then
					local boxWidth = objects["holder"].Size.X.Offset
					local barWidth = math.max(math.floor(boxWidth * ammoRatio), 1)
					
					objects[ "ammobar_holder" ].Size = UDim2.fromOffset(barWidth + 2, barW + 2)
					objects[ "ammobar_holder" ].Position = UDim2.new(0, -1, 1, currentY)
					objects[ "ammobar_holder" ].Visible = true
					
					objects[ "ammobar_container" ].Size = UDim2.fromOffset(barWidth, barW)
					objects[ "ammobar_container" ].Position = UDim2.fromOffset(1, 1)
					
					objects[ "ammobar" ].Size = UDim2.fromOffset(barWidth, barW)
					objects[ "ammobar" ].Position = UDim2.fromOffset(0, 0)
					objects[ "ammobar" ].BackgroundColor3 = flag_color("esp_ammo_bar_color")
					
					currentY = currentY + barW + 2 + 2
				else
					objects[ "ammobar_holder" ].Visible = false
				end
				
				if flag_bool("esp_ammo_text") and objects[ "ammo_text" ].Parent == objects[ "holder" ] then
					objects[ "ammo_text" ].Text = ammoTextStr
					objects[ "ammo_text" ].TextColor3 = flag_color("esp_ammo_text_color")
					objects[ "ammo_text" ].Position = dim2(0.5, 0, 1, currentY)
					objects[ "ammo_text" ].Visible = true
					currentY = currentY + lineH
				else
					objects[ "ammo_text" ].Visible = false
				end
				
				if flag_bool("esp_distance") and objects[ "distance" ].Parent == objects[ "holder" ] then
					objects[ "distance" ].Position = dim2(0.5, 0, 1, currentY)
					currentY = currentY + lineH
				end
				
				if flag_bool("esp_weapon") and objects[ "weapon" ].Parent == objects[ "holder" ] then
					objects[ "weapon" ].Position = dim2(0.5, 0, 1, currentY)
				end

				update_corners()
			end

			local function safe_set_parent(inst, new_parent)
				if not inst or not new_parent then return end
				pcall(function() inst.Parent = new_parent end)
			end

			function cfg.refresh_elements( )
				local st = get_settings and get_settings()
				local textSize = (st and st.TextSize) or 14
				local barW = (st and st.HealthBarWidth) or 3
				local boxFillTrans = (st and st.BoxFillTransparency) or 0.85
				local fontFace = (st and st.ESPFont) or library.font
				safe_set_parent(objects.holder, flag_bool("esp_enabled") and items.viewportframe or library.cache)

				objects["name"].Visible = flag_bool("esp_names")
				safe_set_parent(objects["name"], flag_bool("esp_names") and objects["holder"] or library.cache)
				objects["name"].TextColor3 = flag_color("esp_name_color")
				objects["name"].TextSize = textSize
				if objects["name"].FontFace then objects["name"].FontFace = fontFace end

				objects["distance"].Visible = flag_bool("esp_distance")
				safe_set_parent(objects["distance"], flag_bool("esp_distance") and objects["holder"] or library.cache)
				objects["distance"].TextColor3 = flag_color("esp_distance_color")
				objects["distance"].TextSize = math.max(8, textSize - 2)
				if objects["distance"].FontFace then objects["distance"].FontFace = fontFace end

				objects["weapon"].Visible = flag_bool("esp_weapon")
				safe_set_parent(objects["weapon"], flag_bool("esp_weapon") and objects["holder"] or library.cache)
				objects["weapon"].TextColor3 = flag_color("esp_weapon_color")
				objects["weapon"].TextSize = math.max(8, textSize - 2)
				if objects["weapon"].FontFace then objects["weapon"].FontFace = fontFace end

				objects["ammobar_holder"].Visible = flag_bool("esp_ammo_bar")
				safe_set_parent(objects["ammobar_holder"], flag_bool("esp_ammo_bar") and objects["holder"] or library.cache)
				
				objects["ammo_text"].Visible = flag_bool("esp_ammo_text")
				safe_set_parent(objects["ammo_text"], flag_bool("esp_ammo_text") and objects["holder"] or library.cache)
				objects["ammo_text"].TextColor3 = flag_color("esp_ammo_text_color")
				objects["ammo_text"].TextSize = math.max(8, textSize - 2)
				if objects["ammo_text"].FontFace then objects["ammo_text"].FontFace = fontFace end

				objects["healthbar_holder"].Visible = flag_bool("esp_healthbar")
				safe_set_parent(objects["healthbar_holder"], flag_bool("esp_healthbar") and objects["holder"] or library.cache)

				objects["health_text"].Visible = flag_bool("esp_healthtext")
				safe_set_parent(objects["health_text"], flag_bool("esp_healthtext") and objects["holder"] or library.cache)
				objects["health_text"].TextColor3 = flag_color("esp_healthtext_color")
				objects["health_text"].TextSize = math.max(8, textSize - 2)
				if objects["health_text"].FontFace then objects["health_text"].FontFace = fontFace end

				local flagLineH = math.max(12, textSize - 2) + 2
				local flagY = -2

				if flag_bool("esp_flags") then
					objects["flag"].Visible = true
					safe_set_parent(objects["flag"], objects["holder"])
					objects["flag"].TextColor3 = flag_color("esp_flag_innocent")
					objects["flag"].TextSize = math.max(8, textSize - 2)
					objects["flag"].AnchorPoint = vec2(0, 0)
					objects["flag"].Position = dim2(1, 5, 0, flagY)
					objects["flag"].TextXAlignment = Enum.TextXAlignment.Left
					if objects["flag"].FontFace then objects["flag"].FontFace = fontFace end
					flagY = flagY + flagLineH
				else
					objects["flag"].Visible = false
					safe_set_parent(objects["flag"], library.cache)
				end

				if flag_bool("esp_team_flag") then
					objects["team_flag"].Visible = true
					safe_set_parent(objects["team_flag"], objects["holder"])
					objects["team_flag"].TextSize = math.max(8, textSize - 2)
					objects["team_flag"].AnchorPoint = vec2(0, 0)
					objects["team_flag"].Position = dim2(1, 5, 0, flagY)
					objects["team_flag"].TextXAlignment = Enum.TextXAlignment.Left
					if st and st.FlagTeamInmatesColor then
						objects["team_flag"].TextColor3 = type(st.FlagTeamInmatesColor) == "table" and st.FlagTeamInmatesColor.Color or st.FlagTeamInmatesColor
					end
					if objects["team_flag"].FontFace then objects["team_flag"].FontFace = fontFace end
				else
					objects["team_flag"].Visible = false
					safe_set_parent(objects["team_flag"], library.cache)
				end

				if flag_bool("esp_box") then
					if flags["esp_box_mode"] == "Corner Boxes" then
						safe_set_parent(objects["box_handler"], library.cache)
						safe_set_parent(objects["box_outline"], library.cache)
						for _, name in ipairs({"LeftTop", "LeftSide", "RightTop", "RightSide", "BottomLeft", "BottomDown", "BottomRightSide", "BottomRightDown"}) do
							objects[name].Main.Visible = true
							objects[name].Outline.Visible = true
						end
					else
						safe_set_parent(objects["box_handler"], objects["holder"])
						safe_set_parent(objects["box_outline"], objects["holder"])
						for _, name in ipairs({"LeftTop", "LeftSide", "RightTop", "RightSide", "BottomLeft", "BottomDown", "BottomRightSide", "BottomRightDown"}) do
							objects[name].Main.Visible = false
							objects[name].Outline.Visible = false
						end
					end
				else
					safe_set_parent(objects["box_handler"], library.cache)
					safe_set_parent(objects["box_outline"], library.cache)
					for _, name in ipairs({"LeftTop", "LeftSide", "RightTop", "RightSide", "BottomLeft", "BottomDown", "BottomRightSide", "BottomRightDown"}) do
						objects[name].Main.Visible = false
						objects[name].Outline.Visible = false
					end
				end

				local boxCol = flag_color("esp_box_color")
				objects["box_color"].Color = boxCol
				for _, name in ipairs({"LeftTop", "LeftSide", "RightTop", "RightSide", "BottomLeft", "BottomDown", "BottomRightSide", "BottomRightDown"}) do
					objects[name].Main.BackgroundColor3 = boxCol
				end

				objects["box_fill"].Visible = flag_bool("esp_box_fill")
				safe_set_parent(objects["box_fill"], flag_bool("esp_box_fill") and objects["holder"] or library.cache)
				objects["box_fill"].BackgroundTransparency = boxFillTrans
				if objects["box_fill"]:FindFirstChildOfClass("UIGradient") then
					objects["box_fill"]:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, flag_color("esp_gradient_end")),
						ColorSequenceKeypoint.new(1, Color3.new(0,0,0))
					})
				end

				if cfg.preview_highlight and character and character.Parent then
					local show = st and st.ChamsEnabled and st.ShowHighlight
					cfg.preview_highlight.Enabled = show
					if show then
						local fillC = st.HighlightFillColor
						local outC = st.HighlightOutlineColor
						cfg.preview_highlight.FillColor = type(fillC) == "table" and (fillC.Color or fillC) or fillC or rgb(255,255,255)
						cfg.preview_highlight.OutlineColor = type(outC) == "table" and (outC.Color or outC) or outC or rgb(0,0,0)
						cfg.preview_highlight.FillTransparency = type(st.HighlightFillTransparency) == "number" and st.HighlightFillTransparency or 0.5
						cfg.preview_highlight.OutlineTransparency = type(st.HighlightOutlineTransparency) == "number" and st.HighlightOutlineTransparency or 0
					end
				end
				
				cfg.change_health()
			end

			task.spawn(function()
				while true do 
					task.wait()
					cfg.change_health()
				end 
			end)

			return setmetatable(cfg, library)
		end

		function library:refresh_notifications()  	
			for _, notif in next, library.notifications do 
				local idx = table.find(library.notifications, notif)
				if idx then
					local dir = (flags["notify_invert"] and -1 or 1)
					local base_y = flags["notify_y"] or 72
					local base_x = flags["notify_x"] or 20
					local offset = (idx - 1) * 28 * dir
					tween_service:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = dim2(0, base_x, 0, base_y + offset)}):Play()
				end
			end     
		end

		function library:notification(properties)
			local cfg = {
				time = properties.time or 5,
				text = properties.text or properties.name or "Notification",
				flashing = false, 
				text_color = properties.text_color or nil,
				rich_text = properties.rich_text or false,
				font_enum = properties.font_enum or nil,
			}
		
			local dir = (flags["notify_invert"] and -1 or 1)
			local base_y = flags["notify_y"] or 72
			local base_x = flags["notify_x"] or 20
			local offset = (#library.notifications * 28) * dir

			-- Instances
				local watermark_outline = library:create("Frame", {
					Parent = notif_holder,
					Name = "",
					Size = UDim2.new(0, 0, 0, 24),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(0, base_x, 0, base_y + offset),
					AutomaticSize = Enum.AutomaticSize.X,
					BackgroundColor3 = themes.preset.outline,
					AnchorPoint = Vector2.new(1, 0)
				})
			
				local watermark_inline = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})

				local watermark_background = library:create("Frame", {
					Parent = watermark_inline,
					Name = "",
					Position = UDim2.new(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
		
				local UIGradient = library:create("UIGradient", {
					Parent = watermark_background,
					Name = "",
					Color = ColorSequence.new{
						rgbkey(0, themes.preset.high_contrast),
						rgbkey(1, themes.preset.low_contrast)
					}
				})
		
				local textProps = {
					Parent = watermark_background,
					Name = "",
					TextColor3 = cfg.text_color or themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "  " .. cfg.text .. "  ",
					RichText = cfg.rich_text,
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				}
				if cfg.font_enum then
					textProps.Font = cfg.font_enum
				else
					textProps.FontFace = library.font
				end
				local text = library:create("TextLabel", textProps)
		
				local accent = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = UDim2.new(0, 2, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(0, 1, 1, -4),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})

				library:apply_theme(accent, "accent", "BackgroundColor3")
		
				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Name = "",
					Rotation = 90,
					Color = ColorSequence.new{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				local accent_bottom = library:create("Frame", {
					Parent = watermark_outline,
					Name = "",
					Position = UDim2.new(0, 2, 1, -3),
					BorderColor3 = rgb(0, 0, 0),
					Size = UDim2.new(0, -4, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Name = "",
					Rotation = 90,
					Color = ColorSequence.new{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})

				local index = #library.notifications + 1
				library.notifications[index] =watermark_outline

				library:refresh_notifications()

				tween_service:Create(watermark_outline, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {AnchorPoint = Vector2.new(0, 0)}):Play()
				
				tween_service:Create(accent_bottom, TweenInfo.new(cfg.time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, -4, 0, 1)}):Play()
			--
			
			task.spawn(function()
				task.wait(cfg.time)

				library.notifications[index] = nil

				tween_service:Create(watermark_outline, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {AnchorPoint = Vector2.new(1, 0), BackgroundTransparency = 1}):Play()
				
				for _, v in next, watermark_outline:GetDescendants() do 
					if v:IsA("TextLabel") then 
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
					elseif v:IsA("Frame") then 
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
					elseif v:IsA("ImageLabel") then
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
					elseif v:IsA("UIStroke") then 
						tween_service:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Transparency = 1}):Play()
					end 
				end 

				task.wait(1)

				watermark_outline:Destroy()
				library:refresh_notifications()
			end)    
		end 

		function library:tab(options)	
			local cfg = {
				name = options.name or "tab", 
				enabled = false, 
			}
			
				local tab_holder = library:create("TextButton", {
					Parent = self.tab_holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "\0",
					BorderSizePixel = 0,
					Size = dim2(0, 0, 1, -2),
					ZIndex = 5,
					TextSize = 12,
					BackgroundColor3 = themes.preset.outline,
					AutoButtonColor = false
				}) library:apply_theme(tab_holder, "outline", "BackgroundColor3") 

				local inline = library:create("Frame", {
					Parent = tab_holder,
					Size = dim2(1, -2, 1, 0),
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 

				local background = library:create("Frame", {
					Parent = inline,
					Size = dim2(1, -2, 1, -1),
					Name = "\0",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 5,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
				}) library:apply_theme(UIGradient, "contrast", "Color") 

				local text = library:create("TextLabel", {
					Parent = background,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "\0",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					ZIndex = 5,
					BackgroundColor3 = rgb(255, 255, 255)
				}, "text")
				library:apply_theme(text, "accent", "TextColor3")
			-- 

				local section_holder = library:create("Frame", {
					Parent = library.section_holder,
					BackgroundTransparency = 1,
					Name = "\0",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					Visible = false,
					BackgroundColor3 = rgb(255, 255, 255)
				})
			
				cfg["holder"] = section_holder

				library:create("UIListLayout", {
					Parent = section_holder,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 

			function cfg.open_tab()
				if library.current_tab and library.current_tab[1] ~= background then 
					local button = library.current_tab[1]
					button.Size = dim2(1, -2, 1, -1)
					button:FindFirstChildOfClass("UIGradient").Rotation = 90
					button:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.text
						
					library.current_tab[2].Visible = false
					
					library.current_tab = nil
				end
				
				library.current_tab = {
					background, section_holder
				}
				
				local button = library.current_tab[1] 
				button.Size = dim2(1, -2, 1, 0) -- ENABLED
				button:FindFirstChildOfClass("UIGradient").Rotation = -90
				button:FindFirstChildOfClass("TextLabel").TextColor3 = themes.preset.accent 

				library.current_tab[2].Visible = true 

				if library.current_element_open and library.current_element_open ~= cfg then 
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false 
					library.current_element_open = nil 
				end
			end
			
			tab_holder.MouseButton1Click:Connect(cfg.open_tab)
			
			return setmetatable(cfg, library) 
		end

		function library:column(path) 
			local cfg = {}
			
			local holder = path or self.holder
			
			local column = library:create("Frame", {
				Parent = holder,
				BackgroundTransparency = 1,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(column, "inline", "BackgroundColor3") 
			
			library:create("UIListLayout", {
				Parent = column,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalFlex = Enum.UIFlexAlignment.Fill
			})
			
			cfg["holder"] = column

			return setmetatable(cfg, library) 
		end

		function library:multi_section(options)
			local cfg = {
				names = options.names or {"First", "Second", "Third"}, 
				sections = {},
			}

			local section = library:create("Frame", {
				Parent = self.holder,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(section, "inline", "BackgroundColor3")
			
			local inline = library:create("Frame", {
				Parent = section,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(inline, "outline", "BackgroundColor3") 
			
			local __background = library:create("Frame", {
				Parent = inline,
				Name = "",
				ClipsDescendants = true,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				ZIndex = 1,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local accent = library:create("Frame", {
				Parent = __background,
				Name = "",
				Size = dim2(1, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3")
			
			local UIGradient = library:create("UIGradient", {
				Parent = accent,
				Name = "",
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))}
			}) 
			
			local UIGradient = library:create("UIGradient", {
				Parent = __background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
			}) library:apply_theme(UIGradient, "contrast", "Color") 
			
			local tab_holder = library:create("Frame", {
				Parent = __background,
				Name = "",
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Position = dim2(0, -1, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 2, 0, 21),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			}) 
			
			library:create("UIListLayout", {
				Parent = tab_holder,
				Name = "",
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, -3),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			for _, tab in next, cfg.names do 
				local multi = {
					open = false, 
				} 

				-- Tab
					local tabb = library:create("TextButton", {
						Parent = tab_holder,
						Name = "",
						AutoButtonColor = false,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = "",
						BorderSizePixel = 0,
						Size = dim2(0, 0, 1, 0),
						ZIndex = 1,
						TextSize = 12,
						BackgroundColor3 = themes.preset.outline
					}) library:apply_theme(tabb, "outline", "BackgroundColor3") 
					
					local background = library:create("Frame", {
						Parent = tabb,
						Name = "",
						Size = dim2(1, 0, 1, -2),
						Position = dim2(0, 1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						ZIndex = 1,
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					local UIGradient = library:create("UIGradient", {
						Parent = background,
						Name = "",
						Rotation = 90,
						Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))}
					}) library:apply_theme(UIGradient, "contrast", "Color")
					
					local text = library:create("TextLabel", {
						Parent = background,
						Name = "",
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = tab,
						BackgroundTransparency = 1,
						Size = dim2(1, 0, 1, 0),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(text, "accent", "TextColor3")
					
					local UIStroke = library:create("UIStroke", {
						Parent = text,
						Name = "",
						LineJoinMode = Enum.LineJoinMode.Miter
					})
				-- 

					local ScrollingFrame = library:create("ScrollingFrame", {
						Parent = __background,
						Name = "",
						ScrollBarImageColor3 = themes.preset.accent,
						Active = true,
						MidImage = "rbxassetid://103468666327206",
						TopImage = "rbxassetid://103468666327206",
						BottomImage = "rbxassetid://103468666327206",
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollBarThickness = 2,
						Size = dim2(1, 0, 1, -20),
						Visible = false, 
						BackgroundTransparency = 1,
						Position = dim2(0, 0, 0, 24),
						BackgroundColor3 = rgb(255, 255, 255),
						BorderColor3 = rgb(0, 0, 0),
						BorderSizePixel = 0,
						ScrollBarThickness = 2,
						CanvasSize = dim2(0, 0, 0, 0)
					}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
					
					local elements = library:create("Frame", {
						Parent = ScrollingFrame,
						Name = "",
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 0, 0),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					}) multi.holder = elements
					
					local UIListLayout = library:create("UIListLayout", {
						Parent = elements,
						Name = "",
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = dim(0, 4)
					})
					
					local UIPadding = library:create("UIPadding", {
						Parent = ScrollingFrame,
						Name = "",
						PaddingBottom = dim(0, 60)
					})
				--
				
				function multi:open_tab(bool) 
					ScrollingFrame.Visible = bool 
					UIGradient.Rotation = bool and -90 or 90
					tabb.Size = dim2(0, 0, 1, bool and 1 or 0)
					text.TextColor3 = bool and themes.preset.accent or themes.preset.text
				end

				library:connection(tabb.MouseButton1Click, function()
					for _, multi_s in next, cfg.sections do 
						multi_s:open_tab(false)
					end

					if library.current_element_open then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
						library.current_element_open = nil 
					end

					multi:open_tab(true) 
				end)

				cfg.sections[#cfg.sections + 1] = setmetatable(multi, library)
			end 

			cfg.sections[1]:open_tab(true)

			return unpack(cfg.sections)
		end 

		function library:section(options)
			local cfg = {
				name = options.name or "Section", 
			}
			
			local section = library:create("Frame", {
				Parent = self.holder,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(section, "inline", "BackgroundColor3") 

			local inline = library:create("Frame", {
				Parent = section,
				Name = "\0",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(inline, "outline", "BackgroundColor3") 

			local background = library:create("Frame", {
				Parent = inline,
				Name = "\0",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local text = library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Name = "\0",
				BackgroundTransparency = 1,
				Position = dim2(0, 6, 0, 4),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local accent = library:create("Frame", {
				Parent = background,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3") 

			local UIGradient = library:create("UIGradient", {
				Parent = accent,
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
			})

			local UIGradient = library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			}) library:apply_theme(UIGradient, "contrast", "Color") 

			local ScrollingFrame = library:create("ScrollingFrame", {
				Parent = background,
				ScrollBarImageColor3 = themes.preset.accent,
				Active = true,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				MidImage = "rbxassetid://103468666327206",
				TopImage = "rbxassetid://103468666327206",
				BottomImage = "rbxassetid://103468666327206",
				Size = dim2(1, 0, 1, -20),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, 20),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = dim2(0, 0, 0, 0)
			}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 

			ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
				if library.current_element_open then 
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false 
					library.current_element_open = nil
				end
			end) 

			local elements = library:create("Frame", {
				Parent = ScrollingFrame,
				Name = "\0",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.holder = elements 

			library:create("UIListLayout", {
				Parent = elements,
				Padding = dim(0, 4),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = ScrollingFrame,
				PaddingBottom = dim(0, 10)
			})

			return setmetatable(cfg, library)
		end

		function library:slider(options)
			local cfg = {
				name = options.name or nil,
				suffix = options.suffix or "",
				flag = options.flag or tostring(2^789),
				callback = options.callback or function() end, 
				visible = options.visible or true, 
				input_disabled = options.input or false,
				custom_color = options.custom or nil; 

				min = options.min or options.minimum or 0,
				max = options.max or options.maximum or 100,
				intervals = options.interval or options.decimal or 1,
				default = options.default or 10,

				dragging = false,
				value = options.default or 10, 
			} 

			-- instances 
				local slider_REAL = library:create("TextLabel", {
					Parent = self.holder, 
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "slider",
					ZIndex = 1,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local TEXT_LABEL; 
				if cfg.name then 
					local left_components = library:create("Frame", {
						Parent = slider_REAL,
						Name = "left_components",
						BackgroundTransparency = 1,
						Position = dim2(0, 2, 0, -1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(0, 0, 0, 14),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					TEXT_LABEL = library:create("TextLabel", {
						Parent = left_components,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = cfg.name,
						Name = "text",
						BackgroundTransparency = 1,
						Size = dim2(0, 0, 1, -1),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					}, "text")

					library:create("UIListLayout", {
						Parent = left_components,
						Padding = dim(0, 5),
						Name = "_",
						FillDirection = Enum.FillDirection.Horizontal
					})
				end 
				
				local bottom_components = library:create("Frame", {
					Parent = slider_REAL,
					Name = "bottom_components",
					Position = dim2(0, 0, 0, cfg.name and 15 or 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local slider = library:create("TextButton", {
					Parent = bottom_components,
					Name = "slider",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -1, 1, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(slider, "outline", "BackgroundColor3") 

				if not cfg.input_disabled then 
					library:hoverify(slider_REAL, slider)
				end

				local inline = library:create("Frame", {
					Parent = slider,
					Name = "inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					ZIndex = 1;
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 

				local background = library:create("Frame", {
					Parent = inline,
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
				}) 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "contrast",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local slidertext = library:create("TextLabel", {
					Parent = contrast,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "12.50/100.00",
					Name = "text",
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, -1),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					ZIndex = 2,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local fill = library:create("Frame", {
					Parent = contrast,
					Name = "fill",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = cfg.custom_color or themes.preset.accent
				}) if not cfg.custom_color then library:apply_theme(fill, "accent", "BackgroundColor3") end; 
				
				local UIGradient = library:create("UIGradient", {
					Parent = fill,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Padding = dim(0, 10),
					Name = "_",
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			--  

			function cfg.set(value)
				if type(value) == "userdata" then 
					return 
				end

				cfg.value = math.clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

				fill.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
				slidertext.Text = tostring(cfg.value) .. "/" .. tostring(cfg.max)
				flags[cfg.flag] = cfg.value

				cfg.callback(flags[cfg.flag])
			end

			function cfg.set_element_visible(bool)
				slider_REAL.Visible = bool 

				if TEXT_LABEL then 
					TEXT_LABEL.Visible = bool 
				end 
			end

			if not cfg.input_disabled then 
				library:connection(uis.InputChanged, function(input)
					if cfg.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then 
						local size_x = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
						local value = ((cfg.max - cfg.min) * size_x) + cfg.min
						cfg.set(value)
					end
				end)

				library:connection(uis.InputEnded, function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						cfg.dragging = false 
					end 
				end)

				slider.MouseButton1Down:Connect(function()
					cfg.dragging = true
				end)
			end

			if cfg.tooltip then 
				library:tool_tip({name = cfg.tooltip, path = slider_REAL})
			end

			cfg.set(cfg.default)
			cfg.set_element_visible(cfg.visible)
					
			config_flags[cfg.flag] = cfg.set

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library) 
		end 

		function library:toggle(options)
			local cfg = {
				enabled = options.enabled or nil,
				name = options.name or "Toggle",
				flag = options.flag or tostring(random(1,9999999)),
				callback = options.callback or function() end,
				default = options.default or false,
				colorpicker = options.color or nil,
				visible = options.visible or true,
				tooltip = options.tooltip or nil,
			}

			-- instances
				local toggle_holder = library:create("TextButton", {
					Parent = self.holder,
					FontFace = library.font,
					TextColor3 = rgb(151, 151, 151),
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "toggle",
					ZIndex = 1,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local right_components = library:create("Frame", {
					Parent = toggle_holder,
					Name = "right_components",
					Position = dim2(1, -1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 0, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				cfg["right_holder"] = right_components
			
				local list = library:create("UIListLayout", {
					Parent = right_components,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = dim(0, 4),
					Name = "list",
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			
				library:create("UIPadding", {
					Parent = toggle_holder
				})
			
				local left_components = library:create("Frame", {
					Parent = toggle_holder,
					Name = "left_components",
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 0, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local text = library:create("TextLabel", {
					Parent = left_components,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "text",
					BackgroundTransparency = 1,
					Size = dim2(0, 0, 1, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
			
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
			
				library:create("UIListLayout", {
					Parent = left_components,
					Padding = dim(0, 5),
					Name = "_",
					FillDirection = Enum.FillDirection.Horizontal
				})
			
				local toggle = library:create("TextButton", {
					Parent = left_components,
					Name = "!toggle",
					Text = "",
					AutoButtonColor = false,
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 0, 14),
					BorderSizePixel = 0,
					ZIndex = 1, 
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(toggle, "outline", "BackgroundColor3") 
				library:apply_theme(toggle, "accent", "BackgroundColor3") 

				local inline = library:create("Frame", {
					Parent = toggle,
					Name = "inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					ZIndex = 2;
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
			
				local accent = library:create("Frame", {
					Parent = inline,
					BackgroundTransparency = 1;
					ZIndex = 3;
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				library:apply_theme(accent, "accent", "BackgroundColor3") 

				local UIGradient = library:create("UIGradient", {
					Parent = accent,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})

				local background = library:create("Frame", {
					Parent = inline,
					ZIndex = 2;
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				library:apply_theme(background, "accent", "BackgroundColor3") 

				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
			--  

			library:hoverify(toggle_holder, toggle)

			function cfg.set(bool)
				library:tween(accent, {BackgroundTransparency = bool and 0 or 1})
				flags[cfg.flag] = bool
				
				cfg.callback(bool)
			end

			function cfg.set_element_visible(bool)
				toggle_holder.Visible = bool 
			end 
		
			library:connection(toggle_holder.MouseButton1Click, function()
				cfg.enabled = not cfg.enabled
		
				cfg.set(cfg.enabled)
			end)

			library:connection(toggle.MouseButton1Click, function()
				cfg.enabled = not cfg.enabled
		
				cfg.set(cfg.enabled)
			end)

			if cfg.tooltip then 
				library:tool_tip({name = cfg.tooltip, path = toggle_holder})
			end

			cfg.set(cfg.default)
			
			cfg.set_element_visible(cfg.visible)
			
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end
		
		function library:colorpicker(options)
			local parent = self.right_holder
			
			local cfg = {
				name = options.name or "Color", 
				flag = options.flag or tostring(2^789),
				color = options.color or color(1, 1, 1),
				alpha = options.alpha or 1,
				callback = options.callback or function() end,
				right_holder = self.right_holder,
			}

			local dragging_sat = false 
			local dragging_hue = false 
			local dragging_alpha = false 

			local h, s, v = cfg.color:ToHSV() 
			local a = cfg.alpha 
			
				local colorpicker_button = library:create("TextButton", {
					Parent = parent,
					Name = "outline",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 24, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(colorpicker_button, "outline", "BackgroundColor3") 
			
				local inline = library:create("Frame", {
					Parent = colorpicker_button,
					Name = "inline",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
			
				local handler = library:create("Frame", {
					Parent = inline,
					Name = "handler",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(250, 165, 27)
				})

				library:hoverify(colorpicker_button, colorpicker_button)
			
				local UIGradient = library:create("UIGradient", {
					Parent = handler,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				})
			-- 

				local colorpicker_holder = library:create("Frame", {
					Parent = sgui,
					Name = "colorpicker",
					Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 17),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 190, 0, 234),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Visible = false,
					ZIndex = 1
				}) library:apply_theme(colorpicker_holder, "outline", "BackgroundColor3") 

				library:make_resizable(colorpicker_holder)
				
				local window_inline = library:create("Frame", {
					Parent = colorpicker_holder,
					Name = "window_inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(window_inline, "accent", "BackgroundColor3") 
				
				local window_holder = library:create("Frame", {
					Parent = window_inline,
					Name = "window_holder",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = themes.preset.outline,
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local UIGradient = library:create("UIGradient", {
					Parent = window_holder,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local text = library:create("TextLabel", {
					Parent = window_holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					Name = "text",
					BackgroundTransparency = 1,
					Position = dim2(0, 2, 0, 4),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				library:create("UIPadding", {
					Parent = window_holder,
					Name = "_",
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local main_holder = library:create("Frame", {
					Parent = window_holder,
					Name = "main_holder",
					Position = dim2(0, 0, 0, 20),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, -40),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(main_holder, "inline", "BackgroundColor3") 
				
				cfg.holder = library:create( "Frame" , {
					Parent = colorpicker_holder;
					Name = "\0";
					Position = dim2(0, 6, 1, -21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -120, 0, 0);
					BorderSizePixel = 0;
				});
				
				local RainbowToggle = setmetatable(cfg, library):toggle({name = "Rainbow", flag = cfg.flag .. "_RAINBOW_FLAG"})

				cfg.holder = library:create( "Frame" , {
					Parent = colorpicker_holder;
					Name = "\0";
					Position = dim2(1, 2, 1, -23);
					BorderColor3 = rgb(0, 0, 0);
					AnchorPoint = vec2(1, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
				});
				
				local section = setmetatable(cfg, library)
				section:button_holder({})
				section:button({name = "Copy", callback = function()
					library.copied_flag = flags[cfg.flag]
					library.is_rainbow = cfg.flag .. "_RAINBOW_FLAG"
				end})
				section:button({name = "Paste", callback = function()
					RainbowToggle.set(library.is_rainbow)
					cfg.set(library.copied_flag.Color, library.copied_flag.Transparency)
				end})

				local main_holder_inline = library:create("Frame", {
					Parent = main_holder,
					Name = "main_holder_inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder_inline, "outline", "BackgroundColor3") 
				
				local main_holder_background = library:create("Frame", {
					Parent = main_holder_inline,
					Name = "main_holder_background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = main_holder_background,
					Rotation = 90,
					Name = "_",
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIPadding", {
					Parent = main_holder_background,
					PaddingTop = dim(0, 4),
					Name = "_",
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				-- round 6: same construction as the transparency (alpha)
				-- slider box - gray (inline) body, outline inset ring, then
				-- the content layer - and the same 14px height
				local hex_holder = library:create("Frame", {
					Parent = main_holder_background,
					Name = "hex_holder",
					Position = dim2(0, 0, 1, -28),
					Size = dim2(1, -20, 0, 14),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
				}) library:apply_theme(hex_holder, "inline", "BackgroundColor3")
				local hex_inline = library:create("Frame", {
					Parent = hex_holder,
					Name = "hex_inline",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
				}) library:apply_theme(hex_inline, "outline", "BackgroundColor3")
				local hex_input = library:create("TextBox", {
					Parent = hex_inline,
					Name = "hex_input",
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					TextSize = 11,
					Text = "#FFFFFF",
					PlaceholderText = "#FFFFFF",
					PlaceholderColor3 = themes.preset.text,
					ClearTextOnFocus = false,
					TextXAlignment = Enum.TextXAlignment.Center,
				}) library:apply_theme(hex_input, "text", "TextColor3")

				local alpha = library:create("TextButton", {
					Parent = main_holder_background,
					AnchorPoint = vec2(0, 0.5),
					Name = "alpha",
					Position = dim2(0, 0, 1, -8),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					Text = "",
					AutoButtonColor = false,
				}) library:apply_theme(alpha, "inline", "BackgroundColor3") 
				
				local outline = library:create("Frame", {
					Parent = alpha,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				
				local alpha_drag = library:create("Frame", {
					Parent = outline,
					Name = "alpha_drag",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				
				local alphaind = library:create("ImageLabel", {
					Parent = alpha_drag,
					ScaleType = Enum.ScaleType.Tile,
					BorderColor3 = rgb(0, 0, 0),
					Image = "rbxassetid://18274452449",
					BackgroundTransparency = 1,
					Name = "alphaind",
					Size = dim2(1, 0, 1, 0),
					TileSize = dim2(0, 6, 0, 6),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = alphaind,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					}
				})
				
				local alpha_picker = library:create("Frame", {
					Parent = alpha_drag,
					Name = "alpha_picker",
					BorderMode = Enum.BorderMode.Inset,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 4, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local hue = library:create("TextButton", {
					Parent = main_holder_background,
					AnchorPoint = vec2(1, 0),
					Name = "hue",
					Position = dim2(1, -1, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 1, -42),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline,
					Text = "",
					AutoButtonColor = false
				})
				
				local outline = library:create("Frame", {
					Parent = hue,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				
				local Frame = library:create("Frame", {
					Parent = outline,
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = Frame,
					Rotation = 270,
					Color = rgbseq{
						rgbkey(0, rgb(255, 0, 0)),
						rgbkey(0.17000000178813934, rgb(255, 255, 0)),
						rgbkey(0.33000001311302185, rgb(0, 255, 0)),
						rgbkey(0.5, rgb(0, 255, 255)),
						rgbkey(0.6700000166893005, rgb(0, 0, 255)),
						rgbkey(0.8299999833106995, rgb(255, 0, 255)),
						rgbkey(1, rgb(255, 0, 0))
					}
				}) 
				
				local hue_picker = library:create("Frame", {
					Parent = Frame,
					Name = "hue_picker",
					BorderMode = Enum.BorderMode.Inset,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 4),
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local visualize = library:create("Frame", {
					Parent = main_holder_background,
					AnchorPoint = vec2(1, 1),
					Name = "visualize",
					Position = dim2(1, -1, 1, -1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 14, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(visualize, "inline", "BackgroundColor3") 
				
				local outline = library:create("Frame", {
					Parent = visualize,
					Size = dim2(1, -2, 1, -2),
					Name = "outline",
					Active = true,
					BorderColor3 = rgb(0, 0, 0),
					Position = dim2(0, 1, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				
				local visualize = library:create("Frame", {
					Parent = outline,
					Size = dim2(1, -2, 1, -2),
					Name = "visualize",
					Active = true,
					BorderColor3 = rgb(0, 0, 0),
					Position = dim2(0, 1, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				
				local satval_picker = library:create("Frame", {
					Parent = main_holder_background,
					Name = "satval_picker",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -20, 1, -42),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(satval_picker, "inline", "BackgroundColor3") 
				
				local outline = library:create("Frame", {
					Parent = satval_picker,
					Name = "outline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(outline, "outline", "BackgroundColor3") 
				
				local colorpicker = library:create("Frame", {
					Parent = outline,
					Name = "colorpicker",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(0, 221, 255)
				})
				
				local sat = library:create("TextButton", {
					Parent = colorpicker,
					Name = "sat",
					Size = dim2(1, 0, 1, 0),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = sat,
					Rotation = 270,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					},
					Color = rgbseq{
						rgbkey(0, rgb(0, 0, 0)),
						rgbkey(1, rgb(0, 0, 0))
					}
				})
				
				local val = library:create("TextButton", {
					Parent = colorpicker,
					Name = "val",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					Text = "",
					AutoButtonColor = false,
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = val,
					Transparency = numseq{
						numkey(0, 0),
						numkey(1, 1)
					}
				})
				
				local satval_picker_REAL = library:create("Frame", {
					Parent = colorpicker,
					Name = "satval_picker_REAL",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 2, 0, 2),
					BorderSizePixel = 1,
					BackgroundColor3 = rgb(255, 255, 255),
					ZIndex = 3, 
				})
			-- 
				
			function cfg.set_visible(bool)
				colorpicker_holder.Visible = bool

				if bool then 
					if library.current_element_open and library.current_element_open ~= cfg then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
					end

					library.current_element_open = cfg
					colorpicker_holder.Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 17)
				end
			end 

			colorpicker_button.MouseButton1Click:Connect(function()		
				cfg.open = not cfg.open

				cfg.set_visible(cfg.open) 
			end)

			function cfg.set(color, alpha)
				if color then 
					h, s, v = color:ToHSV()
				end 
			
				if alpha then 
					a = alpha
				end 
			
				local hsv_position = Color3.fromHSV(h, s, v)
				local Color = Color3.fromHSV(h, s, v)
				
				local value = 1 - h
				local offset = (value < 1) and 0 or -4
				hue_picker.Position = dim2(0, 0, value, offset)

				local offset = (a < 1) and 0 or -4
				alpha_picker.Position = dim2(a, offset, 0, 0)

				alpha_drag.BackgroundColor3 = Color3.fromHSV(h, s, v)
				
				visualize.BackgroundColor3 = Color
				handler.BackgroundColor3 = Color 

				colorpicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				
				cfg.color = Color
				cfg.alpha = a
				
				local s_offset = (s < 1) and 0 or -3
				local v_offset = (1 - v < 1) and 0 or -3
				satval_picker_REAL.Position = dim2(s, s_offset, 1 - v, v_offset)

				flags[cfg.flag] = {} 
				flags[cfg.flag]["Color"] = Color
				flags[cfg.flag]["Transparency"] = a

				pcall(function()
					hex_input.Text = string.format("#%02X%02X%02X", math.floor(Color.R * 255 + 0.5), math.floor(Color.G * 255 + 0.5), math.floor(Color.B * 255 + 0.5))
				end)
			
				cfg.callback(Color, a)
			end

			hex_input.FocusLost:Connect(function()
				local raw = hex_input.Text:gsub("#", ""):gsub("^%s+", ""):gsub("%s+$", "")
				if #raw == 6 then
					local r, g, b = tonumber(raw:sub(1,2), 16), tonumber(raw:sub(3,4), 16), tonumber(raw:sub(5,6), 16)
					if r and g and b then
						cfg.set(Color3.fromRGB(r, g, b), nil)
						return
					end
				elseif #raw == 3 then
					local r, g, b = tonumber(raw:sub(1,1):rep(2), 16), tonumber(raw:sub(2,2):rep(2), 16), tonumber(raw:sub(3,3):rep(2), 16)
					if r and g and b then
						cfg.set(Color3.fromRGB(r, g, b), nil)
						return
					end
				end
				cfg.set(nil, nil)
			end)

			function cfg.update_color() 
				local mouse = uis:GetMouseLocation() 

				if dragging_sat then	
					s = math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - val.AbsolutePosition).X / val.AbsoluteSize.X, 0, 1)
					v = 1 - math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - sat.AbsolutePosition).Y / sat.AbsoluteSize.Y, 0, 1)
				elseif dragging_hue then 
					h = math.clamp(1 - (vec2(mouse.X, mouse.Y - gui_offset) - hue.AbsolutePosition).Y / hue.AbsoluteSize.Y, 0, 1)
				elseif dragging_alpha then 
					a = math.clamp((vec2(mouse.X, mouse.Y - gui_offset) - alpha.AbsolutePosition).X / alpha.AbsoluteSize.X, 0, 1)
				end

				cfg.set(nil, nil)
			end
			
			alpha.MouseButton1Down:Connect(function()
				dragging_alpha = true 
			end)

			hue.MouseButton1Down:Connect(function()
				dragging_hue = true 
			end)

			sat.MouseButton1Down:Connect(function()
				dragging_sat = true  
			end)

			uis.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging_sat = false
					dragging_hue = false
					dragging_alpha = false 
				end
			end)

			uis.InputChanged:Connect(function(input)
				if (dragging_sat or dragging_hue or dragging_alpha) and input.UserInputType == Enum.UserInputType.MouseMovement then
					cfg.update_color() 
				end
			end)	

			task.spawn(function()
				while true do 
					task.wait()
					if flags[cfg.flag .. "_RAINBOW_FLAG"] then 
						cfg.set(
							hsv(math.abs(math.sin(tick())), 
							s, 
							v
						), a) 
					end     
				end     
			end)

			cfg.set(cfg.color, cfg.alpha)

			library.config_flags[cfg.flag] = cfg.set
		
			return setmetatable(cfg, library) 
		end

		function library:keybind(options)
			local parent = self.right_holder

			local cfg = {
				flag = options.flag or "SET ME A FLAG NOWWW!!!!",
				callback = options.callback or function() end,
				open = false,
				binding = nil, 
				name = options.name or nil, 
				ignore_key = options.ignore or false, 

				key = options.key or nil, 
				mode = options.mode or "toggle",
				active = options.default or false, 

				hold_instances = {},
			}

			flags[cfg.flag] = {} 
			
			local KEYBIND_ELEMENT;
			if cfg.name then 
				KEYBIND_ELEMENT = library:create("TextLabel", {
					Parent = library.keybind_list,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "[ Hold ]  Fly - X",
					Size = dim2(1, -10, 0, 18),
					Visible = false, 
					Position = dim2(0, 5, 0, -1),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.None,
					TextWrapped = true,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = themes.preset.text
				}, "text")
			end 

			local element_outline = library:create("TextButton", {
				Parent = parent,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Text = "", 
				Size = dim2(0, 24, 0, 14),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(element_outline, "outline", "BackgroundColor3")

			library:create("UIPadding", {
				Parent = element_outline,
				PaddingRight = dim(0, 2),
			})

			local instance = library:hoverify(element_outline, element_outline)
			instance.Size = dim2(1, 2, 1, 0)

			local inline = library:create("Frame", {
				Parent = element_outline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = dim2(1, -2, 1, -2),
				ZIndex = 2;
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3") 

			library:create("UIPadding", {
				Parent = inline,
				PaddingRight = dim(0, 2),
			})
			
			local handler = library:create("Frame", {
				Parent = inline,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local UIGradient = library:create("UIGradient", {
				Parent = handler,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			}); library:apply_theme(UIGradient, "contrast", "Color") 
			
			local key_text = library:create("TextLabel", {
				Parent = handler,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2;
				Text = "b",
				Size = dim2(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = key_text,
				PaddingLeft = dim(0, 3),
				PaddingRight = dim(0, 2),
			})
			
				local keybind_selector = library:create("Frame", {
					Parent = sgui,
					Name = "",
					Position = dim2(0, element_outline.AbsolutePosition.X + 1, 0, element_outline.AbsolutePosition.Y + 17),
					BorderColor3 = rgb(255, 255, 255),
					BorderSizePixel = 2,
					Visible = false, 
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = keybind_selector,
					Name = "",
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 2)
				})
				
				local hold_button = library:create("TextButton", {
					Parent = keybind_selector,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "hold",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = hold_button,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				library:create("UIPadding", {
					Parent = keybind_selector,
					Name = "",
					PaddingTop = dim(0, 3),
					PaddingBottom = dim(0, 5),
					PaddingRight = dim(0, 5),
					PaddingLeft = dim(0, 5)
				})
				
				local toggle_button = library:create("TextButton", {
					Parent = keybind_selector,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "toggle",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = toggle_button,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local always_button = library:create("TextButton", {
					Parent = keybind_selector,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "always",
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = always_button,
					Name = "",
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = keybind_selector,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color")
				
				local UIStroke = library:create("UIStroke", {
					Parent = keybind_selector,
					Name = "",
					Color = themes.preset.inline,
					LineJoinMode = Enum.LineJoinMode.Miter,
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				})
			-- 

			-- init 
				function cfg.set_visible(bool)
					keybind_selector.Visible = bool
					keybind_selector.Position = dim2(0, element_outline.AbsolutePosition.X + 1, 0, element_outline.AbsolutePosition.Y + 17)

					if bool then 
						if library.current_element_open and library.current_element_open ~= cfg then 
							library.current_element_open.set_visible(false)
							library.current_element_open.open = false 
						end

						library.current_element_open = cfg 
					end
				end 

				function cfg.set_mode(mode) 
					cfg.mode = mode 

					if mode == "always" then
						cfg.set(true)
					elseif mode == "hold" then
						cfg.set(false)
					end

					flags[cfg.flag]["mode"] = mode
				end 

				function cfg.set(input)
					if type(input) == "boolean" then 
						local __cached = input 

						if cfg.mode == "always" then 
							__cached = true 
						end 

						cfg.active = __cached 
						flags[cfg.flag]["active"] = __cached 
						cfg.callback(__cached)
					elseif tostring(input):find("Enum") then 
						input = input.Name == "Escape" and "none" or input
						
						cfg.key = input or "none"	

						local _text = keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")
						local _text2 = (tostring(_text):gsub("KeyCode.", ""):gsub("UserInputType.", "")) or "none"
						cfg.key_name = _text2

						flags[cfg.flag]["mode"] = cfg.mode 
						flags[cfg.flag]["key"] = cfg.key 

						key_text.Text = (_text2 and _text2 ~= "none") and string.lower(_text2) or "Set"

						cfg.callback(cfg.active or false)
					elseif find({"toggle", "hold", "always"}, input) then 
						cfg.set_mode(input)

						if input == "always" then 
							cfg.active = true 
						end 

						cfg.callback(cfg.active or false)
					elseif type(input) == "table" then 
						input.key = type(input.key) == "string" and input.key ~= "none" and library:convert_enum(input.key) or input.key

						input.key = input.key == Enum.KeyCode.Escape and "none" or input.key
						cfg.key = input.key or "none"
						
						cfg.mode = input.mode or "toggle"

						if input.active ~= nil then
							cfg.active = input.active
						end

						local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
						local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
						
						key_text.Text = (__text and __text ~= "none") and string.lower(__text) or "Set"
						cfg.key_name = __text
					end 

					flags[cfg.flag] = {
						mode = cfg.mode,
						key = cfg.key, 
						active = cfg.active
					}
					
					if cfg.name and KEYBIND_ELEMENT and KEYBIND_ELEMENT.Parent then 
						local keySet = (cfg.key and tostring(cfg.key) ~= "none")
						KEYBIND_ELEMENT.Visible = keySet
						KEYBIND_ELEMENT.TextTransparency = 0
						KEYBIND_ELEMENT.TextColor3 = cfg.active and themes.preset.accent or themes.preset.text
						local stroke = KEYBIND_ELEMENT:FindFirstChildOfClass("UIStroke")
						if stroke then stroke.Transparency = 0 stroke.Color = themes.preset.text_outline end
						local text = tostring(cfg.key) ~= "Enums" and (keys[cfg.key] or tostring(cfg.key):gsub("Enum.", "")) or nil
						local __text = text and (tostring(text):gsub("KeyCode.", ""):gsub("UserInputType.", ""))
						KEYBIND_ELEMENT.Text = "[ " .. string.upper(string.sub(cfg.mode, 1, 1)) .. string.sub(cfg.mode, 2) .. " ] " .. cfg.name .. " - " .. (__text or "none")
					end
				end


				hold_button.MouseButton1Click:Connect(function()
					cfg.set_mode("hold") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 

				toggle_button.MouseButton1Click:Connect(function()
					cfg.set_mode("toggle") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 

				always_button.MouseButton1Click:Connect(function()
					cfg.set_mode("always") 
					cfg.set_visible(false)
					cfg.open = false 
				end) 
				
				element_outline.MouseButton2Click:Connect(function()
					cfg.open = not cfg.open 

					cfg.set_visible(cfg.open)
				end)

				element_outline.MouseButton1Down:Connect(function()
					task.wait()
					key_text.Text = "..."	

					if cfg.binding then return end 

					cfg.binding = library:connection(uis.InputBegan, function(input, game_event)  
						local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

						cfg.set(selected_key)

						cfg.binding:Disconnect() 
						cfg.binding = nil
					end)
				end)

				library:connection(uis.InputBegan, function(input, game_event) 
					local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType

					if not game_event then 
						if selected_key == cfg.key then 
							if cfg.mode == "toggle" then 
								cfg.active = not cfg.active
								cfg.set(cfg.active)
							elseif cfg.mode == "hold" then 
								cfg.set(true)
							end
						end
					end
				end)

				library:connection(uis.InputEnded, function(input, game_event) 
					if game_event then 
						return 
					end 

					local selected_key = input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
		
					if selected_key == cfg.key then
						if cfg.mode == "hold" then 
							cfg.set(false)
						end
					end
				end)
		
				cfg.set({mode = cfg.mode, active = cfg.active, key = cfg.key})
		
				library.config_flags[cfg.flag] = cfg.set
			-- 
			
			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library) 
		end 

		function library:dropdown(options)
			local parent = self.holder 

			local cfg = {
				name = options.name or nil,
				flag = options.flag or tostring(random(1,9999999)),

				items = options.items or {"1", "2", "3"},
				callback = options.callback or function() end,
				multi = options.multi or false, 
				visible = options.visible or true,

				open = false, 
				option_instances = {}, 
				multi_items = {}, 
				scrolling = options.scrolling or false, 
				ignore = options.ignore or nil,
			}

			cfg.default = options.default or (cfg.multi and {cfg.items[1]}) or cfg.items[1] or nil

				local dropdown_REAL = library:create("TextLabel", {
					Parent = parent,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Name = "dropdown",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local main_text      
				if cfg.name then 
					local left_components = library:create("Frame", {
						Parent = dropdown_REAL,
						Name = "left_components",
						BackgroundTransparency = 1,
						Position = dim2(0, 2, 0, -1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(0, 0, 0, 14),
						AutomaticSize = Enum.AutomaticSize.X,
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					cfg["left_holder"] = left_components

					main_text = library:create("TextLabel", {
						Parent = left_components,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Text = cfg.name,
						Name = "text",
						BackgroundTransparency = 1,
						Size = dim2(0, 0, 1, -1),
						BorderSizePixel = 0,
						AutomaticSize = Enum.AutomaticSize.X,
						TextSize = 12,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					
					library:create("UIStroke", {
						Parent = main_text,
						LineJoinMode = Enum.LineJoinMode.Miter
					})
					
					library:create("UIListLayout", {
						Parent = left_components,
						Padding = dim(0, 5),
						Name = "_",
						FillDirection = Enum.FillDirection.Horizontal
					})

					local right_components = library:create("Frame", {
						Parent = dropdown_REAL,
						Name = "right_components",
						Position = dim2(1, -1, 0, 1),
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(0, 0, 0, 12),
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255)
					})
					cfg["right_holder"] = right_components
		
					local list = library:create("UIListLayout", {
						Parent = right_components,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						Padding = dim(0, 4),
						Name = "list",
						SortOrder = Enum.SortOrder.LayoutOrder
					})
				end 

				local bottom_components = library:create("Frame", {
					Parent = dropdown_REAL,
					Name = "bottom_components",
					Position = dim2(0, 0, 0, cfg.name and 15 or 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local dropdown = library:create("TextButton", {
					Parent = bottom_components,
					Name = "dropdown",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					Text = "",
					AutoButtonColor = false, 
				}) library:apply_theme(dropdown, "outline", "BackgroundColor3") 
				
				library:hoverify(dropdown_REAL, dropdown)

				local inline = library:create("Frame", {
					Parent = dropdown,
					Name = "inline",
					ZIndex = 2;
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "background",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					ZIndex = 2;
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(background, "accent", "BackgroundColor3") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "contrast",
					ZIndex = 2;
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local plus = library:create("TextLabel", {
					Parent = contrast,
					TextWrapped = true,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2;
					Text = "+",
					Name = "plus",
					Size = dim2(1, -4, 1, 0),
					Position = dim2(0, 0, 0, -1),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Right,
					FontFace = library.font,
					TextTruncate = Enum.TextTruncate.AtEnd,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = plus,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local text = library:create("TextLabel", {
					Parent = contrast,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					ZIndex = 2;
					BorderColor3 = rgb(0, 0, 0),
					Text = "aa",
					Name = "text",
					Size = dim2(1, -4, 1, 0),
					Position = dim2(0, 4, 0, -1),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Padding = dim(0, 10),
					Name = "_",
					SortOrder = Enum.SortOrder.LayoutOrder
				})     
			--

				local dropdown_holder = library:create("Frame", {
					Parent = sgui,
					BorderColor3 = rgb(0, 0, 0),
					Name = "dropdown_holder",
					BackgroundTransparency = 1,
					Position = dim2(0, dropdown.AbsolutePosition.X + 1, 0, dropdown.AbsolutePosition.Y + 22),
					Size = dim2(0, dropdown.AbsoluteSize.X, 0, cfg.scrolling and 180 or 0),
					BorderSizePixel = 0,
					AutomaticSize = cfg.scrolling and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.outline,
					Visible = false
				})
				
				local inline = library:create("Frame", {
					Parent = dropdown_holder,
					Size = dim2(1, -2, 1, 2),
					Name = "inline",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background; 
				if not cfg.scrolling then 
					background = library:create("Frame", {
						Parent = inline,
						BorderColor3 = rgb(0, 0, 0),
						Name = "background",
						BackgroundTransparency = 1,
						Position = dim2(0, 1, 0, 1),
						Size = dim2(1, -2, 1, 1),
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent
					})
					library:apply_theme(background, "accent", "BackgroundColor3") 
				else 
					background = library:create("ScrollingFrame", {
						Parent = inline,
						BorderColor3 = rgb(0, 0, 0),
						Name = "background",
						BackgroundTransparency = 1,
						MidImage = "rbxassetid://103468666327206",
						TopImage = "rbxassetid://103468666327206",
						BottomImage = "rbxassetid://103468666327206",
						Position = dim2(0, 1, 0, 1),
						Size = dim2(1, -2, 1, 1),
						ZIndex = 2,
						BorderSizePixel = 0,
						BackgroundColor3 = themes.preset.accent,
						CanvasSize = dim2(0, 0, 0, 0),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollBarThickness = 2,
						ScrollBarImageColor3 = themes.preset.accent
					})
					library:apply_theme(background, "accent", "BackgroundColor3") 
					library:apply_theme(background, "accent", "ScrollBarImageColor3") 
				end 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "contrast",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, -3),
					BorderSizePixel = 0,
					ZIndex = 2, 
					BackgroundColor3 = rgb(255, 255, 255),
					AutomaticSize = cfg.scrolling and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
				}); 

				library:create("UIPadding", {
					Parent = contrast,
					PaddingTop = dim(0, 2),
					PaddingBottom = dim(0, 2),
					PaddingRight = dim(0, 0),
					PaddingLeft = dim(0, 4)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
			
				library:create("UIListLayout", {
					Parent = contrast,
					Padding = dim(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local stroke = library:create("UIStroke", {
					Parent = inline,
					Color = themes.preset.outline,
					LineJoinMode = Enum.LineJoinMode.Miter
				}) library:apply_theme(stroke, "outline", "Color") 
			-- 
				
			function cfg.set_element_visible(bool)
				dropdown_REAL.Visible = bool 

				if main_text then 
					main_text.Visible = bool
				end 
			end 

			function cfg.set_visible(bool) 
				library.current_element_open = cfg.ignore or cfg

				dropdown_holder.Visible = bool

				plus.Text = bool and "-" or "+"
				plus.TextSize = bool and 12 or 8

				if bool then 
					if library.current_element_open and library.current_element_open ~= cfg and not cfg.ignore then 
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false 
					end

					dropdown_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, dropdown_holder.Size.Y.Offset)
					dropdown_holder.Position = dim2(0, dropdown.AbsolutePosition.X + 1, 0, dropdown.AbsolutePosition.Y + 22)                    
				end
			end

			function cfg.set(value) 
				local selected = {}
				local is_table = type(value) == "table"

				if cfg.multi and type(cfg.multi_items) ~= "table" then
					cfg.multi_items = {}
				end

				if cfg.multi and is_table then
					cfg.multi_items = value
				end

				for _,v in next, cfg.option_instances do 
					if v.Text == value or (is_table and find(value, v.Text)) then 
						insert(selected, v.Text)
						v.TextColor3 = themes.preset.accent
					else 
						v.TextColor3 = themes.preset.text
					end
				end

				if #selected > 0 then
					text.Text = is_table and concat(selected, ", ") or selected[1]
					flags[cfg.flag] = is_table and selected or selected[1]
					if cfg.multi then cfg.multi_items = selected end
				else
					if is_table and #value > 0 then
						text.Text = concat(value, ", ")
					elseif type(value) == "string" and value ~= "" then
						text.Text = value
					else
						text.Text = ""
					end
					flags[cfg.flag] = value
				end
				
				cfg.callback(flags[cfg.flag]) 
			end
			
			function cfg:refresh_options(refreshed_list) 
				for _, v in next, cfg.option_instances do 
					v:Destroy() 
				end

				cfg.option_instances = {} 

				for i,v in next, refreshed_list do 
					local TextButton = library:create("TextButton", {
						Parent = contrast,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 2, 
						Text = v,
						BackgroundColor3 = rgb(255, 255, 255)
					}) library:apply_theme(TextButton, "accent", "TextColor3") 
					
					library:create("UIStroke", {
						Parent = TextButton,
						LineJoinMode = Enum.LineJoinMode.Miter
					})

					insert(cfg.option_instances, TextButton)

					TextButton.MouseButton1Down:Connect(function()
						if cfg.multi then 
							local selected_index = find(cfg.multi_items, TextButton.Text)

							if selected_index then 
								remove(cfg.multi_items, selected_index)
							else
								insert(cfg.multi_items, TextButton.Text)
							end

							cfg.set(cfg.multi_items) 				
						else 
							cfg.set_visible(false)
							cfg.open = false 

							cfg.set(TextButton.Text)
						end
					end)
				end
				
				if flags[cfg.flag] ~= nil then
					cfg.set(flags[cfg.flag])
				end
			end

			dropdown.MouseButton1Click:Connect(function()
				cfg.open = not cfg.open 

				cfg.set_visible(cfg.open)

				-- round 6: single-select dropdowns highlight the
				-- selected option like the multi dropdowns do -
				-- re-apply the accent every open so it can never
				-- go stale (theme passes repaint these instances)
				if cfg.open then
					local value = flags[cfg.flag]
					if value ~= nil then
						local is_table = type(value) == "table"
						for _, v in next, cfg.option_instances do
							if v.Text == value or (is_table and find(value, v.Text)) then
								v.TextColor3 = themes.preset.accent
							else
								v.TextColor3 = themes.preset.text
							end
						end
					end
				end
			end)

			cfg:refresh_options(cfg.items) 

			cfg.set(cfg.default)
			
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			cfg.set_element_visible(cfg.visible)

			return setmetatable(cfg, library)
		end 

		function library:list(options)
			local cfg = {
				callback = options and options.callback or function() end, 

				scale = options.size or 232, 
				items = options.items or {"1", "2", "3"}, 
				placeholdertext = options.placeholder or options.placeholdertext or "search here...",
				visible = options.visible or true,

				option_instances = {}, 
				current_instance = nil, 
				flag = options.flag or "SET A FLAG U NIGGER", 

			} 

			-- instances 
				local list_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = list_holder,
					Name = "",
					PaddingLeft = dim(0, 1)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = list_holder,
					Name = ""
				})
				
				local bottom_components = library:create("Frame", {
					Parent = list_holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Name = "",
					Padding = dim(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local list = library:create("Frame", {
					Parent = bottom_components,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, cfg.scale),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder, "outline", "BackgroundColor3") 
				
				local inline = library:create("Frame", {
					Parent = list,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				}) library:apply_theme(background, "accent", "BackgroundColor3") 
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}) library:apply_theme(UIGradient, "contrast", "Color") 
				
				local ScrollingFrame = library:create("ScrollingFrame", {
					Parent = contrast,
					Name = "",
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
				
				local UIPadding = library:create("UIPadding", {
					Parent = ScrollingFrame,
					Name = "",
					PaddingBottom = dim(0, 4),
					PaddingTop = dim(0, 4)
				})
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = ScrollingFrame,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			--  

			function cfg.render_option(text) 
				local TextButton = library:create("TextButton", {
					Parent = ScrollingFrame,
					Name = "",
					Text = tostring(text),
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:apply_theme(TextButton, "accent", "TextColor3") 

				local UIStroke = library:create("UIStroke", {
					Parent = TextButton,
					Name = ""
				})

				return TextButton 
			end 

			function cfg.set_element_visible(bool)
				list_holder.Visible = bool 
			end

			function cfg.refresh_options(options) 
				if type(options) == "function" then 
					return 
				end 

				for _, v in next, cfg.option_instances do 
					v:Destroy() 
				end 

				for _, option in next, options do 
					local button = cfg.render_option(option) 

					insert(cfg.option_instances, button)

					button.MouseButton1Click:Connect(function()
						if cfg.current_instance and cfg.current_instance ~= button then 
							cfg.current_instance.TextColor3 = themes.preset.text 
						end 

						cfg.current_instance = button 
						button.TextColor3 = themes.preset.accent 

						flags[cfg.flag] = button.text
						
						cfg.callback(button.text)
					end)
				end 
			end     

			function cfg.filter_options(text)
				for _, v in next, cfg.option_instances do 
					if string.find(v.Text, text) then 
						v.Visible = true 
					else 
						v.Visible = false
					end
				end
			end 

			function cfg.set(value)
				for _, buttons in next, cfg.option_instances do 
					if buttons.Text == value then 
						buttons.TextColor3 = themes.preset.accent 
					else 
						buttons.TextColor3 = themes.preset.text 
					end 
				end 

				flags[cfg.flag] = value
				cfg.callback(value)
			end 

			cfg.refresh_options(cfg.items) 
			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible
			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library)
		end 

		function library:textbox(options)
			local cfg = {
				placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
				default = options.default,
				flag = options.flag or "SET ME NIGGA",
				callback = options.callback or function() end,
				visible = options.visible or true,
			}
			
			-- instances 
				local textbox_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIPadding", {
					Parent = textbox_holder,
					Name = "",
					PaddingLeft = dim(0, 1)
				})
				
				library:create("UIStroke", {
					Parent = textbox_holder,
					Name = ""
				})
				
				local button = library:create("Frame", {
					Parent = textbox_holder,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 0, 18),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})
				library:hoverify(textbox_holder, button)
				
				library:apply_theme(button, "outline", "BackgroundColor3") 
				
				local inline = library:create("Frame", {
					Parent = button,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					ZIndex = 2;
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				})
				
				library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 2;
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				
				library:apply_theme(background, "accent", "BackgroundColor3") 
				
				local TextBox = library:create("TextBox", {
					Parent = background,
					Name = "",
					CursorPosition = -1,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "", 
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextWrapped = true,
					BackgroundTransparency = 1,
					TextTruncate = Enum.TextTruncate.SplitWord,
					PlaceholderText = "Type here...",
					ClearTextOnFocus = false,
					ZIndex = 3;
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIStroke", {
					Parent = TextBox,
					Name = ""
				})
				
				local TextButton = library:create("TextButton", {
					Parent = background,
					Name = "",
					FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
					TextColor3 = rgb(0, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					AutoButtonColor = false,
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 14,
					ZIndex = 2;
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = TextButton,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(41, 41, 55)),
						rgbkey(1, rgb(35, 35, 47))
					}
				})
				
				library:apply_theme(UIGradient, "contrast", "Color") 
				
				library:create("UIListLayout", {
					Parent = textbox_holder,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
					
				TextBox:GetPropertyChangedSignal("Text"):Connect(function()
					flags[cfg.flag] = TextBox.text
					cfg.callback(TextBox.text)
				end)
				
				TextBox.FocusLost:Connect(function(enterPressed)
					if cfg.focus_lost then
						cfg.focus_lost(TextBox.Text, enterPressed)
					end
				end)
			-- 

			function cfg.set_element_visible(bool)
				textbox_holder.Visible = bool 
			end

			function cfg.set(text) 
				flags[cfg.flag] = text
				TextBox.Text = text
				cfg.callback(text)
			end 

			if cfg.default then 
				cfg.set(cfg.default) 
			end 

			cfg.set_element_visible(cfg.visible)

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library) 
		end 

		function library:button_holder(options) 
			local cfg = {
				flag = options.flag or "hi", 
				visible = options.visible or true,
			}

			local button_holder = library:create("TextLabel", {
				Parent = self.holder,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255), 
			})

			self.current_holder = button_holder

			-- instances 
				library:create("UIStroke", {
					Parent = button_holder,
					Name = ""
				})
				
				library:create("UIListLayout", {
					Parent = button_holder,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					Padding = dim(0, 5),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 
			
			function cfg.set_element_visible(bool)
				button_holder.Visible = bool 
			end

			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end 

		function library:button(options)
			local cfg = {
				callback = options.callback or function() end, 
				name = options.text or options.name or "Button",
			}   

			local button = library:create("TextButton", {
				Parent = self.current_holder,
				Name = "",
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 0, 18),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = ""
			})

			library:hoverify(button, button)
			
			library:apply_theme(button, "outline", "BackgroundColor3") 
			
			local inline = library:create("Frame", {
				Parent = button,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})
			
			library:apply_theme(inline, "inline", "BackgroundColor3") 
			
			local background = library:create("Frame", {
				Parent = inline,
				Name = "",
				ZIndex = 2;
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})
			
			library:apply_theme(background, "accent", "BackgroundColor3") 
			
			local _UIGradient = library:create("UIGradient", {
				Parent = background,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				}
			})
			
			library:apply_theme(_UIGradient, "contrast", "Color") 
			
			local contrast = library:create("Frame", {
				Parent = background,
				Name = "",
				ZIndex = 2;
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIGradient = library:create("UIGradient", {
				Parent = contrast,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			})
			
			library:apply_theme(UIGradient, "contrast", "Color") 
			
			local text = library:create("TextLabel", {
				Parent = contrast,
				Name = "",
				TextWrapped = false, 
				ZIndex = 2;
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Size = dim2(1, -4, 1, 0),
				Position = dim2(0, 0, 0, -1),
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextXAlignment = Enum.TextXAlignment.Center,
				BorderSizePixel = 0,
				FontFace = library.font,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIStroke = library:create("UIStroke", {
				Parent = text,
				Name = "",
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			button.MouseButton1Click:Connect(function()
				cfg.callback() 
			end)

			cfg._textInstance = text

			function cfg.set_name(newName, color)
				cfg.name = newName
				if cfg._textInstance and cfg._textInstance.Parent then
					cfg._textInstance.Text = newName
					if color then
						cfg._textInstance.TextColor3 = color
					elseif newName:sub(-1) == "?" then
						cfg._textInstance.TextColor3 = rgb(255, 0, 0)
					else
						cfg._textInstance.TextColor3 = themes.preset.text
					end
				end
			end

			return setmetatable(cfg, library)
		end 

		function library:label(options)
			local cfg = {name = options.text or options.name or "Label"}

			local dropdown = library:create("TextLabel", {
				Parent = self.holder,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local UIStroke = library:create("UIStroke", {
				Parent = dropdown,
				Name = ""
			})
			
			local left_components = library:create("Frame", {
				Parent = dropdown,
				Name = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 2, 0, -1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			
			local TextLabel = library:create("TextLabel", {
				Parent = left_components,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local right_components = library:create("Frame", {
				Parent = dropdown,
				Name = "right_components",
				Position = dim2(1, -1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			}) cfg.right_holder = right_components

			local list = library:create("UIListLayout", {
				Parent = right_components,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = dim(0, 4),
				Name = "list",
				SortOrder = Enum.SortOrder.LayoutOrder
			})
			
			local UIStroke = library:create("UIStroke", {
				Parent = TextLabel,
				Name = ""
			})

			function cfg.set(text) 
				TextLabel.Text = text 
			end 
						
			return setmetatable(cfg, library)   
		end 

		function library:playerlist(options) 
			local cfg = {
				callback = options.callback or function() end, 

				labels = {
					name,
					display, 
					uid, 
				}
			}

			local selected_button; 

			local patterns = {
				["Priority"] = rgb(255, 255, 0),
				["Enemy"] = rgb(255, 0, 0),
				["Neutral"] = themes.preset.text,
				["Friendly"] = hex("23ff0a")
			}

				local playerlist_holder = library:create("TextLabel", {
					Parent = self.holder,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					ZIndex = 2,
					Size = dim2(1, -8, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255),
					LayoutOrder = 0
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = playerlist_holder,
					Name = "",
					PaddingBottom = dim(0, -2),
					PaddingLeft = dim(0, 1)
				})
				
				local UIStroke = library:create("UIStroke", {
					Parent = playerlist_holder,
					Name = ""
				})
				
				local bottom_components = library:create("Frame", {
					Parent = playerlist_holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 26, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				library:create("UIListLayout", {
					Parent = bottom_components,
					Name = "",
					Padding = dim(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
				
				local list = library:create("Frame", {
					Parent = bottom_components,
					Name = "",
					Position = dim2(0, 0, 0, 2),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -27, 1, 232),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(list, "outline", "BackgroundColor3") 
				
				local inline = library:create("Frame", {
					Parent = list,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.inline
				}) library:apply_theme(inline, "inline", "BackgroundColor3") 
				
				local background = library:create("Frame", {
					Parent = inline,
					Name = "",
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = background,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(167, 167, 167))
					}
				}); library:apply_theme(UIGradient, "contrast", "Color") 
				
				local contrast = library:create("Frame", {
					Parent = background,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				
				local UIGradient = library:create("UIGradient", {
					Parent = contrast,
					Name = "",
					Rotation = 90,
					Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
				}); library:apply_theme(UIGradient, "contrast", "Color") 
				
				local ScrollingFrame = library:create("ScrollingFrame", {
					Parent = contrast,
					Name = "",
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = "rbxassetid://103468666327206",
					TopImage = "rbxassetid://103468666327206",
					BottomImage = "rbxassetid://103468666327206",
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 1, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(ScrollingFrame, "accent", "ScrollBarImageColor3") 
				
				local UIPadding = library:create("UIPadding", {
					Parent = ScrollingFrame,
					Name = "",
					PaddingTop = dim(0, 4),
					PaddingBottom = dim(0, 4),
					PaddingRight = dim(0, 4),
					PaddingLeft = dim(0, 4)
				})
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = ScrollingFrame,
					Name = "",
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			-- 

			local team_colors = { inmates = rgb(255, 200, 100), guards = rgb(100, 150, 255), criminals = rgb(255, 100, 100), prisoners = rgb(255, 200, 100) }
			local function get_team_color(playerObj)
				if not playerObj or not playerObj.Team or not playerObj.Team.Name then return themes.preset.text end
				local key = playerObj.Team.Name:lower():gsub("%s+", "")
				return team_colors[key] or themes.preset.text
			end
			local function get_team_sort_order(playerObj)
				if not playerObj or not playerObj.Team or not playerObj.Team.Name then return 3 end
				local key = playerObj.Team.Name:lower():gsub("%s+", "")
				if key == "guards" then return 0
				elseif key == "inmates" or key == "prisoners" then return 1
				elseif key == "criminals" then return 2
				end
				return 3
			end
			local function get_display_color(path)
				if not path then return themes.preset.text end
				if path.priority == "Enemy" and library.flags["ESP_Enemy_Color"] then
					local f = library.flags["ESP_Enemy_Color"]
					return type(f) == "table" and f.Color or f
				end
				if path.priority == "Friendly" and library.flags["ESP_Friendly_Color"] then
					local f = library.flags["ESP_Friendly_Color"]
					return type(f) == "table" and f.Color or f
				end
				if path.priority == "Priority" then
					local f = library.flags["ESP_Priority_Color"]
					return f and (type(f) == "table" and f.Color or f) or patterns["Priority"]
				end
				return path.team_color or themes.preset.text
			end
			function cfg.create_player(player) 
				library.playerlist_data[tostring(player)] = {}
				local path = library.playerlist_data[tostring(player)]
				local playerObj = typeof(player) == "Instance" and player or players:FindFirstChild(tostring(player))
				local nameStr = tostring(player)
				local teamColor = get_team_color(playerObj)
				if nameStr == lp.Name then teamColor = rgb(255, 255, 255) end

				local teamOrder = get_team_sort_order(playerObj)
				local nameSort = (string.byte(nameStr:sub(1, 1)) or 0) * 256 + (string.byte(nameStr:sub(2, 2)) or 0)
				local layoutOrder = (nameStr == lp.Name) and -1000000 or (teamOrder * 100000 + nameSort)
				local TextButton = library:create("TextButton", {
					Parent = ScrollingFrame,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255),
					LayoutOrder = layoutOrder
				})

				local player_name = library:create("TextLabel", {
					Parent = TextButton,
					FontFace = library.font,
					TextColor3 = teamColor,
					BorderColor3 = rgb(0, 0, 0),
					Text = nameStr,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					LayoutOrder = -100, 
					BackgroundColor3 = rgb(255, 255, 255)
				}) 
								
								
				
				local priority_text = library:create("TextLabel", {
					Parent = TextButton,
					Name = "",
					FontFace = library.font,
					TextColor3 = tostring(player) ~= lp.Name and themes.preset.text or rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					Text = tostring(player) ~= lp.Name and "Neutral" or "LocalPlayer",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local Frame = library:create("Frame", {
					Parent = priority_text,
					Name = "",
					Position = dim2(0, -10, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 1, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(main_holder, "outline", "BackgroundColor3") 
				
				local UIListLayout = library:create("UIListLayout", {
					Parent = TextButton,
					Name = "",
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})
				
				local UIPadding = library:create("UIPadding", {
					Parent = TextButton,
					Name = "",
					PaddingRight = dim(0, 2),
					PaddingLeft = dim(0, 2)
				})

				local line = library:create("Frame", {
					Parent = ScrollingFrame,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline,
					LayoutOrder = layoutOrder + 0.5
				}) library:apply_theme(main_holder, "outline", "BackgroundColor3") 

				path.instance = TextButton 
				path.line = line 
				path.priority = "Neutral"
				path.priority_text = priority_text
				path.player_name = player_name
				path.team_color = teamColor
				if playerObj then
					playerObj:GetPropertyChangedSignal("Team"):Connect(function()
						if nameStr == lp.Name then return end
						local newColor = get_team_color(playerObj)
						path.team_color = newColor
						if selected_button ~= player_name then
							player_name.TextColor3 = newColor
						end
						local newOrder = get_team_sort_order(playerObj)
						local newNameSort = (string.byte(nameStr:sub(1, 1)) or 0) * 256 + (string.byte(nameStr:sub(2, 2)) or 0)
						local newLayoutOrder = newOrder * 100000 + newNameSort
						TextButton.LayoutOrder = newLayoutOrder
						line.LayoutOrder = newLayoutOrder + 0.5
					end)
				end
				
				if nameStr ~= lp.Name then
				TextButton.MouseButton1Click:Connect(function()
					local oldSelected = library.selected_player
					if oldSelected then
						local oldPath = library.playerlist_data[oldSelected]
						if oldPath and oldPath.player_name then
							oldPath.player_name.TextColor3 = get_display_color(oldPath)
						end
					end
					selected_button = nil 

					selected_button = player_name 
					player_name.TextColor3 = themes.preset.accent 

					library.selected_player = player_name.Text
					
					if path.priority_text.Text ~= "LocalPlayer" then
						library.config_flags["PLAYERLIST_DROPDOWN"](path.priority_text.Text)
					end

					if cfg.selected_icon and players[player_name.Text] then
						cfg.selected_icon.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", players[player_name.Text].UserId)
					end
					if cfg.labels.name then 
						cfg.labels.name.set("User: " .. player_name.Text)
						cfg.labels.display.set("DisplayName: " .. players[player_name.Text].DisplayName)
						cfg.labels.uid.set("User Id: " .. players[player_name.Text].UserId)
					end
					if cfg.labels.team then
						local p = players[player_name.Text]
						local teamDisplay = "Team: --"
						local teamColor = themes.preset.text
						if p and p.Team and p.Team.Name then
							local key = p.Team.Name:lower():gsub("%s+", "")
							teamDisplay = (key == "guards" and "Team: Guard") or (key == "inmates" or key == "prisoners") and "Team: Inmate" or (key == "criminals" and "Team: Criminal") or ("Team: " .. p.Team.Name)
							teamColor = path.team_color
						end
						cfg.labels.team.set(teamDisplay, teamColor)
					end
				end)
			end

				return path 
			end 

			function cfg.search(text)
				for _, player in next, players:GetPlayers() do 
					local name = tostring(player)
					local path = library.playerlist_data[name]

					if path then 
						local sanity = string.lower(name):match(string.lower(text)) and true or false
						path.instance.Visible = sanity
						path.line.Visible = sanity
					end 
				end 
			end 

			function cfg.remove_player(player) 
				local path = library.playerlist_data[tostring(player)]
				path.instance:Destroy() 
				path.line:Destroy() 
				path = nil 
			end 

			function library.prioritize(text) 
				if not library.selected_player or not text then 
					return 
				end 
				if library.selected_player == lp.Name then return end
				local path = library.playerlist_data[library.selected_player]
				path.priority_text.Text = text
				path.priority_text.TextColor3 = patterns[text] or themes.preset.text
				path.priority = text
				if path.player_name and library.selected_player and selected_button ~= path.player_name then
					path.player_name.TextColor3 = get_display_color(path)
				end
			end 

			function library.set_priority_for_player(playerName, text)
				local path = library.playerlist_data[playerName]
				if path and patterns[text] then
					path.priority = text
					path.priority_text.Text = text
					path.priority_text.TextColor3 = patterns[text]
					if path.player_name then
						path.player_name.TextColor3 = get_display_color(path)
					end
				end
			end

			function library.get_priority(player) 
				local path = library.playerlist_data[tostring(player)]

				if path then 
					return path.priority
				end 
			end 

			players.PlayerAdded:Connect(cfg.create_player)
			players.PlayerRemoving:Connect(cfg.remove_player)
			
			for _, player in players:GetPlayers() do 
				local player_object = cfg.create_player(player.Name)
				insert(library.playerlist_data, player_object)
			end 

			task.spawn(function()
				task.wait(0.5)
				if library.playerlist_data[lp.Name] then
					local path = library.playerlist_data[lp.Name]
					library.selected_player = lp.Name
					path.player_name.TextColor3 = themes.preset.accent
					if cfg.labels.name then 
						cfg.labels.name.set("User: " .. lp.Name)
						cfg.labels.display.set("DisplayName: " .. lp.DisplayName)
						cfg.labels.uid.set("User Id: " .. lp.UserId)
					end
					if cfg.labels.team then
						local teamDisplay = "Team: --"
						local teamColor = get_team_color(lp) or themes.preset.text
						if lp.Team and lp.Team.Name then
							local key = lp.Team.Name:lower():gsub("%s+", "")
							teamDisplay = (key == "guards" and "Team: Guard") or (key == "inmates" or key == "prisoners") and "Team: Inmate" or (key == "criminals" and "Team: Criminal") or ("Team: " .. lp.Team.Name)
						end
						cfg.labels.team.set(teamDisplay, teamColor)
					end
					if cfg.selected_icon then
						cfg.selected_icon.Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", lp.UserId)
					end
				end
			end)

			self:textbox({name = "Search", callback = function(txt)
				cfg.search(txt)
			end})
		
			local icon_row = library:create("Frame", {
				Parent = self.holder,
				Name = "",
				Size = dim2(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			})
			library:create("UIPadding", {
				Parent = icon_row,
				Name = "",
				PaddingLeft = dim(0, 14)
			})
			library:create("UIListLayout", {
				Parent = icon_row,
				Name = "",
				FillDirection = Enum.FillDirection.Horizontal,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = dim(0, 6),
				SortOrder = Enum.SortOrder.LayoutOrder
			})
		
			local icon_outer_frame = library:create("Frame", {
				Parent = icon_row,
				Name = "",
				Size = dim2(0, 68, 0, 68),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(10, 10, 10),
				BorderColor3 = rgb(0, 0, 0),
				LayoutOrder = 0
			})
			local icon_inner_frame = library:create("Frame", {
				Parent = icon_outer_frame,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(45, 45, 45)
			})
			local icon_inner_frame2 = library:create("Frame", {
				Parent = icon_inner_frame,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			local icon_gradient = library:create("UIGradient", {
				Parent = icon_inner_frame2,
				Name = "",
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(30, 30, 30)),
					rgbkey(1, rgb(20, 20, 20))
				}
			})
			local selected_icon = library:create("ImageLabel", {
				Parent = icon_inner_frame2,
				Name = "",
				Size = dim2(1, 0, 1, 0),
				Position = dim2(0.5, 0, 0.5, 0),
				AnchorPoint = vec2(0.5, 0.5),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Image = "",
				ScaleType = Enum.ScaleType.Fit
			})
			cfg.selected_icon = selected_icon
		
			local info_holder = library:create("Frame", {
				Parent = icon_row,
				Name = "",
				Size = dim2(0, 215, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			})
			library:create("UIListLayout", {
				Parent = info_holder,
				Name = "",
				Padding = dim(0, 1),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			})
			local info_section = setmetatable({ holder = info_holder }, library)
			cfg.labels.name = info_section:label({name = "Name: ??"})
			cfg.labels.display = info_section:label({name = "Display Name: ??"})
			cfg.labels.uid = info_section:label({name = "User Id: ??"})
			local team_label = library:create("TextLabel", {
				Parent = info_holder,
				Name = "",
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "Team: --",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 12,
				LayoutOrder = 4,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.labels.team = {
				set = function(text, color)
					team_label.Text = text or "Team: --"
					if color then team_label.TextColor3 = color end
				end
			}
	
			local actions_holder = library:create("Frame", {
				Parent = icon_row,
				Name = "",
				Size = dim2(1, -305, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 2
			})
			library:create("UIPadding", {
				Parent = actions_holder,
				Name = "",
				PaddingLeft = dim(0, 28)
			})
			library:create("UIListLayout", {
				Parent = actions_holder,
				Name = "",
				Padding = dim(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right
			})
			cfg.actions_holder = actions_holder
			cfg.patterns = patterns
			cfg.refresh_player_colors = function()
				for name, path in pairs(library.playerlist_data) do
					if typeof(path) == "table" and path.player_name and selected_button ~= path.player_name then
						path.player_name.TextColor3 = get_display_color(path)
					end
				end
			end
			library.refresh_player_colors = cfg.refresh_player_colors
			library.patterns = patterns

			return setmetatable(cfg, library)
		end 
	-- 
-- 

return library, themes; 
