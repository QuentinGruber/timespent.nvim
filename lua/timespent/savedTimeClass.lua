local SavedTime = {}
SavedTime.__index = SavedTime

-- Constructor
function SavedTime:new(path, time, type, parent)
    local timeNumber = tonumber(time)
    local obj = {
        path = path,
        time = timeNumber,
        type = type,
        parent = parent,
    }
    setmetatable(obj, self)
    return obj
end

return SavedTime
