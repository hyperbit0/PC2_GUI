local EventHandler = {}
EventHandler.__index = EventHandler

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
	return setmetatable(module, EventHandler)
end

return EventHandler