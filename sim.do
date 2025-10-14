add wave -position end  sim:/sqrt_seq/clk
add wave -position end  sim:/sqrt_seq/reset
add wave -position end  sim:/sqrt_seq/debut
add wave -position end  sim:/sqrt_seq/A
add wave -position end  sim:/sqrt_seq/Resultat
add wave -position end  sim:/sqrt_seq/count
add wave -position end  sim:/sqrt_seq/fini
add wave -position end  sim:/sqrt_seq/state
add wave -position end  sim:/sqrt_seq/f_state
add wave -position end  sim:/sqrt_seq/reg_A
add wave -position end  sim:/sqrt_seq/reg_R
add wave -position end  sim:/sqrt_seq/reg_R_prev
add wave -position end  sim:/sqrt_seq/s_count
add wave -position 0  sim:/sqrt_seq/nb_bits

force -freeze sim:/sqrt_seq/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/sqrt_seq/reset 0 0
force -freeze sim:/sqrt_seq/debut 1 5, 0 {230 ps} -r 250
force -freeze sim:/sqrt_seq/A 0000000000000000000000000000000000000000001001101110101010001001 0
