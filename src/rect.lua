Rect = {
    make = function(x_, y_, w_, h_)
        local _rect = {
            x = x_, y = y_,
            width = w_, height = h_,
        }
        return _rect
    end
}

-- bottom right positions are exclusive
function right(rect) return rect.x + rect.width end
function bottom(rect) return rect.y + rect.height end

function horizontal_overlap(rect_a, rect_b)
    return (rect_a.x >= rect_b.x and rect_a.x < right(rect_b))
    or (rect_b.x >= rect_a.x and rect_b.x < right(rect_a))
end
function vertical_overlap(rect_a, rect_b)
    return (rect_a.y >= rect_b.y and rect_a.y < bottom(rect_b))
    or (rect_b.y >= rect_a.y and rect_b.y < bottom(rect_a))
end
function intersect(rect_a, rect_b)
    return horizontal_overlap(rect_a, rect_b) and vertical_overlap(rect_a, rect_b)
end

Body = {
    make = function(x_, y_, w_, h_, s_)
        local _body = Rect.make(x_, y_, w_, h_)
        _body.speed = {x = 0, y = 0}
        _body.sprite = s_
        return _body
    end
}