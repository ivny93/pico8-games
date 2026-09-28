body_class = {
    new = function(x_, y_, w_, h_, s_)
        local body = rect_class.new(x_, y_, w_, h_)
        body.speed = {x = 0, y = 0}
        body.sprite = s_
        return body
    end
}