  /****************************************************************************
    Test case for sending a small packet
  ****************************************************************************/ 
  `define EOF_CODE 8'h0D   
  `timescale  1 ns / 1 ns
  module test;
  
  initial 
  begin
  // Wait for resets and initilization of Code value RAM to be over before 
  // transmitting Serial code.
  wait (~tb.rst);
  $display ($time, "\tTEST: Reset Deasserted");
  wait (tb.init_cr);
  wait (tb.done_cr);
  repeat (10) @(posedge tb.clk);
  $display ($time, "\tTEST: Code RAM initialized");
  
  // Transmit ASCII code from serial port to FPGA
  tb.ser_model.write(8'h63); // char c
  tb.ser_model.write(8'h31); // char 1
  tb.ser_model.write(8'h38); // char 8
  tb.ser_model.write(8'h32); // char 2
  tb.ser_model.write(8'h38); // char 8
  tb.ser_model.write(8'h32); // char 2
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h31); // char 1
  tb.ser_model.write(8'h33); // char 3
  tb.ser_model.write(8'h65); // char e
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h31); // char 1
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(8'h30); // char 0
  tb.ser_model.write(`EOF_CODE); // End of file code for file size less than 4K

  wait (tb.lzw_done);
  wait (tb.final_done);
  repeat (20) @(posedge tb.clk);
  #200 $finish;
  end
  
  // Instance top level tb
  tb tb();
  
  endmodule