
  /****************************************************************************
   Hash generation
  ****************************************************************************/
module hash (
  // Outputs
       addr,                   // To different RAM's
       string_reg,             // To prefix RAM
       not_in_mem,             // To lzw_ctrl
       match,                  // To lzw_ctrl
       collis,                 // To lzw_ctrl
       in_code_mem,            // To lzw_ctrl
  // Inputs
       gen_hash,               // From lzw_ctrl
       recal_hash,             // From lzw_ctrl
       shift_char,             // From lzw_ctrl
       mux_code_val,           // From lzw_ctrl
       char_in,                // From io_ram
       string_data,            // From code_value_ram
       append_data,            // From dictionary_ram
       prefix_data,            // From dictionary_ram
       clk,                    // From iopads
       rst_n                   // From iopads
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output [12:0] addr;               // Address for dictionary and code val. RAM 
  output [12:0] string_reg;         // String register  
  output        not_in_mem;         // Not in memory  
  output        match;              // Match in dictionary  
  output        collis;             // Collision 
  output        in_code_mem;        // Address in code value RAM 
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input   [7:0] char_in;            // Character 
  input  [12:0] string_data;        // String RAM data  
  input   [7:0] append_data;        // Append RAM data
  input  [12:0] prefix_data;        // Prefix RAM data
  input         gen_hash;           // Generate hash
  input         shift_char;         // Shift character from char. to string reg.
  input         recal_hash;         // Match in dictionary
  input         mux_code_val;       // Mux code value into string register
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  reg    [12:0] addr;               // Address for dictionary and code val. RAM 
  reg    [12:0] addr_save;          // Save currently generated address 
  reg    [12:0] string_reg;         // String register  
  reg           gen_hash_s;         // Generate hash delayed
  reg           gen_hash_ss;        // Generate hash delayed by 2
  
  reg    [12:0] index;              // Index
  wire          not_in_mem;         // Address not in code value RAM
  reg           in_code_mem;        // Address in code value RAM
  reg           match;              // Match in dictionary
  reg           collis;             // Collision 
  wire          cmp_append_char;    // Compare append character
  wire          cmp_prefix_data;    // Compare prefix data
  
  /****************************************************************************
   Logic to determine if the current character is a hit in the dictionary
  ****************************************************************************/ 
  assign not_in_mem      = (string_data == 13'h1FFF) & gen_hash_ss;
  assign cmp_append_char = (append_data == char_in);
  assign cmp_prefix_data = (prefix_data == string_reg);//string_data);

  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      in_code_mem <= 1'h0;
    else if (gen_hash)
      in_code_mem <= 1'h0;
    else if (gen_hash_ss)
      in_code_mem <= (string_data != 13'h1FFF);
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      match <= 1'h0;
    else if (gen_hash)
      match <= 1'h0;
    else if (gen_hash_ss)
      match <= cmp_append_char & cmp_prefix_data;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      collis <= 1'h0;
    else if (gen_hash)
      collis <= 1'h0;
    else if (gen_hash_ss)
      collis <= (cmp_append_char & ~cmp_prefix_data) 
              | (~cmp_append_char & cmp_prefix_data);
  end
  
  /****************************************************************************
   Logic to generate hash
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      gen_hash_s <= 1'b0;
    else 
      gen_hash_s <= gen_hash;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      gen_hash_ss <= 1'b0;
    else 
      gen_hash_ss <= gen_hash_s;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      addr_save <= 13'h0000;
    else if (gen_hash_s)
      addr_save <= index;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      index <= 13'h0000;
    else if (gen_hash)
      index <= (char_in << 3'd5) ^ string_reg;
  end
  
  always @ (*)
  begin
    case (recal_hash)
      1'b1: addr = {1'b0,addr_save[11:0] + 'd12};
      1'b0: addr = index;
    endcase
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      string_reg <= 13'h0000;
    else if (shift_char)
      string_reg <= mux_code_val ? string_data : {5'h00,char_in[7:0]};
  end
    
endmodule // hash