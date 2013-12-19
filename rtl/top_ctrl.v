  
  `define EOF_CODE 8'h0D
  
  /****************************************************************************
   Top level controller.
  ****************************************************************************/
module top_ctrl (
  // Outputs
       init_cr,                // To lzw_ctrl       
       init_lzw,               // To lzw_ctrl
       char_cnt,               // To lzw_ctrl
       start_xmt,              // To ser
       addra_ioram,            // To IO RAM
       ena_ioram,              // To IO RAM
       wea_ioram,              // To IO RAM
       addra_outram,           // To out RAM
       ena_outram,             // To out RAM
       ser_recv_done,          // To iopads
       init_cr_out,            // To iopads
       done_cr_out,            // To iopads
       init_lzw_out,           // To iopads
       lzw_done_out,           // To iopads
       final_done,             // To iopads
       pwr_up,                 // To iopads
  // Inputs
       done_cr,                // From lzw_ctrl
       lzw_done,               // From lzw_ctrl
       outram_cnt,             // From lzw_ctrl
       rcv_done,               // From ser
       xmt_done,               // From ser
       char_in,                // From ser
       clk,                    // From iopads
       rst_n                   // From iopads
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output        init_cr;           // Initialize code value RAM
  output        init_lzw;          // Initialize LZW main state machine
  output [11:0] char_cnt;          // Number of characters received
  output        start_xmt;         // Start transmission of serial byte
  output [11:0] addra_ioram;       // Address for IO RAM port A
  output        ena_ioram;         // Enable IO RAM port A 
  output        wea_ioram;         // Write enable IO RAM port A
  output [11:0] addra_outram;      // Address for out RAM port A
  output        ena_outram;        // Enable out RAM port A 
  output        ser_recv_done;     // Serial port data receive done debug out
  output        init_cr_out;       // Initiliaze code value ram debug out
  output        done_cr_out;       // Done initiliaze code value ram debug out
  output        init_lzw_out;      // LZW start debug out
  output        lzw_done_out;      // LZW done debug out
  output        final_done;        // All transactions have finished
  output        pwr_up;            // State machine is in idle state after rst.
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         done_cr;            // Code value RAM initilization done
  input         lzw_done;           // LZW done with processing all data
  input         rcv_done;           // Receive character done
  input         xmt_done;           // Serial byte transmission done
  input   [7:0] char_in;            // Received character
  input  [11:0] outram_cnt;         // Output RAM data count
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/   
  wire           tc_ioractr;        // Terminal count for IO RAM address ctr
  wire    [11:0] addra_ioram;       // Address for IO RAM port A 
  wire           tc_outractr;       // Terminal count for out RAM address ctr
  wire    [11:0] addra_outram;      // Address for out RAM port A
  wire    [11:0] char_cnt;          // Number of characters received
  wire           final_done;        // All transactions have finished
  
  reg     [11:0] nxt_st;            // Next state
  reg     [11:0] curr_st;           // Current state
  reg            init_cr_st;        // Initialize code value RAM, early
  reg            init_cr;           // Initialize code value RAM
  reg            inc_ioraddr;       // Increment IO RAM address
  reg            inc_outraddr;      // Increment out RAM address
  reg            init_lzw_st;       // Initialize LZW main state machine,early
  reg            init_lzw;          // Initialize LZW main state machine
  reg            start_xmt;         // Start transmission of serial byte
  reg            ena_ioram;         // Enable IO RAM port A 
  reg            wea_ioram;         // Write enable IO RAM port A
  reg     [11:0] addr_cntr;         // Address counter for IO RAM address
  reg            clr_acntr;         // Clear address counter
  reg            ena_outram;        // Enable out RAM port A 
  reg     [11:0] addr_outcntr;      // Address counter for out RAM address
  reg            clr_aoutcntr;      // Clear address counter
  reg            ser_recv_done;     // Serial port data receive done debug out
  reg            init_cr_out;       // Initiliaze code value ram debug out
  reg            done_cr_out;       // Done initiliaze code value ram debug out
  reg            init_lzw_out;      // LZW start debug out
  reg            lzw_done_out;      // LZW done debug out
  reg            pwr_up;            // State machine is in idle state after rst.
  
  /****************************************************************************
   One hot state machine for the top level block
  ****************************************************************************/
  `define IDLE    curr_st[0]
  `define INIT_CR curr_st[1]            
  `define WT_RST  curr_st[2]            
  `define WT_RC   curr_st[3]          
  `define WT_ST   curr_st[4]              
  `define LZWDONE curr_st[5]            
  `define WT_TST  curr_st[6]          
  `define WT_TC1  curr_st[7]             
  `define WT_TC   curr_st[8]            
  `define DONE    curr_st[9]   
           
  parameter   IDLE    = 12'b0000_0000_0001,    // Idle
              INIT_CR = 12'b0000_0000_0010,    // Initiliaze code RAM
              WT_RST  = 12'b0000_0000_0100,    // Receive wait state
              WT_RC   = 12'b0000_0000_1000,    // Wait for receive character
              WT_ST   = 12'b0000_0001_0000,    // Wait state
              LZWDONE = 12'b0000_0010_0000,    // Wait for LZW done
              WT_TST  = 12'b0000_0100_0000,    // Transmit wait state
              WT_TC1  = 12'b0000_1000_0000,    // Wait for transmit character1
              WT_TC   = 12'b0001_0000_0000,    // Wait for transmit character
              DONE    = 12'b0010_0000_0000;    // Done
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      curr_st <= IDLE;
    else
      curr_st <= nxt_st;
  end
  
  always @ (*)
  begin                
    init_cr_st = 1'b0;   
    inc_ioraddr = 1'b0;  
    inc_outraddr = 1'b0;  
    init_lzw_st = 1'b0;  
    start_xmt = 1'b0;    
    ena_ioram = 1'b0;    
    wea_ioram = 1'b0;   
    clr_acntr = 1'b0;     
    ena_outram = 1'b0;  
    clr_aoutcntr = 1'b0;    
    case (1'b1)
      `IDLE:
      begin
        init_cr_st = 1'b1;
        nxt_st = INIT_CR;
      end
      `INIT_CR:          // Initiliaze Code RAM
      begin
        if (done_cr)
          nxt_st = WT_RST;
        else
          nxt_st = INIT_CR;
      end
      `WT_RST:          // Wait Receive State
      begin
        nxt_st = WT_RC;
      end
      `WT_RC:           // Wait for receive character
      begin
        if (rcv_done)
        begin
          ena_ioram = 1'b1;
          wea_ioram = 1'b1;
          nxt_st = WT_ST;
        end
        else if (tc_ioractr)
        begin
          init_lzw_st = 1'b1;
          nxt_st = LZWDONE;
        end
        else
          nxt_st = WT_RC;
      end
      `WT_ST:           // Wait  State
      begin
        inc_ioraddr = 1'b1;
        nxt_st = WT_RST;
      end
      `LZWDONE:         // Wait for LZW Done
      begin
        if (lzw_done)
        begin
          nxt_st = WT_TST;
          clr_acntr = 1'b1;
        end
        else
          nxt_st = LZWDONE;
      end
      `WT_TST:          // Wait Transmit State
      begin
        nxt_st = WT_TC1;
        start_xmt = 1'b1;
        ena_outram = 1'b1;
      end
      `WT_TC1:           // Wait for transmit character
      begin
        if (xmt_done)
        begin
          start_xmt = 1'b0;
          nxt_st = WT_TC;
        end      
        else
        begin
          start_xmt = 1'b1;
          nxt_st = WT_TC1;
        end
      end
      `WT_TC:           // Wait for transmit character
      begin
        if (tc_outractr & ~xmt_done)
          nxt_st = DONE;
        else if (~tc_outractr & ~xmt_done)
        begin
          inc_outraddr = 1'b1;
          ena_outram = 1'b1;
          nxt_st = WT_TST;
        end        
        else
          nxt_st = WT_TC;
      end
      `DONE:           // All transmission finished
      begin  
        nxt_st = DONE;
      end
      default: nxt_st = IDLE;
    endcase
  end
  
  /****************************************************************************
   Counter for generating the address to IO RAM
   This address will be used to write the received byte to IO RAM, and read
   a byte from IO RAM for transmission.
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      addr_cntr <= 12'h000;
    else if (clr_acntr)
      addr_cntr <= 12'h000;
    else if (inc_ioraddr)
      addr_cntr <= addr_cntr + 1'b1;
  end
  
  assign tc_ioractr = (addr_cntr == 12'hfff) | (char_in == `EOF_CODE);
  assign addra_ioram = addr_cntr;
  assign char_cnt = addr_cntr;
  
  /****************************************************************************
   Counter for generating the address to out RAM
   This address will be used to read the lzw byte from out RAM
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      addr_outcntr <= 12'h000;
    else if (clr_aoutcntr)
      addr_outcntr <= 12'h000;
    else if (inc_outraddr)
      addr_outcntr <= addr_outcntr + 1'b1;
  end
  
  
  assign tc_outractr = addr_outcntr == outram_cnt + 1'b1;
  assign addra_outram = addr_outcntr;
  
  // Start the initilization of the code value RAM
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      init_cr <= 1'b0;
    else
      init_cr <= init_cr_st;
  end
  
  // Start the LZW block
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      init_lzw <= 1'b0;
    else
      init_lzw <= init_lzw_st;
  end

  /****************************************************************************
   Outputs for debugging on the FPGA board
  ****************************************************************************/  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      pwr_up <= 1'b0;
    else  if (curr_st[0])
      pwr_up <= 1'b1;
  end
  
  // All data has been received
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ser_recv_done <= 1'b0;
    else if (tc_ioractr)
      ser_recv_done <= 1'b1;
  end
  
  // Start the initilization of the code value RAM
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      init_cr_out <= 1'b0;
    else if (init_cr_st)
      init_cr_out <= 1'b1;
  end
  
  // Start the LZW block
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      init_lzw_out <= 1'b0;
    else  if (init_lzw_st)
      init_lzw_out <= 1'b1;
  end
  
  // Finished the initilization of the code value RAM
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      done_cr_out <= 1'b0;
    else if (done_cr)
      done_cr_out <= 1'b1;
  end
  
  // Finished the LZW block
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      lzw_done_out <= 1'b0;
    else  if (lzw_done)
      lzw_done_out <= 1'b1;
  end
  
  assign final_done = `DONE;
  
   //synthesis translate_off
  reg  [20*8:0] st_string;
  always @ (*)
  begin
    case (curr_st)
      IDLE   : st_string = "IDLE";
      INIT_CR: st_string = "INIT_CR";
      WT_RST : st_string = "WT_RST";
      WT_ST  : st_string = "WT_ST";
      WT_RC  : st_string = "WT_RC";
      LZWDONE: st_string = "LZWDONE";
      WT_TST : st_string = "WT_TST";
      WT_TC1 : st_string = "WT_TC1";
      WT_TC  : st_string = "WT_TC";
      DONE   : st_string = "DONE";
    endcase
  end
  //synthesis translate_on
  
endmodule // top_ctrl 