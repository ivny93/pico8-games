function coordinates(x_, y_) return {x=x_, y=y_} end
function size(w_, h_) return {w=w_, h=h_} end

function in_rect(pos, rect)
    return pos.x > rect.pos.x and pos.x < rect.pos.x + rect.size.w
        and pos.y > rect.pos.y and pos.y < rect.pos.y + rect.size.h
end
function intersect(body_a, body_b)
    return in_rect(body_a.pos, body_b) or in_rect(body_b.pos, body_a)
end

function left_adjacent(body_a, body_b)
    return body_a.pos.x + body_a.size.w == body_b.pos.x
end
function right_adjacent(body_a, body_b)
    return body_a.pos.x == body_b.pos.x + body_b.size.w
end
function down_adjacent(body_a, body_b)
    return body_a.pos.y + body_a.size.h == body_b.pos.y
end
function up_adjacent(body_a, body_b)
    return body_a.pos.y == body_b.pos.y + body_b.size.h
end