local SavedTime = {}
SavedTime.__index = SavedTime

-- Constructor
function SavedTime:new(path, time)
    local corrupted
    local timeNumber = tonumber(time)
    if path ~= "" and timeNumber ~= "fail" then
        corrupted = false
    else
        corrupted = true
    end
    local obj = {
        path = path,
        time = timeNumber,
        corrupted = corrupted,
    }
    setmetatable(obj, self)
    return obj
end

-- Add time to saved time value
function SavedTime:addTime(time)
    self.time = self.time + time
end
-- Format saved time to string
function SavedTime:toString()
    return string.format("%s,%d", self.path, self.time)
end

return SavedTime
