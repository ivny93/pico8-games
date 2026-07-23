function _init()
    pos = position(64, 64)
    speed = position(0, 0)
    camera = position(0, 0)
    world = {
        { 1, position(32, 104) },
        { 1, position(96, 104) }
    }
end

function _update()
    if pos.y >= 104 then
        if btn(❎) then
            speed.y = -4
        else
            speed = { x = 0, y = 0 }
            if btn(➡️) and pos.x < 150 then speed.x += 2.5 end
            if btn(⬅️) and pos.x > 0 then speed.x -= 2.5 end
        end
    else
        speed.y += 0.5
    end
    pos.x += speed.x
    camera.x += speed.x

    pos.y += speed.y
    if pos.y < 0 then pos.y = 0 end
    if pos.y > 104 then pos.y = 104 end
end

function draw(sprite, pos)
    local actual_pos = position(pos.x - camera.x, pos.y - camera.y)
    if actual_pos.x > 0 and actual_pos.x < 128 and actual_pos.y > 0 and actual_pos.y < 128 then
        spr(sprite, actual_pos.x, actual_pos.y)
    end
end

function _draw()
    rectfill(0, 0, 128, 128, 1)
    rectfill(0, 104, 128, 128, 3)
    draw(0, pos)
    foreach(world, function(block) draw(block[1], block[2]) end)
    print("pos "..pos.x, 1,1)
    print(" speed "..speed.x, 1, 11)
end