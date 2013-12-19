
  /****************************************************************************
   LZW encoder implementation
  ****************************************************************************/
module lzw_enc (
  // Outputs
       xmt_byte,               // To ser
       web_ioram,              // To IO RAM
       enb_ioram,              // To IO RAM
       addrb_ioram,            // To IO RAM
       lzw_done,               // To top_ctrl
       done_cr,                // To top_ctrl
       outram_cnt,             // To top_ctrl
  // Inputs
       ena_outram,             // From top_ctrl
       addra_outram,           // From top_ctrl
       init_cr,                // From top_ctrl
       init_lzw,               // From top_ctrl
       char_cnt,               // From top_ctrl
       char_in,                // From IO RAM
       clk,                    // From iopads
       rst_n                   // From iopads
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output  [7:0] xmt_byte;          // Transmit output data
  output        web_ioram;         // Write enable for LZW port of IORAM  
  output        enb_ioram;         // Enable LZW port of IORAM
  output [11:0] addrb_ioram;       // Address for LZW port of IORAM
  output        lzw_done;          // LZW block finished all processing
  output        done_cr;           // Code value RAM initilization done
  output [11:0] outram_cnt;        // Output RAM data count
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         init_cr;            // Initiliaze code value RAM
  input         init_lzw;           // Initiliaze the LZW block
  input  [11:0] char_cnt;          // Number of characters received
  input   [7:0] char_in;            // Character in from IORAM
  input         ena_outram;         // Enable for port A of out RAM
  input  [11:0] addra_outram;       // Address for port A of out RAM
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  wire   [12:0] prefix_data;        // Prefix data
  wire    [7:0] append_data;        // Append data
  wire          not_in_mem;         // Address not in code value RAM
  wire          in_code_mem;        // Address in code value RAM
  wire   [12:0] addr;               // Dictionary RAM address
  wire   [12:0] string_data;        // String data
  
  wire   [11:0] addrb_ioram;        // Address for IO RAM port B
  wire   [12:0] addrb_cvram;        // Address for CV RAM port B
  wire   [12:0] wr_cvdataa;         // Write data for code value RAM port A
  wire          web_ioram;          // Write enable for LZW port of IORAM  
  wire   [12:0] string_reg;         // String register  
  
  wire    [7:0] xmt_byte;           // Transmit output data
  wire    [7:0] lzw_byte;           // LZW output data
  wire   [11:0] addrb_outram;       // Address for out RAM port B
  wire          wrb_outram;         // Write enable for out RAM port B
  wire          enb_outram;         // Enable for out RAM port B
                                    
  wire          done_cr;            // Done with code value RAM init.
  wire          done_lzw;           // Done with LZW,early   
  wire          enb_cvram;          // Enable code value RAM port B 
  wire          web_cvram;          // Write enable code value RAM port B
  wire          enb_ioram;          // Enable IO RAM port B 
  wire          shift_char;         // Shift character from char. to string reg.  
  wire          gen_hash;           // Generate hash   
  wire          recal_hash;         // Recalculate hash  
  wire          ena_cvram;          // Enable code value RAM port A
  wire          wea_cvram;          // Write enable code value RAM port A
  wire          inc_cvadata;        // Increment code value RAM port A data
  wire          wea_acram;          // Write Enable append char RAM port A
  wire          wea_pcram;          // Write Enable prefix char RAM port A
  wire          write_data;         // Write data into output register  
  wire          mux_code_val;       // Mux code value into string register
  wire   [11:0] outram_cnt;         // Output RAM data count
  wire           tc_outreg;         // Terminal count output register
  
  /****************************************************************************
   Instance the dictionary RAM
  ****************************************************************************/
  dictionary_ram dictionary_ram (
    // Outputs
         .prefix_data      (prefix_data),   // To comparator
         .append_data      (append_data),   // To comparator
    // Inputs                               
         .wea_acram        (wea_acram),     // From lzw_ctrl 
         .wea_pcram        (wea_pcram),     // From lzw_ctrl   
         .addr             (addr),          // From    
         .char_data        (char_in),       // From 
         .string_data      (string_reg),    // From 
         .clk              (clk),           // From iopads
         .rst_n            (rst_n)          // From iopads
  );
 
  /****************************************************************************
   Instance the code value RAM
  ****************************************************************************/ 
  code_value_ram  code_value_ram (
    // Outputs
         .rd_dataa         (string_data),   // To cmp
    // Inputs		                    
         .wr_porta         (wea_cvram),     // From lzw_ctrl
         .en_porta         (ena_cvram),     // From lzw_ctrl
         .addra            (addr),          // From 
         .wr_dataa         (wr_cvdataa),    // From lzw_ctrl
         .wr_portb         (web_cvram),     // From lzw_ctrl
         .en_portb         (enb_cvram),     // From lzw_ctrl
         .addrb            (addrb_cvram),   // From lzw_ctrl
         .wr_datab         (13'h1FFF),      // From 
         .clk              (clk),	    // From iopads
         .rst_n            (rst_n)          // From iopads
  );

  /****************************************************************************
   Instance the hash block
  ****************************************************************************/  
  hash hash (
    // Outputs
         .addr             (addr),          // To dictionary
         .string_reg       (string_reg),    // To dictionary
         .not_in_mem       (not_in_mem),    // To lzw_ctrl
         .match            (match),         // To lzw_ctrl
         .collis           (collis),        // To lzw_ctrl
         .in_code_mem      (in_code_mem),   // To lzw_ctrl
    // Inputs
         .gen_hash         (gen_hash),      // From lzw_ctrl
         .recal_hash       (recal_hash),    // From lzw_ctrl
         .shift_char       (shift_char),    // From lzw_ctrl
         .mux_code_val     (mux_code_val),  // From lzw_ctrl
         .char_in          (char_in),       // From io_ram
         .string_data      (string_data),   // From code_value_ram
         .append_data      (append_data),   // From dictionary
         .prefix_data      (prefix_data),   // From dictionary
         .clk              (clk),           // From iopads
         .rst_n            (rst_n)          // From iopads
  );
  
  /****************************************************************************
   Instance the control block
  ****************************************************************************/ 
  lzw_ctrl lzw_ctrl (
    // Outputs
         .done_cr            (done_cr),     // To top_ctrl
         .lzw_done           (lzw_done),    // To top_ctrl 
         .gen_hash           (gen_hash),    // To hash
         .recal_hash         (recal_hash),  // To hash
         .addrb_ioram        (addrb_ioram), // To IO RAM
         .enb_ioram          (enb_ioram),   // To IO RAM
         .web_ioram          (web_ioram),   // To IO RAM     
         .addrb_outram       (addrb_outram),// To out RAM
         .enb_outram         (enb_outram),  // To out RAM
         .web_outram         (web_outram),  // To out RAM       
         .addrb_cvram        (addrb_cvram), // To code_value_ram
         .enb_cvram          (enb_cvram),   // To code_value_ram
         .web_cvram          (web_cvram),   // To code_value_ram
         .wr_cvdataa         (wr_cvdataa),  // To code_value_ram
         .ena_cvram          (ena_cvram),   // To code_value_ram
         .wea_cvram          (wea_cvram),   // To code_value_ram
         .wea_acram          (wea_acram),   // To dictionary_ram
         .wea_pcram          (wea_pcram),   // To dictionary_ram  
         .write_data         (write_data),  // To outreg
         .read_data          (read_data),   // To outreg
         .write_sp           (write_sp),    // To outreg
         .shift_char         (shift_char),  // To hash
         .mux_code_val       (mux_code_val),// To hash
         .outram_cnt         (outram_cnt),  // To top_ctrl
    // Inputs
         .valid_dcnt         (valid_dcnt),  // From outreg  
         .tc_outreg          (tc_outreg),   // From outreg 
         .init_cr            (init_cr),     // From top_ctrl       
         .init_lzw           (init_lzw),    // From top_ctrl   
         .char_cnt           (char_cnt),    // From top_ctrl
         .not_in_mem         (not_in_mem),  // From hash
         .match              (match),       // From hash
         .collis             (collis),      // From hash
         .in_code_mem        (in_code_mem), // To lzw_ctrl
         .clk                (clk),         // From iopads
         .rst_n              (rst_n)        // From iopads
  );

  /****************************************************************************
   Instance the output forming block
  ****************************************************************************/ 
  outreg outreg (
    // Outputs
         .valid_dcnt         (valid_dcnt),  // To lzw_ctrl  
         .tc_outreg          (tc_outreg),   // To lzw_ctrl 
         .lzw_byte           (lzw_byte),    // To IO RAM
    // Inputs
         .write_data         (write_data),  // From lzw_ctrl
         .write_sp           (write_sp),    // From lzw_ctrl
         .read_data          (read_data),   // From lzw_ctrl
         .prefix_data        (prefix_data), // From lzw_ctrl
         .clk                (clk),         // From iopads
         .rst_n              (rst_n)        // From iopads
  );
   
  /****************************************************************************
   Instance the output RAM
  ****************************************************************************/ 
  io_ram outram (
    // Outputs
         .rd_dataa       (xmt_byte),        // To ser
         .rd_datab       (),                // To lzw_enc
    // Inputs                               
         .wr_porta       (1'b0),            // From     
         .en_porta       (ena_outram),      // From top_ctrl
         .addra          (addra_outram),    // From top_ctrl
         .wr_dataa       (8'h00),           // From ser
         .wr_portb       (web_outram),      // From lzw_enc
         .en_portb       (enb_outram),      // From lzw_enc
         .addrb          (addrb_outram),    // From lzw_enc        
         .wr_datab       (lzw_byte),        // From lzw_enc
         .clk            (clk),             // From iopads
         .rst_n          (rst_n)            // From iopads
  );

endmodule // lzw_enc 