require_relative 'serializer.rb'
require_relative 'evaluator.rb'
require_relative 'grid.rb'
require_relative 'runtime.rb'
require_relative 'ast.rb'
require_relative 'lexer.rb'
require_relative 'parser.rb'

payload = Runtime.new(Grid.new)

arithmetic = Arithmetic::Modulo.new(
  Arithmetic::Add.new(
    Arithmetic::Multiply.new(Primitive::Integer.new(7), Primitive::Integer.new(4)),
    Primitive::Integer.new(3)
  ),
  Primitive::Integer.new(12)
)

rvalue_shift = Bitwise::LSHIFT.new(
  CellRValues::R_Value.new(
    Primitive::CellAddress.new(
      Arithmetic::Add.new(Primitive::Integer.new(0), Primitive::Integer.new(1)),
      Primitive::Integer.new(1)
    )
  ),
  Primitive::Integer.new(3)
)

rvalue_comparison = Relation::LessThan.new(
  CellRValues::R_Value.new(
    Primitive::CellAddress.new(
      Primitive::Integer.new(1), Primitive::Integer.new(1)
    )
  ),
  CellRValues::R_Value.new(
    Primitive::CellAddress.new(
      Primitive::Integer.new(2), Primitive::Integer.new(1)
    )
  )
)

logic_comparison = Logic::Not.new(
  Relation::GreaterThan.new(
    Primitive::Float.new(3.3), Primitive::Float.new(3.2)
  )
)

sum = Statistic::Sum.new(
  CellLValues::L_Value.new(
    Primitive::CellAddress.new(
      Primitive::Integer.new(1), Primitive::Integer.new(1)
    )
  ),
  CellLValues::L_Value.new(
    Primitive::CellAddress.new(
      Primitive::Integer.new(2), Primitive::Integer.new(1)
    )
  )
)

casting = Arithmetic::Divide.new(
  Casting::IntToFloat.new(Primitive::Integer.new(7)),
  Primitive::Integer.new(2)
)

cell_addr_1 = Primitive::CellAddress.new(Primitive::Integer.new(1), Primitive::Integer.new(1))
cell_addr_2 = Primitive::CellAddress.new(Primitive::Integer.new(2), Primitive::Integer.new(1))
cell_addr_3 = Primitive::CellAddress.new(Primitive::Integer.new(3), Primitive::Integer.new(1))
cell_addr_4 = Primitive::CellAddress.new(Primitive::Integer.new(4), Primitive::Integer.new(1))
cell_addr_5 = Primitive::CellAddress.new(Primitive::Integer.new(5), Primitive::Integer.new(1))
cell_addr_6 = Primitive::CellAddress.new(Primitive::Integer.new(6), Primitive::Integer.new(1))

payload.grid.set_cell(cell_addr_1, arithmetic.to_s, arithmetic, payload)
payload.grid.set_cell(cell_addr_2, rvalue_shift.to_s, rvalue_shift, payload)
payload.grid.set_cell(cell_addr_3, rvalue_comparison.to_s, rvalue_comparison, payload)
payload.grid.set_cell(cell_addr_4, logic_comparison.to_s, logic_comparison, payload)
payload.grid.set_cell(cell_addr_5, sum.to_s, sum, payload)
payload.grid.set_cell(cell_addr_6, casting.to_s, casting, payload)

puts ()
puts (payload.grid.get_cell_text(cell_addr_1))
puts (payload.grid.get_cell_value(cell_addr_1))
puts ()
puts (payload.grid.get_cell_text(cell_addr_2))
puts (payload.grid.get_cell_value(cell_addr_2))
puts ()
puts (payload.grid.get_cell_text(cell_addr_3))
puts (payload.grid.get_cell_value(cell_addr_3))
puts ()
puts (payload.grid.get_cell_text(cell_addr_4))
puts (payload.grid.get_cell_value(cell_addr_4))
puts ()
puts (payload.grid.get_cell_text(cell_addr_5))
puts (payload.grid.get_cell_value(cell_addr_5))
puts ()
puts (payload.grid.get_cell_text(cell_addr_6))
puts (payload.grid.get_cell_value(cell_addr_6))
puts ()

lexer1 = Lexer.new("(5 + 2) * 3 % 4")
tokens1 = lexer1.lex

lexer2 = Lexer.new("#[0, 0] + 3")
tokens2 = lexer2.lex

lexer3 = Lexer.new("#[1 - 1, 0] < #[1 * 1, 1]")
tokens3 = lexer3.lex

lexer4 = Lexer.new("(5 > 3) && !(2 > 8)")
tokens4 = lexer4.lex

lexer5 = Lexer.new("1 + sum([0, 0], [2, 1])")
tokens5 = lexer5.lex

lexer6 = Lexer.new("float(10) / 4.0")
tokens6 = lexer6.lex

puts
puts tokens1
puts
puts tokens2
puts
puts tokens3
puts
puts tokens4
puts
puts tokens5
puts
puts tokens6
puts
