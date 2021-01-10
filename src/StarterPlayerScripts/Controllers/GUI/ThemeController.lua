local Themes = script.Parent.Parent.Parent.Models.GUI.Themes
local DEFAULT_THEME = require(Themes.DarkTheme)

local ThemeController = {}
ThemeController.CurrentTheme = DEFAULT_THEME

function ThemeController:RefreshTheme()
	--Call affected modules to use new CurrentTheme
end

function ThemeController:GetCurrentTheme()
	if not self.CurrentTheme then return DEFAULT_THEME end
	return self.CurrentTheme
end

function ThemeController:Awake()

end

function ThemeController:Start()

end

return ThemeController