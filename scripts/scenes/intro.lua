clock = {}

function clock:new(hour, minutes)
    local o = {
        state = {hour, minutes}
    }
    self.__index = self
    return setmetatable(o, self)
end

function clock:addmin(toadd)
    local minutes = self.state[2]
    local hours = self.state[1]
    
    minutes = minutes + toadd
    
    local extrahours = flr(minutes/60)
    
    minutes = minutes % 60
    
    hours = (hours + extrahours) % 24
    
    self.state = {hours, minutes}
    return self.state
end

-- TODO: draw clock
function clock:draw()
    return 0
end
