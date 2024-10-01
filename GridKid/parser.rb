require_relative 'lexer.rb'
require_relative 'ast.rb'

class Parser
  def initialize(tokens)
    @tokens = tokens
    @current = 0
  end

  def parse
    expression
  end

  def advance
    current_token = @tokens[@current]
    @current += 1 unless @current >= @tokens.length
    current_token
  end

  def has(type)
    return false if @current >= @tokens.length
    @tokens[@current].type == type
  end

  def expression
    logical
  end

  def logical
    left = relational
    while has(:logical_and) || has(:logical_or)
      if has(:logical_and)
        advance
        right = relational
        left = Logic::And.new(left, right)
      elsif has(:logical_or)
        advance
        right = relational
        left = Logic::Or.new(left, right)
      end
    end
    return left
  end

  def relational
    left = bitwise
    while has(:equal) || has(:not_equal) || has(:less_than) || has(:less_than_or_equal) || has(:greater_than) || has(:greater_than_or_equal)
      if has(:equal)
        advance
        right = bitwise
        left = Relation::Equals.new(left, right)
      elsif has(:not_equal)
        advance
        right = bitwise
        left = Relation::NotEquals.new(left, right)
      elsif has(:less_than)
        advance
        right = bitwise
        left = Relation::LessThan.new(left, right)
      elsif has(:less_than_or_equal)
        advance
        right = bitwise
        left = Relation::LessThanOrEqualTo.new(left, right)
      elsif has(:greater_than)
        advance
        right = bitwise
        left = Relation::GreaterThan.new(left, right)
      elsif has(:greater_than_or_equal)
        advance
        right = bitwise
        left = Relation::GreaterThanOrEqualTo.new(left, right)
      end
    end
    return left
  end

  def bitwise
    left = additive
    while has(:bitwise_and) || has(:bitwise_or) || has(:xor) || has(:l_shift) || has(:r_shift)
      if has(:bitwise_and)
        advance
        right = additive
        left = Bitwise::AND.new(left, right)
      elsif has(:bitwise_or)
        advance
        right = additive
        left = Bitwise::OR.new(left, right)
      elsif has(:xor)
        advance
        right = additive
        left = Bitwise::XOR.new(left, right)
      elsif has(:l_shift)
        advance
        right = additive
        left = Bitwise::LSHIFT.new(left, right)
      elsif has(:r_shift)
        advance
        right = additive
        left = Bitwise::RSHIFT.new(left, right)
      end
    end
    return left
  end

  def additive
    left = multiplicative
    while has(:addition) || has(:subtraction)
      if has(:addition)
        advance
        right = multiplicative
        left = Arithmetic::Add.new(left, right)
      elsif has(:subtraction)
        advance
        right = multiplicative
        left = Arithmetic::Subtract.new(left, right)
      end
    end
    return left
  end

  def multiplicative
    left = exponentiation
    while has(:multiplication) || has(:division) || has(:modulo)
      if has(:multiplication)
        advance
        right = exponentiation
        left = Arithmetic::Multiply.new(left, right)
      elsif has(:division)
        advance
        right = exponentiation
        left = Arithmetic::Divide.new(left, right)
      elsif has(:modulo)
        advance
        right = exponentiation
        left = Arithmetic::Modulo.new(left, right)
      end
    end
    return left
  end

  def exponentiation
    right = unary
    if has(:exponent)
      advance
      left = unary
      right = Arithmetic::Exponent.new(left, right)
    end
    return right
  end

  def unary
    if has(:exclamation)
      advance
      right = unary
      Logic::Not.new(right)
    elsif has(:arithmetic_negation)
      advance
      right = unary
      Arithmetic::Negate.new(right)
    else
      primary
    end
  end

  def primary
    if has(:integer_literal)
      token = advance
      Primitive::Integer.new(token.text)
    elsif has(:float_literal)
      token = advance
      Primitive::Float.new(token.text)
    elsif has(:false)
      token = advance
      Primitive::Boolean.new(token.text)
    elsif has(:l_paren)
      advance
      ast = expression
      raise "Missing ')'" if !has(:r_paren)
      advance
      ast
    elsif has(:pound)
      advance
      raise "Missing '['" if !has(:l_bracket)
      advance
      left = expression
      raise "Missing ','" if !has(:comma)
      advance
      right = expression
      raise "Missing ']'" if !has(:r_bracket)
      advance
      CellRValues::R_Value.new(left, right)
    elsif has(:l_bracket)
      advance
      left = expression
      raise "Missing ','" if !has(:comma)
      advance
      right = expression
      raise "Missing ']'" if !has(:r_bracket)
      advance
      CellLValues::L_Value.new(left, right)
    elsif has(:max)
      advance
      raise "Missing '('" if !has(:l_paren)
      advance
      left = expression
      raise "Missing ','" if !has(:comma)
      advance
      right = expression
      raise "Missing ')'" if !has(:r_paren)
      advance
      Statistic::Max.new(left, right)
    elsif has(:min)
      advance
      raise "Missing '('" if !has(:l_paren)
      advance
      left = expression
      raise "Missing ','" if !has(:comma)
      advance
      right = expression
      raise "Missing ')'" if !has(:r_paren)
      advance
      Statistic::Min.new(left, right)
    elsif has(:mean)
      advance
      raise "Missing '('" if !has(:l_paren)
      advance
      left = expression
      raise "Missing ','" if !has(:comma)
      advance
      right = expression
      raise "Missing ')'" if !has(:r_paren)
      advance
      Statistic::Mean.new(left, right)
    elsif has(:sum)
      advance
      raise "Missing '('" if !has(:l_paren)
      advance
      left = expression
      raise "Missing ','" if !has(:comma)
      advance
      right = expression
      raise "Missing ')'" if !has(:r_paren)
      advance
      Statistic::Sum.new(left, right)
    elsif has(:cast_to_float)
      advance
      raise "Missing '('" if !has(:l_paren)
      advance
      ast = expression
      raise "Missing ')'" if !has(:r_paren)
      advance
      Casting::IntToFloat.new(ast)
    else
      raise "Unexpected issue in primary"
    end
  end
end

# lexer = Lexer.new("(5 + 2) * 3 % 4")
# tokens = lexer.lex
# puts Parser.new(tokens).parse
# puts
# lexer2 = Lexer.new("#[0, 0] + 3")
# tokens2 = lexer2.lex
# puts Parser.new(tokens2).parse
# puts
# lexer3 = Lexer.new("#[1 - 1, 0] < #[1 * 1, 1]")
# tokens3 = lexer3.lex
# puts Parser.new(tokens3).parse
# puts
# lexer4 = Lexer.new("(5 > 3) && !(2 > 8)")
# tokens4 = lexer4.lex
# puts Parser.new(tokens4).parse
# puts
# lexer5 = Lexer.new("1 + sum([0 , 0], [2 , 1])")
# tokens5 = lexer5.lex
# puts Parser.new(tokens5).parse
# puts
# lexer6 = Lexer.new("float(10) / 4.0")
# tokens6 = lexer6.lex
# puts Parser.new(tokens6).parse
# puts
