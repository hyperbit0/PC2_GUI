if not game:IsLoaded() then game.Loaded:Wait() end

local EventHandler = require(script.Parent:WaitForChild("Core").EventHandler)

local Controllers = {}

function loadModules() --Require each controller and call Awake() methods synchronously
	for i,v in pairs(script.Parent:WaitForChild("Controllers"):GetDescendants()) do
		if v:IsA("ModuleScript") then
			local success, module = pcall(function()
				return require(v)
			end)

			if success then

				module = EventHandler.Attach(module)

				if module.Awake then
					module.Awake()
				end

				Controllers[v] = module
				
			else
				warn("Could not load " .. v:GetFullName())
			end
		end
	end
end

function startModules() --Call Start() methods in controllers asynchronously
	for moduleScript,module in pairs(Controllers) do
		coroutine.wrap(function()
			local success, result = pcall(function()
				module:Start()
			end)
			
			if not success then
				warn("Module ".. moduleScript:GetFullName() .. " does not have a Start() method")
			end
		end)()
	end
end

loadModules()
startModules()