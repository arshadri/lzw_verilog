 
  /****************************************************************************
    A model of the serial interface which interfaces to the FPGA
    Does not model any error conditions or handling.
    By default runs at 115200 Baud rate
  ****************************************************************************/
  
 `timescale 1 ps/1 ps
  
module ser_model (
    // Outputs
         sout,
    // Inputs
  	 rst,			
         sin
  );
  
  parameter   CLKHALF_PER = 270000; // 1.8432MHZ approx.
  /****************************************************************************
   Outputs
  ****************************************************************************/  
  output           sout;           // Serial data out
  
  /****************************************************************************
   Inputs
  ****************************************************************************/  
  input            rst;            // Reset from FPGA board
  input            sin;            // Serial data in

  /****************************************************************************
   Internal declarations
  ****************************************************************************/   
  reg     [8:0]    byte_in;        // Byte received 
  reg     [7:0]    byte_out;       // Byte to be transmitted
  reg     [9:0]    bout;           // Byte to be transmitted with one start and stop bit
  reg              sclk;           // Serial clock at 16 times the baud rate
  reg     [3:0]    xmt_cnt;        // Transmit bit count
  reg     [3:0]    xmt_cnt16;      // Counter for holding the transmit data bit for 16 clock cycles
  reg     [3:0]    cnt;            // Counter for detecting valid start bit
  reg              valid_start;    // Valid start bit detected on received data
  reg     [3:0]    rcv_cnt;        // Received bit count
  reg              start_xmt;      // Start transmission of serial data
  reg              ld_data;        // Load data into transmit shift register
  reg     [3:0]    rcv_cnt16;      // Receive data bit is counted for 16 clocks for valid reception
  reg     [4:0]    cnt_cmd_bytes;  // Count number of command bytes received.
  reg     [15:0]   disp_cnt;       // Display count
  
  wire             sout;           // Serial data out
  wire             tc;             // Terminal count
  wire             tc_xmt_cnt;     // Terminal count for transmit bit counter
  wire             tc_rcv_cnt;     // Terminal count for receive bit counter
  wire             tc_xmt_cnt16;   // Terminal count for holding the transmit bit for 16 clocks
  wire             tc_rcv_cnt16;   // Terminal count for holding the receive bit for 16 clocks
  wire    [7:0]    rcv_byte;       // Received data byte
  
  integer  file0;  
    
  assign rcv_byte = byte_in[7:0];
  
  // Initialize values of signals
  initial begin
  file0 = $fopen("lzw_out.txt");
  start_xmt = 1'b0;
  valid_start = 1'b0;
  ld_data = 1'b0;
  cnt_cmd_bytes = 5'h00;
  disp_cnt = 16'h0000;
  end
  
  // Generate clock for buad rate*16 speed
  initial begin
    sclk = 1'b0;
    forever #(CLKHALF_PER) sclk = ~sclk;
  end

  /****************************************************************************
    Transmit logic
  ****************************************************************************/    
  // Counter for counting 16 clocks, and than generates a terminal count.
  // On terminal count a new bit is transmitted out.
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      xmt_cnt16 <= 4'h0;
    else if (~start_xmt)
      xmt_cnt16 <= 4'h0;
    else if (start_xmt)
      xmt_cnt16 <= xmt_cnt16 + 1'b1;
  end
  
  assign tc_xmt_cnt16 = xmt_cnt16 == 4'hf;
  
  // Transmit bit counter - transmit 8 data bits and one stop and start bit
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      xmt_cnt <= 4'h0;
    else if (~start_xmt)
      xmt_cnt <= 4'h0;
    else if (start_xmt & tc_xmt_cnt16)
      xmt_cnt <= xmt_cnt + 1'b1;
  end
  
  assign tc_xmt_cnt = xmt_cnt == 4'ha;
  
  // Disable transmit signal once all 10-bits are transmitted
 // always @ (tc_xmt_cnt)
 // begin
  //  if (tc_xmt_cnt)
  //    start_xmt = 1'b0;
 // end
  
  // Transmit serial register.
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      bout <= 10'h001;
    else if (~start_xmt | (start_xmt & tc_xmt_cnt16 & xmt_cnt == 4'h9))
      bout <= 10'h001;
    else if (ld_data)
    begin
      bout <= {1'b1,byte_out[7:0],1'b0};
      ld_data <= 1'b0;
    end
    else if (start_xmt & tc_xmt_cnt16)
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
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      cnt <= 4'hf;
    else if (sin | tc | valid_start)
      cnt <= 4'hf;
    else if (~sin)
      cnt <= cnt - 1'b1;
  end
  
  assign tc = (cnt == 4'h0);
  
  // Generate valid start bit detected signal
  always @ (valid_start or tc or tc_rcv_cnt)
  begin
    if (tc_rcv_cnt)
      valid_start <= 1'b0;
    else if (tc)
      valid_start <= 1'b1;
  end
  
  // Counter for counting 16 clocks, and than generates a terminal count.
  // On terminal count a new receive bit is loaded into the receive shift
  // register.
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      rcv_cnt16 <= 4'h0;
    else if (~valid_start)
      rcv_cnt16 <= 4'h0;
    else if (valid_start)
      rcv_cnt16 <= rcv_cnt16 + 1'b1;
  end
  
  assign tc_rcv_cnt16 = rcv_cnt16 == 4'hf;
    
  // Receive counter - 8 data bits and one stop and start bit
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      rcv_cnt <= 4'h0;
    else if (~valid_start)
      rcv_cnt <= 4'h0;
    else if (valid_start & tc_rcv_cnt16)
      rcv_cnt <= rcv_cnt + 1'b1;
  end
  
  assign tc_rcv_cnt = rcv_cnt == 4'h9;
    
  // Receive data shift register
  always @ (posedge sclk or posedge rst)
  begin
    if (rst)
      byte_in <= 9'h00;
    else if (valid_start & tc_rcv_cnt16)
      byte_in <= {sin,byte_in[8:1]};
  end
  
  // Display on Terminal the received data 
  always @ (posedge sclk)
  begin
    if (tc_rcv_cnt)
    begin
      disp_cnt = disp_cnt + 1'b1;
      $display ($time, "\tSER_MODEL: Received Byte = %h, Byte Count = %d", rcv_byte,disp_cnt);
    end
  end
  
  // Put into file the received data
  always @ (posedge sclk)
  begin
    if (tc_rcv_cnt)
    begin
      #2;
       $fwrite (file0, "%h", rcv_byte);
    end
  end
   
  /****************************************************************************
    Task to write into the transmit register. This data is than 
    transmitted out on serial out.
  ****************************************************************************/   

  task   write;
  input  [7:0] din;
  
  begin
    byte_out = din;
    ld_data = 1'b1;
    start_xmt = 1'b1;
    wait (tc_xmt_cnt);
       start_xmt = 1'b0;
     @(posedge sclk);
     @(posedge sclk);
     $display ($time,"Task ends");
  end
  
  endtask
  
  /****************************************************************************
     Task to read from the receive register. This is data that has been
     received on serial in.
  ****************************************************************************/   
 
  task   read;
  output  [7:0] dout;
  
  begin
    dout = byte_in[7:0];
  end
  
  endtask
  

endmodule