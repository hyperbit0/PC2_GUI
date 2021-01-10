local BuildMenuCategory1Container = require(script.Parent.Parent.Parent.Models.GUI.BuildMenuCategory1Container)
local BuildMenuCategory1ContainerController = {}

function BuildMenuCategory1ContainerController:Awake()
	BuildMenuCategory1Container = self.Models.BuildMenuCategory1Container
end

function BuildMenuCategory1ContainerController:Start()
	self:ListenEvent("BuildButton", function(bool)
		if bool then
			BuildMenuCategory1Container:Open()
		else
			BuildMenuCategory1Container:Close()
		end
	end)
end

return BuildMenuCategory1ContainerController
