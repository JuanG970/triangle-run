road = {}

function road:new()
    local o = {
        obstacles = {},
        vy = 1,
        vymax = 5,
        width = 118,
        max_obs = 5
    }
    self.__index = self
    return setmetatable(o, self)
end

function road:add_obs(x, y, w, class)
    add(self.obstacles, {x = x, y = y, w=w, h=5, class=class})
end

function road:draw()
    -- Draw the road
    rect(10, -10, self.width, 128, 7)
    -- Draw walls
    for obstacle in all(self.obstacles) do
        draw_obs(obstacle)
    end
end

function road:add_random_obs(initialx, initialy, initialw, recursed)
    -- Constants
    local MIN_Y_DISTANCE = 10
    local MIN_X_DISTANCE = 10
    local MAX_Y_OFFSET = 100
    local MIN_WIDTH = 5
    local MAX_WIDTH_OFFSET = 30
    local RECURSION_LIMIT = 1

    if #self.obstacles >= self.max_obs then
        return -- Stop if maximum obstacles reached
    end

    local y = initialy or -flr(rnd(MAX_Y_OFFSET))
    local w = initialw or flr(rnd(MAX_WIDTH_OFFSET)) + MIN_WIDTH
    local x = initialx or flr(rnd(self.width - w - MIN_WIDTH)) + MIN_WIDTH

    -- Ensure obstacle fits within bounds
    w = min(w, self.width - x)
    local class = "wall"

    -- Validate placement to ensure path remains valid
    local function is_valid_obstacle(nx, ny, nw)
        for obstacle in all(self.obstacles) do
            -- Check vertical and horizontal overlap
            local overlap_y = abs(ny - obstacle.y) < MIN_Y_DISTANCE
            local overlap_x = abs(nx - obstacle.x) < MIN_X_DISTANCE
            if overlap_y and overlap_x then
                return false
            end
        end
        return true
    end

    if is_valid_obstacle(x, y, w) then
        self:add_obs(x, y, w, class)
    else
        if not recursed then
            -- Retry placing obstacle with adjusted coordinates
            local new_x = x + flr(rnd(MIN_X_DISTANCE))
            local new_y = y - flr(rnd(MIN_Y_DISTANCE))
            self:add_random_obs(new_x, new_y, w, true)
        end
    end

    -- Validate that there's still a path for the player
    self:ensure_valid_path()
end

-- Function to ensure there's always a valid path
function road:ensure_valid_path()
    -- Example validation: Ensure at least one clear column
    local columns = {}
    for x = 1, self.width do
        columns[x] = true
    end

    for obstacle in all(self.obstacles) do
        for i = obstacle.x, obstacle.x + obstacle.w - 1 do
            columns[i] = false
        end
    end

    -- Check if there’s at least one passable column
    local passable = false
    for x, is_clear in pairs(columns) do
        if is_clear then
            passable = true
            break
        end
    end

    -- Remove obstacles if no valid path
    if not passable then
        del(self.obstacles, self.obstacles[#self.obstacles])
        self:ensure_valid_path()
    end
end


function draw_obs(obs)
    local color, shadow_color, outline_color
    
    -- Determine colors based on obstacle class
    if obs.class == "wall" then
        color = 7
    end
    
    -- Draw obstacle
    rectfill(obs.x, obs.y - obs.h, obs.x + obs.w, obs.y, color)
end

function road:move()
    for obstacle in all(self.obstacles) do
        obstacle.y += self.vy
        if obstacle.y > 128 then
            del(self.obstacles, obstacle)
        end
    end
end
