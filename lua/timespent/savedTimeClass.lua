local SavedTime = {}
SavedTime.__index = SavedTime

-- Constructor
function SavedTime:new(path, time)
    local obj = {
        path = path,
        time = time or 0, -- Default to 0 if time is not provided
    }
    setmetatable(obj, self)
    return obj
end

-- Method to add time
function SavedTime:addTime(time)
    self.time = self.time + time
end

-- Method to get the current saved time
function SavedTime:getTime()
    return self.time
end

return SavedTime
