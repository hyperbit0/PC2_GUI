local EventHandler = {}
local Events = {}

function EventHandler:CreateEvent(name)
	local event = Instance.new("BindableEvent")
	
	Events[name] = event
	
	print("Successfully created event: "..name)
end

function EventHandler:FireEvent(name, ...)
	if Events[name] then
		Events[name]:Fire(...)
	end
end

function EventHandler:ListenEvent(name, func)
	if Events[name] then
		Events[name].Event:Connect(func)
	end
end

function EventHandler.Attach(module)
	local mt = {}
	mt.__module = module
	mt.__events = {}
	mt.__index = function(_, key)
		if EventHandler[key] then return EventHandler[key] end --Inherit all EventHandler functions
		if mt.__module[key] then return mt.__module[key] end --Inherit all original module functions
		if key == "GetPropertyChanged" then
			local function GetPropertyChanged(_, propertyName)
				local signal = {}
				
				function signal:Connect(func)
					mt.__events[propertyName] = func
				end

				return signal
			end

			return GetPropertyChanged
		end
	end
	mt.__newindex = function(_, key, val)
		print(key .. " was changed!")
		mt.__module[key] = val
		if mt.__events[key] then
			mt.__events[key](key, val)
		end
	end
	return setmetatable({}, mt)
end

return EventHandler