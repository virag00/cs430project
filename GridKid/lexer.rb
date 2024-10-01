class Token
  attr_reader :type, :text, :start_index, :end_index

  def initialize(type, text, start_index, end_index)
    @type = type
    @text = text
    @start_index = start_index
    @end_index = end_index
  end

  def to_s
    "(:#{@type}, \"#{@text}\", #{@start_index}, #{@end_index})"
  end
end

class Lexer

  def initialize(code)
    @code = code
    @tokens = []
    @i = 0
    @token_so_far = ''
  end

  def has(target)
    @i < @code.length && @code[@i] == target
  end

  def capture
    @token_so_far += @code[@i]
    @i += 1
  end

  def abandon
    @i += 1
    @token_so_far = ''
  end

  def emit_token(type)
    @tokens.push(Token.new(type, @token_so_far, @i - @token_so_far.length, @i - 1))
    @token_so_far = ''
  end

  def lex
    while @i < @code.length
      if has(' ')
        abandon
      elsif has('(')
        capture
        emit_token(:l_paren)
      elsif  has(')')
        capture
        emit_token(:r_paren)
      elsif has('[')
        capture
        emit_token(:l_bracket)
      elsif has(']')
        capture
        emit_token(:r_bracket)
      elsif has(',')
        capture
        emit_token(:comma)
      elsif has('#')
        capture
        emit_token(:pound)
      elsif has('+')
        capture
        emit_token(:addition)
      elsif has('-')
        tokenize_arithmetic_negation_or_subtraction
      elsif has('*')
        capture
        emit_token(:multiplication)
      elsif has('/')
        capture
        emit_token(:division)
      elsif has('%')
        capture
        emit_token(:modulo)
      elsif has_bitwise_left_shift
        capture
        capture
        emit_token(:l_shift)
      elsif has('<') || has('>')
        tokenize_relational
      elsif has('&') || has('|')
        tokenize_logic_or_bitwise
      elsif has('^')
        capture
        emit_token(:xor)
      elsif has('!')
        capture
        emit_token(:exclamation)
      elsif has('~')
        capture
        emit_token(:bitwise_negate)
      elsif has_digit || has('.')
        tokenize_number_or_float
      elsif has_sum
        capture
        capture
        capture
        emit_token(:sum)
      elsif has_mean
        capture
        capture
        capture
        capture
        emit_token(:mean)
      elsif has_min
        capture
        capture
        capture
        emit_token(:min)
      elsif has_max
        capture
        capture
        capture
        emit_token(:max)
      elsif has_false
        capture
        capture
        capture
        capture
        capture
        emit_token(:false)
      elsif has_float
        capture
        capture
        capture
        capture
        capture
        emit_token(:cast_to_float)
      else
        raise "unexpected #{@code[@i]}"
      end
    end

    @tokens
  end

  private

  def has_digit
    @i < @code.length && ('0'.. '9').include?(@code[@i])
  end

  def has_letter
    @i < @code.length && @code[@i] =~ /[a-zA-Z]/
  end

  def has_sum
    @i + 2 < @code.length && @code[@i, 3] == 'sum'
  end

  def has_mean
    @i + 3 < @code.length && @code[@i, 4] == 'mean'
  end

  def has_min
    @i + 2 < @code.length && @code[@i, 3] == 'min'
  end

  def has_max
    @i + 2 < @code.length && @code[@i, 3] == 'max'
  end

  def has_float
    @i + 4 < @code.length && @code[@i, 5] == 'float'
  end

  def has_false
    @i + 4 < @code.length && @code[@i, 5] == 'false'
  end

  def has_bitwise_left_shift
    @i + 1 < @code.length && @code[@i, 2] == '<<'
  end

  def tokenize_number_or_float
    is_float = false
    while has_digit || (!is_float && has('.'))
      is_float ||= has('.')
      capture
    end
    token_type = is_float ? :float_literal : :integer_literal
    emit_token(token_type)
  end

  def tokenize_relational
    capture
    if has('=')
      if @token_so_far == '<'
        capture
        emit_token(:less_than_or_equal)
      else
        capture
        emit_token(:greater_than_or_equal)
      end
    else
      if @token_so_far == '<'
        emit_token(:less_than)
      else
        emit_token(:greater_than)
      end
    end
  end

  def tokenize_logic_or_bitwise
    capture
    case @token_so_far
    when '&'
      if has('&')
        capture
        emit_token(:logical_and)
      else
        emit_token(:bitwise_and)
      end
    when '|'
      if has('|')
        capture
        emit_token(:logical_or)
      else
        emit_token(:bitwise_or)
      end
    end
  end

  def tokenize_arithmetic_negation_or_subtraction
    capture
    if @tokens.empty? || @tokens.last.type == :l_paren || @tokens.last.type == :comma || @tokens.last.type == :pound
      emit_token(:arithmetic_negation)
    else
      emit_token(:subtraction)
    end
  end
end

# lexer1 = Lexer.new("(5 + 2) * 3 % 4")
# tokens1 = lexer1.lex
# lexer2 = Lexer.new("#[0, 0] + 3")
# tokens2 = lexer2.lex
# lexer3 = Lexer.new("#[1 - 1, 0] < #[1 * 1, 1]")
# tokens3 = lexer3.lex
# lexer4 = Lexer.new("(5 > 3) && !(2 > 8)")
# tokens4 = lexer4.lex
# lexer5 = Lexer.new("1 + sum([0, 0], [2, 1])")
# tokens5 = lexer5.lex
# lexer6 = Lexer.new("float(10) / 4.0")
# tokens6 = lexer6.lex
# puts
# puts tokens1
# puts
# puts tokens2
# puts
# puts tokens3
# puts
# puts tokens4
# puts
# puts tokens5
# puts
# puts tokens6
# puts
