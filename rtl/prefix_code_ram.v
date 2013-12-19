
  /****************************************************************************
   Append character RAM.
  ****************************************************************************/
module prefix_code_ram (
  // Outputs
       rd_data,
  // Inputs
       wren,
       en,
       addr,
       wr_data,
       clk, 
       rst_n
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output [12:0] rd_data;            // Read data from RAM
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         wren;               // Write enable RAM
  input         en;                 // RAM enable
  input  [11:0] addr;               // RAM address
  input  [12:0] wr_data;            // Write data
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  reg    [12:0] rd_data;            // Read data for RAM
  reg    [12:0] rd_data_r;          // Registered read data
  reg           en_porta_r;         // Registered enable 
  
  wire   [15:0] rd_data0;           // Read data RAM 0
  wire   [15:0] rd_data1;           // Read data RAM 1
  wire   [15:0] rd_data2;           // Read data RAM 2
  wire   [15:0] rd_data3;           // Read data RAM 3
  wire    [3:0] ram_en;             // Enable for RAM 0-3  
  wire          rst;                // Reset inverted version of input
  
  /****************************************************************************
   Generate the enable signals for the RAM's and the output data muxing
  ****************************************************************************/
  assign rst = ~rst_n;
  
  assign ram_en[0] = en & ~addr[1] & ~addr[0];
  assign ram_en[1] = en & ~addr[1] &  addr[0];
  assign ram_en[2] = en &  addr[1] & ~addr[0];
  assign ram_en[3] = en &  addr[1] &  addr[0];

  always @ (*)
  begin
    case ({en_porta_r,addr[1:0]})
      {1'b1,2'b00}: rd_data = rd_data0[12:0];
      {1'b1,2'b01}: rd_data = rd_data1[12:0];
      {1'b1,2'b10}: rd_data = rd_data2[12:0];
      {1'b1,2'b11}: rd_data = rd_data3[12:0];
      default: rd_data = rd_data_r;
    endcase
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      en_porta_r <= 1'h0;
    else 
      en_porta_r <= en;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      rd_data_r <= 13'h0000;
    else if (en_porta_r)
      rd_data_r <= rd_data;
  end
  
  /****************************************************************************
   Instance the RAMS
  ****************************************************************************/
  RAMB16_S18 i0 (
    // Outputs
         .DO        (rd_data0),
         .DOP       (),
    // Inputs
         .ADDR      (addr[11:2]),         
         .CLK       (clk),        
         .DI        ({3'h0,wr_data[12:0]}),     
         .DIP       (2'b00),  
         .EN        (ram_en[0]),
         .WE        (wren),
         .SSR       (rst)
  );
  
  RAMB16_S18 i1 (
    // Outputs
         .DO        (rd_data1),
         .DOP       (),
    // Inputs
         .ADDR      (addr[11:2]),         
         .CLK       (clk),        
         .DI        ({3'h0,wr_data[12:0]}),     
         .DIP       (2'b00),  
         .EN        (ram_en[1]),
         .WE        (wren),
         .SSR       (rst)
  );
  
  RAMB16_S18 i2 (
    // Outputs
         .DO        (rd_data2),
         .DOP       (),
    // Inputs
         .ADDR      (addr[11:2]),         
         .CLK       (clk),        
         .DI        ({3'h0,wr_data[12:0]}),     
         .DIP       (2'b00),  
         .EN        (ram_en[2]),
         .WE        (wren),
         .SSR       (rst)
  );
  
  RAMB16_S18 i3 (
    // Outputs
         .DO        (rd_data3),
    // Inputs
         .DOP       (),
         .ADDR      (addr[11:2]),         
         .CLK       (clk),        
         .DI        ({3'h0,wr_data[12:0]}),     
         .DIP       (2'b00),  
         .EN        (ram_en[3]),
         .WE        (wren),
         .SSR       (rst)
  );
  

endmodule // prefix_code_ram 