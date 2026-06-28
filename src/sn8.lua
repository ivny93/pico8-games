function hit(p1, p2)
  return p1.x==p2.x and p1.y==p2.y
end

function random_position()
  -- Randomizes the position of the next fruit
  -- Each game cell is 8 pixels wide and tall
  -- The border cells (Those that contain x/y at value 0/127) should be excluded
  return {
    x=(flr(rnd(13)) + 1)*8,
    y=(flr(rnd(13)) + 1)*8
  }
end
function tile_occupied(pos)
  -- Checks whether the generated position overlaps the snake or a wall
    if hit(pos, head) then return true end
    if fruit and hit(pos, fruit) then return true end
    if golden_fruit and hit(pos, golden_fruit) then return true end
    for i=1, #tail do
      if hit(pos, tail[i]) then return true end
    end
    for i=1, #walls do
      if hit(pos, walls[i]) then return true end
    end
    return false 
end

function has_empty_space()
  -- The gameboard grid is 15x16, for a total of 240 available tiles
  -- If they're all occupied, no fruit should be generated
  return #walls + #tail + 2 < 240
end

function in_gameboard(pos)
  return pos.x >= gameboard.left
    and pos.x <= gameboard.right
    and pos.y >= gameboard.top
    and pos.y <= gameboard.bottom
end

function find_free_space(center_pos)
  -- Finds the first free position around the given center
  -- Looks in the sorrounding 3x3 square,
  -- then increases the size of the square until a free position is found
  local k = 0
  while true do
    k += 8
    local edge_size = (2 * k) - 8
    local topleft = {x = center_pos.x - k, y = center_pos.y - k }
    -- top border
    for x = topleft.x, topleft.x + edge_size - 8, 8 do
      local tile = { x = x, y = topleft.y }
      if in_gameboard(tile) and not tile_occupied(tile) then return tile end
    end
    -- bottom border
    for x = topleft.x, topleft.x + edge_size - 8, 8 do
      local tile = { x = x, y = topleft.y + edge_size - 8 }
      if in_gameboard(tile) and not tile_occupied(tile) then return tile end
    end
    -- left border
    for y = topleft.y, topleft.y + edge_size - 8, 8 do
      local tile = { x = topleft.x, y = y }
      if in_gameboard(tile) and not tile_occupied(tile) then return tile end
    end
    -- left border
    for y = topleft.y, topleft.y + edge_size - 8, 8 do
      local tile = { x = topleft.x + edge_size - 8, y = y }
      if in_gameboard(tile) and not tile_occupied(tile) then return tile end
    end
  end
end 

function generate_fruit(golden_chance)
  if not has_empty_space() then return end

  fruit = nil
  local new_fruit = random_position()
  if tile_occupied(new_fruit) then
    new_fruit = find_free_space(new_fruit)
  end
  fruit = new_fruit

  if golden_chance > 0 then generate_golden_fruit(golden_chance) end
end

function generate_golden_fruit(chance)
  if not has_empty_space() then return end
  if golden_fruit then return end -- There cannot be more than one golden fruit

  if chance > 0 and flr(rnd(chance)) == 0 then
    -- There's a 1 in 10 chance that a golden fruit is generated
    local check_pos = function()
      return tile_occupied(golden_fruit) or hit(golden_fruit, fruit)
    end
    local new_golden_fruit = random_position()
    if tile_occupied(new_golden_fruit) do
      new_golden_fruit = find_free_space(new_golden_fruit)
    end
    golden_fruit = new_golden_fruit
    golden_fruit_counter = 150 -- Roughly 5 seconds to get the golden fruit
  end
end

function init_game(level)
  in_game = true
  gameover = false
  current_level = level

  head={x=48, y=64}
  tail={}
  add(tail, {x=40,y=64})
  add(tail, {x=32,y=64})
  add(tail, {x=24,y=64})
  snake_direction={x=8, y=0}
  speed=11
  move_counter=0
  score=0

  walls={} -- level 1 - Easy
  if level == 2 then -- Medium
    for i=0,120,8 do add(walls, {x=i, y=gameboard.top}) end -- top line of walls
    for i=0,120,8 do add(walls, {x=i, y=gameboard.bottom}) end -- bottom line of walls
  elseif level == 3 then -- Hard
    for i=0,120,8 do add(walls, {x=i, y=gameboard.top}) end -- top line of walls
    for i=0,120,8 do add(walls, {x=i, y=gameboard.bottom}) end -- bottom line of walls
    for i=8,112,8 do add(walls, {x=gameboard.left, y=i}) end -- left line of walls
    for i=8,112,8 do add(walls, {x=gameboard.right, y=i}) end -- right line of walls
  elseif level == 4 then -- Maze
    -- top-left corner
    add(walls, {x=gameboard.left, y=gameboard.top})
    add(walls, {x=gameboard.left, y=gameboard.top+8})
    add(walls, {x=gameboard.left+8, y=gameboard.top})
    add(walls, {x=gameboard.left+16, y=gameboard.top})

    for i=56,120,8 do add(walls, {x=i, y=gameboard.top}) end -- top-right horizontal line
    for i=gameboard.top,40,8 do add(walls, {x=48, y=i}) end -- top vertical line
    for i=0,48,8 do add(walls, {x=i, y=48}) end -- left-middle horizontal line
    for i=80,120,8 do add(walls, {x=i, y=48}) end -- right-middle horizontal line
    for i=0,120,8 do add(walls, {x=i, y=88}) end -- lower horizontal line
    for i=96,120,8 do add(walls,{x=48, y=i}) end -- bottom vertical line
  end

  fruit = {}
  golden_fruit = nil
  generate_fruit(0)
end

function to_menu()
  gameover = false
  in_game = false
end

function reset_highscores()
  highscores = {0, 0, 0, 0}
  dset(0, 0)
  dset(1, 0)
  dset(2, 0)
  dset(3, 0)
end

function _init()
  -- Graphics definitions
  palt(0, false)
  block_size = 8
  snake_head_h_sprite = 0
  snake_head_v_sprite = 7
  snake_body_h_sprite = 1
  snake_body_v_sprite = 6
  snake_body_d_sprite = 4
  snake_tail_h_sprite = 8
  snake_tail_v_sprite = 9
  red_fruit_sprite = 2
  golden_fruit_sprite = 3
  wall_sprite = 5
  logo_sprite=10 -- 4 sprites x 4 sprites
  -- sprite 14: empty grass
  -- sprite 15: horizontal tall grass
  -- sprite 16: verical tall grass
  header_color = 1 -- dark blue
  bg_color = 11 -- light green
  header_rect={left=0, top=0, right=127, bottom=7}

  -- Audio definitions
  red_eaten_sfx = 0
  golden_eaten_sfx = 1
  gameover_sfx = 2
  gameover_highscore_sfx = 3
  menu_button_sfx = 4
  golden_expired_sfx = 5
  snake_turn_sfx = 6 

  -- Menu
  menu = {
    elements={"classic", "tunnel", "box", "maze"},
    selected=1,
    bg_col=11, -- light green
    bg_sel_col=11,
    font_col=1, -- dark blue
    font_sel_col=8, -- red
    sfx=4
  }

  -- Game components
  gameboard = {left= 0, top=8, right=120, bottom=120}
  gameover = false
  in_game = false
  current_level = 0

  -- Load Highscores
  highscores = { 0, 0, 0, 0 }
  if cartdata("sn8_highscores") then
    highscores[1] = dget(0)
    highscores[2] = dget(1)
    highscores[3] = dget(2)
    highscores[4] = dget(3)
  end
  menuitem(1, "return to menu", to_menu)
  menuitem(2, "reset highscores", reset_highscores)
end

function copy_pos(source, dest)
  dest.x = source.x
  dest.y = source.y
end

function is_highscore()
  return score > highscores[current_level]
end

function update_game()
  if gameover then
    snake_direction={x=0, y=0}
    return
  end
  -- check input
  -- If a button is pressed, it changes direction
  -- only if there is not a tail block in the next cell
  -- the head should go
  --    left
  if btn(⬅️) and tail[1].x >= head.x then
    snake_direction={x=-8, y=0}
    sfx(snake_turn_sfx)
  end
  --    right
  if btn(➡️) and tail[1].x <= head.x then
    snake_direction={x=8, y=0}
    sfx(snake_turn_sfx)
  end
  --    up
  if btn(⬆️) and tail[1].y >= head.y then
    snake_direction={x=0, y=-8}
    sfx(snake_turn_sfx)
  end
  --    down
  if btn(⬇️) and tail[1].y <= head.y then
    snake_direction={x=0, y=8}
    sfx(snake_turn_sfx)
  end
  -- update the position
  -- Increases the move counter
  -- and if it reached the speed goal,
  -- moves the snake
  move_counter += 1
  if move_counter >= speed then
    move_counter=0
    -- update tail position
    local new_tail = (
      (add_tail) and
      {x=tail[#tail].x, y=tail[#tail].y}
      or nil
    )
    add_tail=false
    for i=#tail, 2, -1 do
      copy_pos(tail[i-1], tail[i])
    end
    copy_pos(head, tail[1])
    -- update head position
    head.x += snake_direction.x
    head.y += snake_direction.y
    if head.x < gameboard.left then head.x = gameboard.right end
    if head.x > gameboard.right then head.x = gameboard.left end
    if head.y < gameboard.top then head.y = gameboard.bottom end
    if head.y > gameboard.bottom then head.y = gameboard.top end
    -- add new part of tail
    if new_tail then add(tail, new_tail) end
  end
  -- check for gameover
  gameover = false
  foreach(tail, function(pos)
    if hit(head, pos) then
      gameover = true
      sfx(is_highscore() and gameover_highscore_sfx or gameover_sfx)
    end
  end)
  foreach(walls, function(pos)
    if hit(head, pos) then
      gameover = true
      sfx(is_highscore() and gameover_highscore_sfx or gameover_sfx)
    end
  end)

  -- fruit check
  if hit(head, fruit) then
    -- Red fruits (sprite 2) grant 3 point
    score += 3
    sfx(red_eaten_sfx)
    generate_fruit(5)
    -- The speed value is reduced at each tick by 0.5
    -- This way it is increased each 2 ticks
    -- Its value cannot go below 2
    if speed > 2 then speed -= 0.5 end
    add_tail=true
  elseif golden_fruit and hit(head, golden_fruit) then
    -- Golden fruits (sprite 3) grant 9 point
    score += 9
    sfx(1)
    golden_fruit = nil
  end
  -- If a golden fruit is on the field,
  -- decreases its counter.
  -- When it reaches 0,
  -- a new fruit is generated
  if golden_fruit then
    golden_fruit_counter -= 1
    if golden_fruit_counter == 0 then
      golden_fruit = nil
      sfx(golden_expired_sfx)
    end
  end
end

function _update()
  if gameover then
    if btn(🅾️) or btn(❎) then
      if is_highscore() then
        highscores[current_level] = score
        dset(current_level - 1, score)
      end
      gameover = false
  end
  elseif in_game then
    update_game()
    if gameover then
      in_game = false
    end
  else -- Title screen
    local sel = update_menu(menu)
    if sel then
      init_game(sel)
    end
  end
end

function draw_snake()

  local function is_left(pos, ref_pos)
    return (pos.x == ref_pos.x - 8) or (pos.x == gameboard.right and ref_pos.x == gameboard.left)
  end
  local function is_right(pos, ref_pos)
    return (pos.x == ref_pos.x + 8) or (pos.x == gameboard.left and ref_pos.x == gameboard.right)
  end
  local function is_up(pos, ref_pos)
    return (pos.y == ref_pos.y - 8) or (pos.y == gameboard.bottom and ref_pos.y == gameboard.top)
  end
  local function is_down(pos, ref_pos)
    return (pos.y == ref_pos.y + 8) or (pos.y == gameboard.top and ref_pos.y == gameboard.bottom)
  end

  -- Determines the head's orientation and draws it
  if is_left(head, tail[1]) then
    spr(snake_head_h_sprite, head.x, head.y) -- left
  elseif is_right(head, tail[1]) then
    spr(snake_head_h_sprite, head.x, head.y, 1, 1, true, false) -- right
  elseif is_up(head, tail[1]) then
    spr(snake_head_v_sprite, head.x, head.y) -- up
  elseif is_down(head, tail[1]) then
    spr(snake_head_v_sprite, head.x, head.y, 1, 1, false, true) -- down
  end

  -- Determines each body block's orientation and draws it
  local function draw_snake_body(pos, prev_pos, next_pos)
    if is_right(pos, prev_pos) and is_up(pos, next_pos) then
      -- H T
      --   T
      spr(snake_body_d_sprite, pos.x, pos.y)
    elseif is_right(pos, prev_pos) and is_down(pos, next_pos) then
      --   T
      -- H T
      spr(snake_body_d_sprite, pos.x, pos.y, 1, 1, false, true)
    elseif is_left(pos, prev_pos) and is_up(pos, next_pos) then
      -- T H
      -- T
      spr(snake_body_d_sprite, pos.x, pos.y, 1, 1, true, false)
    elseif is_left(pos, prev_pos) and is_down(pos, next_pos) then
      -- T
      -- T H
      spr(snake_body_d_sprite, pos.x, pos.y, 1, 1, true, true)
    elseif is_up(pos, prev_pos) and is_right(pos, next_pos) then
      -- T T
      --   H
      spr(snake_body_d_sprite, pos.x, pos.y)
    elseif is_up(pos, prev_pos) and is_left(pos, next_pos) then
      -- T T
      -- H
      spr(snake_body_d_sprite, pos.x, pos.y, 1, 1, true, false)
    elseif is_down(pos, prev_pos) and is_right(pos, next_pos) then
      --   H
      -- T T
      spr(snake_body_d_sprite, pos.x, pos.y, 1, 1, false, true)
    elseif is_down(pos, prev_pos) and is_left(pos, next_pos) then
      --   H
      -- T T
      spr(snake_body_d_sprite, pos.x, pos.y, 1, 1, true, true)
    elseif not (is_left(pos, prev_pos) or is_right(pos, prev_pos) or is_left(pos, next_pos) or is_right(pos, next_pos)) then
      -- H    T
      -- T    T
      -- T    H
      spr(snake_body_v_sprite, pos.x, pos.y)
    else
      -- H T T
      -- T T H
      spr(snake_body_h_sprite, pos.x, pos.y)
    end
  end
  -- First tail block
  draw_snake_body(tail[1], head, tail[2])
  -- Central tail blocks
  for i=2, #tail-1 do
    draw_snake_body(tail[i], tail[i-1], tail[i+1])
  end

  -- Last tail block
  tail_end = tail[#tail]
  tail_prev = tail[#tail-1]
  if is_right(tail_end, tail_prev) then
    spr(snake_tail_h_sprite, tail_end.x, tail_end.y)
  elseif is_left(tail_end, tail_prev) then
    spr(snake_tail_h_sprite, tail_end.x, tail_end.y, 1, 1, true, false)
  elseif is_down(tail_end, tail_prev) then
    spr(snake_tail_v_sprite, tail_end.x, tail_end.y)
  else
    spr(snake_tail_v_sprite, tail_end.x, tail_end.y, 1, 1, false, true)
  end
end

function _draw()
  -- draw board
  map()
  rectfill(header_rect.left, header_rect.top, header_rect.right, header_rect.bottom, header_color)
  
  if gameover then
    print("gameover", 46, 40, 8)
    print("score: "..score, 46, 50, 1)
    if is_highscore() then print("new highscore!", 36, 60, 8) end
  elseif in_game then
    -- print points
    print("score: "..score, 1, 1, 12)

    draw_snake()
    -- draw fruit
    if fruit then
      spr(red_fruit_sprite, fruit.x, fruit.y)
    end
    if golden_fruit then
      spr(golden_fruit_sprite, golden_fruit.x, golden_fruit.y)
    end
    -- draw walls
    foreach (walls, function (wall)
      spr(wall_sprite, wall.x, wall.y)
    end)
  else -- Title screen
    spr(logo_sprite, 48, 20, 4, 4)
    print("select game mode:", 30, 60, 1)
    draw_menu(menu, {x=45,y=72})
    print("highscore: "..highscores[menu.selected], 1, 1, 12)
  end
end
