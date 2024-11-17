-- Requires math.lua

-- Function to check collision between body1 and body2
-- Returns true if there is an overlap, false otherwise.
function check_collition(body1, body2)
    local body1_top = body1.y
    local body1_left = body1.x
    local body1_right = body1.x + body1.w
    local body1_bottom = body1.y + body1.h
    
    local body2_bottom = body2.y
    local body2_left = body2.x
    local body2_right = body2.x + body2.w
    local body2_top = body2.y + body2.h
    
    return
        interval_overlaps(
            {body1_top, body1_bottom},
            {body2_bottom, body2_top}
        )
        and
        interval_overlaps(
            {body1_left, body1_right},
            {body2_left, body2_right}
        )

end



