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

    return {__index = function (_, k)
        return Search(k, arg)
    end}
end

function ClassHandler.MergeClass(inst) --Merge table and metatable.__index (table)
    local parentClass = getmetatable(inst).__index

    if typeof(parentClass) == "table" then
        setmetatable(inst, nil)

        for i,v in pairs(parentClass) do
            if i ~= "__index" then
                inst[i] = v
            end
        end

        return inst
    end
end

function ClassHandler.MergeIndex(tab, class) --Merge tab's metatable.__index (function) with class (table)
    if typeof(getmetatable(tab).__index) ~= "function" then return end
    local func = getmetatable(tab).__index
    getmetatable(tab).__index = function(t, k)
        if class[k] then
            return class[k]
        else
            return func(t, k)
        end
    end

    return tab
end

return ClassHandler