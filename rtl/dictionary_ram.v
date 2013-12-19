
  /****************************************************************************
   Dictionary RAM.
  ****************************************************************************/
module dictionary_ram (
  // Outputs
       prefix_data,
       append_data,
  // Inputs
       wea_acram,
       wea_pcram,
       addr,
       char_data,
       string_data,
       clk, 
       rst_n
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output  [12:0] prefix_data;       // Prefix data
  output   [7:0] append_data;       // Append data
   
  /****************************************************************************
   Inputs
  ****************************************************************************/  
  input         wea_acram;          // Write Enable append char RAM port A  
  input         wea_pcram;          // Write Enable prefix code char RAM port A
  input  [12:0] addr;               // Address
  input   [7:0] char_data;          // Character data
  input  [12:0] string_data;        // String data
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/   
  wire    [12:0] prefix_data;       // Prefix data
  wire     [7:0] append_data;       // Append data
 
  /****************************************************************************
   Instance the prefix code RAM
  ****************************************************************************/
  prefix_code_ram prefix_code_ram (
    // Outputs
         .rd_data     (prefix_data),
    // Inputs
         .wren        (wea_pcram),
         .en          (1'b1),
         .addr        (addr[11:0]),
         .wr_data     (string_data),
         .clk         (clk), 
         .rst_n       (rst_n)
  );
  
  /****************************************************************************
   Instance the append character RAM
  ****************************************************************************/
  append_char_ram append_char_ram (
    // Outputs
         .rd_data     (append_data),
    // Inputs
         .wren        (wea_acram),
         .en          (1'b1),
         .addr        (addr[11:0]),
         .wr_data     (char_data),
         .clk         (clk), 
         .rst_n       (rst_n)
  );
  

endmodule // dictionary_ram 