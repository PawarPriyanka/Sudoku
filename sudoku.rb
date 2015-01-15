class Sudoku
  def create_puzzle
    sudoku = Array.new(9){ Array.new(9,0) }
    81.times do
      row = rand(0..8)
      col = rand(0..8)
      number = rand(1..9)
      if is_safe?(sudoku, row, col, number)
        sudoku[row][col] = number
      else
        sudoku[row][col] = 0
      end
    end
    return sudoku
  end

#DISPLAY the sudoku
  def display_sudoku(array)
    array.each do |cell|
      cell.each do |element|
        print element," "
      end
      print "\n"
    end
  end

  #get column
  def get_column(array, col_no)
    column = Array.new(9)
    9.times do |row_no|
      column[ row_no ] = array[row_no][col_no]
    end
    return column
  end

  #get 3*3 block
  def get_block(array, row, col)
    new_array = Array.new(3, Array.new(3))
    temp_row = row - row % 3
    temp_col = col - col % 3
    3.times do |index|
      new_array[index] = array.slice(temp_row + index).slice(temp_col,3)
    end
    return new_array.flatten
  end

  #validation
  def is_safe?(array, row, col, number)
    column = get_column(array, col)
    block = get_block(array, row, col)
    validate_row = lambda{ |row, number| !array.slice(row).include?(number) }
    validate_col = lambda {|column, number| !column.include?(number) }
    validate_block = lambda { |bock, number| !block.include?(number) }
    if validate_row.call(row, number) and validate_col.call(column, number) and
      validate_block.call(block, number)
      return true
    end
  end

  def fix_values(array)
    store_fix = Hash.new
    array.each_with_index do |cell, r|
      cell.each_with_index do |element, c|
        if !element.zero?
          store_fix.store([r, c], element)
        end
      end
    end
    return store_fix
  end

  def make_editable(array, row, col)
    if !fix_values(array).key?([row, col])
      array[row][col] = 0
    end
  end

  def get_empty(array)
    count = 0
    array.flatten.each do |index|
      if index.zero?
        count += 1
      end
    end
  return count
  end
end

class Player
  def save_entry?(array, row, col)
    save_entries = Hash.new
    save_entries.store(row, col)
  end



  def play_sudoku
    s = Sudoku.new
    puzzle = s.create_puzzle
    s.display_sudoku(puzzle)
    empty_field = s.get_empty(puzzle)
    stored_values = s.fix_values(puzzle)
    #print stored_values
    begin
      while !empty_field.zero?
        print empty_field
        print "Enter row and column (1 to 9)\n"
        input_row = gets.chomp.to_i
        raise "Invalid Position by row\n" if !input_row.between?(1, 9)
        input_col = gets.chomp.to_i
        raise "Invalid Position by column\n" if !input_col.between?(1, 9)
        #s.make_editable(puzzle, input_row - 1, input_col - 1)
        raise "cannot be modified\n" if stored_values.key?([input_row - 1, input_col - 1])
        print "Enter Number (1 to 9)\n"
        number = gets.chomp.to_i
        s.make_editable(puzzle, input_row - 1, input_col - 1)
        raise "Invalid input\n" if !number.between?(1, 9)
        if s.is_safe?(puzzle, input_row - 1, input_col - 1, number)
          puzzle[input_row - 1][input_col - 1] = number
          s.display_sudoku(puzzle)
          empty_field -= 1
        else
          print"Wrong input\n"
          s.display_sudoku(puzzle)
        end
      end
    rescue Exception => e
      print e.message
      retry
    end
  end
end

u = User.new
u.play_sudoku
