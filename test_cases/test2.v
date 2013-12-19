  /****************************************************************************
    Test case for sending a alphabets so that no compression occurs
  ****************************************************************************/ 
  `define EOF_CODE 8'h0D  
  `timescale  1 ns / 1 ns
  module test2;
  
  integer i;
  
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
  tb.ser_model.write(8'h41); // char A
  tb.ser_model.write(8'h42); // char B
  tb.ser_model.write(8'h43); // char C
  tb.ser_model.write(8'h44); // char D
  tb.ser_model.write(8'h45); // char E  
  tb.ser_model.write(8'h46); // char F
  tb.ser_model.write(8'h47); // char G
  tb.ser_model.write(8'h48); // char H
  tb.ser_model.write(8'h49); // char I
  tb.ser_model.write(8'h4a); // char J
  tb.ser_model.write(8'h4b); // char K
  tb.ser_model.write(8'h4c); // char L
  tb.ser_model.write(8'h4d); // char M
  tb.ser_model.write(8'h4e); // char N
  tb.ser_model.write(8'h4f); // char O
  tb.ser_model.write(8'h50); // char P
  tb.ser_model.write(8'h51); // char Q
  tb.ser_model.write(8'h52); // char R
  tb.ser_model.write(8'h53); // char S
  tb.ser_model.write(8'h54); // char T
  tb.ser_model.write(8'h55); // char U
  tb.ser_model.write(8'h56); // char V
  tb.ser_model.write(8'h57); // char W
  tb.ser_model.write(8'h58); // char X
  tb.ser_model.write(8'h59); // char Y
  tb.ser_model.write(8'h5A); // char Z
  tb.ser_model.write(8'h61); // char a
  tb.ser_model.write(8'h62); // char b
  tb.ser_model.write(8'h63); // char c
  tb.ser_model.write(8'h64); // char d
  tb.ser_model.write(8'h65); // char e
  tb.ser_model.write(8'h66); // char f
  tb.ser_model.write(8'h67); // char g
  tb.ser_model.write(8'h68); // char h
  tb.ser_model.write(8'h69); // char i
  tb.ser_model.write(8'h6a); // char j
  tb.ser_model.write(8'h6b); // char k
  tb.ser_model.write(8'h6c); // char l
  tb.ser_model.write(8'h6d); // char m
  tb.ser_model.write(8'h6e); // char n
  tb.ser_model.write(8'h6f); // char o
  tb.ser_model.write(8'h70); // char p
  tb.ser_model.write(8'h71); // char q
  tb.ser_model.write(8'h72); // char r
  tb.ser_model.write(8'h73); // char s
  tb.ser_model.write(8'h74); // char t
  tb.ser_model.write(8'h75); // char u
  tb.ser_model.write(8'h76); // char v
  tb.ser_model.write(8'h77); // char w
  tb.ser_model.write(8'h78); // char x
  tb.ser_model.write(8'h79); // char y
  tb.ser_model.write(8'h7a); // char z


  tb.ser_model.write(`EOF_CODE); // End of file code for file size less than 4K

  wait (tb.lzw_done);
  wait (tb.final_done);
  repeat (20) @(posedge tb.clk);
  #200 $finish;
  end
  
  // Instance top level tb
  tb tb();
  
  endmodule