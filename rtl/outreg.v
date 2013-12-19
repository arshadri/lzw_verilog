
  /****************************************************************************
   Output forming logic.
  ****************************************************************************/
module outreg (
  // Outputs
       valid_dcnt,             // To lzw_ctrl  
       tc_outreg,              // To lzw_ctrl
       lzw_byte,               // To IO RAM
  // Inputs
       write_sp,               // From lzw_ctrl
       write_data,             // From lzw_ctrl
       read_data,              // From lzw_ctrl
       prefix_data,            // From lzw_ctrl
       clk,                    // From iopads
       rst_n                   // From iopads
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/ 
  output        valid_dcnt;        // Data count is a valid count
  output        tc_outreg;         // Terminal count output register
  output  [7:0] lzw_byte;          // Write data for IO RAM port B
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         write_data;        // Write data into output register
  input         write_sp;          // Write special code into output register
  input         read_data;         // Read data from output register   
  input  [12:0] prefix_data;       // Prefix data
  input         clk;               // System clock
  input         rst_n;             // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/   
  wire           valid_dcnt;       // Data count is a valid count
  wire           tc_outreg;        // Terminal count output register
  wire           flush;            // Flush the output register
  
  reg      [7:0] lzw_byte;         // Write data for IO RAM port B  
  reg      [4:0] datain_cnt;       // Input data count
  reg     [31:0] shift_reg;        // Shift register
  reg            up_low;           // Upper or lower byte valid
  reg            up_low_r;         // Upper or lower byte valid, registered
  reg      [7:0] lzw_byte_r;       // Registered version for holding the data
  reg     [31:0] ars;
  reg      [7:0] ars1;
  
  /****************************************************************************
   Shift register for combining and outputting data to IORAM
  ****************************************************************************/
  assign flush = read_data & datain_cnt < 'd8;
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      datain_cnt <= 5'h00;
    else if (flush)
      datain_cnt <= 5'h00;
    else 
    begin
      case ({read_data,write_data,write_sp})
        {1'b1,1'b0,1'b0}: datain_cnt <= datain_cnt - 5'd8;
        {1'b0,1'b1,1'b0}: datain_cnt <= datain_cnt + 5'd13;
        {1'b0,1'b0,1'b1}: datain_cnt <= datain_cnt + 5'd13;
        default: datain_cnt <= datain_cnt;
      endcase
    end
  end
  
  assign tc_outreg  = datain_cnt == 'd0;
  assign valid_dcnt = datain_cnt >= 'd8;
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      shift_reg <= 32'h0000_0000;
    else if (write_data)
    begin
      shift_reg <= shift_reg | (prefix_data << ('d19-datain_cnt));
    end
    else if (write_sp)
    begin
      shift_reg <= shift_reg | (13'h1fff << ('d19-datain_cnt));
    end
    else if (read_data)
    begin
      shift_reg <= shift_reg  << 'd8;
    end
  end
  
  always @ (*)
  begin
    lzw_byte = shift_reg >> 'd24;
  end
  
 
endmodule // outreg 