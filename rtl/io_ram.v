
  /****************************************************************************
   Input output RAM.
   One port of the RAM is connected to the serial port
   Second port of the RAM is connected to the output forming logic of the
   LZW block
  ****************************************************************************/
module io_ram (
  // Outputs
       rd_dataa,
       rd_datab,
  // Inputs
       wr_porta,
       en_porta,
       addra,
       wr_dataa,
       wr_portb,
       en_portb,
       addrb,
       wr_datab,
       clk, 
       rst_n
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output  [7:0] rd_dataa;           // Read data for port A
  output  [7:0] rd_datab;           // Read data for port B
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         wr_porta;           // Write enable for port A
  input         en_porta;           // RAM enable for port A
  input         wr_portb;           // Write enable for port B
  input         en_portb;           // RAM enable for port B
  input  [11:0] addra;              // RAM address for port A
  input  [11:0] addrb;              // RAM address for port B
  input   [7:0] wr_dataa;           // Write data for port A
  input   [7:0] wr_datab;           // Write data for port B
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  reg     [7:0] rd_dataa;           // Read data for port A
  reg     [7:0] rd_datab;           // Read data for port B
  reg     [7:0] rd_dataa_r;         // Registered read data for port A
  reg     [7:0] rd_datab_r;         // Registered read data for port B
  reg           en_porta_r;         // Registered enable for port A
  reg           en_portb_r;         // Registered enable for port B
  
  wire    [7:0] rd_dataa0;          // Read data port A RAM 0
  wire    [7:0] rd_datab0;          // Read data port B RAM 0
  wire    [7:0] rd_dataa1;          // Read data port A RAM 1
  wire    [7:0] rd_datab1;          // Read data port B RAM 1
  wire    [7:0] rd_dataa2;          // Read data port A RAM 2
  wire    [7:0] rd_datab2;          // Read data port B RAM 2
  wire    [7:0] rd_dataa3;          // Read data port A RAM 3
  wire    [7:0] rd_datab3;          // Read data port B RAM 3
  wire    [7:0] rd_dataa4;          // Read data port A RAM 4
  wire    [7:0] rd_datab4;          // Read data port B RAM 5
  wire    [7:0] rd_dataa5;          // Read data port A RAM 5
  wire    [7:0] rd_datab5;          // Read data port B RAM 6
  wire    [7:0] rd_dataa6;          // Read data port A RAM 6
  wire    [7:0] rd_datab6;          // Read data port B RAM 7
  wire    [7:0] rd_dataa7;          // Read data port A RAM 7
  wire    [7:0] rd_datab7;          // Read data port B RAM 7
  wire    [7:0] en_a;               // Enable for port A of RAM 0-7  
  wire    [7:0] en_b;               // Enable for port B of RAM 0-7
  wire          rst;                // Reset inverted version of input
  
  /****************************************************************************
   Generate the enable signals for the RAM's and the output data muxing
  ****************************************************************************/
  assign rst = ~rst_n;
  
  assign en_a[0] = en_porta & ~addra[2] & ~addra[1] & ~addra[0];
  assign en_a[1] = en_porta & ~addra[2] & ~addra[1] &  addra[0];
  assign en_a[2] = en_porta & ~addra[2] &  addra[1] & ~addra[0];
  assign en_a[3] = en_porta & ~addra[2] &  addra[1] &  addra[0];
  assign en_a[4] = en_porta &  addra[2] & ~addra[1] & ~addra[0];
  assign en_a[5] = en_porta &  addra[2] & ~addra[1] &  addra[0];
  assign en_a[6] = en_porta &  addra[2] &  addra[1] & ~addra[0];
  assign en_a[7] = en_porta &  addra[2] &  addra[1] &  addra[0];
  
  assign en_b[0] = en_portb & ~addrb[2] & ~addrb[1] & ~addrb[0];
  assign en_b[1] = en_portb & ~addrb[2] & ~addrb[1] &  addrb[0];
  assign en_b[2] = en_portb & ~addrb[2] &  addrb[1] & ~addrb[0];
  assign en_b[3] = en_portb & ~addrb[2] &  addrb[1] &  addrb[0];
  assign en_b[4] = en_portb &  addrb[2] & ~addrb[1] & ~addrb[0];
  assign en_b[5] = en_portb &  addrb[2] & ~addrb[1] &  addrb[0];
  assign en_b[6] = en_portb &  addrb[2] &  addrb[1] & ~addrb[0];
  assign en_b[7] = en_portb &  addrb[2] &  addrb[1] &  addrb[0];
                                        
  always @ (*)
  begin
    case ({en_porta_r,addra[2:0]})
      {1'b1,3'b000}: rd_dataa = rd_dataa0;
      {1'b1,3'b001}: rd_dataa = rd_dataa1;
      {1'b1,3'b010}: rd_dataa = rd_dataa2;
      {1'b1,3'b011}: rd_dataa = rd_dataa3;
      {1'b1,3'b100}: rd_dataa = rd_dataa4;
      {1'b1,3'b101}: rd_dataa = rd_dataa5;
      {1'b1,3'b110}: rd_dataa = rd_dataa6;
      {1'b1,3'b111}: rd_dataa = rd_dataa7;
      default: rd_dataa = rd_dataa_r;
    endcase
  end
  
  always @ (*)
  begin
    case ({en_portb_r,addrb[2:0]})
      {1'b1,3'b000}: rd_datab = rd_datab0;
      {1'b1,3'b001}: rd_datab = rd_datab1;
      {1'b1,3'b010}: rd_datab = rd_datab2;
      {1'b1,3'b011}: rd_datab = rd_datab3;
      {1'b1,3'b100}: rd_datab = rd_datab4;
      {1'b1,3'b101}: rd_datab = rd_datab5;
      {1'b1,3'b110}: rd_datab = rd_datab6;
      {1'b1,3'b111}: rd_datab = rd_datab7;
      default: rd_datab = rd_datab_r;
    endcase
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      en_portb_r <= 1'h0;
    else 
      en_portb_r <= en_portb;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      en_porta_r <= 1'h0;
    else 
      en_porta_r <= en_porta;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      rd_datab_r <= 8'h00;
    else if (en_portb_r)
      rd_datab_r <= rd_datab;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      rd_dataa_r <= 8'h00;
    else if (en_porta_r)
      rd_dataa_r <= rd_dataa;
  end
  
  /****************************************************************************
   Instance the RAMS
  ****************************************************************************/
  RAMB4_S8_S8 i0 (
    // Outputs
         .DOA       (rd_dataa0),
         .DOB       (rd_datab0),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[0]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[0]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i1 (
    // Outputs
         .DOA       (rd_dataa1),
         .DOB       (rd_datab1),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[1]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[1]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i2 (
    // Outputs
         .DOA       (rd_dataa2),
         .DOB       (rd_datab2),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[2]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[2]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i3 (
    // Outputs
         .DOA       (rd_dataa3),
         .DOB       (rd_datab3),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[3]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[3]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i4 (
    // Outputs
         .DOA       (rd_dataa4),
         .DOB       (rd_datab4),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[4]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[4]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i5 (
    // Outputs
         .DOA       (rd_dataa5),
         .DOB       (rd_datab5),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[5]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[5]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i6 (
    // Outputs
         .DOA       (rd_dataa6),
         .DOB       (rd_datab6),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[6]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[6]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
  RAMB4_S8_S8 i7 (
    // Outputs
         .DOA       (rd_dataa7),
         .DOB       (rd_datab7),
    // Inputs
         .ADDRA     (addra[11:3]),         
         .CLKA      (clk),        
         .DIA       (wr_dataa),  
         .ENA       (en_a[7]),
         .WEA       (wr_porta),
         .RSTA      (rst),
         .ADDRB     (addrb[11:3]),         
         .CLKB      (clk),        
         .DIB       (wr_datab),  
         .ENB       (en_b[7]),
         .WEB       (wr_portb),
         .RSTB      (rst)
  );
  
endmodule // io_ram 