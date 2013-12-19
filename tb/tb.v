
`timescale 1ps/1ps
  /****************************************************************************
  Testbench for veifying the LZW implementation
  ****************************************************************************/
module tb ();
  
  wire          tx;                 // Serial transmit data
  wire          ser_recv_done;      // Serial port data receive done
  wire          init_cr;            // Initialize code value RAM
  wire          init_lzw;           // Initialize LZW main state machine
  wire          done_cr;            // Code value RAM initilization done
  wire          lzw_done;           // LZW done with processing all data
  wire          final_done;         // All transactions have finished   
  wire          pwr_up;             // Power up for debug purpose on FPGA
  wire          valid_start_deb;    // Valid start on Rx detected for debug
  wire          rx;                 // Serial receive data
  
  reg           clk;                // System clock
  reg           rst;                // System reset, active high

  /****************************************************************************
   Clock generation logic. Generate 66MHZ clock to match FPGA board clock
  ****************************************************************************/ 
  initial 
  begin
    clk = 1'b0;  
    forever #(7500) clk = ~clk;
  end
  
  /****************************************************************************
   Clock generation logic
  ****************************************************************************/ 
  initial 
  begin
    rst = 1'b1;  
    #89000 rst = 1'b0;
  end
  
  /****************************************************************************
   Instance the block under test
  ****************************************************************************/  
  lzw lzw (
    // Outputs
         .TX              (tx),
         .SER_RECV_DONE   (ser_recv_done),
         .INIT_CR         (init_cr),      
         .INIT_LZW        (init_lzw),     
         .DONE_CR         (done_cr),      
         .LZW_DONE        (lzw_done),     
         .FINAL_DONE      (final_done),     
         .PWR_UP          (pwr_up),     
         .VALID_START_DEB (valid_start_deb),   
    // Inputs            
         .RX              (rx),
         .CLK66           (clk), 
         .RST             (rst)
  );

  /****************************************************************************
   Instance the serial port model
  ****************************************************************************/  
  ser_model ser_model (
    // Outputs
         .sout            (rx),
    // Inputs             
         .sin             (tx),
         .rst             (rst)
  );

endmodule //tb  