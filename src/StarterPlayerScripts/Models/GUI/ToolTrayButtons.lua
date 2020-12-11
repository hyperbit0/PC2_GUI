local BuildGui = require(script.Parent.BuildGui)
local BuildMenuCategory1Container = require(script.Parent.BuildMenuCategory1Container)

local Theme = require(script.Parent.CurrentTheme.Value).ToolTrayButtons

local BUILD_BUTTON = BuildGui.Protect.ToolContainer.Tools.BuildButton
local DELETE_BUTTON = BuildGui.Protect.ToolContainer.Tools.DeleteButton
local CONFIGURE_BUTTON = BuildGui.Protect.ToolContainer.Tools.ConfigureButton
local MOVE_BUTTON = BuildGui.Protect.ToolContainer.Tools.MoveButton
local PAINT_BUTTON = BuildGui.Protect.ToolContainer.Tools.PaintButton

local ToolTrayButtons = {}

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

ToolTrayButtons.New = function()
	for i,v in pairs(ToolTrayButtons.Tools) do
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

					for a,b in pairs(ToolTrayButtons.Tools) do
						b:toDefault()
					end

					self:toActive()
				end
			}
		})
	end
end

return ToolTrayButtons