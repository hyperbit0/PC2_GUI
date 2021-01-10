local ToolTrayButtons = require(script.Parent.Parent.Parent.Models.GUI.ToolTrayButtons)
local UIS = game:GetService("UserInputService")

local BUILD_KEY = Enum.KeyCode.One
local DELETE_KEY = Enum.KeyCode.Two
local CONFIGURE_KEY = Enum.KeyCode.Three
local MOVE_KEY = Enum.KeyCode.Four
local PAINT_KEY = Enum.KeyCode.Five

local Keybinds = {
	[BUILD_KEY] = ToolTrayButtons.Tools.Build,
	[DELETE_KEY] = ToolTrayButtons.Tools.Delete,
	[CONFIGURE_KEY] = ToolTrayButtons.Tools.Configure,
	[MOVE_KEY] = ToolTrayButtons.Tools.Move,
	[PAINT_KEY] = ToolTrayButtons.Tools.Paint
}

local ToolTrayButtonsController = {}

local function checkEvents()
	if ToolTrayButtons.Tools.Build.Active then
		ToolTrayButtonsController:FireEvent("BuildButton", true)
	else
		ToolTrayButtonsController:FireEvent("BuildButton", false)
	end
end

local function onInput(input)
	if Keybinds[input.KeyCode] then
		Keybinds[input.KeyCode]:onClick()
		checkEvents()
	end
end

local function onToolTrayButtonClick(tool)
	tool.Button.MouseButton1Down:Connect(function()
		tool:onClick()
		checkEvents()
	end)
end

local function onToolTrayButtonMouseEnter(tool)
	tool.Button.MouseEnter:Connect(function()
		tool:onMouseEnter()
	end)
end

local function onToolTrayButtonMouseLeave(tool)
	tool.Button.MouseLeave:Connect(function()
		tool:onMouseLeave()
	end)
end

local function createButtonEffects()
	for _,tool in pairs(ToolTrayButtons.Tools) do
		onToolTrayButtonMouseEnter(tool)
		onToolTrayButtonMouseLeave(tool)
		onToolTrayButtonClick(tool)
	end
end

function ToolTrayButtonsController:Awake()
	ToolTrayButtonsController = self
	ToolTrayButtons = self.Models.ToolTrayButtons
	self:CreateEvent("BuildButton")
end

function ToolTrayButtonsController:Start()
	ToolTrayButtons.New()
	createButtonEffects()
	UIS.InputBegan:Connect(onInput)
	self.Models.ToolTrayButtons:GetPropertyChanged("Something"):Connect(function(_, v)
		print(v)
	end)
end

return ToolTrayButtonsController