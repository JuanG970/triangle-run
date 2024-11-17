function draw_dialog_box(text_lines, x, y, width, height, options)
    -- Calculate text height
    local text_height = #text_lines * 6  -- Each line of text is 6 pixels high in pico-8
    height = height or text_height + 4

    -- Draw shadow rectangle
    local shadow_color = 5 or options.shadow_color
    rectfill(x + 2, y + 2, x + width + 2, y + height + 2, 5)

    -- Draw main rectangle
    local color = 0 or options.color
    rectfill(x, y, x + width, y + height, 0)

    -- Draw outline
    local outline_color = 7 or options.outline_color
    rect(x, y, x + width, y + height, 7)

    -- Draw centered text
    for i, line in ipairs(text_lines) do
        local text_width = #line * 4  -- Each character is 4 pixels wide in pico-8
        local text_x = x + (width - text_width) / 2
        local text_y = y + (height - text_height) / 2 + (i - 1) * 6
        print(line, text_x, text_y, 7)
    end
end

function print_sprite_list(sprite_list, y, sprite_size, x_space)
    local sprite_size = 8
    local x_space = 1 or x_space
    local width = #sprite_list * sprite_size + (#sprite_list - 1) * x_space
    local x = (128 - width) / 2 - 5
    for i = 1, #sprite_list do
        spr(sprite_list[i], x + i * sprite_size + x_space, y)
    end

end
