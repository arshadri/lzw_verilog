onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider tb
add wave -noupdate -format Logic /test2/tb/tx
add wave -noupdate -format Logic /test2/tb/rx
add wave -noupdate -format Logic /test2/tb/clk
add wave -noupdate -format Logic /test2/tb/init_cr
add wave -noupdate -format Logic /test2/tb/done_cr
add wave -noupdate -format Logic /test2/tb/ser_recv_done
add wave -noupdate -format Logic /test2/tb/init_lzw
add wave -noupdate -format Logic /test2/tb/lzw_done
add wave -noupdate -format Logic /test2/tb/final_done
add wave -noupdate -divider lzw
add wave -noupdate -format Logic /test2/tb/lzw/TX
add wave -noupdate -format Logic /test2/tb/lzw/RX
add wave -noupdate -format Logic /test2/tb/lzw/sout
add wave -noupdate -format Logic /test2/tb/lzw/sin
add wave -noupdate -format Logic /test2/tb/lzw/clk
add wave -noupdate -format Logic /test2/tb/lzw/rst_n
add wave -noupdate -format Logic /test2/tb/lzw/ena_ioram
add wave -noupdate -format Logic /test2/tb/lzw/enb_ioram
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/rcv_byte
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_byte
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/char_in
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/xmt_byte
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/addra_ioram
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/addrb_ioram
add wave -noupdate -format Logic /test2/tb/lzw/rcv_done
add wave -noupdate -format Logic /test2/tb/lzw/xmt_done
add wave -noupdate -format Logic /test2/tb/lzw/init_cr
add wave -noupdate -format Logic /test2/tb/lzw/init_lzw
add wave -noupdate -format Logic /test2/tb/lzw/done_cr
add wave -noupdate -format Logic /test2/tb/lzw/lzw_done
add wave -noupdate -format Logic /test2/tb/lzw/start_xmt
add wave -noupdate -format Logic /test2/tb/lzw/wea_ioram
add wave -noupdate -format Logic /test2/tb/lzw/web_ioram
add wave -noupdate -divider ser
add wave -noupdate -format Logic /test2/tb/lzw/ser/sclk
add wave -noupdate -format Logic /test2/tb/ser_model/sclk
add wave -noupdate -format Logic /test2/tb/lzw/ser/start_xmt
add wave -noupdate -format Logic /test2/tb/lzw/ser/tc_xmt_cnt
add wave -noupdate -format Logic -radix unsigned /test2/tb/lzw/ser/tc_xmt_cnt16
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/ser/xmt_byte
add wave -noupdate -format Literal /test2/tb/lzw/ser/xmt_cnt
add wave -noupdate -format Literal /test2/tb/lzw/ser/xmt_cnt16
add wave -noupdate -format Logic /test2/tb/lzw/ser/xmt_done
add wave -noupdate -format Logic /test2/tb/lzw/ser/xmt_done_s
add wave -noupdate -format Logic /test2/tb/lzw/ser/xmt_done_ss
add wave -noupdate -format Logic /test2/tb/lzw/ser/ld_data
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/ser/bout
add wave -noupdate -format Logic /test2/tb/lzw/ser/tc_rcv_cnt
add wave -noupdate -format Logic /test2/tb/lzw/ser/tc_rcv_cnt16
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/ser/rcv_byte
add wave -noupdate -format Logic /test2/tb/lzw/ser/rcv_done
add wave -noupdate -format Logic /test2/tb/lzw/ser/rcv_done_s
add wave -noupdate -format Logic /test2/tb/lzw/ser/rcv_done_ss
add wave -noupdate -format Logic /test2/tb/lzw/ser/ars_done
add wave -noupdate -format Logic /test2/tb/lzw/ser/ars_done1
add wave -noupdate -format Logic /test2/tb/lzw/ser/ars_done2
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/ser/ars_byte
add wave -noupdate -divider top_ctrl
add wave -noupdate -format Literal -radix ascii /test2/tb/lzw/top_ctrl/st_string
add wave -noupdate -format Logic /test2/tb/lzw/top_ctrl/tc_ioractr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/top_ctrl/addr_cntr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/top_ctrl/addr_outcntr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/top_ctrl/outram_cnt
add wave -noupdate -format Logic /test2/tb/lzw/top_ctrl/tc_outractr
add wave -noupdate -divider ioram
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/clk
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/rst_n
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/rst
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_dataa
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/wr_porta
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/en_porta
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/addra
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/wr_dataa
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/en_a
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/wr_portb
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/io_ram/en_portb
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/addrb
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/wr_datab
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/en_b
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab0
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab1
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab2
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab3
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab4
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab5
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab6
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab7
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_dataa_r
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/io_ram/rd_datab_r
add wave -noupdate -divider lzw_enc
add wave -noupdate -divider code_value_ram
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/clk
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/rst_n
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/rst
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/en_a
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/wr_porta
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/en_porta
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/addra
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/wr_dataa
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/rd_dataa
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/en_portb
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/wr_portb
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/addrb
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/code_value_ram/wr_datab
add wave -noupdate -divider {prefix ram}
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/rd_data
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/wren
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/en
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/addr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/wr_data
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/rd_data_r
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/en_porta_r
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/rd_data0
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/prefix_code_ram/ram_en
add wave -noupdate -divider {append_char ram}
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/append_char_ram/addr
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/append_char_ram/en
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/append_char_ram/wr_data
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/dictionary_ram/append_char_ram/wren
add wave -noupdate -divider lzw_ctrl
add wave -noupdate -format Literal -radix ascii /test2/tb/lzw/lzw_enc/lzw_ctrl/st_string
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/lzw_ctrl/addrb_ioram
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/inc_ioraddr
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/ena_cvram
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/done_cr
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/lzw_done
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/tc_ioractr
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/tc_cvactr
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/tc_outractr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/lzw_ctrl/addr_cntr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/lzw_ctrl/addrb_cvram
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/lzw_ctrl/addrb_ioram
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/done_lzw_st
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/match
add wave -noupdate -divider hash
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/addr
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/addr_save
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/append_data
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/char_in
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/cmp_append_char
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/cmp_prefix_data
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/collis
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/gen_hash
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/gen_hash_s
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/hash/gen_hash_ss
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/index
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/match
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/not_in_mem
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/lzw_ctrl/in_code_mem
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/prefix_data
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/recal_hash
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/shift_char
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/string_data
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/hash/string_reg
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/hash/mux_code_val
add wave -noupdate -divider outreg
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/write_data
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/outreg/write_sp
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/outreg/valid_dcnt
add wave -noupdate -format Literal -radix unsigned /test2/tb/lzw/lzw_enc/outreg/datain_cnt
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/prefix_data
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/read_data
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/shift_reg
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/lzw_byte
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/outreg/tc_outreg
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/outreg/flush
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/outreg/up_low
add wave -noupdate -format Logic /test2/tb/lzw/lzw_enc/outreg/up_low_r
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/ars
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outreg/ars1
add wave -noupdate -divider outram
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/clk
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/en_a
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/en_porta
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/addra
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/wr_dataa
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/rd_dataa
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/wr_porta
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/en_b
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/en_portb
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/addrb
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/rd_datab
add wave -noupdate -format Literal -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/wr_datab
add wave -noupdate -format Logic -radix hexadecimal /test2/tb/lzw/lzw_enc/outram/wr_portb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1131810000 ps} 0} {{Cursor 2} {360731127867 ps} 0} {{Cursor 3} {4696867500 ps} 0}
WaveRestoreZoom {1538515416 ps} {1543128136 ps}
configure wave -namecolwidth 244
configure wave -valuecolwidth 117
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
