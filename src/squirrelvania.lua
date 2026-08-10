function _init()
    player = Body.make(64, 64, 8, 4, 0)
    player.on_ground = false
    --player.speed.y = 1
    camera = Body.make(0, 0, 128, 128)
    world = {
        Body.make(-1, 0, 1, 130), -- left limit
        Body.make(159, 1, 1, 130), -- right limit
        Body.make(0, 110, 160, 24), -- bottom limit
        Body.make(32, 102, 8, 8, 1),
        Body.make(96, 102, 8, 8, 1)
    }
end

function check_speed_boundaries(body)
    function fix_speed(overlap_fn, dist_fn, axis)
        local dist = 128
        for elem in all(world) do
            local d = dist_fn(body, elem)
            if overlap_fn(body, elem) and d >= 0 then
                dist = min(dist, d)
            end
        end
        m = (body.speed[axis] < 0 and -1 or 1)
        if dist < (m * body.speed[axis]) then
            body.speed[axis] = m * min(min(m * body.speed[axis], dist - 1), 0)
        end
    end

    if body.speed.x > 0 then
        fix_speed(vertical_overlap, function (a, b) return b.pos.x - right(a) end, "x")
    elseif body.speed.x < 0 then
        fix_speed(vertical_overlap, function (a, b) return a.pos.x - right(b) end, "x")
    end
    
    if body.speed.y > 0 then
        fix_speed(horizontal_overlap, function (a, b) return b.pos.y - bottom(a) end, "y")
    elseif body.speed.y < 0 then
        fix_speed(horizontal_overlap, function (a, b) return a.pos.y - bottom(b) end, "y")
    end
end

function on_ground(body)
    for elem in all(world) do
        if horizontal_overlap(body,elem) and elem.pos.y - bottom(body) == 1 then
            body.on_ground = true
            return
        end
    end
    body.on_ground = false
end

function _update()
    on_ground(player)
    if player.on_ground then
        player.speed.y = 0
        if btn(❎) then
            player.speed.y = -5
        else
            if btn(➡️) then player.speed.x = 2.0
            elseif btn(⬅️) then player.speed.x = -2.0
            else player.speed.x = 0.0 end
        end
    else
        player.speed.y = player.speed.y + 1
    end
    check_speed_boundaries(player)

    player.pos.x += player.speed.x
    camera.pos.x += player.speed.x

    player.pos.y += player.speed.y
end

function draw(body)
    if not intersect(body, camera) then return end 
    spr(body.sprite, body.pos.x - camera.pos.x, body.pos.y - camera.pos.y)
end

function _draw()
    rectfill(0, 0, 128, 128, 1)
    rectfill(0, 110, 128, 128, 3)
    foreach(world, function(block) if block.sprite then draw(block) end end)
    draw(player)
    print("pos: "..player.pos.x.."x"..player.pos.y, 1, 1 ,7)
    print("speed: "..player.speed.x.."x"..player.speed.y, 1, 11, 7)
    print("camera:"..camera.pos.x.."x"..camera.pos.y,1, 21, 7)
end