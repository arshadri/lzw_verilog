
  /****************************************************************************
   Top most level block of the LZW implementation
  ****************************************************************************/
module lzw (
  // Outputs
       TX,
       SER_RECV_DONE,
       INIT_CR,      
       INIT_LZW,     
       DONE_CR,      
       LZW_DONE,   
       FINAL_DONE,  
       PWR_UP,
       VALID_START_DEB,
  // Inputs
       RX,
       CLK66, 
       RST
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output        TX;                 // Serial transmit data
  output        SER_RECV_DONE;      // Serial port data receive done
  output        INIT_CR;            // Initialize code value RAM
  output        INIT_LZW;           // Initialize LZW main state machine
  output        DONE_CR;            // Code value RAM initilization done
  output        LZW_DONE;           // LZW done with processing all data
  output        FINAL_DONE;         // All transactions have finished
  output        PWR_UP;             // Power up for debug purpose on FPGA
  output        VALID_START_DEB;    // Valid start on Rx detected for debug
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         RX;                 // Serial receive data
  input         CLK66;              // System clock, 66MHZ
  input         RST;                // System reset, active high
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  wire          TX;                 // Serial transmit data
  wire          SER_RECV_DONE;      // Serial port data receive done
  wire          INIT_CR;            // Initialize code value RAM
  wire          INIT_LZW;           // Initialize LZW main state machine
  wire          DONE_CR;            // Code value RAM initilization done
  wire          LZW_DONE;           // LZW done with processing all data
  wire          FINAL_DONE;         // All transactions have finished
  wire          PWR_UP;             // Power up for debug purpose on FPGA
  wire          VALID_START_DEB;    // Valid start on Rx detected for debug
  wire          sout;               // Serial transmit data
  wire          sin;                // Serial receive data
  wire          clk66;              // System clock, 66MHZ
  wire          rst;                // System reset, active high
  
  wire          wea_ioram;          // Write enable for port A of IO RAM
  wire          ena_ioram;          // Enable for port A of IO RAM
  wire          web_ioram;          // Write enable for port B of IO RAM
  wire          enb_ioram;          // Enable for port B of IO RAM
  wire    [7:0] rcv_byte;           // Receive byte from serial port
  wire    [7:0] lzw_byte;           // Output byte from LZW output forming logic  
  wire    [7:0] char_in;            // Read data from IO RAM port A
  wire    [7:0] xmt_byte;           // Read data from IO RAM port B
  wire   [11:0] addra_ioram;        // Address for port A of IO RAM
  wire   [11:0] addrb_ioram;        // Address for port B of IO RAM
  wire          ena_outram;         // Enable for port A of out RAM
  wire   [11:0] addra_outram;       // Address for port A of out RAM
  wire          rcv_done;           // Reception of byte complete   
  wire          xmt_done;           // Transmission of byte complete
  wire          init_cr;            // Initialize code value RAM
  wire          init_lzw;           // Initialize LZW main state machine
  wire          done_cr;            // Code value RAM initilization done
  wire          lzw_done;           // LZW done with processing all data
  wire   [11:0] outram_cnt;         // Output RAM data count
  wire   [11:0] char_cnt;           // Number of characters received  
  wire          ser_recv_done;      // Serial port data receive done
  wire          init_cr_out;        // Initiliaze code value ram debug out
  wire          done_cr_out;        // Done initiliaze code value ram debug out
  wire          init_lzw_out;       // LZW start debug out
  wire          lzw_done_out;       // LZW done debug out
  wire          final_done;         // All transactions have finished
  wire          pwr_up;             // Power up for debug purpose on FPGA
  wire          vld_str_deb;        // Valid start on Rx detected for debug
    
  reg           clk;                // Clock 33 MHZ used everywhere
  reg           rst_s;              // First Synchronized reset
  reg           rst_n;              // Synchronized reset, active low
  
  /****************************************************************************
   IOPads
  ****************************************************************************/
  assign TX    = sout;
  assign sin   = RX;
  assign clk66 = CLK66;
  assign rst = RST; 
  assign LZW_DONE = lzw_done_out;
  assign INIT_CR = init_cr_out;
  assign DONE_CR = done_cr_out;
  assign SER_RECV_DONE = ser_recv_done;
  assign INIT_LZW = init_lzw_out;
  assign FINAL_DONE = final_done;
  assign PWR_UP = pwr_up;
  assign VALID_START_DEB = vld_str_deb;
  
  /****************************************************************************
   Synchronize the input switch from FPGA board
  ****************************************************************************/
  always @(posedge clk or posedge rst)
  begin
  if (rst)
  begin
    rst_s <= 1'b0;
    rst_n <= 1'b0;
  end
  else
  begin   
    rst_s <= 1'b1;
    rst_n <= rst_s;
  end
  
  end
  
  /****************************************************************************
   Divide clock 66MHZ by 2 to run the FPGA at 33MHZ. Just a safe clock speed.
  ****************************************************************************/
  //synthesis translate_off
  initial clk = 1'b0;
   //synthesis translate_on
   
  always @(posedge clk66)
    clk = ~clk;
  /****************************************************************************
   Instance the input/output RAM
  ****************************************************************************/
  io_ram io_ram (
    // Outputs
         .rd_dataa       (),                
         .rd_datab       (char_in),         // To lzw_enc
    // Inputs                               
         .wr_porta       (wea_ioram),       // From top_ctrl    
         .en_porta       (ena_ioram),       // From top_ctrl    
         .addra          (addra_ioram),     // From top_ctrl
         .wr_dataa       (rcv_byte),        // From ser
         .wr_portb       (1'b0),            // From lzw_enc
         .en_portb       (enb_ioram),       // From lzw_enc
         .addrb          (addrb_ioram),     // From lzw_enc        
         .wr_datab       (8'h00),           // From lzw_enc
         .clk            (clk),             // From iopads
         .rst_n          (rst_n)            // From iopads
  );

  /****************************************************************************
   Instance the LZW encoder block
  ****************************************************************************/ 
  lzw_enc lzw_enc (
    // Outputs
         .xmt_byte       (xmt_byte),        // To IO RAM
         .web_ioram      (web_ioram),       // To IO RAM
         .enb_ioram      (enb_ioram),       // To IO RAM
         .addrb_ioram    (addrb_ioram),     // To IO RAM
         .lzw_done       (lzw_done),        // To top_ctrl
         .done_cr        (done_cr),         // To top_ctrl
         .outram_cnt     (outram_cnt),      // To top_ctrl
    // Inputs
         .addra_outram   (addra_outram),    // To out RAM
         .ena_outram     (ena_outram),      // To out RAM
         .init_cr        (init_cr),         // From top_ctrl
         .init_lzw       (init_lzw),        // From top_ctrl   
         .char_cnt       (char_cnt),        // From top_ctrl 
         .char_in        (char_in),         // From IO RAM
         .clk            (clk),             // From iopads
         .rst_n          (rst_n)            // From iopads
);
   
  /****************************************************************************
   Instance the top level controller block
  ****************************************************************************/ 
  top_ctrl top_ctrl (
    // Outputs
         .init_cr        (init_cr),         // To lzw_ctrl       
         .init_lzw       (init_lzw),        // To lzw_ctrl     
         .char_cnt       (char_cnt),        // To lzw_ctrl
         .start_xmt      (start_xmt),       // To ser
         .addra_ioram    (addra_ioram),     // To IO RAM
         .ena_ioram      (ena_ioram),       // To IO RAM
         .wea_ioram      (wea_ioram),       // To IO RAM
         .addra_outram   (addra_outram),    // To out RAM
         .ena_outram     (ena_outram),      // To out RAM
         .ser_recv_done  (ser_recv_done),   // To iopads
         .init_cr_out    (init_cr_out),     // To iopads
         .done_cr_out    (done_cr_out),     // To iopads
         .init_lzw_out   (init_lzw_out),    // To iopads
         .lzw_done_out   (lzw_done_out),    // To iopads
         .final_done     (final_done),      // To iopads
         .pwr_up         (pwr_up),          // To iopads
    // Inputs
         .done_cr        (done_cr),         // From lzw_ctrl
         .lzw_done       (lzw_done),        // From lzw_ctrl
         .outram_cnt     (outram_cnt),      // From lzw_ctrl
         .rcv_done       (rcv_done),        // From ser
         .xmt_done       (xmt_done),        // From ser
         .char_in        (rcv_byte),        // From ser
         .clk            (clk),             // From iopads
         .rst_n          (rst_n)            // From iopads
  );
  
  /****************************************************************************
   Instance the serial port
  ****************************************************************************/ 
  ser  ser (
    // Outputs
         .sout           (sout),            // To iopads
         .rcv_byte       (rcv_byte),        // To io_ram
         .rcv_done       (rcv_done),        // To top_ctrl
         .xmt_done       (xmt_done),        // To top_ctrl
         .vld_str_deb    (vld_str_deb),     // To iopads
    // Inputs		                    
         .sin            (sin),             // From iopads
         .start_xmt      (start_xmt),       // From top_ctrl
         .xmt_byte       (xmt_byte),        // From io_ram
         .clk            (clk),	            // From iopads
         .rst_n          (rst_n)            // From iopads
  );

  //synthesis translate_off
  glbl glbl ();
  //synthesis translate_on
  
endmodule // lzw 