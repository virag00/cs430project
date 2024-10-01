# Serializer for Expression tree
class Serializer

  # PRIMITIVE SERIALIZATIONS
  ##########################
  # Visit Integer
  def visit_int(node, payload)
    node.value.to_s
  end

  # Visit Float
  def visit_float(node, payload)
    node.value.to_s
  end

  # Visit Boolean
  def visit_bool(node, payload)
    node.value.to_s
  end

  # Visit String
  def visit_str(node, payload)
    node.value.to_s
  end

  # Visit Cell Address
  def visit_cell_addr(node, payload)
    column = node.column.traverse(self, payload)
    row = node.row.traverse(self, payload)
    "#{column}, #{row}"
  end

  # ARITHMETIC SERIALIZATIONS
  ###########################
  # Visit Add
  def visit_add(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} + #{right_val})"
  end

  # Visit Subtract
  def visit_sub(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} - #{right_val})"
  end

  # Visit Multiply
  def visit_mult(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} * #{right_val})"
  end

  # Visit Divide
  def visit_div(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} / #{right_val})"
  end

  # Visit Modulo
  def visit_mod(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} % #{right_val})"
  end

  # Visit Exponentiation
  def visit_pow(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} ** #{right_val})"
  end

  # Visit Negation
  def visit_neg(node, payload)
    "-(#{node.value.traverse(self, payload)})"
  end

  # LOGIC SERIALIZATIONS
  ######################
  # Visit Logical And
  def visit_l_and(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} && #{right_val})"
  end

  # Visit Logical Or
  def visit_l_or(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} || #{right_val})"
  end

  # Visit Logical Not
  def visit_l_not(node, payload)
    "!#{node.value.traverse(self, payload)}"
  end

  # CELL L_VALUE SERIALIZATIONS
  #############################
  # Visit Cell L_Value
  def visit_l_value(node, payload)
    row = node.row.traverse(self, payload)
    column = node.column.traverse(self, payload)
    "[#{row}, #{column}]"
  end

  # CELL R_VALUE SERIALIZATIONS
  #############################
  # Visit Cell R_Value
  def visit_r_value(node, payload)
    row = node.row.traverse(self, payload)
    column = node.column.traverse(self, payload)
    "#[#{row}, #{column}]"
  end

  # BITWISE SERIALIZATION
  #######################
  # Visit Bitwise And
  def visit_b_and(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} & #{right_val})"
  end

  # Visit Bitwise Or
  def visit_b_or(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} | #{right_val})"
  end

  # Visit Bitwise Xor
  def visit_b_xor(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} ^ #{right_val})"
  end

  # Visit Bitwise Not
  def visit_b_not(node, payload)
    "~#{node.value.traverse(self, payload)}"
  end

  # Visit Bitwise Left Shift
  def visit_b_lshift(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} << #{right_val})"
  end

  # Visit Bitwise Right Shift
  def visit_b_rshift(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} >> #{right_val})"
  end

  # RELATION SERIALIZATION
  ########################
  # Visit Equals
  def visit_equals(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} == #{right_val})"
  end

  # Visit NotEquals
  def visit_not_equals(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} != #{right_val})"
  end

  # Visit Less Than
  def visit_less_than(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} < #{right_val})"
  end

  # Visit Less Than or Equal To
  def visit_less_than_equal_to(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} <= #{right_val})"
  end

  # Visit Greater Than
  def visit_greater_than(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} > #{right_val})"
  end

  # Visit Greater Than or Equal To
  def visit_greater_than_equal_to(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "(#{left_val} >= #{right_val})"
  end

  # CASTING SERIALIZATION
  #######################
  # Visit Float to Int
  def visit_float_to_int(node, payload)
    "int(#{node.value.traverse(self, payload)})"
  end

  # Visit Int to Float
  def visit_int_to_float(node, payload)
    "float(#{node.value.traverse(self, payload)})"
  end

  # STATISTICAL SERIALIZATION
  ###########################
  # Visit Max
  def visit_max(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "max(#{left_val}, #{right_val})"
  end

  # Visit Min
  def visit_min(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "min(#{left_val}, #{right_val})"
  end

  # Visit Mean
  def visit_mean(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "mean(#{left_val}, #{right_val})"
  end

  # Visit Sum
  def visit_sum(node, payload)
    left_val = node.left_operand.traverse(self, payload)
    right_val = node.right_operand.traverse(self, payload)
    "sum(#{left_val}, #{right_val})"
  end
end
