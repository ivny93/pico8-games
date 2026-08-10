function coordinates(x_, y_) return {x=x_, y=y_} end
function size(w_, h_) return {w=w_, h=h_} end
Body = {
    make = function(x_, y_, w_, h_, s_)
        local _body = {
            pos = coordinates(x_, y_),
            size = size(w_, h_),
            speed = coordinates(0, 0),
            sprite = s_
        }

        return _body
    end
}
function right(body) return body.pos.x + body.size.w - 1 end
function bottom(body) return body.pos.y + body.size.h - 1 end

function horizontal_overlap(body_a, body_b)
    return (body_a.pos.x >= body_b.pos.x and body_a.pos.x <= right(body_b))
    or (body_b.pos.x >= body_a.pos.x and body_b.pos.x <= right(body_a))
end
function vertical_overlap(body_a, body_b)
    return (body_a.pos.y >= body_b.pos.y and body_a.pos.y <= bottom(body_b))
    or (body_b.pos.y >= body_a.pos.y and body_b.pos.y <= bottom(body_a))
end
function intersect(body_a, body_b)
    return horizontal_overlap(body_a, body_b) and vertical_overlap(body_a, body_b)
end