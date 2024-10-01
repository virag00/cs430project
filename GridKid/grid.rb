class Grid
  attr_accessor :cells
  Cell = Struct.new(:source_code, :abstract_syntax_tree, :model_primitive, :model_text, :row, :column)

  def initialize(rows = 8, cols = 8)
    @rows = rows
    @cols = cols
    @cells = Array.new(rows) { Array.new(cols) }
  end

  # Setter: Accepts a cell address and an abstract syntax tree to store at that cell.
  def set_cell(row, column, source_code, abstract_syntax_tree, payload)
    model_primitive = evaluate_tree(abstract_syntax_tree, payload)
    model_text = serialize_tree(abstract_syntax_tree, payload)
    @cells[row][column] = Cell.new(source_code, abstract_syntax_tree, model_primitive, model_text, row, column)
  end

  # Getter: Accepts an address and returns the cell's model primitive.
  def get_cell_value(row, column)
    cell = @cells[row.to_i][column.to_i]
    raise ArgumentError, "Cell not defined at (#{row}, #{column})" unless cell

    cell.model_primitive
  end

  # Getter: Accepts an address and returns the cell's serialization.
  def get_cell_text(row, column)
    cell = @cells[row][column]
    raise ArgumentError, "Cell not defined at (#{row}, #{column})" unless cell

    cell.model_text
  end

  # Function to get CellAddress based on column and row
  def get_cell_address(row, column)
    return nil unless valid_address?(row, column)

    cell_addr = Primitive::CellAddress.new(row, column)
    cell_addr
  end

  # Function to get cell addresses between two given addresses
  def get_cells_between(start_addr, end_addr)

    # Collect cell addresses between start and end addresses
    cell_addresses_between = []
    (start_addr.row..end_addr.row).each do |row|
      (start_addr.column..end_addr.column).each do |column|
        cell_addresses_between << @cells[row][column]
      end
    end

    cell_addresses_between
  end

  private

  # Helper method to evaluate the abstract syntax tree and return the model primitive.
  def evaluate_tree(tree, payload)
    evaluate = Evaluator.new
    tree.traverse(evaluate, payload)
  end

  # Helper method to serialize the abstract syntax tree and return the source code.
  def serialize_tree(tree, payload)
    serialize = Serializer.new
    tree.traverse(serialize, nil)
  end

  # Helper method to check if a given address is valid within the grid dimensions.
  def valid_address?(row, column)
    row.between?(0, @rows - 1) && column.between?(0, @cols - 1)
  end
end
