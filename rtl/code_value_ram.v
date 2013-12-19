
  /****************************************************************************
   Code Value RAM.
   One port of the RAM is connected to the initilization logic
   Second port of the RAM is used for string data
  ****************************************************************************/
module code_value_ram (
  // Outputs
       rd_dataa,
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
  output [12:0] rd_dataa;           // Read data for port A
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         wr_porta;           // Write enable for port A
  input         en_porta;           // RAM enable for port A
  input         wr_portb;           // Write enable for port B
  input         en_portb;           // RAM enable for port B
  input  [12:0] addra;              // RAM address for port A
  input  [12:0] addrb;              // RAM address for port B
  input  [12:0] wr_dataa;           // Write data for port A
  input  [12:0] wr_datab;           // Write data for port B
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/ 
  reg    [12:0] rd_dataa;           // Read data for port A
  reg    [12:0] rd_dataa_r;         // Registered read data for port A
  reg           en_porta_r;         // Registered enable for port A
  
  wire   [15:0] rd_dataa0;          // Read data port A RAM 0
  wire   [15:0] rd_dataa1;          // Read data port A RAM 1
  wire   [15:0] rd_dataa2;          // Read data port A RAM 2
  wire   [15:0] rd_dataa3;          // Read data port A RAM 3
  wire    [3:0] en_a;               // Enable for port A of RAM 0-3 
  wire          rst;                // Reset inverted version of input
  
  /****************************************************************************
   Generate the enable signals for the RAM's and the output data muxing
  ****************************************************************************/
  assign rst = ~rst_n;
  
  assign en_a[0] = en_porta & ~addra[1] & ~addra[0];
  assign en_a[1] = en_porta & ~addra[1] &  addra[0];
  assign en_a[2] = en_porta &  addra[1] & ~addra[0];
  assign en_a[3] = en_porta &  addra[1] &  addra[0];
  
  always @ (*)
  begin
    case ({en_porta_r,addra[1:0]})
      {1'b1,2'b00}: rd_dataa = rd_dataa0[12:0];
      {1'b1,2'b01}: rd_dataa = rd_dataa1[12:0];
      {1'b1,2'b10}: rd_dataa = rd_dataa2[12:0];
      {1'b1,2'b11}: rd_dataa = rd_dataa3[12:0];
      default: rd_dataa = rd_dataa_r;
    endcase
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
      rd_dataa_r <= 13'h0000;
    else if (en_porta_r)
      rd_dataa_r <= rd_dataa;
  end
  
  /****************************************************************************
   Instance the RAMS
  ****************************************************************************/
  RAMB16_S18_S18 i0 (
    // Outputs
         .DOA       (rd_dataa0),
         .DOPA      (),
         .DOB       (),
         .DOPB      (),
    // Inputs
         .ADDRA     (addra[11:2]),         
         .CLKA      (clk),        
         .DIA       ({3'h0,wr_dataa[12:0]}),   
         .DIPA      (2'b00),  
         .ENA       (en_a[0]),
         .WEA       (wr_porta),
         .SSRA      (rst),
         .ADDRB     (addrb[9:0]),         
         .CLKB      (clk),        
         .DIB       ({3'h0,wr_datab[12:0]}),  
         .DIPB      (2'b00),  
         .ENB       (en_portb),
         .WEB       (wr_portb),
         .SSRB      (rst)
  );
  
  RAMB16_S18_S18 i1 (
    // Outputs
         .DOA       (rd_dataa1),
         .DOPA      (),
         .DOB       (),
         .DOPB      (),
    // Inputs
         .ADDRA     (addra[11:2]),                   
         .CLKA      (clk),                  
         .DIA       ({3'h0,wr_dataa[12:0]}),
         .DIPA      (2'b00),                
         .ENA       (en_a[1]),          
         .WEA       (wr_porta),             
         .SSRA      (rst),                  
         .ADDRB     (addrb[9:0]),                   
         .CLKB      (clk),                  
         .DIB       ({3'h0,wr_datab[12:0]}),
         .DIPB      (2'b00),                
         .ENB       (en_portb),          
         .WEB       (wr_portb),             
         .SSRB      (rst)                   
  );
  
  RAMB16_S18_S18 i2 (
    // Outputs
         .DOA       (rd_dataa2),
         .DOPA      (),
         .DOB       (),
         .DOPB      (),
    // Inputs
         .ADDRA     (addra[11:2]),                   
         .CLKA      (clk),                  
         .DIA       ({3'h0,wr_dataa[12:0]}),
         .DIPA      (2'b00),                
         .ENA       (en_a[2]),          
         .WEA       (wr_porta),             
         .SSRA      (rst),                  
         .ADDRB     (addrb[9:0]),                   
         .CLKB      (clk),                  
         .DIB       ({3'h0,wr_datab[12:0]}),
         .DIPB      (2'b00),                
         .ENB       (en_portb),          
         .WEB       (wr_portb),             
         .SSRB      (rst)                   
  );
  
  RAMB16_S18_S18 i3 (
    // Outputs
         .DOA       (rd_dataa3),
         .DOPA      (),
         .DOB       (),
         .DOPB      (),
    // Inputs
         .ADDRA     (addra[11:2]),                  
         .CLKA      (clk),                  
         .DIA       ({3'h0,wr_dataa[12:0]}),
         .DIPA      (2'b00),                
         .ENA       (en_a[3]),          
         .WEA       (wr_porta),             
         .SSRA      (rst),                  
         .ADDRB     (addrb[9:0]),                  
         .CLKB      (clk),                  
         .DIB       ({3'h0,wr_datab[12:0]}),
         .DIPB      (2'b00),                
         .ENB       (en_portb),          
         .WEB       (wr_portb),             
         .SSRB      (rst)                   
  );
  
 
endmodule // code_value_ram 