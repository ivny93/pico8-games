_next_eventid = 1
_events = {}
event_class = {
    new = function(time_gap_, callback_, repeated_)
        local event = {
            id = _next_eventid,
            time_gap = time_gap_,
            end_t = time() + time_gap_,
            callback = callback_,
            repeated = repeated_ and repeated_ or false
        }
        _events[event.id] = event
        _next_eventid += 1
        return event
    end,

    check = function()
        local t = time()
        for event in all(_events) do
            if event.end_t >= t then
                event.callback()
                if event.repeated then
                    event.end_t = t + event.time_gap
                else
                    _events[event.id] = nil
                end
            end
        end
    end
}