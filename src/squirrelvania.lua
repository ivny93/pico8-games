function _init()
    player = Body.make(0, 64, 8, 4, 0)
    player.on_ground = false
    --player.speed.y = 1
    camera = Body.make(-60, 0, 128, 128)
    world = {
        Body.make(-1, 0, 1, 130), -- left limit
        Body.make(200, 1, 1, 130), -- right limit
        Body.make(0, 110, 210, 24), -- bottom limit
        Body.make(32, 102, 8, 8, 1),
        Body.make(96, 102, 8, 4, 1),
        Body.make(120, 98, 8, 4, 1),
        Body.make(148, 94, 8, 4, 1),
    }
end

function check_and_run_speed(body)
    function fix_speed(overlap_fn, dist_fn, axis)
        local speed = body.speed[axis]
        local dist = 128
        for elem in all(world) do
            local d = dist_fn(body, elem)
            if overlap_fn(body, elem) and d >= 0 then
                dist = min(dist, d)
            end
        end
        if dist < flr(abs(speed)) then
            body.speed[axis] = sgn(speed) * min(abs(speed), dist)
        end
    end

    if body.speed.x > 0 then
        fix_speed(vertical_overlap, function (a, b) return b.x - right(a) end, "x")
    elseif body.speed.x < 0 then
        fix_speed(vertical_overlap, function (a, b) return a.x - right(b) end, "x")
    end

    body.x += body.speed.x
    
    if body.speed.y > 0 then
        fix_speed(horizontal_overlap, function (a, b) return b.y - bottom(a) end, "y")
    elseif body.speed.y < 0 then
        fix_speed(horizontal_overlap, function (a, b) return a.y - bottom(b) end, "y")
    end

    body.y += (body.speed.y > 0 and flr or ceil)(body.speed.y)
end

function on_ground(body)
    body.on_ground = false
    for elem in all(world) do
        if horizontal_overlap(body,elem) and elem.y - bottom(body) == 0 then
            body.on_ground = true
            return
        end
    end
end

function _update()
    on_ground(player)
    if player.on_ground then
        if btn(❎) then player.speed.y = -4 end
        if btn(➡️) then player.speed.x = 2.0
        elseif btn(⬅️) then player.speed.x = -2.0
        else player.speed.x = 0.0 end
    else
        player.speed.y += 0.5
    end
    check_and_run_speed(player)
    camera.x += player.speed.x
end

function draw(body)
    if not intersect(body, camera) then return end 
    spr(body.sprite, body.x - camera.x, body.y - camera.y, body.width / 8, body.height / 8)
end

function _draw()
    rectfill(0, 0, 128, 128, 1)
    rectfill(0, 110, 128, 128, 3)
    foreach(world, function(block) if block.sprite then draw(block) end end)
    draw(player)
    print("pos: "..player.x.."x"..player.y, 1, 1 ,7)
    print("speed: "..player.speed.x.."x"..player.speed.y, 1, 11, 7)
    print("camera:"..camera.x.."x"..camera.y,1, 21, 7)
end