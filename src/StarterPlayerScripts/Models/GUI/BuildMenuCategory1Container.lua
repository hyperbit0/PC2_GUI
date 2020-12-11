local BuildGui = require(script.Parent.BuildGui)

local BUILD_MENU_CATEGORY_1_CONTAINER = BuildGui.Protect.Category1Container

local BuildMenuCategory1Container = {}

BuildMenuCategory1Container.Active = false

function BuildMenuCategory1Container:Open()
	if self.Active then return end
	BUILD_MENU_CATEGORY_1_CONTAINER:TweenPosition(UDim2.new(0,0,0.07,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)
	self.Active = true
end

function BuildMenuCategory1Container:Close()
	if not self.Active then return end
	BUILD_MENU_CATEGORY_1_CONTAINER:TweenPosition(UDim2.new(-3,0,0.07,0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.2,true)
	self.Active = false	
end

return BuildMenuCategory1Container