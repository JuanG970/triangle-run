devmode = false

if devmode then
    srand(5)
end

btn_l = "⬅️"
btn_r = "➡️"

logfile = "trun.txt"

aux_timer = 0


function levelhandler()
    if not stat(57) then
        music(0)
    end
    g.timer += 1
    g:compute_score()
    if g.timer % 10 == 0 then
        if g.difficulty_mult < 1 then
            g.difficulty_mult = 0.1 + (1 - g.lc ^ (-g.score))
        else
            g.difficulty_mult = 1
        end
        g.timer = 0
    end
    
    if p.state == "dead" then
        -- Reset logic: press left or right to restart
        g.drawhandler = gameoverdraw
        if btn(0) and btn(1) then
            init_game()
        end
        return
    end
    
    r:move()
    p:move()
    
    -- Draw random obstacles
    local obstacle_prob = 0.5
    if rnd(1) > obstacle_prob then
        r:add_random_obs()
    end
    -- Check for collisions, lose condition
    for obstacle in all(r.obstacles) do
        if check_collition(p, obstacle) == true then
            r.vy = 0
            g.gameover = true
            p:kill()
        end
    end
    if p.x < 10 or p.x + p.w > 118 then
        r.vy = 0
        p:kill()
        g.gameover = true
    end
    -- update difficulty
    r.vy = r.vymax * g.difficulty_mult
    p.axrate = 20 + 80 * g.difficulty_mult
    vxlimit = 50 + 100 * g.difficulty_mult
end

function leveldrawer()
    cls()
    r:draw()
    p:draw()
    -- print the score
    rectfill(0, 0, 128, 6, 0)
    print("score: " .. g.score, 0, 0, 7)
    if devmode then
        print("vy: " .. r.vy, 0, 8, 7)
        print("d: " .. g.difficulty_mult, 0, 16, 7)
    end
end

function start_screen_handler()
    if btn(0) and btn(1) then
        init_game()
    end
end

function start_screen_drawer()
    cls()
    local y_pos = 50

    aux_timer += 1

    local triangle_word = {}
    for i = 32, 39 do
        add(triangle_word, i)
    end
    local run_word = {40, 41, 42}

    --add particles around the print sprite list
    if aux_timer % 30 > 15 then
        for i = 1, 10 do
            local x = rnd(128)
            local y = rnd(128)
            local c = rnd(15)
            pset(x, y, c)
        end
    end

    print_sprite_list(triangle_word, y_pos, 8)
    print_sprite_list(run_word, y_pos + 10, 8)

    -- make it blink
    if aux_timer % 20 < 10 then
        print("press " .. btn_l .. " and " .. btn_r .. " to start", 5, 120, 7)
    else
        print("press " .. btn_l .. " and " .. btn_r .. " to start", 5, 120, 5)
    end
end

function gameoverdraw()
    draw_dialog_box(
        {
            "game over",
            "press " .. btn_l .. " and " .. btn_r .." to restart"
        },
        5, 40, 118
    )
end

function _init()
    -- initialize game instance
    g = game:new(levelhandler, leveldrawer)
    
    g.statehandler = start_screen_handler
    g.drawhandler = start_screen_drawer
end

function init_game()
    cls()
    -- initialize the player
    p = player:new(
        {
            {state= "idle", frames = {1}, speed = 0.001},
            {state= "dead", frames = {2,3,4,5}, speed = 0.2},
        }
    )
    p.x = 60
    p.y = 120
    p.position = {1, 3}
    p.state = "idle"
    -- initialize the road
    r = road:new()
    r:add_random_obs()
    -- game logic
    g:reset()
    g.statehandler = levelhandler
    g.drawhandler = leveldrawer
end

function _draw()
    g:draw()
end

function _update()
    g:update()
end
