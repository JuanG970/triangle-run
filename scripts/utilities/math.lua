function sign(x)
    if x < 0 then
        return -1
    else
        return 1
    end
end

function between(x, interval)
    return x >= interval[1] and x <= interval[2]
end

function interval_overlaps(interval1, interval2)
    return
        between(interval1[1], interval2) or
        between(interval1[2], interval2)
end

-- Convert rad to degrees
function deg(rad)
    return rad * 180 / 3.14159265
end

-- Map value to another one
function map_to(value, lower, upper, new_lower, new_upper)
    return new_lower + (value - lower) * (new_upper - new_lower) / (upper - lower)
end
