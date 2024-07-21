-- Define the Person class
SavedTime = {}
SavedTime.__index = SavedTime

-- Constructor
function SavedTime:new(path, time)
    local obj = {
        path = path,
        time = time,
    }
    setmetatable(obj, SavedTime)
    return obj
end

-- Method
function SavedTime:addTime(time)
    self.time = self.time + time
end

return SavedTime
