  
  vlog ../test_cases/test.v \
       ../tb/tb.v \
       ../rtl/timescale.v \
       ../rtl/lzw.v \
       ../rtl/lzw_ctrl.v \
       ../rtl/lzw_enc.v \
       ../rtl/top_ctrl.v \
       ../rtl/code_value_ram.v \
       ../rtl/hash.v \
       ../rtl/dictionary_ram.v \
       ../rtl/ser.v \
       ../rtl/io_ram.v \
       ../rtl/prefix_code_ram.v \
       ../rtl/append_char_ram.v \
       ../rtl/outreg.v \
       ../models/ser_model.v \
       C:/Xilinx/14.7/ISE_DS/ISE/verilog/src/glbl.v \
       -y C:/Xilinx/14.7/ISE_DS/ISE/verilog/src/unisims +libext+.v
  
  vsim work.test
  do wave.do
  run -all