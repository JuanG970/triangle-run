game = {}

function game:new(istatehandler, idrawhandler)
    local o = {
        statehandler = istatehandler,
        drawhandler = idrawhandler,
        timer = 0,
        difficulty_mult = 0.1,
        score = 0,
        gameover = false,
        lc = 1.01
    }
    self.__index = self
    return setmetatable(o, self)
end

function game:update()
    if self.statehandler then
        self.statehandler()
    end
end

function game:draw()
    if self.drawhandler then
        self.drawhandler()
    end
end

function game:compute_score()
    if not self.gameover and self.timer % 10 == 0 then
        self.score += 1
    end
end

function game:reset()
    self.score = 0
    self.difficulty_mult = 0.1
    self.timer = 0
    self.gameover = false
end
