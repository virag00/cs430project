require_relative 'serializer.rb'
require_relative 'evaluator.rb'
require_relative 'grid.rb'
require_relative 'runtime.rb'

##############################################

module Primitive
  # Abstration for Integer expressions
  class Integer
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_int(self, payload)
    end

    def to_s
      "Primitive::Integer.new(#{@value})"
    end
  end

  # Abstraction for Float expressions
  class Float
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_float(self, payload)
    end

    def to_s
      "Primitive::Float.new(#{@value})"
    end
  end

  # Abstraction for Boolean expressions
  class Boolean
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_bool(self, payload)
    end

    def to_s
      "Primitive::Boolean.new(#{@value})"
    end
  end

  # Abstraction for String expressions
  class String
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_str(self, payload)
    end
  end

  # Abstraction for Cell Address expressions
  class CellAddress
    attr_reader :column, :row

    def initialize(row, column)
      @column = column
      @row = row
    end

    def traverse(visitor, payload)
      visitor.visit_cell_addr(self, payload)
    end

    def to_s
      "Primitive::CellAddress.new(#{row}, #{column})"
    end
  end
end

##############################################

module Arithmetic
  # Common functionality for Binary Expressions
  class BinaryExpression
    attr_reader :left_operand
    attr_reader :right_operand

    def initialize(left_operand, right_operand)
      @left_operand = left_operand
      @right_operand = right_operand
    end

    def traverse(visitor, payload)
      raise NotImplementedError, "Subclasses must implement the serialize method"
    end
  end

  # Abstraction for Addition expressions
  class Add < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_add(self, payload)
    end

    def to_s
      "Arithmetic::Add.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Subtraction expressions
  class Subtract < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_sub(self, payload)
    end

    def to_s
      "Arithmetic::Subtract.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Multiplication expressions
  class Multiply < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_mult(self, payload)
    end

    def to_s
      "Arithmetic::Multiply.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Division expressions
  class Divide < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_div(self, payload)
    end

    def to_s
      "Arithmetic::Divide.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Modulo expressions
  class Modulo < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_mod(self, payload)
    end

    def to_s
      "Arithmetic::Modulo.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Exponentiation expressions
  class Exponent < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_pow(self, payload)
    end

    def to_s
      "Arithmetic::Exponent.new(\n#{left_operand},\n#{right_operand}})"
    end
  end

  # Abstraction for Negation expressions
  class Negate
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_neg(self, payload)
    end

    def to_s
      "Arithmetic::Negate.new(\n#{value})"
    end
  end
end

##############################################

module Logic
  # Common functionality for Binary Expressions
  class BinaryExpression
    attr_reader :left_operand
    attr_reader :right_operand

    def initialize(left_operand, right_operand)
      @left_operand = left_operand
      @right_operand = right_operand
    end

    def traverse(visitor)
      raise NotImplementedError, "Subclasses must implement the serialize method"
    end
  end

  # Abstraction for Logical And expressions
  class And < BinaryExpression
    def traverse(visitor, payload)
      visitor.visit_l_and(self, payload)
    end

    def to_s
      "Logic::And.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Logical Or expressions
  class Or < BinaryExpression
    def traverse(visitor, payload)
      visitor.visit_l_or(self, payload)
    end

    def to_s
      "Logic::Or.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Logical Not expressions
  class Not
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_l_not(self, payload)
    end

    def to_s
      "Logic::Not.new(\n#{@value})"
    end
  end
end

##############################################

module CellLValues

  # Abstraction for Cell L_Value expressions
  class L_Value
      attr_reader :row, :column

    def initialize(row, column)
      @row = row
      @column = column
    end

    def traverse(visitor, payload)
      visitor.visit_l_value(self, payload)
    end

    def to_s
      "CellLValues::L_Value.new(\n#{@row},\n#{@column})"
    end
  end
end

##############################################

module CellRValues

  # Abstraction for Cell R_Value expressions
  class R_Value
    attr_reader :row, :column

    def initialize(row, column)
      @row = row
      @column = column
    end

    def traverse(visitor, payload)
      visitor.visit_r_value(self, payload)
    end

    def to_s
      "CellRValues::R_Value.new(\n#{@row},\n#{@column})"
    end
  end
end

##############################################

module Bitwise

  # Common functionality for Binary Expressions
  class BinaryExpression
    attr_reader :left_operand
    attr_reader :right_operand

    def initialize(left_operand, right_operand)
      @left_operand = left_operand
      @right_operand = right_operand
    end

    def traverse(visitor, payload)
      raise NotImplementedError, "Subclasses must implement the serialize method"
    end
  end

  class AND < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_b_and(self, payload)
    end

    def to_s
      "Bitwise::AND.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class OR < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_b_or(self, payload)
    end

    def to_s
      "Bitwise::OR.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class XOR < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_b_xor(self, payload)
    end

    def to_s
      "Bitwise::XOR.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class NOT
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_b_not(self, payload)
    end

    def to_s
      "Bitwise::NOT.new(\n#{@value})"
    end
  end

  class LSHIFT < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_b_lshift(self, payload)
    end

    def to_s
      "Bitwise::LSHIFT.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class RSHIFT < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_b_rshift(self, payload)
    end

    def to_s
      "Bitwise::RSHIFT.new(\n#{left_operand},\n#{right_operand})"
    end
  end
end

##############################################

module Relation

  # Common functionality for Binary Expressions
  class BinaryExpression
    attr_reader :left_operand
    attr_reader :right_operand

    def initialize(left_operand, right_operand)
      @left_operand = left_operand
      @right_operand = right_operand
    end

    def traverse(visitor)
      raise NotImplementedError, "Subclasses must implement the serialize method"
    end
  end

  class Equals < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_equals(self, payload)
    end

    def to_s
      "Relation::Equals.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class NotEquals < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_not_equals(self, payload)
    end

    def to_s
      "Relation::NotEquals.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class LessThan < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_less_than(self, payload)
    end

    def to_s
      "Relation::LessThan.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class LessThanOrEqualTo < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_less_than_equal_to(self, payload)
    end

    def to_s
      "Relation::LessThanOrEqualTo.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class GreaterThan < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_greater_than(self, payload)
    end

    def to_s
      "Relation::GreaterThan.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  class GreaterThanOrEqualTo < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_greater_than_equal_to(self, payload)
    end

    def to_s
      "Relation::GreaterThanOrEqualTo.new(\n#{left_operand},\n#{right_operand})"
    end
  end
end

##############################################

module Casting
  # Abstraction for Float to Integer casting
  class FloatToInt
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_float_to_int(self, payload)
    end

    def to_s
      "Casting::FloatToInt.new(\n#{@value})"
    end
  end

  # Abstraction for Integer to Float casting
  class IntToFloat
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def traverse(visitor, payload)
      visitor.visit_int_to_float(self, payload)
    end

    def to_s
      "Casting::IntToFloat.new(\n#{@value})"
    end
  end
end

##############################################

module Statistic

  # Common functionality for Binary Expressions
  class BinaryExpression
    attr_reader :left_operand
    attr_reader :right_operand

    def initialize(left_operand, right_operand)
      @left_operand = left_operand
      @right_operand = right_operand
    end

    def traverse(visitor)
      raise NotImplementedError, "Subclasses must implement the serialize method"
    end
  end

  # Abstraction for Maximum statistical operation
  class Max < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_max(self, payload)
    end

    def to_s
      "Statistic::Max.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Minimum statistical operation
  class Min < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_min(self, payload)
    end

    def to_s
      "Statistic::Min.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Mean statistical operation
  class Mean < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_mean(self, payload)
    end

    def to_s
      "Statistic::Mean.new(\n#{left_operand},\n#{right_operand})"
    end
  end

  # Abstraction for Sum statistical operation
  class Sum < BinaryExpression

    def traverse(visitor, payload)
      visitor.visit_sum(self, payload)
    end

    def to_s
      "Statistic::Sum.new(\n#{left_operand},\n#{right_operand})"
    end
  end
end

##############################################
