 
  /****************************************************************************
    A model of the serial interface of the PIC which interfaces to the FPGA
    Does not model any error conditions or handling.
    By default runs at 9600 Baud rate
  ****************************************************************************/
module ser (
  // Outputs
       sout,                   // To iopads
       rcv_byte,               // To io_ram
       rcv_done,               // To top_ctrl
       xmt_done,               // To top_ctrl
       vld_str_deb,            // To iopads
  // Inputs		
       sin,                    // From iopads
       start_xmt,              // From top_ctrl
       xmt_byte,               // From io_ram
       rst_n,	               // From iopads
       clk                     // From iopads
);

  /****************************************************************************
   Outputs
  ****************************************************************************/
  output        sout;          // Serial data out
  output  [7:0] rcv_byte;      // Received data byte
  output        rcv_done;      // Reception of byte complete
  output        xmt_done;      // Transmission of byte complete
  output        vld_str_deb;   // Valid start on Rx detected for debug
  
  /****************************************************************************
   Inputs
  ****************************************************************************/  
  input         sin;           // Serial data in
  input         start_xmt;     // Start transmission of serial data
  input   [7:0] xmt_byte;      // Byte to be transmitted
  input         rst_n;         // System reset, active low
  input         clk;           // System clock
 
  /****************************************************************************
   Internal declarations
  ****************************************************************************/  
  reg     [8:0] byte_in;       // Byte received 
  reg     [9:0] bout;          // Byte to be transmitted with one start and stop bit
  //reg           sclk;          // Serial clock at 16 times the baud rate
  reg     [3:0] xmt_cnt;       // Transmit bit count
  reg     [3:0] xmt_cnt16;     // Counter for holding the transmit data bit for 16 clock cycles
  reg     [3:0] cnt;           // Counter for detecting valid start bit
  reg           valid_start;   // Valid start bit detected on received data
  reg     [3:0] rcv_cnt;       // Received bit count
  reg     [3:0] rcv_cnt16;     // Receive data bit is counted for 16 clocks for valid reception
  reg     [7:0] sclk_cntr;     // Counter for generating the desired baud rate clk
  reg           rcv_done_s;    // Reception of byte complete, synch 1
  reg           rcv_done_ss;   // Reception of byte complete, synch 2
  reg           xmt_done_s;    // Transmission of byte complete, synch 1
  reg           xmt_done_ss;   // Transmission of byte complete, synch 2
  reg           vld_str_deb;   // Valid start on Rx detected for debug
  reg     [7:0] rcv_byte;      // Received data byte
                               
  wire          sout;          // Serial data out
  wire          tc;            // Terminal count
  wire          tc_xmt_cnt;    // Terminal count for transmit bit counter
  wire          tc_xmt_cnt16;  // Terminal count for holding the transmit bit for 16 clocks
  wire          xmt_done;      // Transmission of byte complete
  wire          tc_rcv_cnt;    // Terminal count for receive bit counter
  wire          tc_rcv_cnt16;  // Terminal count for holding the receive bit for 16 clocks
  wire          sclk;          // Serial clock at 16 times the baud rate
  wire          rcv_done;      // Reception of byte complete
  wire          ld_data;       // Load data into transmit shift register
  
  /****************************************************************************
    Divide clk in by 18 to get the sclk at the desired rate
    16*Baud rate. Baud rate is fixed at 115,200 bps
  ****************************************************************************/  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      sclk_cntr <= 8'h0;
    else if (sclk_cntr == 8'd17)
      sclk_cntr <= 8'h0;
    else 
      sclk_cntr <= sclk_cntr + 1'b1;
  end
  
  assign sclk = (sclk_cntr == 8'd17);//sclk_cntr[3];
  
  /****************************************************************************
    Transmit logic
  ****************************************************************************/    
  // Counter for counting 16 clocks, and than generates a terminal count.
  // On terminal count a new bit is transmitted out.
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      xmt_cnt16 <= 4'h0;
    else if (~start_xmt & sclk)
      xmt_cnt16 <= 4'h0;
    else if (start_xmt & sclk)
      xmt_cnt16 <= xmt_cnt16 + 1'b1;
  end
  
  assign tc_xmt_cnt16 = (xmt_cnt16 == 4'hf);
  
  // Transmit bit counter - transmit 8 data bits and one stop and start bit
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      xmt_cnt <= 4'h0;
    else if (~start_xmt & sclk)
      xmt_cnt <= 4'h0;
    else if (start_xmt & tc_xmt_cnt16 & sclk)
      xmt_cnt <= xmt_cnt + 1'b1;
  end
  
  assign tc_xmt_cnt = (xmt_cnt == 4'ha);
  
  // Generate a pulse for the receive done signal
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
      xmt_done_s <= 1'h0;
      xmt_done_ss <= 1'h0;
    end
    else 
    begin
      xmt_done_s <= start_xmt;
      xmt_done_ss <= xmt_done_s;
    end
  end
  
  assign xmt_done = tc_xmt_cnt;//xmt_done_s & ~xmt_done_ss;
  assign ld_data = xmt_done_s & ~xmt_done_ss;
  // Transmit serial register.
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      bout <= 10'h001;
    else if (ld_data)
      bout <= {1'b1,xmt_byte[7:0],1'b0};
    else if (~start_xmt | (start_xmt & tc_xmt_cnt16 & xmt_cnt == 4'h9) & sclk)
      bout <= 10'h001;    
    else if (start_xmt & tc_xmt_cnt16 & sclk)
      bout <= bout >> 1'b1;
  end
  
  // Serial data out
  assign sout = bout[0];

  /****************************************************************************
    Receive logic
  ****************************************************************************/   
  // Detect a valid start bit and start latching data into receive register.
  // If serial in is sampled low for 16 clocks than it is considered a valid
  // start bit.
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      cnt <= 4'hf;
    else if ((sin | tc | valid_start) & sclk)
      cnt <= 4'hf;
    else if (~sin  & sclk)
      cnt <= cnt - 1'b1;
  end
  
  assign tc = (cnt == 4'h0);
  
  // Generate valid start bit detected signal
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      valid_start <= 1'b0;
    else if (tc_rcv_cnt)
      valid_start <= 1'b0;
    else if (tc)
      valid_start <= 1'b1;
  end
  
  // First valid start detection latched. For debug purposes on FPGA board,
  // will indicate serial port is communicating by lighting an LED on the 
  // board
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      vld_str_deb <= 1'b0;
    else if (valid_start)
      vld_str_deb <= 1'b1;
  end
  
  /*
  always @ (valid_start or tc or tc_rcv_cnt)
  begin
    if (tc_rcv_cnt)
      valid_start <= 1'b0;
    else if (tc)
      valid_start <= 1'b1;
  end
  */
  // Counter for counting 16 clocks, and than generates a terminal count.
  // On terminal count a new receive bit is loaded into the receive shift
  // register.
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      rcv_cnt16 <= 4'h0;
    else if (~valid_start & sclk)
      rcv_cnt16 <= 4'h0;
    else if (valid_start & sclk)
      rcv_cnt16 <= rcv_cnt16 + 1'b1;
  end
  
  assign tc_rcv_cnt16 = (rcv_cnt16 == 4'hf);
    
  // Receive counter - 8 data bits and one stop and start bit
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      rcv_cnt <= 4'h0;
    else if (~valid_start & sclk)
      rcv_cnt <= 4'h0;
    else if (valid_start & tc_rcv_cnt16 & sclk)
      rcv_cnt <= rcv_cnt + 1'b1;
  end
  
  assign tc_rcv_cnt = (rcv_cnt == 4'h9);
  
  // Generate a pulse for the receive done signal
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
    begin
      rcv_done_s <= 1'h0;
      rcv_done_ss <= 1'h0;
    end
    else 
    begin
      rcv_done_s <= tc_rcv_cnt;
      rcv_done_ss <= rcv_done_s;
    end
  end
  
  assign rcv_done = ~rcv_done_s & rcv_done_ss;//rcv_done_s & ~rcv_done_ss;
    
  // Receive data shift register
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      byte_in <= 9'h00;
    else if (valid_start & tc_rcv_cnt16 & sclk)
      byte_in <= {sin,byte_in[8:1]};
  end
  
  // Receive data byte
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      rcv_byte <= 8'h00;
    else if (tc_rcv_cnt & sclk)
      rcv_byte <= byte_in[7:0];
  end
  
  //assign rcv_byte = byte_in[7:0];

  //synthesis translate_off
  always @ (posedge clk)
  begin
    if (tc_rcv_cnt & sclk)
    begin
      $display ($time, "\SER: Received Byte = %h", byte_in[7:0]);
    end
  end
  //synthesis translate_on
  
endmodule