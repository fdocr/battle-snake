require 'byebug'

# This function is called on every turn of a game. It's how your Battlesnake decides where to move.
# Valid moves are "up", "down", "left", or "right".
# TODO: Use the information in board to decide your next move.
def move(board)

  { "move": smart_snake(board) }
  # { "move": perimeter_snake(target_snake, board) }
end

def perimeter_snake(board)
  # move towards the edge whatevers closest
  # if it hits an obstacle move clockwise
  valid_moves(board)

  translate_coord_to_move(board[:you][:head], choice)
end

def smart_snake(board)
  target_snake = board[:you]
  one_step_moves = valid_moves(target_snake[:head], board)
  # sorted_next_step_move = one_step_moves.sort do |a, b|
  #   valid_moves(b, board).count <=> valid_moves(a, board).count
  # end
  one_step_moves.reject! { |coord| valid_moves(coord, board).count == 0 }

  coord_distance_to_food = one_step_moves.map { |coord| distance_to_food(coord, board) }

  puts "ONE STEP MOVES: #{one_step_moves}"
  one_step_moves.sort! do |a, b|
    if target_snake[:health] < 50
      distance_to_food(b, board) <=> distance_to_food(a, board)
    else
      distance_to_food(a, board) <=> distance_to_food(b, board)
    end
  end
  puts "FOOD: #{board[:board][:food]}"
  puts "SORTED ONE STEP MOVES: #{one_step_moves}"
  puts "-"*30
  # if health is low
    # sort the one_step_moves based on how far away they are from food

  # puts "CLEAN - ONE STEP MOVES: #{one_step_moves}"

  translate_coord_to_move(board[:you][:head], one_step_moves.first)
end

# Returns all the valid moves for a snake id on the board
def valid_moves(current_coord, board)
  valid_coords = []
  # target_snake = board[:board][:snakes].find { |s| s[:id] == snake_id }
   # =  # {x,y}

  valid_coords << {x: current_coord[:x] + 1, y: current_coord[:y]} if current_coord[:x] + 1 < board[:board][:width]
  valid_coords << {x: current_coord[:x] - 1, y: current_coord[:y]} if current_coord[:x] - 1 >= 0
  valid_coords << {x: current_coord[:x], y: current_coord[:y] + 1} if current_coord[:y] + 1 < board[:board][:height]
  valid_coords << {x: current_coord[:x], y: current_coord[:y] - 1} if current_coord[:y] - 1 >= 0

  valid_coords.reject { |coord| invalid_coords(board).include?(coord) }
end

def distance_to_food(coord, board)
  return 0 if board[:board][:food]
  board[:board][:food].map do |food_coord|
    (coord[:x] - food_coord[:x]).abs + (coord[:y] - food_coord[:y]).abs
  end.min
end

def translate_coord_to_move(origin, target)
  if origin[:x] > target[:x]
    'left'
  elsif origin[:x] < target[:x]
    'right'
  elsif origin[:y] > target[:y]
    'down'
  elsif origin[:y] < target[:y]
    'up'
  end
end

# Returns the distance between two coords
def distance(coord_a, coord_b)
  1
end

# returns a list of invalid coords
def invalid_coords(board)
  board[:board][:snakes].map { |s| s[:body] }.flatten
end
