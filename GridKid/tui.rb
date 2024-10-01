require_relative 'ast.rb'
require_relative 'evaluator.rb'
require_relative 'serializer.rb'
require_relative 'runtime.rb'
require_relative 'grid.rb'
require_relative 'lexer.rb'
require_relative 'parser.rb'
require 'curses'
include Curses

class TUI
  attr_accessor :cell_vals
  def initialize
    init_screen
    start_color
    noecho
    curs_set(0)
    init_pair(0, COLOR_WHITE, COLOR_BLACK)
    init_pair(1, COLOR_BLACK, COLOR_WHITE)
    init_pair(2, COLOR_WHITE, COLOR_BLUE)
    init_pair(3, COLOR_BLACK, COLOR_YELLOW)
    init_pair(4, COLOR_WHITE, COLOR_RED)
    @height = Curses.lines
    @width = Curses.cols
    @grid_width = @width
    @grid_height = @height / 1.5
    @formula_display_width = @width / 2
    @formula_display_height = @height - @grid_height
    @num_rows = 8
    @num_cols = 8
    @cell_windows = Array.new(@num_rows) { Array.new(@num_cols) }
    @cell_vals = Array.new(@num_rows) { Array.new(@num_cols) }
    @current_row = 0  # Track the current selected row
    @current_col = 0  # Track the current selected column
    @formula
    @display
    @grid
    @payload = Runtime.new(Grid.new)
  end

  def main

    @formula = formula_editor_panel
    @display = display_panel
    @grid = grid_panel

    close_screen
  end

  private

  def formula_editor_panel
    # Create the Formula Editor panel to edit source code when a cell is selected
    formula = Window.new(@height - @formula_display_height, @formula_display_width, @grid_height, 0)
    formula.bkgd(color_pair(3))

    tokens = Lexer.new(@cell_vals[@current_row][@current_col].to_s).lex
    parser = Parser.new(tokens).parse

    formula.setpos(1, 0)
    formula.addstr(parser.to_s)
    formula.refresh
    formula
  end

  def display_panel
    # Create the Display panel containing the cell content's source serialization
    display = Window.new(@height - @formula_display_height, @width - @formula_display_width, @grid_height, @formula_display_width)
    display.bkgd(color_pair(2))
    text = cell_vals[@current_row][@current_col].to_s
    display.setpos(@formula_display_height / 2, (@formula_display_width / 2) - (text.length / 2))
    display.addstr(text)
    display.refresh
    display
  end

  def grid_panel
    # Create the Grid panel containing the modifiable 2D grid
    # Each cell contains only the evaluation of the source code
    grid = Window.new(@grid_height, @grid_width, 0, 0)
    grid.bkgd(color_pair(4))
    grid.refresh
    create_grid_cells(grid)
    loop do
      key = grid.getch
      case key
      when 's'
        move_selection(1, 0)  # Move down
      when 'w'
        move_selection(-1, 0)  # Move up
      when 'a'
        move_selection(0, -1)  # Move left
      when 'd'
        move_selection(0, 1)  # Move right
      when 'E'
        switch_to_edit_mode
        create_grid_cells(grid)
      when 'q'  # 'q' key to exit
        break
      end
    end
    grid
  end

  def create_grid_cells(grid)
    # Define spacing between cells and margin for labels
    spacing = 1
    label_size = 3  # width for row labels and height for column labels

    # Adjust grid dimensions for labels
    net_grid_height = @grid_height - label_size - (spacing * (@num_rows - 1))
    net_grid_width = @grid_width - label_size - (spacing * (@num_cols - 1))

    cell_height = (net_grid_height / @num_rows).to_i
    cell_width = (net_grid_width / @num_cols).to_i

    # Initial top and left offsets for the grid, after the label rows and columns
    initial_top_offset = label_size
    initial_left_offset = label_size

    # Create labels for columns
    column_label_window = Window.new(label_size, @grid_width, 0, 0)
    column_label_window.bkgd(color_pair(4))
    @num_cols.times do |col|
      label_position = initial_left_offset + col * (cell_width + spacing) + (cell_width / 2) - 1
      column_label_window.setpos(1, label_position)
      column_label_window.addstr(col.to_s)
    end
    column_label_window.refresh

    # Create labels for rows
    row_label_window = Window.new(@grid_height, label_size, 0, 0)
    row_label_window.bkgd(color_pair(4))
    @num_rows.times do |row|
      label_position = initial_top_offset + row * (cell_height + spacing) + (cell_height / 2) - 1
      row_label_window.setpos(label_position, 1)
      row_label_window.addstr(row.to_s)
    end
    row_label_window.refresh

    @num_rows.times do |row|
      @num_cols.times do |col|
        # Calculate top and left position including initial offsets and spacing
        top = initial_top_offset + (row * (cell_height + spacing))
        left = initial_left_offset + (col * (cell_width + spacing))

        # Create a window for each cell
        cell_win = Window.new(cell_height, cell_width, top, left)
        cell_win.bkgd(color_pair(1))

        value = cell_vals[row][col]
        if value == nil
          # do nothing with the cell
          cell_win.clear
          cell_win.refresh
        elsif value[0] == '='
          # For cells starting with '=', assume it's a formula
          tokens = Lexer.new(value[1..]).lex  # Skip the '=' when lexing
          parser = Parser.new(tokens).parse

          # Evaluate the parsed expression and update the cell value
          @payload.grid.set_cell(row, col, parser.to_s, parser, @payload)
          result = @payload.grid.cells[row][col].model_primitive
          # Update the cell window to display the evaluated value
          cell_win.setpos(cell_height / 2, cell_width / 4)
          cell_win.addstr(result.to_s)
        else
          # treat the value as a primitive
          tokens = Lexer.new(value).lex
          parser = Parser.new(tokens).parse

          if tokens[0] == :integer_literal && tokens[2] == :false
            cell_win.setpos(cell_height / 2, cell_width / 4)
            cell_win.addstr("Error")
          else
            # Evaluate the parsed expression and update the cell value
            @payload.grid.set_cell(row, col, parser.to_s, parser, @payload)
            result = @payload.grid.cells[row][col].model_primitive

            # Update the cell window to display the evaluated value
            cell_win.setpos(cell_height / 2, cell_width / 4)
            cell_win.addstr(result.to_s)
          end
        end

        cell_win.refresh

        # Store cell window
        @cell_windows[row][col] = cell_win
      end
    end

    # Highlight initial selected cell
    highlight_cell(@current_row, @current_col)
  end

  def highlight_cell(row, col)
    @cell_windows[row][col].bkgd(color_pair(0))  # Reverse video
    @cell_windows[row][col].refresh
  end

  def unhighlight_cell(row, col)
    @cell_windows[row][col].bkgd(color_pair(1))  # Restore original color
    @cell_windows[row][col].refresh
  end

  def move_selection(row_delta, col_delta)
    new_row = @current_row + row_delta
    new_col = @current_col + col_delta

    return if new_row < 0 || new_row >= @num_rows || new_col < 0 || new_col >= @num_cols

    unhighlight_cell(@current_row, @current_col)  # Unhighlight current cell
    @current_row = new_row
    @current_col = new_col
    highlight_cell(@current_row, @current_col)  # Highlight new cell

    # Update the display panel to show the current cell's primitive's if not NULL
    if cell_vals[@current_row][@current_col] == nil
      @display.clear
      @display.refresh
    else
      @display.clear
      text = cell_vals[@current_row][@current_col].to_s
      @display.setpos(@formula_display_height / 2, (@formula_display_width / 2) - (text.length / 2))
      @display.addstr(text)
      @display.refresh
    end

    # Update the Formula Editor to show the current cell's source code
    if cell_vals[@current_row][@current_col] == nil
      @formula.clear
      @formula.refresh
    else
      tokens = Lexer.new(@cell_vals[@current_row][@current_col]).lex
      parser = Parser.new(tokens).parse
      @formula.clear
      @formula.setpos(1, 0)
      @formula.addstr(parser.to_s)
      @formula.refresh
    end
  end

  def switch_to_edit_mode
    # Switch to edit mode by focusing on the formula editor panel
    curs_set(1)
    echo

    # Start loop to get characters
    text = ''
    loop do
      @display.clear
      text.lines.each_with_index do |line|
        @display.setpos(@formula_display_height / 2, @formula_display_width / 6)
        @display.addstr(line)
      end

      c = @display.getch
      if c == 10
        break
      elsif c == 127
        text.chop!
      else
        text += c
      end
    end

    # Reset screen after exiting
    curs_set(0)
    noecho
    if text != ""
        @display.refresh
        @cell_vals[@current_row][@current_col] = text

      # Define spacing between cells and margin for labels
        spacing = 1
        label_size = 3  # width for row labels and height for column labels

      # Adjust grid dimensions for labels
        net_grid_height = @grid_height - label_size - (spacing * (@num_rows - 1))
        net_grid_width = @grid_width - label_size - (spacing * (@num_cols - 1))

        cell_height = (net_grid_height / @num_rows).to_i
        cell_width = (net_grid_width / @num_cols).to_i

      # treat the value as a primitive
        tokens = Lexer.new(text).lex
        parser = Parser.new(tokens).parse

      # Evaluate the parsed expression and update the cell value
        @payload.grid.set_cell(@current_row, @current_col, parser.to_s, parser, @payload)
        result = @payload.grid.cells[@current_row][@current_col].model_primitive
      # Update the cell window to display the evaluated value
        @cell_windows[@current_row][@current_col].setpos(cell_height / 2, cell_width / 4)
        @cell_windows[@current_row][@current_col].addstr(result.to_s)
        @cell_windows[@current_row][@current_col].refresh
    end
  end
end
