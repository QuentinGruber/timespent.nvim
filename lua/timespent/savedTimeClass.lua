local SavedTime = {}
SavedTime.__index = SavedTime

-- Constructor
function SavedTime:new(path, time)
    local timeNumber = tonumber(time)
    local obj = {
        path = path,
        time = timeNumber,
    }
    setmetatable(obj, self)
    return obj
end

return SavedTime
