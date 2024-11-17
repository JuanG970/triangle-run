player = {}

function player:new(ispr_list)
    local o = {
        -- map actual coordinates
        x = 0,
        y = 0,
        -- size of the sprite
        w = 8,
        h = 8,
        r = 0,
        -- movement variables
        vx = 0,
        vxlimit = 50,
        ax = 0,
        axlimit = 300,
        axrate = 100,
        friction = 0.03,
        dt = 1/30,
        framecounter = 1,
        -- movement logic
        state = "idle",
        sprpos = isprpos,
        spr_list = ispr_list,
        currentframe = 1
    }
    self.__index = self
    return setmetatable(o, self)
end

function player:update()
    -- Update velocity based on acceleration
    self.vx = self.vx + self.ax*self.dt - self.friction*self.vx
    if self.vx > self.vxlimit then
        self.vx = self.vxlimit
    elseif self.vx < -self.vxlimit then
        self.vx = -self.vxlimit
    end
    -- Update position based on velocity
    self.x = self.x + self.vx*self.dt
    -- Update rotation(r) according to the acceleration direction
    local heading_factor = self.vx/self.vxlimit
    self.r = calc_rotation(heading_factor)
end

function player:draw()
    self.framecounter = self.framecounter + 1
    for _, sprite in ipairs(self.spr_list) do
        if sprite.state == self.state then
            local scaledframe = flr(self.framecounter * sprite.speed)
            self.currentframe = (scaledframe % #sprite.frames) + 1
            local sprnum = sprite.frames[self.currentframe]
            spr_r(sprnum, self.x, self.y - self.h / 2, self.r, 1, 1)
        end
    end
end

function player:make_sound()
    if self.state == "idle" then
        sfx(1, 2)
    end
end

function player:move()
    if self.state == "dead" then
        return
    end
    -- move left
    if btn(0) then
        self.ax = self.ax - self.axrate
        self:make_sound()
    elseif btn(1) then
        self.ax = self.ax + self.axrate
        self:make_sound()
    else
        self.ax = 0
    end
    -- limit the acceleration
    if self.ax > self.axlimit then
        self.ax = self.axlimit
    elseif self.ax < -self.axlimit then
        self.ax = -self.axlimit
    end
    -- Update the position
    self:update()
end

function player:kill()
    self.state = "dead"
    self.ax = 0
    self.vx = 0
end

function spr_r(s,x,y,a,w,h)
    sw=(w or 1)*8
    sh=(h or 1)*8
    sx=(s%8)*8
    sy=flr(s/8)*8
    x0=flr(0.5*sw)
    y0=flr(0.5*sh)
    a=a/360
    sa=sin(a)
    ca=cos(a)
    for ix=0,sw-1 do
        for iy=0,sh-1 do
            dx=ix-x0
            dy=iy-y0
            xx=flr(dx*ca-dy*sa+x0)
            yy=flr(dx*sa+dy*ca+y0)
            if (xx>=0 and xx<sw and yy>=0 and yy<=sh) then
                pset(x+ix,y+iy,sget(sx+xx,sy+yy))
            end
        end
    end
end

function calc_rotation(vx)
    return map_to(vx, -1, 1, -90, 90)
end
