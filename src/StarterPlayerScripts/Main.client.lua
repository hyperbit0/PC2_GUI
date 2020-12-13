if not game:IsLoaded() then
	game.Loaded:Wait()
end

local EventHandler = require(script.Parent:WaitForChild("Core").EventHandler)
local ClassHandler = require(script.Parent:WaitForChild("Core").ClassHandler)

local PC = {
	Controllers = {},
	Models = {}
}
local Instances = {}

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
	for _, class in pairs(PC) do
		for _, module in pairs(class) do
			EventHandler.Attach(module)
		end
	end
end


local function awakeModule(module)
	if module.Awake then
		return module:Awake()
	end
end

local function awakeModules() --Call Awake() methods synchronously and check for instances if applicable
	for className, class in pairs(PC) do
		if typeof(class) == "table" then
			for moduleName, module in pairs(class) do
				local inst = awakeModule(module)
				if inst then
					table.insert(Instances, {className, moduleName, inst})
				end
			end
		end
	end
end

local function attachModules()
	local mt = {__index = PC}

	for i,v in pairs(EventHandler) do
		if i ~= "__index" then
			mt.__index[i] = v
		end
	end

	for _,instanceInfo in pairs(Instances) do 
		local className, moduleName, inst = unpack(instanceInfo)
		if getmetatable(inst) then
			inst = ClassHandler.MergeClass(inst) --Transfer existing class methods and properties directly into the instance table
		end
		PC[className][moduleName] = inst --Replace modules with their instances in shared table
	end

	for _, class in pairs(PC) do
		if typeof(class) == "table" then
			for _, module in pairs(class) do
				module = setmetatable(module, mt)
			end
		end
	end
end

local function startModule(moduleName, module)
	coroutine.wrap(function()
		local success = pcall(function()
			if module.Start then
				return module:Start()
			end
			--warn("Module ".. moduleName .. " does not have a Start() method")
		end)

		if not success then
			warn("Could not start ".. moduleName)
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
attachEvents() --Inject EventHandler functions in each module
awakeModules() --Where modules set up events and other essential actions before use
attachModules() --Replace modules with their instances and inject modules in each other
startModules() --Where modules can start communicating and accessing other modules