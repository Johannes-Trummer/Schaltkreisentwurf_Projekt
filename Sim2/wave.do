onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/top/datapath/rst
add wave -noupdate /testbench/top/datapath/clk
add wave -noupdate /testbench/top/datapath/modulo_start_i
add wave -noupdate /testbench/top/datapath/start_i
add wave -noupdate -radix unsigned /testbench/top/datapath/Zahl1_i
add wave -noupdate -radix unsigned /testbench/top/datapath/Zahl2_i
add wave -noupdate -radix unsigned /testbench/top/datapath/alu_mode_i
add wave -noupdate /testbench/top/datapath/wren_zw_gross
add wave -noupdate /testbench/top/datapath/wren_zw_klein
add wave -noupdate /testbench/top/datapath/wren_zw_in_zahlen
add wave -noupdate /testbench/top/datapath/wren_erg_modulo
add wave -noupdate /testbench/top/datapath/wren_Zahl
add wave -noupdate /testbench/top/datapath/wren_to_new_numbers
add wave -noupdate /testbench/top/datapath/Zahl1_to_alu_a
add wave -noupdate /testbench/top/datapath/Zahl2_to_alu_b
add wave -noupdate /testbench/top/datapath/check_for_termination_i
add wave -noupdate /testbench/top/datapath/valid_o
add wave -noupdate -radix unsigned /testbench/top/datapath/ergebnis
add wave -noupdate /testbench/top/datapath/modulo_ready_o
add wave -noupdate /testbench/top/datapath/alu_a_temp
add wave -noupdate /testbench/top/datapath/alu_b_temp
add wave -noupdate /testbench/top/datapath/wbb
add wave -noupdate /testbench/top/datapath/alu_c_r
add wave -noupdate /testbench/top/datapath/alu_c
add wave -noupdate -radix unsigned /testbench/top/datapath/Zahl1_r
add wave -noupdate -radix unsigned /testbench/top/datapath/Zahl2_r
add wave -noupdate -radix unsigned /testbench/top/datapath/Zahl1_temp
add wave -noupdate -radix unsigned /testbench/top/datapath/Zahl2_temp
add wave -noupdate -radix unsigned /testbench/top/datapath/erg_modulo_temp
add wave -noupdate -radix unsigned /testbench/top/datapath/erg_modulo_r
add wave -noupdate -radix unsigned /testbench/top/datapath/erg_zuvor_temp
add wave -noupdate -radix unsigned /testbench/top/datapath/erg_zuvor_r
add wave -noupdate -radix unsigned /testbench/top/datapath/zwischen_gross_temp
add wave -noupdate -radix unsigned /testbench/top/datapath/zwischen_gross_r
add wave -noupdate -radix unsigned /testbench/top/datapath/zwischen_klein_temp
add wave -noupdate -radix unsigned /testbench/top/datapath/zwischen_klein_r
add wave -noupdate /testbench/top/datapath/start_r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1435 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 388
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {7716 ps} {7804 ps}
