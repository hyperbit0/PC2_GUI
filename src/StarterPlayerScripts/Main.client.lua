if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Core = script.Parent:WaitForChild("Core")
local EventHandler = require(Core.EventHandler)
local ClassHandler = require(Core.ClassHandler)

local PC = {
	Controllers = {},
	Models = {}
}

local function gatherControllers()
	for _,v in pairs(script.Parent:WaitForChild("Controllers"):GetDescendants()) do
		if v:IsA("ModuleScript") then
			local success, module = pcall(function()
				return require(v)
			end)

			if success and typeof(module) == "table" then
				PC.Controllers[v.Name] = module
			else
				warn("Could not load controller " .. v:GetFullName())
			end
		end
	end
end

local function gatherModels()
	for _,v in pairs(script.Parent:WaitForChild("Models"):GetDescendants()) do
		if v:IsA("ModuleScript") then
			local success, module = pcall(function()
				return require(v)
			end)

			if success and typeof(module) == "table" then
				PC.Models[v.Name] = module
			elseif typeof(module) == "table" then
				warn("Could not load model " .. v:GetFullName())
			end
		end
	end
end

local function gatherModules() --Pool all controllers to prepare calling Awake() and then Start() methods
	gatherControllers()
	gatherModels()
end

local function attachEvents()
	for className, class in pairs(PC) do
		for moduleName, module in pairs(class) do
			local inst = EventHandler.Attach(module)
			ClassHandler.MergeIndex(inst, PC)
			PC[className][moduleName] = inst
		end
	end
end

local function awakeModule(module)
	if module.Awake then
		return module:Awake()
	end
end

local function awakeModules() --Call Awake() methods synchronously and check for instances (returned values in Awake()) if applicable
	for _, class in pairs(PC) do
		if typeof(class) == "table" then
			for _, module in pairs(class) do
				awakeModule(module)
			end
		end
	end
end

local function startModule(moduleName, module)
	coroutine.wrap(function()
		local success, res = pcall(function()
			if module.Start then
				return module:Start()
			end
			--warn("Module ".. moduleName .. " does not have a Start() method")
		end)

		if not success then
			warn("Could not start ".. moduleName, res)
		end
	end)()
end

local function startModules() --Call Start() methods asynchronously
	for _, class in pairs(PC) do
		if typeof(class) == "table" then
			for moduleName, module in pairs(class) do
				startModule(moduleName, module)
			end
		end
	end
end

gatherModules() --Populate Controllers and Models table
attachEvents() --Inject EventHandler functions and PC table in each module
awakeModules() --Where modules set up events and other essential actions before use
startModules() --Where modules can start communicating and accessing other modules