
  /****************************************************************************
   LZW controller.
  ****************************************************************************/
module lzw_ctrl (
  // Outputs
       done_cr,                // To top_ctrl
       lzw_done,               // To top_ctrl 
       gen_hash,               // To hash
       recal_hash,             // To hash
       addrb_ioram,            // To IO RAM
       enb_ioram,              // To IO RAM
       web_ioram,              // To IO RAM      
       addrb_cvram,            // To code_value_ram
       enb_cvram,              // To code_value_ram
       web_cvram,              // To code_value_ram
       wr_cvdataa,             // To code_value_ram
       ena_cvram,              // To code_value_ram
       wea_cvram,              // To code_value_ram
       wea_acram,              // To dictionary_ram
       wea_pcram,              // To dictionary_ram  
       write_data,             // To data output register
       shift_char,             // To shift character register

  // Inputs
       init_cr,                // From top_ctrl       
       init_lzw,               // From top_ctrl
       not_in_mem,             // From hash
       match,                  // From hash
       collis,                 // From hash
       clk,                    // From iopads
       rst_n                   // From iopads
);
   
  /****************************************************************************
   Outputs
  ****************************************************************************/
  output        done_cr;           // Code value RAM initilization done
  output        lzw_done;          // LZW done with processing all data
  output        gen_hash;          // Generate Hash 
  output        recal_hash;        // Recalculate hash due to collision
  output [11:0] addrb_ioram;       // Address for IO RAM port B
  output        enb_ioram;         // Enable IO RAM port B 
  output        web_ioram;         // Write enable IO RAM port B
  output [12:0] addrb_cvram;       // Address for CV RAM port B
  output        enb_cvram;         // Enable code value RAM port B 
  output        web_cvram;         // Write enable code value RAM port B
  output [12:0] wr_cvdataa;        // Write data for code value RAM port A
  output        ena_cvram;         // Enable code value RAM port A
  output        wea_cvram;         // Write enable code value RAM port A
  output        wea_acram;         // Write Enable append char RAM port A  
  output        wea_pcram;         // Write Enable prefix code char RAM port A
  output        write_data;        // Write data into output register  
  output        shift_char;        // Shift character from char. to string reg.
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         init_cr;            // Initialize code value RAM
  input         init_lzw;           // Initialize LZW main state machine  
  input         not_in_mem;         // Address not in code value RAM  
  input         match;              // Match in dictionary  
  input         collis;             // Collision   
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/   
  wire           tc_ioractr;        // Terminal count for IO RAM address ctr  
  wire           tc_cvactr;         // Terminal count for CV RAM address ctr
  wire    [11:0] addrb_ioram;       // Address for IO RAM port B
  wire    [12:0] addrb_cvram;       // Address for CV RAM port B
  wire    [12:0] wr_cvdataa;        // Write data for code value RAM port A

  
  reg     [11:0] nxt_st;            // Next state
  reg     [11:0] curr_st;           // Current state
  reg            done_cr_st;        // Done with code value RAM init., early
  reg            done_cr;           // Done with code value RAM init.
  reg            inc_ioraddr;       // Increment IO RAM address
  reg            done_lzw_st;       // Done with LZW,early
  reg            lzw_done;          // Done with LZW,early   
  reg     [12:0] data_cntr;         // Data counter for CV RAM data port A
  reg            enb_cvram;         // Enable code value RAM port B 
  reg            web_cvram;         // Write enable code value RAM port B
  reg            inc_cvbaddr;       // Increment code value RAM port B address
  reg            clr_acntr;         // Clear address counter for CV RAM
  reg            enb_ioram;         // Enable IO RAM port B 
  reg            shift_char;        // Shift character from char. to string reg.  
  reg            gen_hash;          // Generate hash   
  reg            recal_hash;        // Recalculate hash  
  reg            ena_cvram;         // Enable code value RAM port A
  reg            wea_cvram;         // Write enable code value RAM port A
  reg            inc_cvadata;       // Increment code value RAM port A data
  reg            wea_acram;         // Write Enable append char RAM port A
  reg            wea_pcram;         // Write Enable prefix char RAM port A
  reg            write_data;        // Write data into output register  
  reg     [10:0] addr_cntr;         // Address counter for CV RAM address
  reg     [11:0] ioaddr_cntr;       // Address counter for IO RAM address
  reg            clr_ioacntr;       // Clear address counter for IO RAM 
  
  /****************************************************************************
   One hot state machine for the LZW control block
  ****************************************************************************/
  `define LIDLE      curr_st[0]
  `define LINIT_CR   curr_st[1]            
  `define WT_LZWST   curr_st[2]            
  `define RD_2NDCHAR curr_st[3]            
  `define GEN_HASH   curr_st[4]            
  `define WT_HASH    curr_st[5]            
  `define WT_RHASH   curr_st[6]            
  `define WR_OREG    curr_st[7]   
  `define LDONE      curr_st[8]  
             
  parameter LIDLE      = 12'b0000_0000_0001, // Idle
            LINIT_CR   = 12'b0000_0000_0010, // Initiliaze code RAM
            WT_LZWST   = 12'b0000_0000_0100, // LZW wait state
            RD_2NDCHAR = 12'b0000_0000_1000, // Read 2nd char. from IORAM
            GEN_HASH   = 12'b0000_0001_0000, // Generate Hash
            WT_HASH    = 12'b0000_0010_0000, // Wait for Hash result
            WT_RHASH   = 12'b0000_0100_0000, // Regenerate Hash in case of coll.
            WR_OREG    = 12'b0000_1000_0000, // Write result to output reg.
            LDONE      = 12'b0001_0000_0000; // Done
              
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      curr_st <= LIDLE;
    else
      curr_st <= nxt_st;
  end
  
  always @ (*)
  begin
    enb_cvram = 1'b0;
    web_cvram = 1'b0;
    inc_cvbaddr = 1'b0;
    done_cr_st = 1'b0;
    clr_acntr = 1'b0;
    enb_ioram = 1'b0;
    shift_char = 1'b0;
    gen_hash = 1'b0;
    ena_cvram = 1'b1;
    wea_cvram = 1'b0;
    inc_cvadata = 1'b0;
    wea_acram = 1'b0;
    wea_pcram = 1'b0;
    recal_hash = 1'b0;          
    write_data = 1'b0;
    done_lzw_st = 1'b0;
    case (1'b1)
      `LIDLE:
      begin
        if (init_cr)
        begin
          enb_cvram = 1'b1;
          web_cvram = 1'b1;
          inc_cvbaddr = 1'b1;
          ena_cvram = 1'b0;
          nxt_st = LINIT_CR;
        end
        else
          nxt_st = LIDLE;
      end
      `LINIT_CR:          // Initiliaze Code RAM
      begin
        if (tc_cvactr)
        begin
          done_cr_st = 1'b1;
          clr_acntr = 1'b1;
          nxt_st = WT_LZWST;
        end
        else
        begin
          web_cvram = 1'b1;
          enb_cvram = 1'b1;
          inc_cvbaddr = 1'b1;
          ena_cvram = 1'b0;
          nxt_st = LINIT_CR;
        end
      end
      `WT_LZWST:          // Wait for LZW start
      begin
        if (init_lzw)
        begin
          enb_ioram = 1'b1;
          inc_ioraddr = 1'b1;
          nxt_st = RD_2NDCHAR;
        end
        else
          nxt_st = WT_LZWST;
      end
      `RD_2NDCHAR:          // Read second character from IO RAM
      begin
        enb_ioram = 1'b1;
        shift_char = 1'b1;
        nxt_st = GEN_HASH;
      end
      `GEN_HASH:           // Generate HASH
      begin
        gen_hash = 1'b1;
        nxt_st = WT_HASH;
      end
      `WT_HASH:           // Wait for HASH result
      begin
        if (not_in_mem)    // Not in memory write data into all RAM's
        begin                
          wea_cvram = 1'b1;
          inc_cvadata = 1'b1;
          wea_acram = 1'b1;
          wea_pcram = 1'b1;
          nxt_st = WR_OREG;
        end
        else if (match)   // Match in dictionary 
        begin
          nxt_st = WR_OREG;
        end
        else if (collis)  // Collision generate during hash, recaluclate
        begin
          recal_hash = 1'b1;
          nxt_st = WT_RHASH;
        end
        else 
          nxt_st = WT_HASH;
      end
      `WT_RHASH:           // Wait for recalculate HASH result
      begin
        if (not_in_mem)
        begin              
          wea_cvram = 1'b1;
          inc_cvadata = 1'b1;
          wea_acram = 1'b1;
          wea_pcram = 1'b1;
          nxt_st = WR_OREG;
        end
        else if (match) // Match in dictionary 
        begin
          nxt_st = WR_OREG;
        end
        else if (collis)  // Wait for recalculate HASH result
        begin
          recal_hash = 1'b1;
          nxt_st = WT_HASH;
        end
        else 
          nxt_st = WT_RHASH;
      end
      `WR_OREG:          // Write to output data register
      begin
        if (tc_ioractr)
        begin
          write_data = 1'b1;
          nxt_st = LDONE;
        end
        else 
        begin
          write_data = 1'b1;
          enb_ioram = 1'b1;
          inc_ioraddr = 1'b1;
          nxt_st = RD_2NDCHAR;
        end
      end
      LDONE:           // All transmission finished
      begin  
        nxt_st = LIDLE;
        done_lzw_st = 1'b1;
      end
      default: nxt_st = LIDLE;
    endcase
  end
  
  /****************************************************************************
   Counter for generating the address to IO RAM
   This address will be used to read the received byte from IO RAM
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      ioaddr_cntr <= 12'h000;
    else if (clr_ioacntr)
      ioaddr_cntr <= 12'h000;
    else if (inc_ioraddr)
      ioaddr_cntr <= ioaddr_cntr + 1'b1;
  end
  
  assign tc_ioractr = (ioaddr_cntr == 12'hfff);
  assign addrb_ioram = ioaddr_cntr;
  
  /****************************************************************************
   Counter for generating the address to Code value RAM
   This address will be used to initiliaze the data and write code value data
   to RAM.
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      addr_cntr <= 11'h000;
    else if (clr_acntr)
      addr_cntr <= 11'h000;
    else if (inc_cvbaddr)
      addr_cntr <= addr_cntr + 1'b1;
  end
  
  assign tc_cvactr = (addr_cntr == 11'h7ff);
  assign addrb_cvram = {addr_cntr[10:0],2'b11};
  
  /****************************************************************************
   Counter for generating the data to the Code value RAM
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      data_cntr <= 13'h100;
    else if (done_lzw_st)
      data_cntr <= 13'h100;
    else if (inc_cvadata)
      data_cntr <= data_cntr + 1'b1;
  end
  
  assign wr_cvdataa = data_cntr;
  
  // Initilization of the code value RAM has ended
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      done_cr <= 1'b0;
    else
      done_cr <= done_cr_st;
  end
  
  // LZW for all data has ended
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      lzw_done <= 1'b0;
    else
      lzw_done <= done_lzw_st;
  end
  
  //synthesis translate_off
  reg  [20*8:0] st_string;
  always @ (*)
  begin
    case (curr_st)
      LIDLE     : st_string = "LIDLE";     
      LINIT_CR  : st_string = "LINIT_CR";  
      WT_LZWST  : st_string = "WT_LZWST";  
      RD_2NDCHAR: st_string = "RD_2NDCHAR";
      GEN_HASH  : st_string = "GEN_HASH"; 
      WT_HASH   : st_string = "WT_HASH";   
      WT_RHASH  : st_string = "WT_RHASH";  
      WR_OREG   : st_string = "WR_OREG";   
      LDONE     : st_string = "LDONE";     
    endcase      
  end
  //synthesis translate_on
  
endmodule // lzw_ctrl 