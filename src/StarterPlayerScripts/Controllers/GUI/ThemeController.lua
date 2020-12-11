local Themes = script.Parent.Parent.Parent.Models.GUI.Themes
local CurrentTheme = script.Parent.Parent.Parent.Models.GUI.CurrentTheme

local DEFAULT_THEME = Themes.DarkTheme

local ThemeController = {}

local function refreshTheme()
--hia
end

function ThemeController:Awake()
	if not CurrentTheme then
		CurrentTheme.Value = DEFAULT_THEME
	end
end

function ThemeController:Start()

end

return ThemeController