local Container = require(script.Parent.BuildGui).Protect.ToolContainer.Tools
local BUILD_BUTTON = Container.BuildButton
local DELETE_BUTTON = Container.DeleteButton
local CONFIGURE_BUTTON = Container.ConfigureButton
local MOVE_BUTTON = Container.MoveButton
local PAINT_BUTTON = Container.PaintButton

local ToolTrayButtons = {}
local Theme

ToolTrayButtons.Tools = {
	Build = {
		Button = BUILD_BUTTON,
		Name = "Build"
	},
	Delete = {
		Button = DELETE_BUTTON,
		Name = "Delete"
	},
	Configure = {
		Button = CONFIGURE_BUTTON,
		Name = "Configure"
	},
	Move = {
		Button = MOVE_BUTTON,
		Name = "Move"
	},
	Paint = {
		Button = PAINT_BUTTON,
		Name = "Paint"
	}
}

ToolTrayButtons.Something = 3

ToolTrayButtons.New = function()
	for _,v in pairs(ToolTrayButtons.Tools) do
		v = setmetatable(v,{
			__index = {
				Active = false,
				toDefault = function(self)
					self.Active = false
					self.Button.BackgroundColor3 = Theme[self.Name].DefaultColor
				end,
				toActive = function(self)
					self.Active = true
					self.Button.BackgroundColor3 = Theme[self.Name].SelectedColor
				end,
				onMouseEnter = function(self)
					if self.Active then return end
					self.Button.BackgroundColor3 = Theme[self.Name].HoverColor
				end,
				onMouseLeave = function(self)
					if self.Active then return end
					self:toDefault()
				end,
				onClick = function(self)
					if self.Active then 
						self:toDefault()
						return
					end

					for _,b in pairs(ToolTrayButtons.Tools) do
						b:toDefault()
					end

					self:toActive()
				end
			}
		})
	end
end

function ToolTrayButtons:Awake()
	Theme = self.Controllers.ThemeController.CurrentTheme.ToolTrayButtons
end

function ToolTrayButtons:Start()
	while true do
		wait(3)
		self.Something = self.Something + 1
	end
end

return ToolTrayButtons