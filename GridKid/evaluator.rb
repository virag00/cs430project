require_relative 'runtime.rb'

# Evaluator for Expression tree
class Evaluator

  # PRIMITIVE EVALUATIONS
  #######################
  # Evaluate Integer
  def visit_int(node, payload)
    node.value.to_i
  end

  # Evaluate Float
  def visit_float(node, payload)
    node.value.to_f
  end

  # Evaluate Boolean
  def visit_bool(node, payload)
    (node.value == true) ? true : false
  end

  # Evaluate String
  def visit_str(node, payload)
    node.value
  end

  # Evaluate Cell Address
  def visit_cell_addr(node, payload)
    col = node.column.traverse(self, payload)
    row = node.row.traverse(self, payload)

    payload.grid.get_cell_address(row, col)
  end

  # ARITHMETIC EVALUATIONS
  ########################
  # Evaluate Add
  def visit_add(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    # Type checking
    # unless left_val.is_a?(Numeric) && right_val.is_a?(Numeric)
    #  raise TypeError, "Addition requires numeric operands"
    # end

    left_val + right_val
  end

  # Evaluate Subtract
  def visit_sub(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    # Type checking
    # unless left_val.is_a?(Numeric) && right_val.is_a?(Numeric)
    #   raise TypeError, "Subtraction requires numeric operands"
    # end

    left_val - right_val
  end

  # Evaluate Multiply
  def visit_mult(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    # Type checking
    # unless left_val.is_a?(Numeric) && right_val.is_a?(Numeric)
    #   raise TypeError, "Multiplication requires numeric operands"
    # end

    product = left_val * right_val
    product
  end

  # Evaluate Divide
  def visit_div(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    # Type checking
    unless left_val.is_a?(Numeric) && right_val.is_a?(Numeric)
      raise TypeError, "Division requires numeric operands"
    end

    left_val / right_val
  end

  # Evaluate Modulo
  def visit_mod(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    # Type checking
    # unless left_val.is_a?(Numeric) && right_val.is_a?(Numeric)
    #   raise TypeError, "Modulo requires numeric operands"
    # end

    remainder = left_val % right_val
    remainder.to_i
  end

  # Evaluate Exponentiation
  def visit_pow(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    # Type checking
    unless left_val.is_a?(Numeric) && right_val.is_a?(Numeric)
      raise TypeError, "Exponentiation requires numeric operands"
    end

    left_val ** right_val
  end

  # Evaluate Negation
  def visit_neg(node, payload)
    value = node.value.traverse(self, payload)

    # Type checking
    # unless value.is_a?(Numeric)
    #   raise TypeError, "Subtraction requires numeric operands"
    # end

    -value
  end

  # LOGIC EVALUATIONS
  ###################
  # Evaluate Logical And
  def visit_l_and(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    unless [true, false].include?(left_val) && [true, false].include?(right_val)
      raise TypeError, "Logical AND requires boolean operands"
    end

    left_val && right_val
  end

  # Evaluate Logical Or
  def visit_l_or(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)

    unless [true, false].include?(left_val) && [true, false].include?(right_val)
      raise TypeError, "Logical OR requires boolean operands"
    end

    left_val || right_val
  end

  # Evaluate Logical Not
  def visit_l_not(node, payload)
    result = node.value.traverse(self, payload)

    unless [true, false].include?(result)
      warn TypeError, "Logical NOT requires boolean value"
    end

    !result
  end

  # CELL L_VALUE EVALUATION
  #########################
  def visit_l_value(node, payload)
    row = node.row.traverse(self, payload)
    column = node.column.traverse(self, payload)

    payload.grid.get_cell_address(row, column)
  end

  # CELL R_VALUE EVALUATION
  #########################
  def visit_r_value(node, payload)
    row = node.row.traverse(self, payload)
    column = node.column.traverse(self, payload)

    payload.grid.get_cell_value(row, column)
  end

  # BITWISE EVALUATIONS
  #####################
  # Evaluate Bitwise And
  def visit_b_and(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    binary_representation = left_val & right_val
    binary_representation.to_s(2).to_i
  end

  # Evaluate Bitwise Or
  def visit_b_or(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    binary_representation = left_val | right_val
    binary_representation.to_s(2).to_i
  end

  # Evaluate Bitwise Xor
  def visit_b_xor(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    binary_representation = left_val ^ right_val
    binary_representation.to_s(2).to_i
  end

  # Evaluate Bitwise Not
  def visit_b_not(node, payload)
    binary_representation = ~node.value.traverse(self, payload)
    binary_representation.to_s(2).to_i
  end

  # Evaluate Bitwise Left Shift
  def visit_b_lshift(node, payload)
    def visit_b_lshift(node, payload)
      left_val = node.left_operand.traverse(self, payload)
      right_val = node.right_operand.traverse(self, payload)
      valid = true
      left_val.is_a?(Numeric) ? valid = true : valid = false

      right_val.is_a?(Numeric) ? valid = true : valid = false

      if valid == true
        binary_representation = left_val << right_val
        binary_representation.to_s.to_i
      else
        "Error"
      end
    end
  end

  # Evaluate Bitwise Right Shift
  def visit_b_rshift(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    binary_representation = left_val >> right_val
    binary_representation.to_s(2).to_i
  end

  # RELATION EVALUATIONS
  ######################
  # Evaluate Equals
  def visit_equals(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    left_val == right_val
  end

  # Evaluate NotEquals
  def visit_not_equals(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    left_val != right_val
  end

  # Evaluate Less Than
  def visit_less_than(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    left_val < right_val
  end

  # Evaluate Less Than or Equal To
  def visit_less_than_equal_to(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    left_val <= right_val
  end

  # Evaluate Greater Than
  def visit_greater_than(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    left_val > right_val
  end

  # Evaluate Greater Than or Equal To
  def visit_greater_than_equal_to(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    left_val >= right_val
  end

  # CASTING EVALUATION
  ####################
  # Evaluate Float to Int
  def visit_float_to_int(node, payload)
    node.value.traverse(self, payload).to_i
  end

  # Evaluate Int to Float
  def visit_int_to_float(node, payload)
    node.value.traverse(self, payload).to_f
  end

  # STATISTICAL EVALUATION
  ########################
  # Evaluate Max
  def visit_max(node, payload)
    left_addr = node.left_operand.traverse(self, payload)
    right_addr = node.right_operand.traverse(self, payload)

    cells_between = payload.grid.get_cells_between(left_addr, right_addr)

    max_value = -Float::INFINITY

    # Iterate over cells between the specified range
    cells_between.each do |cell_address|
      cell_value = payload.grid.get_cell_value(cell_address.row, cell_address.column)
      max_value = cell_value if cell_value.is_a?(Numeric) && cell_value > max_value
    end

    max_value
  end

  # Evaluate Min
  def visit_min(node, payload)
    left_addr = node.left_operand.traverse(self, payload)
    right_addr = node.right_operand.traverse(self, payload)

    cells_between = payload.grid.get_cells_between(left_addr, right_addr)

    min_value = Float::INFINITY

    # Iterate over cells between the specified range
    cells_between.each do |cell_address|
      cell_value = payload.grid.get_cell_value(cell_address.row, cell_address.column)
      min_value = cell_value if cell_value.is_a?(Numeric) && cell_value < min_value
    end

    min_value
  end

  # Evaluate Mean
  def visit_mean(node, payload)
    left_addr = node.left_operand.traverse(self, payload)
    right_addr = node.right_operand.traverse(self, payload)

    cells_between = payload.grid.get_cells_between(left_addr, right_addr)

    i = 0
    mean_result = cells_between.reduce(0) do |total, cell_address|
      cell_value = payload.grid.get_cell_value(cell_address.row, cell_address.column)
      i = i + 1
      total + (cell_value.is_a?(Numeric) ? cell_value : 0)
    end

    mean_result / i
  end

  # Evaluate Sum
  def visit_sum(node, payload)
    left_addr = node.left_operand.traverse(self, payload)
    right_addr = node.right_operand.traverse(self, payload)

    # Validate if the values are Numeric
    # unless left_value.is_a?(Numeric) && right_value.is_a?(Numeric)
    #   raise TypeError, "Sum requires numeric operands"
    # end

    # Retrieve cell addresses between left and right addresses
    cells_between = payload.grid.get_cells_between(left_addr, right_addr)

    # Sum the Numeric values contained between the two operand cell addresses
    sum_result = cells_between.reduce(0) do |sum, cell_address|
      cell_value = payload.grid.get_cell_value(cell_address.row, cell_address.column)
      sum + (cell_value.is_a?(Numeric) ? cell_value : 0)
    end

    sum_result
  end
end
