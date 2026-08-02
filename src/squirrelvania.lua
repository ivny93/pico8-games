function _init()
    player = {
        pos = coordinates(64, 64),
        size = size(7,7),
        speed = coordinates(0, 0),
        on_ground = false
    }
    camera = coordinates(0, 0)
    world = {
        { sprite = 1, pos = coordinates(32, 102), size = size(8,8) },
        { sprite = 1, pos = coordinates(96, 102), size = size(8,8) }
    }
end

function check_speed_boundaries(pos, speed_delta)
    if speed_delta > 0 then
        if pos.x >= 150 then return 0 end
    end
    if speed_delta < 0 then
        if pos.x <= 0 then return 0 end
    end
    return speed_delta
end

function _update()
    player.on_ground = player.pos.y >= 104
    if player.on_ground then
        if btn(❎) then
            player.speed.y = -4
        else
            player.speed = { x = 0, y = 0 }
            speed_delta = 0
            if btn(➡️) then speed_delta = 2.0 end
            if btn(⬅️) then speed_delta = -2.0 end
            player.speed.x = check_speed_boundaries(player.pos, speed_delta)
        end
    else
        player.speed.y += 0.5
    end

    player.pos.x += player.speed.x
    camera.x += player.speed.x

    player.pos.y += player.speed.y
    if player.pos.y < 0 then player.pos.y = 0 end
    if player.pos.y > 104 then player.pos.y = 104 end
end

function draw(sprite, pos)
    local screen_pos = coordinates(pos.x - camera.x, pos.y - camera.y)
    if screen_pos.x > 0 and screen_pos.x < 128 and screen_pos.y > 0 and screen_pos.y < 128 then
        spr(sprite, screen_pos.x, screen_pos.y)
    end
end

function _draw()
    rectfill(0, 0, 128, 128, 1)
    rectfill(0, 104, 128, 128, 3)
    draw(0, player.pos) 
    foreach(world, function(block) draw(block.sprite, block.pos) end)
    print("pos "..player.pos.x, 1,1)
    print(" speed "..player.speed.x, 1, 11)
end