require_relative 'tui.rb'
tui = TUI.new
tui.cell_vals[0][0] = "5.3"
tui.cell_vals[1][0] = "-4.1"
tui.cell_vals[2][0] = "10.8"
tui.cell_vals[0][1] = "0.0"
tui.cell_vals[1][1] = "-2.5"
tui.cell_vals[2][1] = "4.4"
tui.cell_vals[4][0] = "100"
tui.cell_vals[4][1] = "3"
# #[4, 0] * #[4, 1]
tui.cell_vals[5][0] = "9"
tui.cell_vals[5][1] = "false"
# #[5, 0] << #[5, 1]
# max([0, 0], [2, 1])
# min([0, 0], [2, 1])
# mean([0, 0], [2, 1])
# sum([0, 0], [2, 1])

tui.main
