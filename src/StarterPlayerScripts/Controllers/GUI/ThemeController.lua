local Themes = script.Parent.Parent.Parent.Models.GUI.Themes
local DEFAULT_THEME = require(Themes.DarkTheme)

local ThemeController = {}

function ThemeController:RefreshTheme()
	--Call affected modules to use new CurrentTheme
end

function ThemeController:GetCurrentTheme()
	if not self.CurrentTheme then return DEFAULT_THEME end
	return self.CurrentTheme
end

function ThemeController.NewTheme()
	return setmetatable({CurrentTheme = DEFAULT_THEME}, {__index = ThemeController})
end

function ThemeController:Awake()
	return ThemeController.NewTheme()
end

function ThemeController:Start()

end

return ThemeController