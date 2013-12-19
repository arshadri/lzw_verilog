
  /****************************************************************************
   Append character RAM.
  ****************************************************************************/
module append_char_ram (
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
  output  [7:0] rd_data;            // Read data from RAM
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         wren;               // Write enable RAM
  input         en;                 // RAM enable
  input  [11:0] addr;               // RAM address
  input   [7:0] wr_data;            // Write data
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  reg     [7:0] rd_data;            // Read data for RAM
  reg     [7:0] rd_data_r;          // Registered read data
  reg           en_porta_r;         // Registered enable
  
  wire    [7:0] rd_data0;           // Read data RAM 0
  wire    [7:0] rd_data1;           // Read data RAM 1
  wire    [7:0] rd_data2;           // Read data RAM 2
  wire    [7:0] rd_data3;           // Read data RAM 3
  wire    [7:0] rd_data4;           // Read data RAM 4
  wire    [7:0] rd_data5;           // Read data RAM 5
  wire    [7:0] rd_data6;           // Read data RAM 6
  wire    [7:0] rd_data7;           // Read data RAM 7
  wire    [7:0] ram_en;             // Enable for RAM 0-7  
  wire          rst;                // Reset inverted version of input
  
  /****************************************************************************
   Generate the enable signals for the RAM's and the output data muxing
  ****************************************************************************/
  assign rst = ~rst_n;
  
  assign ram_en[0] = en & ~addr[2] & ~addr[1] & ~addr[0];
  assign ram_en[1] = en & ~addr[2] & ~addr[1] &  addr[0];
  assign ram_en[2] = en & ~addr[2] &  addr[1] & ~addr[0];
  assign ram_en[3] = en & ~addr[2] &  addr[1] &  addr[0];
  assign ram_en[4] = en &  addr[2] & ~addr[1] & ~addr[0];
  assign ram_en[5] = en &  addr[2] & ~addr[1] &  addr[0];
  assign ram_en[6] = en &  addr[2] &  addr[1] & ~addr[0];
  assign ram_en[7] = en &  addr[2] &  addr[1] &  addr[0];

  always @ (*)
  begin
    case ({en_porta_r,addr[2:0]})
      {1'b1,3'b000}: rd_data = rd_data0;
      {1'b1,3'b001}: rd_data = rd_data1;
      {1'b1,3'b010}: rd_data = rd_data2;
      {1'b1,3'b011}: rd_data = rd_data3;
      {1'b1,3'b100}: rd_data = rd_data4;
      {1'b1,3'b101}: rd_data = rd_data5;
      {1'b1,3'b110}: rd_data = rd_data6;
      {1'b1,3'b111}: rd_data = rd_data7;
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
      rd_data_r <= 8'h00;
    else if (en_porta_r)
      rd_data_r <= rd_data;
  end
  
  
  /****************************************************************************
   Instance the RAMS
  ****************************************************************************/
  RAMB4_S8 i0 (
    // Outputs
         .DO        (rd_data0),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[0]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i1 (
    // Outputs
         .DO        (rd_data1),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[1]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i2 (
    // Outputs
         .DO        (rd_data2),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[2]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i3 (
    // Outputs
         .DO        (rd_data3),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[3]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i4 (
    // Outputs
         .DO        (rd_data4),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[4]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i5 (
    // Outputs
         .DO        (rd_data5),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[5]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i6 (
    // Outputs
         .DO        (rd_data6),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[6]),
         .WE        (wren),
         .RST       (rst)
  );
  
  RAMB4_S8 i7 (
    // Outputs
         .DO        (rd_data7),
    // Inputs
         .ADDR      (addr[11:3]),         
         .CLK       (clk),        
         .DI        (wr_data),   
         .EN        (ram_en[7]),
         .WE        (wren),
         .RST       (rst)
  );

endmodule // append_char_ram 