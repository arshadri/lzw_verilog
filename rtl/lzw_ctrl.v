
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
       addrb_outram,           // To out RAM
       enb_outram,             // To out RAM
       web_outram,             // To out RAM   
       addrb_cvram,            // To code_value_ram
       enb_cvram,              // To code_value_ram
       web_cvram,              // To code_value_ram
       wr_cvdataa,             // To code_value_ram
       ena_cvram,              // To code_value_ram
       wea_cvram,              // To code_value_ram
       wea_acram,              // To dictionary_ram
       wea_pcram,              // To dictionary_ram  
       write_data,             // To outreg
       read_data,              // To outreg
       write_sp,               // To outreg
       shift_char,             // To hash
       mux_code_val,           // To hash
       outram_cnt,             // To top_ctrl
  // Inputs
       init_cr,                // From top_ctrl       
       init_lzw,               // From top_ctrl      
       char_cnt,               // From top_ctrl
       not_in_mem,             // From hash
       in_code_mem,            // From hash
       match,                  // From hash
       collis,                 // From hash
       valid_dcnt,             // From outreg
       tc_outreg,              // From outreg
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
  output [11:0] addrb_outram;      // Address for out RAM port B
  output        enb_outram;        // Enable out RAM port B 
  output        web_outram;        // Write enable out RAM port B
  output [12:0] addrb_cvram;       // Address for CV RAM port B
  output        enb_cvram;         // Enable code value RAM port B 
  output        web_cvram;         // Write enable code value RAM port B
  output [12:0] wr_cvdataa;        // Write data for code value RAM port A
  output        ena_cvram;         // Enable code value RAM port A
  output        wea_cvram;         // Write enable code value RAM port A
  output        wea_acram;         // Write Enable append char RAM port A  
  output        wea_pcram;         // Write Enable prefix code char RAM port A 
  output        read_data;         // Read data from output register  
  output        write_data;        // Write data into output register  
  output        shift_char;        // Shift character from char. to string reg.
  output        mux_code_val;      // Mux code value into string register
  output [11:0] outram_cnt;        // Output RAM data count
  output        write_sp;          // Write special code into output register
   
  /****************************************************************************
   Inputs
  ****************************************************************************/
  input         init_cr;            // Initialize code value RAM
  input         init_lzw;           // Initialize LZW main state machine  
  input  [11:0] char_cnt;           // Number of characters received
  input         not_in_mem;         // Address not in code value RAM  
  input         in_code_mem;        // Address in code value RAM  
  input         match;              // Match in dictionary  
  input         collis;             // Collision   
  input         valid_dcnt;         // Valid data count in outreg  
  input         tc_outreg;          // Terminal count output register 
  input         clk;                // System clock
  input         rst_n;              // System reset, active low
  
  /****************************************************************************
   Internal declarations
  ****************************************************************************/   
  wire           tc_ioractr;        // Terminal count for IO RAM address ctr  
  wire           tc_cvactr;         // Terminal count for CV RAM address ctr  
  wire    [11:0] addrb_ioram;       // Address for IO RAM port B
  wire    [11:0] addrb_outram;      // Address for out RAM port B
  wire    [12:0] addrb_cvram;       // Address for CV RAM port B
  wire    [12:0] wr_cvdataa;        // Write data for code value RAM port A
  wire    [11:0] outram_cnt;        // Output RAM data count

  
  reg     [15:0] nxt_st;            // Next state
  reg     [15:0] curr_st;           // Current state
  reg            done_cr_st;        // Done with code value RAM init., early
  reg            done_cr;           // Done with code value RAM init.
  reg            inc_ioraddr;       // Increment IO RAM address
  reg            inc_outraddr;      // Increment out RAM address
  reg            done_lzw_st;       // Done with LZW,early
  reg            lzw_done;          // Done with LZW,early   
  reg     [12:0] data_cntr;         // Data counter for CV RAM data port A
  reg            enb_cvram;         // Enable code value RAM port B 
  reg            web_cvram;         // Write enable code value RAM port B
  reg            inc_cvbaddr;       // Increment code value RAM port B address
  reg            inc_cvbaddr_d;     // Increment code value RAM port B address delayed
  reg            clr_acntr;         // Clear address counter for CV RAM
  reg            enb_ioram;         // Enable IO RAM port B 
  reg            web_ioram;         // Write enable IO RAM port B  
  reg            enb_outram;        // Enable out RAM port B 
  reg            web_outram;        // Write enable out RAM port B
  reg            shift_char;        // Shift character from char. to string reg.  
  reg            gen_hash;          // Generate hash   
  reg            recal_hash_st;     // Recalculate hash early
  reg            recal_hash;        // Recalculate hash  
  reg            ena_cvram;         // Enable code value RAM port A
  reg            wea_cvram;         // Write enable code value RAM port A
  reg            inc_cvadata;       // Increment code value RAM port A data
  reg            wea_acram;         // Write Enable append char RAM port A
  reg            wea_pcram;         // Write Enable prefix char RAM port A
  reg            write_data;        // Write data into output register  
  reg            read_data;         // Read data from output register  
  reg     [10:0] addr_cntr;         // Address counter for CV RAM address
  reg     [11:0] ioaddr_cntr;       // Address counter for IO RAM address
  reg     [11:0] outaddr_cntr;      // Address counter for out RAM address
  reg            clr_ioacntr;       // Clear address counter for IO RAM 
  reg            mux_code_val;      // Mux code value into string register 
  reg            write_sp;          // Write special code into output register
  reg            write_sp_r;        // Write special code into output register
  
  /****************************************************************************
   One hot state machine for the LZW control block
  ****************************************************************************/
  `define LIDLE      curr_st[0]
  `define LINIT_CR   curr_st[1]            
  `define WT_LZWST   curr_st[2]            
  `define WT_DST1    curr_st[3]            
  `define RD_2NDCHAR curr_st[4]            
  `define WT_DST2    curr_st[5]            
  `define GEN_HASH   curr_st[6]            
  `define WT_HASH    curr_st[7]            
  `define WT_RHASH   curr_st[8]            
  `define WR_OREG    curr_st[9]             
  `define RD_OREG    curr_st[10]             
  `define RD_OREG2   curr_st[11]             
  `define CHK_CNT    curr_st[12]              
  `define SP_CHR     curr_st[13]            
  `define FL_OUT     curr_st[14]   
  `define LDONE      curr_st[15]  
             
  parameter LIDLE      = 16'b0000_0000_0000_0001, // Idle
            LINIT_CR   = 16'b0000_0000_0000_0010, // Initiliaze code RAM
            WT_LZWST   = 16'b0000_0000_0000_0100, // LZW wait state
            WT_DST1    = 16'b0000_0000_0000_1000, // Wait for Data 1
            RD_2NDCHAR = 16'b0000_0000_0001_0000, // Read 2nd char. from IORAM
            WT_DST2    = 16'b0000_0000_0010_0000, // Wait for Data 2
            GEN_HASH   = 16'b0000_0000_0100_0000, // Generate Hash
            WT_HASH    = 16'b0000_0000_1000_0000, // Wait for Hash result
            WT_RHASH   = 16'b0000_0001_0000_0000, // Regenerate Hash in case of coll.
            WR_OREG    = 16'b0000_0010_0000_0000, // Write result to output reg.
            RD_OREG    = 16'b0000_0100_0000_0000, // Read from output reg.
            RD_OREG2   = 16'b0000_1000_0000_0000, // Read from output reg. if more data
            CHK_CNT    = 16'b0001_0000_0000_0000, // Check max. count of ioact0
            SP_CHR     = 16'b0010_0000_0000_0000, // Special character
            FL_OUT     = 16'b0100_0000_0000_0000, // Flush output RAM
            LDONE      = 16'b1000_0000_0000_0000; // Done
              
  
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
    web_ioram = 1'b0;
    enb_outram = 1'b0;
    web_outram = 1'b0;
    shift_char = 1'b0;
    gen_hash = 1'b0;
    ena_cvram = 1'b1;
    wea_cvram = 1'b0;
    inc_cvadata = 1'b0;
    wea_acram = 1'b0;
    wea_pcram = 1'b0;
    recal_hash_st = 1'b0;          
    write_data = 1'b0;         
    read_data = 1'b0;
    done_lzw_st = 1'b0;
    inc_ioraddr = 1'b0;
    inc_outraddr = 1'b0;
    clr_ioacntr = 1'b0;
    mux_code_val = 1'b0;
    write_sp = 1'b0;
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
          nxt_st = WT_DST1;
        end
        else
          nxt_st = WT_LZWST;
      end
      `WT_DST1:          // Wait for Data 1
      begin
        inc_ioraddr = 1'b1;
        shift_char = 1'b1;
        nxt_st = RD_2NDCHAR;
      end
      `RD_2NDCHAR:          // Read second character from IO RAM
      begin
        enb_ioram = 1'b1;
        nxt_st = WT_DST2;
      end 
      `WT_DST2:          // Wait for Data 2
      begin
        gen_hash = 1'b1;
        nxt_st = GEN_HASH;
      end
      `GEN_HASH:           // Generate HASH
      begin
        ena_cvram = 1'b1;
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
       else if (match) // Match in dictionary 
        begin
          mux_code_val = 1'b1;
          shift_char = 1'b1;
          nxt_st = CHK_CNT;
        end
        else if (in_code_mem)   // Match in code memory 
        begin
          mux_code_val = 1'b1;
          nxt_st = WR_OREG;
        end
        else if (collis)  // Collision generate during hash, recaluclate
        begin
          recal_hash_st = 1'b1;
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
          mux_code_val = 1'b1;
          shift_char = 1'b1;
          //nxt_st = CHK_CNT;
          nxt_st = RD_2NDCHAR;
        end
        else if (in_code_mem)   // Match in code memory 
        begin
          nxt_st = WR_OREG;
        end
        else if (collis)  // Wait for recalculate HASH result
        begin
          recal_hash_st = 1'b1;
          nxt_st = WT_HASH;
        end
        else 
          nxt_st = WT_RHASH;
      end
      `WR_OREG:          // Write to output data register
      begin
        mux_code_val = in_code_mem ? 1'b1 : 1'b0;
        write_data = 1'b1;
        shift_char = 1'b1;
        nxt_st = RD_OREG;
      end
      `RD_OREG:          // Read from output data register and write to IORAM
      begin
        read_data = 1'b1;
        web_outram = 1'b1;
        enb_outram = 1'b1;
        inc_outraddr = 1'b1;
        nxt_st = RD_OREG2;
      end
      `RD_OREG2:          // If greater than 8-bits data than read again
      begin
        if (valid_dcnt)
        begin
          read_data = 1'b1;
          web_outram = 1'b1;
          enb_outram = 1'b1;
          inc_outraddr = 1'b1;
          nxt_st = RD_OREG2;
        end
        else 
        begin
          enb_outram = 1'b0;
          web_outram = 1'b0;
          inc_outraddr = 1'b0;
          nxt_st = CHK_CNT;
        end
      end
      `CHK_CNT:          // Check that IO address counter is at max. value or not
      begin
        if (write_sp_r)
        begin
          nxt_st = FL_OUT;
        end
        else if (tc_ioractr & ~match & ~write_sp_r)
        begin
          write_sp = 1'b1;
          nxt_st = SP_CHR;
        end
        else if (tc_ioractr & match & ~write_sp_r)
        begin
          inc_outraddr = 1'b1;
          write_sp = 1'b1;
          nxt_st = SP_CHR;
        end
        else if (match) 
        begin
          inc_ioraddr = 1'b1;
          nxt_st = RD_2NDCHAR;
        end
        else   //~match case
        begin
          inc_ioraddr = 1'b1;
          nxt_st = RD_2NDCHAR;
        end
      end
      `SP_CHR:           // Write special character
      begin        
        nxt_st = RD_OREG;
      end
      `FL_OUT:           // All transmission finished
      begin  
       if (tc_outreg)
       begin
        nxt_st = LDONE;
       end
       else   // Less than byte left in outreg, flush it
       begin
         read_data = 1'b1;
         web_outram = 1'b1;
         enb_outram = 1'b1;
         done_lzw_st = 1'b1;
         nxt_st = LDONE;
       end
      end
      `LDONE:           // All transmission finished
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
  
  assign tc_ioractr = (ioaddr_cntr == char_cnt);
  assign addrb_ioram = ioaddr_cntr;
  
  /****************************************************************************
   Counter for generating the address to out RAM
   This address will be used to write the lzw byte to out RAM
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      outaddr_cntr <= 12'h000;
    else if (inc_outraddr)
      outaddr_cntr <= outaddr_cntr + 1'b1;
  end
  
  assign addrb_outram = outaddr_cntr;
  assign outram_cnt = outaddr_cntr;
  
  /****************************************************************************
   Counter for generating the address to Code value RAM
   This address will be used to initiliaze the data and write code value data
   to RAM.
  ****************************************************************************/
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      inc_cvbaddr_d <= 1'b0;
    else 
      inc_cvbaddr_d <= inc_cvbaddr;
  end
  
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      addr_cntr <= 11'h000;
    else if (clr_acntr)
      addr_cntr <= 11'h000;
    else if (inc_cvbaddr_d)
      addr_cntr <= addr_cntr + 1'b1;
  end
  
  assign tc_cvactr = (addr_cntr == 11'h7ff);
  assign addrb_cvram = {2'b00,addr_cntr[10:0]};
  
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
  
  // LZW for all data has ended
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      recal_hash <= 1'b0;
    else
      recal_hash <= recal_hash_st;
  end
  
  // Delayed version of write special character
  always @ (posedge clk or negedge rst_n)
  begin
    if (~rst_n)
      write_sp_r <= 1'b0;
    else if (done_lzw_st)
      write_sp_r <= 1'b0;
    else if (write_sp)
      write_sp_r <= 1'b1;
  end
  
  //synthesis translate_off
  reg  [20*8:0] st_string;
  always @ (*)
  begin
    case (curr_st)
      LIDLE     : st_string = "LIDLE";     
      LINIT_CR  : st_string = "LINIT_CR";  
      WT_LZWST  : st_string = "WT_LZWST";  
      WT_DST1   : st_string = "WT_DST1";  
      RD_2NDCHAR: st_string = "RD_2NDCHAR"; 
      WT_DST2   : st_string = "WT_DST2";  
      GEN_HASH  : st_string = "GEN_HASH"; 
      WT_HASH   : st_string = "WT_HASH";   
      WT_RHASH  : st_string = "WT_RHASH";  
      WR_OREG   : st_string = "WR_OREG";   
      RD_OREG   : st_string = "RD_OREG";   
      RD_OREG2  : st_string = "RD_OREG2";   
      CHK_CNT   : st_string = "CHK_CNT";     
      SP_CHR    : st_string = "SP_CHR";     
      FL_OUT    : st_string = "FL_OUT";   
      LDONE     : st_string = "LDONE";     
    endcase      
  end
  //synthesis translate_on
  
endmodule // lzw_ctrl 