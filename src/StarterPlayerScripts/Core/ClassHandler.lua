local ClassHandler = {}

--Look up for 'k' in list of tables 'plist'
local function Search(k, plist)
    for i = 1, #plist do
        local v = plist[i][k] --Try 'i'-th superclass
        if v then return v end
    end
end

function ClassHandler.CreateClass(...)
    local arg = {...}

    return {__index = function (t, k)
        return Search(k, arg)
    end}
end

function ClassHandler.MergeClass(inst)
    local parentClass = getmetatable(inst).__index
    setmetatable(inst, nil)

    if typeof(parentClass) == "table" then
        for i,v in pairs(parentClass) do
            if i ~= "__index" then
                inst[i] = v
            end
        end

        return inst
    end
end

return ClassHandler